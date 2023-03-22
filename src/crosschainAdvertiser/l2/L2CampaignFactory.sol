pragma solidity ^0.8.15;

import { L2Campaign } from "./L2Campaign.sol";

contract L2CampaignFactory {
    // The address of the forwarder contract
    address public immutable l1Forwarder;
    // The address of the connext contract
    address public immutable connext;
    // The domain the campaign contract is deployed at
    uint32 public immutable originDomain;

    // Event for new campaign created
    event CampaignCreated(address indexed target, address indexed author, uint256 commission, uint256 totalReward);

    constructor(
        address _l1Forwarder,
        address _connext,
        uint32 _originDomain
    ) {
        l1Forwarder = _l1Forwarder;
        connext = _connext;
        originDomain = _originDomain;
    }

    function deployCampaign(
        uint256 _commission,
        address _target
    ) external payable {
        require(msg.value >= _commission, "Commission cannot be less than total reward added");

        new L2Campaign(
            _commission,
            _target,
            l1Forwarder,
            connext,
            originDomain
        );

        emit CampaignCreated(_target, msg.sender, _commission, msg.value);
    } 
}
