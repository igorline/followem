pragma solidity ^0.8.15;

import {IConnext} from "interfaces/core/IConnext.sol";
import {IXReceiver} from "interfaces/core/IXReceiver.sol";

import {getAdHash} from "../AdHash.sol";

contract AdForwarder {
    IConnext public immutable connext;

    constructor(IConnext _connext) {
        connext = _connext;
    }

    event AdExecuted(bytes32 indexed adHash, address indexed advertiser);

    function executeAd(
        //the address of the contract the calldata should be exectuted at
        address target,
        //The actual transaction calldata
        bytes calldata _calldata,
        //the address of the campaignContract
        address l2CampaignContract,
        //The advertiser that should earn the reward
        address advertiser,
        //The domain the campain contract is deployed
        uint32 destinationDomain,
        //The relayerFee that needs to be paid to the connext relayer
        uint256 relayerFee
    ) external payable {
        (bool success, bytes memory result) = target.call(_calldata);
        require(success, "tx failed");
        //Adhash works as an id for the ad
        bytes32 adHash = getAdHash(
            target,
            _calldata,
            l2CampaignContract,
            advertiser,
            destinationDomain
        );

        connext.xcall{value: relayerFee}(
            destinationDomain, // _destination: domain ID of the destination chain
            target, // _to: address of the target contract (Pong)
            address(0), // _asset: use address zero for 0-value transfers
            msg.sender, // _delegate: address that can revert or forceLocal on destination
            0, // _amount: 0 because no funds are being transferred
            0, // _slippage: can be anything between 0-10000 because no funds are being transferred
            abi.encode(adHash, advertiser) // _callData: the encoded calldata to send
        );

        emit AdExecuted(adHash, advertiser);
    }
}
