pragma solidity ^0.8.15;

// TODO: Do fallback to save gassss
interface ICompleteAd {
    function completeAd(address target) external payable returns(bool);
}
