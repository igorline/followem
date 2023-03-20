pragma solidity ^0.8.0;

interface IBoredApeYachtClub {
    function flipSaleState() external;
    function mintApe(uint256 _tokenId) external;
    function balanceOf(address _owner) external view returns (uint256);
}
