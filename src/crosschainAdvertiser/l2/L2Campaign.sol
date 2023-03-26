pragma solidity ^0.8.15;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

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
    // Selector for the xReceive function
    bytes4 public immutable selector;

    mapping(address => uint32) public claimableRewards;
    uint32 totalRewards;

    constructor(
        uint256 _commission,
        address _target,
        uint256 _deadline,
        address _l1Forwarder,
        address _connext,
        uint32 _originDomain,
        bytes4 _selector
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
        selector = _selector;
    }

    modifier onlySource(address _originSender, uint32 _origin) {
        require(
            //FIXME origin sender is not working as expected due to issues with connext op testnet
            // _originSender == l1Forwarder && msg.sender == connext,
            msg.sender == connext,
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
        (bytes4 _selector, address advertiser) = abi.decode(
            _callData,
            (bytes4, address)
        );
        require(_selector == selector, "Invalid selector");
        ++uableRewards[advertiser];
        ++totalRewards;
    }

    function withdraw() external onlyOwner onlyAfter(deadline) {
        require(
            address(this).balance > totalRewards,
            "Not enough funds to withdraw"
        );
        payable(address(msg.sender)).transfer(
            (address(this).balance) - totalRewards
        );
    }

    function claim() public payable {
        // Reduce claimable rewards
        uint32 rewardsCount = claimableRewards[msg.sender];
        claimableRewards[msg.sender] = 0;
        // Reduce balance of the claimer
        totalRewards -= rewardsCount;
        // Send the reward to the sender
        // FIXME: https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/
        payable(address(msg.sender)).transfer(commission * rewardsCount);
    }
}
//forge verify-contract 0xc48ff12ED5275dbe8064eA39712118F59BF4b0ED L2Campaign KUG3QTVUKNTCH5DXEHQ5GY7XN1WMHPXWV7 --chain optimism-goerli --constructor-args-path constructor-args.txt
