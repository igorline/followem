pragma solidity ^0.8.15;

function getAdHash(
    address target,
    bytes memory _calldata,
    address l2CampaignContract,
    address adverstiser,
    uint32 destinationDomain
) pure returns (bytes32) {
    return
        keccak256(
            abi.encodePacked(
                target,
                keccak256(_calldata),
                l2CampaignContract,
                adverstiser,
                destinationDomain
            )
        );
}
