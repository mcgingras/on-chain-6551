// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { console } from "forge-std/console.sol";
import { Character } from "../src/Character.sol";
import { Trait } from "../src/Trait.sol";
import { TraitStorage } from "../src/TraitStorage.sol";
import { SVGStorage } from "../src/SVGStorage.sol";
import {Account as TBA} from "../lib/contracts/src/Account.sol";
import { ERC6551Registry } from "../lib/reference/src/ERC6551Registry.sol";

contract CharacterTest is Test {
    Character public character;
    Trait public trait;
    TraitStorage public traitStorage;
    SVGStorage public svgStorage;
    ERC6551Registry public registry;
    TBA public account;

    address _owner = address(123);
    address _character1TBA;

    function setUp() public {
      account = new TBA(address(2), address(3));
      svgStorage = new SVGStorage();
      traitStorage = new TraitStorage();
      registry = new ERC6551Registry();
      trait = new Trait(address(traitStorage), address(svgStorage));
      character = new Character(address(trait), address(registry), address(account), address(svgStorage));
      character.mint(_owner);
      _character1TBA = registry.createAccount(address(account), block.chainid, address(character), 1, 123, "");
    }

    function testTokenURI() public {
      vm.startPrank(_owner);
      // token URI should return the empty case when no traits are minted towards it
      string memory emptyTokenURI = character.tokenURI(0);
      assertEq(emptyTokenURI, svgStorage.EMPTY());

      // mint a trait of token 1
      trait.mint(_character1TBA);

      bytes4 functionSelector = bytes4(keccak256(bytes("equip(uint256)")));
      bytes memory data = abi.encodeWithSelector(functionSelector, 1);
      account.executeCall(address(trait), 0, data);

      string memory tokenURI = character.tokenURI(0);
      assertNotEq(tokenURI, emptyTokenURI);
      vm.stopPrank();
    }
}