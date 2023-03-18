// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/BoredApesRefSale.sol";
import "../src/BoredApeYachtClub.sol";

contract BoredApesRefSaleTest is Test {
    BoredApesRefSale public baRefSale;
    BoredApeYachtClub public bayc;

    function setUp() public {
        bayc = new BoredApeYachtClub("BAYC", "BAYC", 1000, 0);
        baRefSale = new BoredApesRefSale(address(bayc));
    }

    function testMint() public {
        baRefSale.executeAd(abi.encodeWithSignature("mintApe(uint)", 1));
        // TODO: test add event
        // TODO: test balance of minter (this contract) for bored ape
        // TODO: test rewards
    }
}
