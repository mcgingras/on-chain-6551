// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Trait} from "../src/Trait.sol";
import {TraitDetails} from "../src/TraitDetailsStruct.sol";

contract TraitTest is Test {
    Trait public trait;
    address owner = address(123);

    function setUp() public {
      trait = new Trait(address(123), address(123));
    }

    function testMint() public {
      vm.startPrank(owner);
      trait.mint(msg.sender);
      vm.stopPrank();

      assertEq(trait.balanceOf(msg.sender), 1);
    }

    function testEquip() public {
      vm.startPrank(owner);
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
      vm.startPrank(owner);
      trait.mint(msg.sender);
      vm.stopPrank();

      string memory tokenURI = trait.tokenURI(1);
      console.log(tokenURI);
      assertNotEq(tokenURI, "");
    }

    function testTraitsOfOwner() public {
      vm.startPrank(owner);
      trait.mint(msg.sender);
      vm.stopPrank();

      uint256[] memory traits = trait.traitsOfOwner(msg.sender);
      assertEq(traits.length, 1);
    }

    function testEquippedTraitsOfOwner() public {
      vm.startPrank(owner);
      trait.mint(msg.sender);
      vm.stopPrank();

      trait.equip(1);
      uint256[] memory equippedTraits = trait.equippedTraitsOfOwner(msg.sender);
      assertEq(equippedTraits.length, 1);
    }
}