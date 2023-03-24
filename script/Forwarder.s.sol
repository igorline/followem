// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.15;

import "forge-std/Script.sol";
import "../src/crosschainAdvertiser/l1/Forwarder.sol";
import "../src/crosschainAdvertiser/l1/ERC721Forwarder.sol";
import {IConnext} from "interfaces/core/IConnext.sol";

contract DeployForwarder is Script {
    address constant connextGoerli = 0xFCa08024A6D4bCc87275b1E4A1E22B71fAD7f649;

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        AdForwarder forwarder = new AdForwarder(IConnext(connextGoerli));

        // deploy erc721 forwarder
        ERC721Forwarder erc721Forwarder = new ERC721Forwarder();

        // add handler for minting Apes
        bytes4 mintApe = bytes4(keccak256(bytes("mintApe(uint256)")));
        forwarder.setHandler(mintApe, address(0), address(erc721Forwarder));

        vm.stopBroadcast();
    }
}
//forge script script/Forwarder.s.sol:DeployForwarder --broadcast --verify --rpc-url {$GOERLI_RPC_URL}

//https://goerli.etherscan.io/address/0xe076ba8bfbde4074cd99694558ba77b60fef5c21
