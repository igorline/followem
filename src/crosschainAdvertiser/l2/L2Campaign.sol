pragma solidity ^0.8.15;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {getAdHash} from "../AdHash.sol";

contract L2Campaign is Ownable {
    // The amount an advertiser will receive for a successful ad
    uint256 public immutable commission;
    // The contract the campaign is targeting
    address public immutable target;
    // The address of the forwarder contract
    address public immutable l1Forwarder;
    // The address of the connext contract
    address public immutable connext;
    // The domain the campaign contract is deployed at
    //TODO i think we can remove this
    uint32 public immutable originDomain;
    // Deadline after which the owner can withdraw the funds
    uint256 public immutable deadline;

    mapping(bytes32 => address) claims;
    uint public claimableRewards;

    event DEBUGXRECEIVE(
        address expectedForwarder,
        address actualForwarder,
        address msgSender,
        address connext
    );

    event DEBUGXRECEIVE2(
        bytes32 _transferId,
        uint256 _amount,
        address _asset,
        address _originSender,
        uint32 _origin
    );

    constructor(
        uint256 _commission,
        address _target,
        uint256 _deadline,
        address _l1Forwarder,
        address _connext,
        uint32 _originDomain
    ) payable {
        require(
            msg.value >= _commission,
            "Commission cannot be less than total reward added"
        );

        commission = _commission;
        target = _target;
        l1Forwarder = _l1Forwarder;
        connext = _connext;
        originDomain = _originDomain;
        deadline = _deadline;
    }

    modifier onlySource(address _originSender, uint32 _origin) {
        emit DEBUGXRECEIVE(l1Forwarder, msg.sender, _originSender, connext);
        require(
            _originSender == l1Forwarder && msg.sender == connext,
            "Expected original caller to be source contract on origin domain and this to be called by Connext"
        );
        _;
    }

    modifier onlyAfter(uint256 _time) {
        require(block.timestamp >= _time, "Function called too early");
        _;
    }

    function xReceive(
        bytes32 _transferId,
        uint256 _amount,
        address _asset,
        address _originSender,
        uint32 _origin,
        bytes memory _callData
    ) external onlySource(_originSender, _origin) returns (bytes memory) {
        emit DEBUGXRECEIVE2(
            _transferId,
            _amount,
            _asset,
            _originSender,
            _origin
        );

        (bytes32 adHash, address advertiser) = abi.decode(
            _callData,
            (bytes32, address)
        );
        claims[adHash] = advertiser;
        claimableRewards += commission;
    }

    function withdraw() external onlyOwner onlyAfter(deadline) {
        require(
            address(this).balance > claimableRewards,
            "Not enough funds to withdraw"
        );
        payable(address(msg.sender)).transfer(
            (address(this).balance) - claimableRewards
        );
    }

    // TODO: Implement batch claim
    function claim(bytes32 expectedAdHash) public payable {
        // If all params are correcct the hash will equal the one written be xReceive to the claim function. -> claim is authorized
        require(claims[expectedAdHash] == msg.sender, "unauthorized");

        // A claim can only claime once
        claims[expectedAdHash] = address(0);
        // Reduce claimable rewards
        claimableRewards -= commission;
        // Send the reward to the sender
        // FIXME: https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/
        payable(address(msg.sender)).transfer(commission);
    }
}
//forge verify-contract 0x80090db34388C0327e7381af5B1791226318F41C L2Campaign KUG3QTVUKNTCH5DXEHQ5GY7XN1WMHPXWV7 --chain optimism-goerli --constructor-args-path constructor-args.txt
