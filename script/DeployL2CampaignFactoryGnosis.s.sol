// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "../src/crosschainAdvertiser/l2/L2CampaignFactory.sol";

contract DeployL2CampaignFactoryGnosis is Script {
    //
    address constant l1Forwarder = 0x3075fd855E0aB31D02cCed321F883B119cc24271;
    //Connext Mumbai
    address constant connext = 0x5bB83e95f63217CDa6aE3D181BA580Ef377D2109;
    //Domain Optimism-Gnosis
    uint32 constant originDomain = 6778479;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        new L2CampaignFactory(l1Forwarder, connext, originDomain);

        vm.stopBroadcast();
    }
}
//forge script script/DeployL2CampaignFactoryGnosis.s.sol:DeployL2CampaignFactoryGnosis --broadcast --rpc-url https://rpc.chiadochain.net  -- --network--gnosis


