// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {IConnext} from "interfaces/core/IConnext.sol";
import "forge-std/Test.sol";
import "../../src/crosschainAdvertiser/l1/Forwarder.sol";
import "../../src/crosschainAdvertiser/l2/L2Campaign.sol";
import "../../src/crosschainAdvertiser/IBoredApeYachtClub.sol";
import "../../src/crosschainAdvertiser/ICrosschainHandler.sol";
import "../../src/crosschainAdvertiser/l1/ConnextHandler.sol";
import "../../src/crosschainAdvertiser/l1/ERC721Forwarder.sol";

contract ConnextMock {
    function xcall(
        uint32, // destinationDomain
        address, // target
        address, // to
        address, // from
        uint256, // value
        uint256, // gasLimit
        bytes calldata data
    ) external payable returns (bytes memory) {
        return data;
    }
}

contract ForwarderTest is Test {
    AdForwarder public forwarder;
    L2Campaign public campaign;
    address public connextMockAddress;
    IBoredApeYachtClub public bayc;
    ERC721Forwarder public erc721Forwarder;
    ICrosschainHandler public crosschainHandler;

    address minter = address(2);
    address advertiser = address(3);

    uint32 chainId = 5;
    uint256 relayerFee = 1 wei;
    uint256 commission = 1 wei;

    event AdConsumed(address indexed target, address indexed adMaker, address indexed adTaker, address campaign, uint32 chainId);

    function setUp() public {
        ConnextMock connextMock = new ConnextMock();
        connextMockAddress = address(connextMock);
        address baycAddress = deployCode("BoredApeYachtClub.sol", abi.encode("BAYC", "BAYC", 1000, 0));
        bayc = IBoredApeYachtClub(baycAddress);
        bayc.flipSaleState();
        erc721Forwarder = new ERC721Forwarder();
        forwarder = new AdForwarder();
        crosschainHandler = new ConnextHandler(IConnext(connextMockAddress), address(forwarder));
        forwarder.setCrosschainHandler(crosschainHandler);

        bytes4 sig = bytes4(keccak256(bytes("mintApe(uint256)")));
        forwarder.setHandler(sig, address(0), address(erc721Forwarder));

        campaign = new L2Campaign{value: 1 ether}(
            commission,
            address(bayc),
            0,
            address(forwarder),
            connextMockAddress,
            chainId
        );
    }

    function testGetHandler() public {
        bytes4 sig = bytes4(keccak256(bytes("mintApe(uint256)")));
        forwarder.setHandler(sig, address(0), address(1));
        forwarder.setHandler(sig, address(4), address(2));
        assertEq(address(forwarder.getHandler(sig, address(4))), address(2));
        assertEq(address(forwarder.getHandler(sig, address(1))), address(1));
    }

    function testForward() public {
        bytes memory _calldata = abi.encodeWithSignature(
            "mintApe(uint256)",
            1
        );

        vm.deal(minter, 1 ether);
        vm.startPrank(minter);

        vm.expectEmit(true, true, false, false);
        emit AdConsumed(
            address(bayc),
            advertiser,
            address(this),
            address(campaign),
            chainId
        );

        assertEq(bayc.balanceOf(address(this)), 0);
        assertEq(bayc.balanceOf(address(forwarder)), 0);

        forwarder.consumeAd{value: 1 ether}(
            address(bayc),
            _calldata,
            address(campaign),
            advertiser,
            chainId,
            relayerFee
        );
        vm.stopPrank();

        assertEq(bayc.balanceOf(minter), 1);
        assertEq(bayc.balanceOf(address(forwarder)), 0);
    }
}
