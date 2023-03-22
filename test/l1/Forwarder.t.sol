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
    ConnextMock public connextMock;

    address target = address(1);
    address minter = address(2);
    address advertiser = address(3);

    uint32 destinationDomain = 100;
    uint256 relayerFee = 1 wei;
    uint256 commission = 1 wei;

    event AdExecuted(bytes32 indexed adHash, address indexed advertiser);

    function setUp() public {
        connextMock = new ConnextMock();
        forwarder = new AdForwarder(IConnext(address(connextMock)));
        campaign = new L2Campaign{value: 1 ether}(
            commission,
            target,
            0,
            address(forwarder),
            address(connextMock),
            destinationDomain
        );
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

}
