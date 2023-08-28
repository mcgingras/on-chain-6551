// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/Base64.sol";
import "openzeppelin-contracts/utils/Counters.sol";



// todo: mark each trait as active?
contract Trait is ERC721Enumerable {
  using Strings for uint256;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenCount;

  struct TraitDetails {
    string traitType;
    string name;
    bool equipped;
  }

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



    // types:
    // weapon
    // chest armor
    // head armor
    // waist armor
    // foot armor
    mapping (uint256 => TraitDetails) public traitDetails;

    function getTraitDetails(uint256 tokenId) external view returns (string memory traitType, string memory name, bool equipped) {
      TraitDetails memory details = traitDetails[tokenId];
      return (details.traitType, details.name, details.equipped);
    }

    function _random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function getItem(uint256 tokenId) public view returns (string memory) {
        return _pluck(tokenId, "ITEM", _weapon);
    }

    function _pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
        uint256 rand = _random(string(abi.encodePacked(keyPrefix, tokenId.toString())));
        string memory output = sourceArray[rand % sourceArray.length];
        return output;
    }

    function equip(uint256 tokenId) public {
      // require no other equipped items of this type
      traitDetails[tokenId].equipped = true;
    }

    function unequip(uint256 tokenId) public {
      traitDetails[tokenId].equipped = false;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
      TraitDetails memory data = traitDetails[tokenId];

      string[5] memory parts;
      parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { font-family: "IBM Plex Mono", monospace; font-size: 14px; text-transform: uppercase; } .left { fill: #ffffff70; } .right { fill: #fff; text-anchor: end; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base left">';
      parts[1] = data.traitType;
      parts[2] = '</text><text x="340" y="20" class="base right">';
      parts[3] = data.name;
      parts[4] = '</text></svg>';

      string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2]));

      string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Token Bound Item #', tokenId.toString(), '", "description": "On-chain token bound loot item. Send this to a token bound account for it to dynamically appear on the base NFT.", "attributes": [{"trait_type": "Trait type", "value": "', data.traitType, '"}], "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
      output = string(abi.encodePacked('data:application/json;base64,', json));

      return output;
    }

    function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
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

    function _mint(address to, string memory traitType) internal {
      // require valid type?
      uint256 tokenId = _tokenCount.current();
      traitDetails[tokenId] = TraitDetails(traitType, getItem(tokenId), false);
      _safeMint(to, tokenId);
      _tokenCount.increment();
    }

    function mint(string memory traitType) public {
      _mint(msg.sender, traitType);
    }

    function mint(address to, string memory traitType) public {
      _mint(to, traitType);
    }

    // function tbaMint(address to, uint256 tokenId, string memory traitType) public {
    //   // get TBA address from registry and mint to that address
    //   _mint(to, tokenId, traitType);
    // }

    constructor() ERC721("Station Tokenbound Loot Demo", "STLD") {}
}
