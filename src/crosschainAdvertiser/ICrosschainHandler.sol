pragma solidity ^0.8.18;

interface ICrosschainHandler {
    function doCall(
        address l2CampaignContract,
        address advertiser,
        uint32 chainId
    ) external payable;
}
