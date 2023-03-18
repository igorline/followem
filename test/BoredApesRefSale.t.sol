// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/BoredApesRefSale.sol";
import "../src/BoredApeYachtClub.sol";

contract BoredApesRefSaleTest is Test {
    BoredApesRefSale public baRefSale;
    BoredApeYachtClub public bayc;

    event AdConsumed(address indexed _adMaker, address indexed _adTaker);

    function setUp() public {
        bayc = new BoredApeYachtClub("BAYC", "BAYC", 1000, 0);
        baRefSale = new BoredApesRefSale(address(bayc));
    }

    function testMint() public {
        // TODO: Check maker
        vm.expectEmit(false, true, false, false);

        // test ad event
        emit AdConsumed(address(this), address(this));

        baRefSale.executeAd{value: 1 ether}(abi.encodeWithSignature("mintApe(uint256)", 1));
        // TODO: test rewards
    }
}
