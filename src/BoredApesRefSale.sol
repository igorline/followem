// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import {AdForwarder} from "./AdForwarder.sol";

contract BoredApesRefSale is AdForwarder {
    constructor(address nftAddress) {
        contractAddress = nftAddress;
        // TODO: Add func selectors to only be able to mint nfts
    }

    function rewardAdTaker() internal override {
        // TODO: Transfer nft to msg.sender
    }
}
