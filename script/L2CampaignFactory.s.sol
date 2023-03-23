// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "../src/crosschainAdvertiser/l2/L2CampaignFactory.sol";

contract DeployL2CampaignFactory is Script {
    //
    address constant l1Forwarder = 0xCf0200e25c618C5Ae14534F6fb3335c97BdfeDF8;
    //Connext Optimism-Goerli
    address constant connext = 0x5Ea1bb242326044699C3d81341c5f535d5Af1504;
    //Domain Optimism-Goerli
    uint32 constant originDomain = 1735356532;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new L2CampaignFactory(l1Forwarder, connext, originDomain);

        vm.stopBroadcast();
    }
}
//forge script script/L2CampaignFactory.s.sol:DeployL2CampaignFactory --broadcast --verify --rpc-url {$OPTIMISM_GOERLI_RPC_URL} --etherscan-api-key {$ETHERSCAN_OPTIMISM_GOERLI_API_KEY} -- --network--optimism-goerli
//forge verify-contract 0xCf0200e25c618C5Ae14534F6fb3335c97BdfeDF8 L2CampaignFactory --watch
