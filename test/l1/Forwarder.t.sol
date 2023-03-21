// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IConnext} from "interfaces/core/IConnext.sol";
import "forge-std/Test.sol";
import "../../src/crosschainAdvertiser/l1/Forwarder.sol";
import "../../src/crosschainAdvertiser/l2/L2Campaign.sol";

contract ConnextMock {
    function xcall(
        uint32 destinationDomain,
        address target,
        address to,
        address from,
        uint256 value,
        uint256 gasLimit,
        bytes calldata data
    ) external payable returns (bytes memory) {
        return data;
    }
}

contract ForwarderTest is Test {
    AdForwarder public forwarder;
    L2Campaign public campaign;

    address target = address(1);
    address minter = address(2);
    address advertiser = address(3);

    uint32 destinationDomain = 100;
    uint256 relayerFee = 1 wei;
    uint256 comission = 1 wei;

    event AdExecuted(bytes32 indexed adHash, address indexed advertiser);

    function setUp() public {
        forwarder = new AdForwarder(IConnext(address(new ConnextMock())));
        campaign = new L2Campaign(comission, target, address(forwarder));
        //Campaign is funded with 1 ETH
        vm.deal(address(campaign), 1 ether);
    }

    function testForward() public {
        bytes memory _calldata = abi.encodeWithSignature(
            "mint(address,uint256)",
            minter,
            0
        );

        vm.deal(minter, 1 ether);
        vm.startPrank(minter);

        bytes memory callData = abi.encode(_calldata);
        vm.expectEmit(true, true, false, false);
        emit AdExecuted(
            0xcfc594dc74253c11f1cb658aefb5183c42bb9d236010c148927607d3006e4f95,
            advertiser
        );

        forwarder.executeAd{value: 1 wei}(
            target,
            _calldata,
            address(campaign),
            advertiser,
            destinationDomain,
            relayerFee
        );
        vm.stopPrank();
    }

    function testClaim() public {
        vm.prank(address(0));

        //Pretend that the ad was executed
        campaign.xReceive(
            0x0,
            0,
            address(0),
            minter,
            destinationDomain,
            abi.encode(
                0xcfc594dc74253c11f1cb658aefb5183c42bb9d236010c148927607d3006e4f95,
                advertiser
            )
        );

        vm.prank(advertiser);
        uint balanceBefore = address(advertiser).balance;
        campaign.claim(minter, 0);
        uint balanceAfter = address(advertiser).balance;
        //Advertiser claimed his comission of 1 wei after he prooved that the minter minted token 0 on his behalf
        assert(balanceAfter == balanceBefore + comission);
    }
}
