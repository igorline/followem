// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {AdForwarder} from "./AdForwarder.sol";
import { IERC721Receiver } from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract BoredApesRefSale is AdForwarder {
    constructor(address payable nftAddress) {
        contractAddress = nftAddress;
        // TODO: Add func selectors to only be able to mint nfts
    }

    function rewardAdTaker() internal override {
        // TODO: Transfer nft to msg.sender
    }

    function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
