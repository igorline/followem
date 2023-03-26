// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "../src/crosschainAdvertiser/l2/L2CampaignFactory.sol";

contract DeployL2CampaignFactoryOptimism is Script {
    //
    address constant l1Forwarder = 0x3075fd855E0aB31D02cCed321F883B119cc24271;
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
//forge script script/DeployL2CampaignFactoryOptimism.s.sol:DeployL2CampaignFactoryOptimism --broadcast --verify --rpc-url {$OPTIMISM_GOERLI_RPC_URL} --etherscan-api-key {$ETHERSCAN_OPTIMISM_GOERLI_API_KEY} -- --network--optimism-goerli
//https://goerli-optimism.etherscan.io/address/0x3b41a4a44a9080937400cd40f3d33a78a99eeb25
