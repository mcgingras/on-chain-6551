// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { console } from "forge-std/console.sol";
import { Character } from "../src/Character.sol";
import { Trait } from "../src/Trait.sol";
import { SimpleERC6551AccountRegistry } from "../src/AccountRegistry.sol";
import { SimpleERC6551Account } from "../src/Account.sol";
import { TraitStorage } from "../src/TraitStorage.sol";
import { SVGStorage } from "../src/SVGStorage.sol";

contract CharacterTest is Test {
    Character public character;
    Trait public trait;
    TraitStorage public traitStorage;
    SVGStorage public svgStorage;
    SimpleERC6551AccountRegistry public registry;

    function setUp() public {
      SimpleERC6551Account account = new SimpleERC6551Account();
      svgStorage = new SVGStorage();
      traitStorage = new TraitStorage();
      registry = new SimpleERC6551AccountRegistry(address(account));
      trait = new Trait(address(traitStorage), address(svgStorage));
      character = new Character(address(trait), address(registry), address(svgStorage));
    }

    function testTokenURI() public {
      // token URI should return the empty case when no traits are minted towards it
      string memory emptyTokenURI = character.tokenURI(0);
      assertEq(emptyTokenURI, svgStorage.EMPTY());

      // mint a trait of token 0
      // assuming goerli (this is baked into contract rn)
      address tba = registry.account(5, address(character), 0);
      trait.mint(tba);
      trait.equip(1);

      // token URI should return some value
      string memory tokenURI = character.tokenURI(0);
      // console.log(tokenURI);
      assertNotEq(tokenURI, emptyTokenURI);
    }
}