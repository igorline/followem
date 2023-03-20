pragma solidity ^0.8.15;

import {IConnext} from "interfaces/core/IConnext.sol";
import {IXReceiver} from "interfaces/core/IXReceiver.sol";

// FIXME: Should this be a library instead?
contract AdForwarder {
    IConnext public immutable connext;

    constructor(IConnext _connext) {
        connext = _connext;
    }

    function executeAd(
        //the address of the contract the calldata should be exectuted at
        address target,
        //The actual transaction calldata
        bytes calldata _calldata,
        //The advertiser that should earn the reward
        address adverstiser,
        //The relayerFee that needs to be paid to the connext relayer
        uint256 relayerFee,
        //The domain the campain contract is deployed
        uint32 destinationDomain
    ) external {
        (bool success, bytes memory result) = target.call(_calldata);
        require(success, "tx failed");
        //Adhash works as an id for the ad
        bytes32 adHash = getAddHash(target, _calldata, adverstiser);

        bytes memory callData = abi.encode(_calldata);

        connext.xcall{value: relayerFee}(
            destinationDomain, // _destination: domain ID of the destination chain
            target, // _to: address of the target contract (Pong)
            address(0), // _asset: use address zero for 0-value transfers
            msg.sender, // _delegate: address that can revert or forceLocal on destination
            0, // _amount: 0 because no funds are being transferred
            0, // _slippage: can be anything between 0-10000 because no funds are being transferred
            callData // _callData: the encoded calldata to send
        );
    }

    function getAddHash(
        address target,
        bytes calldata _calldata,
        address adverstiser
    ) private returns (bytes32) {
        bytes32 calldatahash = keccak256(abi.encodePacked(_calldata));
        return keccak256(abi.encodePacked(target, calldatahash, adverstiser));
    }
}
