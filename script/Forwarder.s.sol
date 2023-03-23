// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "../src/crosschainAdvertiser/l1/Forwarder.sol";
import {IConnext} from "interfaces/core/IConnext.sol";

contract DeployForwarder is Script {
    address constant connextGoerli = 0xFCa08024A6D4bCc87275b1E4A1E22B71fAD7f649;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        AdForwarder forwarder = new AdForwarder(IConnext(connextGoerli));

        vm.stopBroadcast();
    }
}
//forge script script/Forwarder.s.sol:DeployForwarder --broadcast --verify --rpc-url {$GOERLI_RPC_URL}

//https://goerli.etherscan.io/address/0xcf0200e25c618c5ae14534f6fb3335c97bdfedf8
