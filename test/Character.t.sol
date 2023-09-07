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
    SimpleERC6551Account public account;

    address _owner = address(123);
    address _character1TBA;

    function setUp() public {
      account = new SimpleERC6551Account();
      svgStorage = new SVGStorage();
      traitStorage = new TraitStorage();
      registry = new SimpleERC6551AccountRegistry(address(account));
      trait = new Trait(address(traitStorage), address(svgStorage));
      character = new Character(address(trait), address(registry), address(svgStorage));
      // start dumb hack to get chainid
      uint256 id;
      assembly {
        id := chainid()
      }
      // end dumb hack to get chainid
      character.mint(_owner);
      _character1TBA = registry.createAccount(id, address(character), 1);
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
      account.execute(address(trait), 0, data, 0);

      string memory tokenURI = character.tokenURI(0);
      assertNotEq(tokenURI, emptyTokenURI);
      vm.stopPrank();
    }
}