// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "../src/crosschainAdvertiser/l2/L2CampaignFactory.sol";

contract DeployL2CampaignFactoryMumbai is Script {
    //
    address constant l1Forwarder = 0x3075fd855E0aB31D02cCed321F883B119cc24271;
    //Connext Mumbai
    address constant connext = 0x2334937846Ab2A3FCE747b32587e1A1A2f6EEC5a;
    //Domain Optimism-Goerli
    uint32 constant originDomain = 9991;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new L2CampaignFactory(l1Forwarder, connext, originDomain);

        vm.stopBroadcast();
    }
}
//forge script script/DeployL2CampaignFactoryMumbai.s.sol:DeployL2CampaignFactoryMumbai --broadcast --verify --rpc-url https://polygon-mumbai.blockpi.network/v1/rpc/public --etherscan-api-key {$ETHERSCAN_OPTIMISM_GOERLI_API_KEY} -- --network--mumbai

//forge verify-contract 0xB1e5C3f7898E46277EefAFa0E8732760E07ffe21 L2CampaignFactory M8HM4IYY4Z71HS8TC9BQNUAT3CN6XH77G7 --chain mumbai --constructor-args-path factory-args.txt
