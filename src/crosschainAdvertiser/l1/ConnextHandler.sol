pragma solidity ^0.8.18;

import { ICrosschainHandler } from "../ICrosschainHandler.sol";
import { IConnext } from "interfaces/core/IConnext.sol";

contract ConnextHandler is ICrosschainHandler {
    // Testnets
    uint32 public constant GOERLI_DOMAIN = 1735353714;
    uint32 public constant GOERLI_CHAINID = 5;

    uint32 public constant OPTIMISM_GOERLI_DOMAIN = 1735356532;
    uint32 public constant OPTIMISM_GOERLI_CHAINID = 420;

    uint32 public constant MUMBAI_DOMAIN = 9991;
    uint32 public constant MUMBAI_CHAINID = 80001;

    // Mainnets
    // uint32 public constant MAINNET_DOMAIN = 6648936;
    // uint32 public constant OPTIMISM_DOMAIN = 1869640809;
    // uint32 public constant ARBITRUM_DOMAIN = 1634886255;
    // uint32 public constant POLYGON_DOMAIN = 1886350457;
    uint32 public constant GNOSIS_DOMAIN = 6778479;
    uint32 public constant GNOSIS_CHAINID = 100;

    mapping (uint32 chainId => uint32 domainId) public destinationDomains;
    address public immutable caller;
    IConnext public immutable connext;

    constructor(IConnext _connext, address _caller) {
        destinationDomains[GOERLI_CHAINID] = GOERLI_DOMAIN;
        destinationDomains[OPTIMISM_GOERLI_CHAINID] = OPTIMISM_GOERLI_DOMAIN;
        destinationDomains[MUMBAI_CHAINID] = MUMBAI_DOMAIN;
        destinationDomains[GNOSIS_CHAINID] = GNOSIS_DOMAIN;

        caller = _caller;
        connext = _connext;
    }

    modifier onlyCaller {
        require(msg.sender == caller, "Can be called only by caller");
        _;
    }

    function doCall(
        // the address of the campaignContract
        address l2CampaignContract,
        // The advertiser that should earn the reward
        bytes memory _calldata,
        // The chain id for campaign contract
        uint32 chainId
    ) external payable onlyCaller {
        uint32 destinationDomain = destinationDomains[chainId];
        connext.xcall{value: msg.value}(
            destinationDomain, // _destination: domain ID of the destination chain
            l2CampaignContract, // _to: address of the target contract (Pong)
            address(0), // _asset: use address zero for 0-value transfers
            msg.sender, // _delegate: address that can revert or forceLocal on destination
            0, // _amount: 0 because no funds are being transferred
            0, // _slippage: can be anything between 0-10000 because no funds are being transferred
            _calldata // _callData: the encoded calldata to send
        );
    }
}
