pragma solidity ^0.8.15;

import {L2Campaign} from "./L2Campaign.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract L2CampaignFactory is Ownable {
    // The address of the caller contract
    address public l1Caller;
    // The address of the connext contract
    address public immutable connext;
    // The domain the campaign contract is deployed at
    uint32 public immutable originDomain;

    // Event for new campaign created
    event CampaignCreated(
        address indexed target,
        address indexed author,
        address campaign,
        uint256 commission,
        uint256 totalReward
    );

    constructor(address _l1Caller, address _connext, uint32 _originDomain) {
        l1Caller = _l1Caller;
        connext = _connext;
        originDomain = _originDomain;
    }

    function setL1Caller(address newCaller) external onlyOwner {
        l1Caller = newCaller;
    }

    function deployCampaign(
        uint256 _commission,
        address _target,
        uint256 _deadline
    ) external payable {
        L2Campaign campaign = new L2Campaign{value: msg.value}(
            _commission,
            _target,
            _deadline,
            l1Caller,
            connext,
            originDomain
        );

        emit CampaignCreated(
            _target,
            msg.sender,
            address(campaign),
            _commission,
            msg.value
        );
    }
}
