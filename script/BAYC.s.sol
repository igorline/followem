// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.7.0;

import "forge-std/Script.sol";
import "../src/BoredApeYachtClub.sol";

contract DeployBAYC is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        BoredApeYachtClub nft = new BoredApeYachtClub(
            "Bored Ape Yacht Club",
            "BAYC",
            10000,
            0
        );

        // start the sale
        nft.flipSaleState();

        vm.stopBroadcast();
    }
}
