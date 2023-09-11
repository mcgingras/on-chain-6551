// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test } from "forge-std/Test.sol";
import { console } from "forge-std/console.sol";
import { Character } from "../src/Character.sol";
import { Trait } from "../src/Trait.sol";
import { TraitDetails } from "../src/TraitDetailsStruct.sol";
import { TraitStorage } from "../src/TraitStorage.sol";
import { SVGStorage } from "../src/SVGStorage.sol";

contract TraitTest is Test {
    Trait public trait;
    TraitStorage public traitStorage;
    SVGStorage public svgStorage;

    address _owner = address(123);
    address _recipient = address(456);
    address _ownerTBA;
    address _recipientTBA;

    function setUp() public {
      svgStorage = new SVGStorage();
      traitStorage = new TraitStorage();
      trait = new Trait(address(traitStorage), address(svgStorage));
    }

    function testMint() public {
      vm.startPrank(_owner);
      trait.mint(_owner);
      assertEq(trait.balanceOf(_owner), 1);
      vm.stopPrank();
    }

    function testEquip() public {
      vm.startPrank(_owner);
      trait.mint(_owner);

      // trait starts as unequipped
      TraitDetails memory preEquipDetails = trait.getTraitDetails(1);
      assertEq(preEquipDetails.equipped, false);

      trait.equip(1);
      TraitDetails memory postEquipDetails = trait.getTraitDetails(1);
      assertEq(postEquipDetails.equipped, true);

      trait.unequip(1);
      TraitDetails memory postUnequipDetails = trait.getTraitDetails(1);
      assertEq(postUnequipDetails.equipped, false);

      vm.stopPrank();
    }

    function testTokenURI() public {
      vm.startPrank(_owner);
      trait.mint(_owner);

      string memory tokenURI = trait.tokenURI(1);
      assertNotEq(tokenURI, "");
      vm.stopPrank();
    }

    function testTraitsOfOwner() public {
      vm.startPrank(_owner);
      trait.mint(_owner);


      uint256[] memory traits = trait.traitsOfOwner(_owner);
      assertEq(traits.length, 1);
      vm.stopPrank();
    }

    function testEquippedTraitsOfOwner() public {
      vm.startPrank(_owner);
      trait.mint(_owner);
      trait.equip(1);
      uint256[] memory equippedTraits = trait.equippedTraitsOfOwner(_owner);
      assertEq(equippedTraits.length, 1);
      vm.stopPrank();
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
    }
}