pragma solidity ^0.8.15;

import {getAdHash} from "../AdHash.sol";

contract L2Campaign {
    //The amount an advertiser will receive for a successful ad
    uint256 public immutable commision;
    //The contract the campaign is targeting
    address public immutable target;
    //The address of the forwarder contract
    address public immutable l1Forwarder;

    mapping(bytes32 => address) claims;

    constructor(uint256 _commision, address _target, address _l1Forwarder) {
        commision = _commision;
        target = _target;
        l1Forwarder = _l1Forwarder;
    }

    function xReceive(
        bytes32 _transferId,
        uint256 _amount,
        address _asset,
        address _originSender,
        uint32 _origin,
        bytes memory _callData
    ) external returns (bytes memory) {
        //TODO add onlySource modifier to protect against malicious calls
        (bytes32 adHash, address advertiser) = abi.decode(
            _callData,
            (bytes32, address)
        );
        claims[adHash] = advertiser;
    }

    function claim(address minter, uint256 tokenId) public payable {
        //This campaign only supports hardcoded mint but of course campaign can add more selectors on their behalf
        //In order to claim his reward the advertiser needs to specify which tokenId he wan'ts to claim a reward for.
        //If this is true the calldata will be exactly the same as the one called be the user
        bytes memory _calldata = abi.encodeWithSignature(
            "mint(address,uint256)",
            minter,
            tokenId
        );
        //If all params are correcct the hash will equal the one written be xReceive to the claim function. -> claim is authorized
        bytes32 expectedAddHash = getAdHash(
            target,
            _calldata,
            address(this),
            msg.sender,
            100
        );
        require(claims[expectedAddHash] == msg.sender, "unauthorized");

        //A claim can only claime once
        claims[expectedAddHash] = address(0);
        //Send the reward to the sender
        payable(address(msg.sender)).transfer(commision);
    }
}
