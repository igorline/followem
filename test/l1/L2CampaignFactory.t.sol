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
    
    event CampaignCreated(address indexed target, address indexed author, uint256 commission);

    function setUp() public {
        campaignFactory = new L2CampaignFactory(
            forwarderAddress,
            connextAddress,
            destinationDomain
        );
    }

    function testDeployCampaign() public {
        vm.expectEmit(true, true, false, true);
        emit CampaignCreated(target, address(this), commission);

        campaignFactory.deployCampaign(
            commission,
            target
        );
    }
}
