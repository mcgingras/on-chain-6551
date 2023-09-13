// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "openzeppelin-contracts/token/ERC721/ERC721.sol";

import { Character } from "../../src/Character.sol";
import { Trait } from "../../src/Trait.sol";
import { TraitStorage } from "../../src/TraitStorage.sol";
import { SVGStorageBase } from "../../src/SVGStorageBase.sol";
import { SVGStorageEmpty } from "../../src/SVGStorageEmpty.sol";
import { SimpleERC6551Account as TBA } from "../../src/Account.sol";
import { ERC6551Registry } from "../../lib/reference/src/ERC6551Registry.sol";

// Deploying to Goerli
// forge script --keystores $ETH_KEYSTORE --sender $ETH_FROM --broadcast --fork-url $GOERLI_RPC_URL script/v3/DeploySuite.s.sol:Deploy

// Deploying to Base Goerli
// forge script --keystores $ETH_KEYSTORE --sender $ETH_FROM --broadcast --fork-url $BASE_GOERLI_RPC_URL script/v3/DeploySuite.s.sol:Deploy

// Goerli Contracts
// ----------------------------------------------------

// forge verify-contract --chain 5 --etherscan-api-key $ETHERSCAN_API_KEY --constructor-args $(cast abi-encode "constructor(address,address)" "0xfb844a0E38E1699D1FfDB03b0cb88d75dc2cFc97" "0x7c84F7499f964965c938c44E1560E426d81080d2" 18 1000000000000000000000) 0xA52664865409515cbC07Ec10744aE54022a3E119 src/Character.sol:Character --watch


contract Deploy is Script {
    function run() public {
        vm.startBroadcast();
        // BASE
        // TBA account = TBA(payable(0x139e89fCAb8bBB005358b1362175069F20cCa138));
        // SVGStorageBase svgStorageBase = SVGStorageBase(0x6dE9ee54E8FF85D78E20DaE243a5D1565bF8d741);
        // SVGStorageEmpty svgStorageEmpty = SVGStorageEmpty(0xc126701d96718d6af157fD85fa3950A4A1Ab055D);
        // TraitStorage traitStorage = TraitStorage(0xe2c32869Fe199cacD7c3B840Ca1426eD6d74268f);
        // ERC6551Registry registry = ERC6551Registry(0xAd08a4C9C3bA4ea89b2fe19E30761411548AcBe1);
        // Trait trait = Trait(0x4377183d9f9376E7DA270c3d103F0250A5ec803f);
        // Character character = Character(0xadBc7EC633B78dc4407215D56Eb0861dD7c51431);

        // GOERLI

        // RESET
        // TBA account = new TBA();
        // SVGStorageBase svgStorageBase = new SVGStorageBase();
        // SVGStorageEmpty svgStorageEmpty = new SVGStorageEmpty();
        // TraitStorage traitStorage = new TraitStorage();
        // ERC6551Registry registry = new ERC6551Registry();
        // Trait trait = new Trait(address(traitStorage), address(svgStorageBase));
        // new Character(address(trait), address(registry), address(account), address(svgStorageBase), address(svgStorageEmpty));
        vm.stopBroadcast();
    }
}
