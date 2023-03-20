pragma solidity ^0.8.15;
import {IConnext} from "@connext/smart-contracts/contracts/core/connext/interfaces/IConnext.sol";
import {IXReceiver} from "@connext/smart-contracts/contracts/core/connext/interfaces/IXReceiver.sol";

// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

// FIXME: Should this be a library instead?
contract AdForwarder {
    // event to emit when ad is consumed
    event AdConsumed(
        address indexed target,
        address indexed promoter,
        bytes32 adHash
    );

    function executeAd(
        //the address of the nftContrac
        address target,
        //The actual transaction
        bytes calldata _calldata,
        //The advertiser that should earn the reward
        address adverstiser,
        
    ) external {
        (bool success, bytes memory result) = target.call(_calldata);
        require(success, "tx failed");
        //Adhash works as an id for the ad 
        bytes32 adHash = getAddHash(target, _calldata, adverstiser);

        bytes memory callData = abi.encode(_calldata);

        connext.xcall{value: relayerFee}(
        destinationDomain, // _destination: domain ID of the destination chain
        target,            // _to: address of the target contract (Pong)
        address(0),        // _asset: use address zero for 0-value transfers
        msg.sender,        // _delegate: address that can revert or forceLocal on destination
        0,                 // _amount: 0 because no funds are being transferred
        0,                 // _slippage: can be anything between 0-10000 because no funds are being transferred
        callData           // _callData: the encoded calldata to send
        );
  }

    }

    function getAddHash(
        address target,
        bytes calldata _calldata,
        address adverstiser
    ) {
        bytes32 calldatahash = keccak256(abi.encodePacked(_calldata))
        return keccak256(abi.encodePacked([target, calldatahash, advertiser]));
    }
}

