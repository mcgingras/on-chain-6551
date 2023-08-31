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
// 0xA52664865409515cbC07Ec10744aE54022a3E119 -- character
// 0x11d4E56Bf556C43e72b91cEb6e74e04cDcDA7e03 -- trait

// forge verify-contract --chain 5 --etherscan-api-key $ETHERSCAN_API_KEY --constructor-args $(cast abi-encode "constructor(address,address)" "0x11d4E56Bf556C43e72b91cEb6e74e04cDcDA7e03" "0x7c84F7499f964965c938c44E1560E426d81080d2" 18 1000000000000000000000) 0xA52664865409515cbC07Ec10744aE54022a3E119 src/Character.sol:Character --watch

// forge verify-contract --chain 5 --etherscan-api-key $ETHERSCAN_API_KEY 0x11d4E56Bf556C43e72b91cEb6e74e04cDcDA7e03 src/Trait.sol:Trait --watch

// forge verify-contract --chain 5 --etherscan-api-key $ETHERSCAN_API_KEY --constructor-args $(cast abi-encode "constructor(address)" "0x509f027c5E26eA6Ce1F4354aBDE668647563B7F6" 18 1000000000000000000000) 0x7c84F7499f964965c938c44E1560E426d81080d2 src/AccountRegistry.sol:SimpleERC6551AccountRegistry --watch

contract Deploy is Script {
    function run() public {
        vm.startBroadcast();

        // use existing registry
        SimpleERC6551AccountRegistry registry = SimpleERC6551AccountRegistry(0x7c84F7499f964965c938c44E1560E426d81080d2);
        // deploy new trait contract
        Trait trait = new Trait();
        // deploy new character contract using trait as renderer and registry as registry
        new Character(address(trait), address(registry));
        vm.stopBroadcast();
    }
}
