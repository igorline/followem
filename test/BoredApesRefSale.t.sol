// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
pragma abicoder v2;

import "forge-std/Test.sol";
import "../src/BoredApesRefSale.sol";
import { IBoredApeYachtClub } from "../src/IBoredApeYachtClub.sol";

contract BoredApesRefSaleTest is Test {
    BoredApesRefSale public baRefSale;
    address public bayc;

    event AdConsumed(address indexed _adMaker, address indexed _adTaker);
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    function setUp() public {
        bayc = deployCode("BoredApeYachtClub.sol", abi.encode("BAYC", "BAYC", 1000, 0));
        baRefSale = new BoredApesRefSale(payable(address(bayc)));
        IBoredApeYachtClub(bayc).flipSaleState();
    }

    function testMint() public {
        // test nft transfer event
        vm.expectEmit(true, true, true, false);
        emit Transfer(address(0), address(baRefSale), 0);

        // test ad consumed event
        // TODO: Check maker
        vm.expectEmit(false, true, false, false);
        emit AdConsumed(address(this), address(this));

        baRefSale.executeAd{value: 1 ether}(abi.encodeWithSignature("mintApe(uint256)", 1));

        // test balance of minter (this contract) for bored ape
        // FIXME: Token should be transfered to this address and not baRefSale
        uint num_tokens = IBoredApeYachtClub(bayc).balanceOf(address(baRefSale));
        assertEq(num_tokens, 1, "Token not minted");
        // TODO: test rewards
    }
}
