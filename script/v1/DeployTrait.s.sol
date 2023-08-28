// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../src/Trait.sol";

// forge script --keystores $ETH_KEYSTORE --sender $ETH_FROM --broadcast --fork-url $GOERLI_RPC_URL script/DeployTrait.s.sol:Deploy
// forge verify-contract --chain 5 --etherscan-api-key $ETHERSCAN_API_KEY 0xf47a94726cf6486dcbebf7d34ba4c5eff457c752 src/Trait.sol:Trait

contract Deploy is Script {
    function run() public {
        // vm.startBroadcast();
        // new Trait();
        // Trait trait = Trait(0xF40543a338a670be62BF15fFebdc671af1f8c099);
        // trait.mint(7);
        // vm.stopBroadcast();
    }
}
