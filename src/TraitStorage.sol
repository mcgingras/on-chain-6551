// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract TraitStorage {
  string[] public traitTypes = [
    "Weapon",
    "Chest Armor",
    "Head Armor",
    "Waist Armor",
    "Foot Armor"
  ];

  function getTraitTypes() external view returns (string[] memory) {
    return traitTypes;
  }

  // can obviously change these if we want to so its not ripping off loot
  string[] public weapon = [
    "Warhammer",
    "Quarterstaff",
    "Maul",
    "Mace",
    "Club",
    "Katana",
    "Falchion",
    "Scimitar",
    "Long Sword",
    "Short Sword",
    "Ghost Wand",
    "Grave Wand",
    "Bone Wand",
    "Wand",
    "Grimoire",
    "Chronicle",
    "Tome",
    "Book"
  ];

  function getWeapon() external view returns (string[] memory) {
    return weapon;
  }

  string[] public chestArmor = [
    "Divine Robe",
    "Silk Robe",
    "Linen Robe",
    "Robe",
    "Shirt",
    "Demon Husk",
    "Dragonskin Armor",
    "Studded Leather Armor",
    "Hard Leather Armor",
    "Leather Armor",
    "Holy Chestplate",
    "Ornate Chestplate",
    "Plate Mail",
    "Chain Mail",
    "Ring Mail"
  ];

  function getChestArmor() external view returns (string[] memory) {
    return chestArmor;
  }

  string[] public headArmor = [
    "Ancient Helm",
    "Ornate Helm",
    "Great Helm",
    "Full Helm",
    "Helm",
    "Demon Crown",
    "Dragon's Crown",
    "War Cap",
    "Leather Cap",
    "Cap",
    "Crown",
    "Divine Hood",
    "Silk Hood",
    "Linen Hood",
    "Hood"
  ];

  function getHeadArmor() external view returns (string[] memory) {
    return headArmor;
  }

  string[] public waistArmor = [
    "Ornate Belt",
    "War Belt",
    "Plated Belt",
    "Mesh Belt",
    "Heavy Belt",
    "Demonhide Belt",
    "Dragonskin Belt",
    "Studded Leather Belt",
    "Hard Leather Belt",
    "Leather Belt",
    "Brightsilk Sash",
    "Silk Sash",
    "Wool Sash",
    "Linen Sash",
    "Sash"
  ];

  function getWaistArmor() external view returns (string[] memory) {
    return waistArmor;
  }

  string[] public footArmor = [
    "Holy Greaves",
    "Ornate Greaves",
    "Greaves",
    "Chain Boots",
    "Heavy Boots",
    "Demonhide Boots",
    "Dragonskin Boots",
    "Studded Leather Boots",
    "Hard Leather Boots",
    "Leather Boots",
    "Divine Slippers",
    "Silk Slippers",
    "Wool Shoes",
    "Linen Shoes",
    "Shoes"
  ];

  function getFootArmor() external view returns (string[] memory) {
    return footArmor;
  }
}