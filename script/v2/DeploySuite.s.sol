// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../src/Account.sol";
import "../../src/AccountRegistry.sol";
import "../../src/Character.sol";
import "../../src/Trait.sol";
import "openzeppelin-contracts/token/ERC721/ERC721.sol";

// forge script --keystores $ETH_KEYSTORE --sender $ETH_FROM --broadcast --fork-url $GOERLI_RPC_URL script/v2/DeploySuite.s.sol:Deploy

// 0x509f027c5E26eA6Ce1F4354aBDE668647563B7F6 -- account
// 0x7c84F7499f964965c938c44E1560E426d81080d2 -- registry
// 0xFC6d357A0df3a2b92752d33B5852464Cc07db9bb -- character
// 0x58F0E67377f6686A4cb181f1FB763a91185dC30B -- trait

// forge verify-contract --chain 5 --etherscan-api-key $ETHERSCAN_API_KEY --constructor-args $(cast abi-encode "constructor(address,address)" "0x58F0E67377f6686A4cb181f1FB763a91185dC30B" "0x7c84F7499f964965c938c44E1560E426d81080d2" 18 1000000000000000000000) 0xFC6d357A0df3a2b92752d33B5852464Cc07db9bb src/Character.sol:Character --watch

// forge verify-contract --chain 5 --etherscan-api-key $ETHERSCAN_API_KEY 0x58F0E67377f6686A4cb181f1FB763a91185dC30B src/Trait.sol:Trait --watch

// forge verify-contract --chain 5 --etherscan-api-key $ETHERSCAN_API_KEY --constructor-args $(cast abi-encode "constructor(address)" "0x509f027c5E26eA6Ce1F4354aBDE668647563B7F6" 18 1000000000000000000000) 0x7c84F7499f964965c938c44E1560E426d81080d2 src/AccountRegistry.sol:SimpleERC6551AccountRegistry --watch

contract Deploy is Script {
    function run() public {
        vm.startBroadcast();

        // use existing registry
        SimpleERC6551AccountRegistry registry = SimpleERC6551AccountRegistry(0x7c84F7499f964965c938c44E1560E426d81080d2);
        // deploy new trait contract
        // Trait trait = new Trait();
        // deploy new character contract using trait as renderer and registry as registry
        new Character(address(0x58F0E67377f6686A4cb181f1FB763a91185dC30B), address(registry));
        vm.stopBroadcast();
    }
}
