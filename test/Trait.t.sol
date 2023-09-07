// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { console } from "forge-std/console.sol";
import { Character } from "../src/Character.sol";
import { Trait } from "../src/Trait.sol";
import { TraitDetails } from "../src/TraitDetailsStruct.sol";
import { SimpleERC6551AccountRegistry } from "../src/AccountRegistry.sol";
import { SimpleERC6551Account } from "../src/Account.sol";
import { TraitStorage } from "../src/TraitStorage.sol";
import { SVGStorage } from "../src/SVGStorage.sol";

contract TraitTest is Test {
    Trait public trait;
    TraitStorage public traitStorage;
    SVGStorage public svgStorage;
    SimpleERC6551Account public account;
    SimpleERC6551AccountRegistry public registry;

    address _owner = address(123);
    address _recipient = address(456);
    address _ownerTBA;
    address _recipientTBA;

    function setUp() public {
      svgStorage = new SVGStorage();
      traitStorage = new TraitStorage();
      account = new SimpleERC6551Account();
      registry = new SimpleERC6551AccountRegistry(address(account));
      trait = new Trait(address(traitStorage), address(svgStorage));
    }

    function testMint() public {
      vm.startPrank(_owner);
      trait.mint(msg.sender);
      vm.stopPrank();

      assertEq(trait.balanceOf(msg.sender), 1);
    }

    function testEquip() public {
      vm.startPrank(_owner);
      trait.mint(msg.sender);
      vm.stopPrank();

      // trait starts as unequipped
      TraitDetails memory preEquipDetails = trait.getTraitDetails(1);
      assertEq(preEquipDetails.equipped, false);

      trait.equip(1);
      TraitDetails memory postEquipDetails = trait.getTraitDetails(1);
      assertEq(postEquipDetails.equipped, true);

      trait.unequip(1);
      TraitDetails memory postUnequipDetails = trait.getTraitDetails(1);
      assertEq(postUnequipDetails.equipped, false);
    }

    function testTokenURI() public {
      vm.startPrank(_owner);
      trait.mint(msg.sender);
      vm.stopPrank();

      string memory tokenURI = trait.tokenURI(1);
      assertNotEq(tokenURI, "");
    }

    function testTraitsOfOwner() public {
      vm.startPrank(_owner);
      trait.mint(msg.sender);
      vm.stopPrank();

      uint256[] memory traits = trait.traitsOfOwner(msg.sender);
      assertEq(traits.length, 1);
    }

    function testEquippedTraitsOfOwner() public {
      vm.startPrank(_owner);
      trait.mint(msg.sender);
      vm.stopPrank();

      trait.equip(1);
      uint256[] memory equippedTraits = trait.equippedTraitsOfOwner(msg.sender);
      assertEq(equippedTraits.length, 1);
    }

    function testUnequipAfterTransfer() public {
      vm.startPrank(_owner);
      trait.mint(_owner);
      trait.equip(1);
      trait.safeTransferFrom(_owner, _recipient, 1);
      // assert that the token was transferred successfully
      assertEq(trait.ownerOf(1), _recipient);

      // assert that trait was unequipped on transfer
      bool equipped = trait.getTraitDetails(1).equipped;
      assertEq(equipped, false);
      vm.stopPrank();

      // bytes4 functionSelector = bytes4(keccak256(bytes("safeTransferFrom(address,address,uint256)")));
      // bytes memory data = abi.encodeWithSelector(functionSelector, _owner, _recipient, 1);
      // bool success = mySimpleERC6551AccountContract.execute(trait, 0, data, 0);
    }
}