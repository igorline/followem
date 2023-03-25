pragma solidity ^0.8.18;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import "openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "openzeppelin-contracts/contracts/token/ERC721/extensions/IERC721Enumerable.sol";

import {ICompleteAd} from "../ICompleteAd.sol";
import {ICrosschainHandler} from "../ICrosschainHandler.sol";

contract AdForwarder is Ownable {
    ICrosschainHandler public crosschainHandler;

    // here we can have generic func selector or specific to contract
    // generic: 0xABCDEF00...00
    // specific: 0xABCDEF12...99
    mapping(bytes24 selector => address handler) public router;

    event AdConsumed(address indexed target, address indexed adMaker, address indexed adTaker, address campaign, uint32 chainId);

    function consumeAd(
        // the address of the contract the calldata should be exectuted at
        address target,
        // The actual transaction calldata
        bytes calldata _calldata,
        // the address of the campaignContract
        address l2CampaignContract,
        // The advertiser that should earn the reward
        address advertiser,
        // The chain id for campaign contract
        uint32 chainId,
        // The relayerFee that needs to be paid to the relayer
        uint256 relayerFee
    ) external payable {
        // 1. Call target with calldata
        (bool successTarget, bytes memory res1) = target.call{
            value: msg.value - relayerFee
        }(_calldata);
        require(successTarget, "target tx failed");

        // 2. Call post ad complete function
        // getting selector from calldata
        bytes4 selector = bytes4(_calldata);
        address handler = getHandler(selector, target);

        // TODO: Reason about possible change of those signatures
        // TODO: Another issue is the need to be able to receive some tokens or implement specfiic interfaces here
        (bool successHandler, bytes memory res2) = address(handler).delegatecall(
            abi.encodeWithSignature("completeAd(address)", target)
        );
        require(successHandler, "handler tx failed");

        // 3. Call crosschain handler to unlock reward to advertiser
        crosschainHandler.doCall{value: relayerFee}(
            l2CampaignContract,
            abi.encode(selector, advertiser),
            chainId
        );

        // 4. Emit event
        emit AdConsumed(target, advertiser, msg.sender, l2CampaignContract, chainId);
    }

    // FIXME: Should it just be supportsInterface?
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public pure returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function getSig(
        bytes4 selector,
        address target
    ) internal pure returns (bytes24) {
        return bytes24((uint192(uint32(selector)) << 160) | uint160(target));
    }

    function getHandler(
        bytes4 selector,
        address target
    ) public view returns (address) {
        bytes24 b = getSig(selector, target);
        if (router[b] == address(0)) {
            b = getSig(selector, address(0));
        }
        // TODO: handle not found case

        return router[b];
    }

    function setCrosschainHandler(ICrosschainHandler _crosschainHandler) external onlyOwner {
        crosschainHandler = _crosschainHandler;
    }

    // TODO: Check whether supports interface
    function setHandler(
        bytes4 selector,
        address contractAddress,
        address handler
    ) external onlyOwner {
        // TODO: Add owner role
        bytes24 b = getSig(selector, contractAddress);
        router[b] = handler;
        // TODO: Add event for new project type added
    }
}
