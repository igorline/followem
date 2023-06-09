// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "forge-std/Test.sol";
import "../../src/crosschainAdvertiser/l2/L2Campaign.sol";

contract L2CampaignTest is Test {
    L2Campaign public campaign;

    address target = address(1);
    address minter = address(2);
    address advertiser = address(3);
    address forwarderAddress = address(4);
    address connextAddress = address(5);

    uint32 destinationDomain = 100;

    uint256 commission = 1 wei;

    function setUp() public {
        campaign = new L2Campaign{value: 1 ether}(
            commission,
            target,
            0,
            forwarderAddress,
            connextAddress,
            destinationDomain,
            bytes4(keccak256(bytes("mintApe(uint256)")))
        );
    }
     
    function testClaim() public {
        //The connext bridge is allowed to set the write new entries to the campaign contract
        vm.prank(connextAddress);
        
        //Pretend that the ad was executed
        campaign.xReceive(
            0x0,
            0,
            address(0),
            forwarderAddress,
            destinationDomain,
            abi.encode(
                bytes4(keccak256(bytes("mintApe(uint256)"))),
                advertiser
            )
        );

        vm.prank(advertiser);
        uint balanceBefore = address(advertiser).balance;
        campaign.claim();
        uint balanceAfter = address(advertiser).balance;
        //Advertiser claimed his commission of 1 wei after he prooved that the minter minted token 0 on his behalf
        assert(balanceAfter == balanceBefore + commission);
    }
}
