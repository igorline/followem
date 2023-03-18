// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

// FIXME: Should this be a library instead?
contract AdForwarder {
    // contract to interract with
    address public contractAddress;
    
    // whitelisted addresses
    address[] public whitelist;

    // whitelisted functions
    bytes4[] public funcSelectors;

    // event to emit when ad is consumed
    event AdConsumed(address indexed _adMaker, address indexed _adTaker);

    // TODO: Consider also submitting signed message with response
    // function to take ad action
    function executeAd(bytes calldata _calldata) external {
        // TODO: check func selectors are whitelisted
        // TODO: check msg.sender is whitelisted

        // reward ad maker
        rewardAdMaker();
        // reward ad taker
        rewardAdTaker();

        // emit Ad consumed event
        // FIXME: maker is contract deployer, taker is msg.sender
        emit AdConsumed(tx.origin, msg.sender);
    }

    // function to reward ad taker
    function rewardAdTaker() internal virtual {

    }
    // function to reward ad maker

    function rewardAdMaker() internal virtual {

    }
}
