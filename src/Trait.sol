// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/Base64.sol";
import "openzeppelin-contracts/utils/Counters.sol";

contract Trait is ERC721Enumerable {
  using Strings for uint256;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenCount = Counters.Counter(1);


  struct TraitDetails {
    string traitType;
    string name;
    bool equipped;
  }

  string[] private _traitTypes = [
    "Weapon",
    "Chest Armor",
    "Head Armor",
    "Waist Armor",
    "Foot Armor"
  ];

  // can obviously change these if we want to so its not ripping off loot
  string[] private _weapon = [
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

  string[] private _chestArmor = [
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

  string[] private _headArmor = [
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

  string[] private _waistArmor = [
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

  string[] private _footArmor = [
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

  mapping (uint256 => TraitDetails) public traitDetails;
  mapping(address => mapping(string => uint256)) public equippedItems;


  constructor() ERC721("Loot2: Tokenbound Trait", "Loot2:T") {}

  function getTraitDetails(uint256 tokenId) external view returns (TraitDetails memory) {
    return traitDetails[tokenId];
  }

  function _random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  function areStringsEqual(string memory str1, string memory str2) public pure returns (bool) {
      return keccak256(abi.encodePacked(str1)) == keccak256(abi.encodePacked(str2));
  }

  function getItem(uint256 tokenId) public view returns (string memory) {
    string memory traitType = _pluck(tokenId, "TYPE", _traitTypes);

    if (areStringsEqual(traitType, "Weapon")) {
      return _pluck(tokenId, "Weapon", _weapon);
    } else if (areStringsEqual(traitType, "Chest Armor")) {
      return _pluck(tokenId, "Chest Armor", _chestArmor);
    } else if (areStringsEqual(traitType, "Head Armor")) {
      return _pluck(tokenId, "Head Armor", _headArmor);
    } else if (areStringsEqual(traitType, "Waist Armor")) {
      return _pluck(tokenId, "Waist Armor", _waistArmor);
    } else if (areStringsEqual(traitType, "Foot Armor")) {
      return _pluck(tokenId, "Foot Armor", _footArmor);
    } else {
      return "INVALID";
    }
  }

  function _pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
      uint256 rand = _random(string(abi.encodePacked(keyPrefix, tokenId.toString())));
      string memory output = sourceArray[rand % sourceArray.length];
      return output;
  }

  function equip(uint256 tokenId) public {
    // handling TBA case... require that msg.sender is owner of TBA || ownerOf?
    // require(ownerOf(tokenId) == msg.sender, "You don't own this token");
    string memory typeToEquip = _pluck(tokenId, "TYPE", _traitTypes);
    require(equippedItems[ownerOf(tokenId)][typeToEquip] == 0, "An item of this type is already equipped.");

    // set to equipped
    traitDetails[tokenId].equipped = true;
    equippedItems[ownerOf(tokenId)][typeToEquip] = tokenId;
  }

  /// @dev feels dangerous to use 0 as a special case here.
  /// I am starting count at 1 to get around this issue, but it feels like a hack?
  /// could use `mapping (uint256 => bool) isEquipped;` but as a solidity noob I'm not sure if it's costly to do so?
  function unequip(uint256 tokenId) public {
    // require(ownerOf(tokenId) == msg.sender, "You don't own this token");
    string memory typeOfTrait = _pluck(tokenId, "TYPE", _traitTypes);
    require(equippedItems[ownerOf(tokenId)][typeOfTrait] != 0, "Item is not equipped.");

    // Set to unequipped
    traitDetails[tokenId].equipped = false;
    equippedItems[ownerOf(tokenId)][typeOfTrait] = 0;
  }

  function tokenURI(uint256 tokenId) override public view returns (string memory) {
    TraitDetails memory data = traitDetails[tokenId];

    string[5] memory parts;
    parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { font-family: "IBM Plex Mono", ui-monospace; font-size: 10px; text-transform: uppercase; } .left { fill: #ffffff70; } .right { fill: #fff; text-anchor: end; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base left">';
    parts[1] = data.traitType;
    parts[2] = '</text><text x="340" y="20" class="base right">';
    parts[3] = data.name;
    parts[4] = '</text></svg>';

    string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2]));

    string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Token Bound Item #', tokenId.toString(), '", "description": "On-chain token bound loot item. Send this to a token bound account for it to dynamically appear on the base NFT.", "attributes": [{"trait_type": "Trait type", "value": "', data.traitType, '"}], "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
    output = string(abi.encodePacked('data:application/json;base64,', json));

    return output;
  }

  function traitsOfOwner(address _owner) external view returns(uint256[] memory) {
    uint256 tokenCount = balanceOf(_owner);

    if (tokenCount == 0) {
      return new uint256[](0);
    } else {
      uint256[] memory result = new uint256[](tokenCount);
      for (uint256 index = 0; index < tokenCount; index++) {
          result[index] = tokenOfOwnerByIndex(_owner, index);
      }
      return result;
    }
  }

  function equippedTraitsOfOwner(address _owner) external view returns(uint256[] memory) {
    uint256 count = 0;

    // Count number of equipped items for pre-allocation of array size
    for (uint i = 0; i < _traitTypes.length; i++) {
      if (equippedItems[_owner][_traitTypes[i]] != 0) {
        count++;
      }
    }

    // Initialize array of equipped item IDs
    uint256[] memory equippedItemIDs = new uint256[](count);

    // Populate the array with IDs of equipped items
    uint256 index = 0;
    for (uint i = 0; i < _traitTypes.length; i++) {
      uint256 tokenId = equippedItems[_owner][_traitTypes[i]];
      if (tokenId != 0) {
        equippedItemIDs[index] = tokenId;
        index++;
      }
    }

    return equippedItemIDs;
  }

  function _mint(address to) internal {
    uint256 tokenId = _tokenCount.current();
    string memory traitType = _pluck(tokenId, "TYPE", _traitTypes);
    traitDetails[tokenId] = TraitDetails(traitType, getItem(tokenId), false);
    _safeMint(to, tokenId);
    _tokenCount.increment();
  }

  function mint() public {
    _mint(msg.sender);
  }

  function mint(address to) public {
    _mint(to);
  }

  // beforeTransfer hook
  // trait should be unequipped before (or after?) transfer

  // function tbaMint(address to, uint256 tokenId, string memory traitType) public {
  //   // get TBA address from registry and mint to that address
  //   _mint(to, tokenId, traitType);
  // }
}
