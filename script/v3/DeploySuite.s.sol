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

// Deploying to Base
// forge script --keystores $ETH_KEYSTORE --sender $ETH_FROM --broadcast --fork-url $BASE_RPC_URL script/v3/DeploySuite.s.sol:Deploy

// forge verify-contract --chain 8453 --etherscan-api-key $BASESCAN_API_KEY --constructor-args $(cast abi-encode "constructor(address,address,address,address,address)" "0xb7d488da393b4F34813DabeB295931a2B86ea505" "0x1B7424e264890950dDFA61C2eeD28C9676b9205f" "0xf21074833502cBb87d69B7e865C19852a63Ca34b" "0x139e89fCAb8bBB005358b1362175069F20cCa138" "0x536a8af52440C60295CFA5176D5B62F399aD429b" 18 1000000000000000000000) 0x6dE9ee54E8FF85D78E20DaE243a5D1565bF8d741 src/Character.sol:Character --watch

// forge verify-contract --chain 8453 --etherscan-api-key $BASESCAN_API_KEY --constructor-args $(cast abi-encode "constructor(address,address)" "0xBE38029BFC6641f32d42F5C01c4332C7fCDC5Af9" "0x139e89fCAb8bBB005358b1362175069F20cCa138" 18 1000000000000000000000) 0xb7d488da393b4F34813DabeB295931a2B86ea505 src/Trait.sol:Trait --watch

// forge verify-contract --chain 8453 --etherscan-api-key $BASESCAN_API_KEY 0xf21074833502cBb87d69B7e865C19852a63Ca34b src/Account.sol:SimpleERC6551Account --watch

// forge verify-contract --chain 8453 --etherscan-api-key $BASESCAN_API_KEY 0x1B7424e264890950dDFA61C2eeD28C9676b9205f lib/reference/src/ERC6551Registry.sol:ERC6551Registry --watch



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

        // BASE
        // TBA account = TBA(payable(0xf21074833502cBb87d69B7e865C19852a63Ca34b));
        // SVGStorageBase svgStorageBase = SVGStorageBase(0x139e89fCAb8bBB005358b1362175069F20cCa138);
        // SVGStorageEmpty svgStorageEmpty = SVGStorageEmpty(0x536a8af52440C60295CFA5176D5B62F399aD429b);
        // TraitStorage traitStorage =  TraitStorage(0xBE38029BFC6641f32d42F5C01c4332C7fCDC5Af9);
        // ERC6551Registry registry =  ERC6551Registry(0x1B7424e264890950dDFA61C2eeD28C9676b9205f);
        // Trait trait =  Trait(0xb7d488da393b4F34813DabeB295931a2B86ea505);
        // Character character = Character(0x6dE9ee54E8FF85D78E20DaE243a5D1565bF8d741);

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
