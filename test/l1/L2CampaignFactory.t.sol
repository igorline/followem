// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/crosschainAdvertiser/l2/L2Campaign.sol";
import "../../src/crosschainAdvertiser/l2/L2CampaignFactory.sol";

contract CampaignFactoryTest is Test {
    L2CampaignFactory public campaignFactory;

    address target = address(1);
    address forwarderAddress = address(2);
    address connextAddress = address(3);

    uint32 destinationDomain = 100;
    uint256 commission = 1 wei;

    function setUp() public {
        campaignFactory = new L2CampaignFactory(
            forwarderAddress,
            connextAddress,
            destinationDomain
        );
    }

    function testDeployCampaign() public {
        address campaign = campaignFactory.deployCampaign(
            commission,
            target
        );
        assertEq(campaign, address(0x104fBc016F4bb334D775a19E8A6510109AC63E00));
    }
}
