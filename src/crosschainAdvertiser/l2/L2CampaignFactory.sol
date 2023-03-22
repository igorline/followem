pragma solidity ^0.8.15;

import { L2Campaign } from "./L2Campaign.sol";

contract L2CampaignFactory {
    //The address of the forwarder contract
    address public immutable l1Forwarder;
    //The address of the connext contract
    address public immutable connext;
    //The domain the campaign contract is deployed at
    uint32 public immutable originDomain;

    // TODO: Add event for deployed campaign to track them

    constructor(
        address _l1Forwarder,
        address _connext,
        uint32 _originDomain
    ) {
        l1Forwarder = _l1Forwarder;
        connext = _connext;
        originDomain = _originDomain;
    }

    // TODO: Should be payable
    function deployCampaign(
        uint256 _commission,
        address _target
    ) external returns(address) {
        L2Campaign campaign = new L2Campaign(
            _commission,
            _target,
            l1Forwarder,
            connext,
            originDomain
        );

        return address(campaign);
    } 
}
