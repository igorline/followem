pragma solidity ^0.8.15;

import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol"; 
import "openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol"; 
import "../ICompleteAd.sol";

contract NFTMint is ICompleteAd {
    function completeAd(address target) external payable returns(bool) {
        // TODO: Should be iterating and transfering all of the tokens
        uint tokenId = IERC721Enumerable(target).tokenOfOwnerByIndex(address(this), 0); 
        IERC721(target).transferFrom(address(this), msg.sender, tokenId);
        return true;
    } 
}
