// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { console } from "forge-std/console.sol";
import { Character } from "../src/Character.sol";
import { Trait } from "../src/Trait.sol";
import { TraitStorage } from "../src/TraitStorage.sol";
import { SVGStorage } from "../src/SVGStorage.sol";
import { SimpleERC6551Account as TBA } from "../src/Account.sol";
import { SimpleERC6551AccountRegistry } from "../src/Registry.sol";

contract CharacterTest is Test {
    Character public character;
    Trait public trait;
    TraitStorage public traitStorage;
    SVGStorage public svgStorage;
    SimpleERC6551AccountRegistry public registry;
    TBA public account;
    TBA public character1TBA;

    address _owner = address(123);

    function setUp() public {
      vm.startPrank(_owner);
      account = new TBA();
      svgStorage = new SVGStorage();
      traitStorage = new TraitStorage();
      registry = new SimpleERC6551AccountRegistry(address(account));
      trait = new Trait(address(traitStorage), address(svgStorage));
      character = new Character(address(trait), address(registry), address(account), address(svgStorage));
      character.mint(_owner);
      character1TBA = TBA(payable(registry.createAccount(address(character), 1)));
      vm.stopPrank();
    }

    function testTokenURI() public {
      vm.startPrank(_owner);
      // token URI should return the empty case when no traits are minted towards it
      string memory emptyTokenURI = character.tokenURI(1);
      assertEq(emptyTokenURI, svgStorage.EMPTY());

      // mint a trait to the TBA of character with id 1 (owned by owner)
      trait.mint(address(character1TBA));

      bytes4 functionSelector = bytes4(keccak256(bytes("equip(uint256)")));
      bytes memory data = abi.encodeWithSelector(functionSelector, 1);

      character1TBA.execute(address(trait), 0, data, 0);

      string memory tokenURI = character.tokenURI(1);
      assertNotEq(tokenURI, emptyTokenURI);
      vm.stopPrank();
    }
}