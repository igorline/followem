pragma solidity ^0.8.19;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import {IConnext} from "interfaces/core/IConnext.sol";
import {IXReceiver} from "interfaces/core/IXReceiver.sol";

import {getAdHash} from "../AdHash.sol";
import {ICompleteAd} from "../ICompleteAd.sol";

contract AdForwarder is Ownable {
    IConnext public immutable connext;

    // here we can have generic func selector or specific to contract
    // generic: 0xABCDEF00...00
    // specific: 0xABCDEF12...99
    mapping(bytes24 selector => address handler) public router; 

    constructor(IConnext _connext) {
        connext = _connext;
    }

    event AdExecuted(bytes32 indexed adHash, address indexed advertiser);

    function executeAd(
        // the address of the contract the calldata should be exectuted at
        address target,
        // The actual transaction calldata
        bytes calldata _calldata,
        // the address of the campaignContract
        address l2CampaignContract,
        // The advertiser that should earn the reward
        address advertiser,
        // The domain the campain contract is deployed
        uint32 destinationDomain,
        // The relayerFee that needs to be paid to the connext relayer
        uint256 relayerFee
    ) external payable {
        (bool success, bytes memory result) = target.call{value: msg.value - relayerFee}(_calldata);
        require(success, "tx failed");
        // Adhash works as an id for the ad
        bytes32 adHash = getAdHash(
            target,
            _calldata,
            l2CampaignContract,
            advertiser,
            destinationDomain
        );

        connext.xcall{value: relayerFee}(
            destinationDomain, // _destination: domain ID of the destination chain
            target, // _to: address of the target contract (Pong)
            address(0), // _asset: use address zero for 0-value transfers
            msg.sender, // _delegate: address that can revert or forceLocal on destination
            0, // _amount: 0 because no funds are being transferred
            0, // _slippage: can be anything between 0-10000 because no funds are being transferred
            abi.encode(adHash, advertiser) // _callData: the encoded calldata to send
        );

        // getting selector from calldata
        bytes4 selector = bytes4(_calldata);

        address handler = getHandler(selector, target);

        // TODO: Reason about possible change of those signatures
        // TODO: Another issue is the need to be able to receive some tokens or implement specfiic interfaces here
        (bool _success, bytes memory _result) = address(handler).delegatecall(abi.encodeWithSignature("completeAd(address)", target));
        // TODO: require success
        
        emit AdExecuted(adHash, advertiser);
    }

    
    // FIXME: Should it just be supportsInterface?
    function onERC721Received(address, address, uint256, bytes memory) public pure returns (bytes4) {
        return this.onERC721Received.selector;
    }

    function getSig(bytes4 selector, address target) internal pure returns (bytes24) {
        return bytes24(uint192(uint32(selector)) << 160 | uint160(target));
    }

    function getHandler(bytes4 selector, address target) public view returns (address) {
        bytes24 b = getSig(selector, target);
        if (router[b] == address(0)) {
            b = getSig(selector, address(0));
        }
        // TODO: handle not found case

        return router[b];
    }

    // TODO: Check whether supports interface
    function setHandler(bytes4 selector, address contractAddress, address handler) external onlyOwner {
        // TODO: Add owner role
        bytes24 b = getSig(selector, contractAddress);
        router[b] = handler;
        // TODO: Add event for new project type added
    }
}
