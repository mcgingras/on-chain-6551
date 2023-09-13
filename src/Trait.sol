// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import { console } from "forge-std/console.sol";

import "openzeppelin-contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/Base64.sol";
import "openzeppelin-contracts/utils/Counters.sol";
import "openzeppelin-contracts/access/Ownable.sol";

import "./TraitStorage.sol";
import "./SVGStorageBase.sol";
import "./TraitDetailsStruct.sol";

contract Trait is ERC721Enumerable, Ownable {
  using Strings for uint256;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenCount = Counters.Counter(1);
  TraitStorage public traitStorage;
  SVGStorageBase public svgStorageBase;

  mapping (uint256 => TraitDetails) public traitDetails;
  mapping(address => mapping(string => uint256)) public equippedItems;

  constructor(address _traitStorage, address _svgStorageBase) ERC721("Loot2: Tokenbound Trait", "Loot2:T") {
    traitStorage = TraitStorage(_traitStorage);
    svgStorageBase = SVGStorageBase(_svgStorageBase);
  }

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
    string memory traitType = _pluck(tokenId, "TYPE", traitStorage.getTraitTypes());

    if (areStringsEqual(traitType, "Weapon")) {
      return _pluck(tokenId, "Weapon", traitStorage.getWeapon());
    } else if (areStringsEqual(traitType, "Chest Armor")) {
      return _pluck(tokenId, "Chest Armor", traitStorage.getChestArmor());
    } else if (areStringsEqual(traitType, "Head Armor")) {
      return _pluck(tokenId, "Head Armor", traitStorage.getHeadArmor());
    } else if (areStringsEqual(traitType, "Waist Armor")) {
      return _pluck(tokenId, "Waist Armor", traitStorage.getWaistArmor());
    } else if (areStringsEqual(traitType, "Foot Armor")) {
      return _pluck(tokenId, "Foot Armor", traitStorage.getFootArmor());
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
    require(ownerOf(tokenId) == msg.sender, "You don't own this token");
    string memory typeToEquip = _pluck(tokenId, "TYPE", traitStorage.getTraitTypes());
    require(equippedItems[ownerOf(tokenId)][typeToEquip] == 0, "An item of this type is already equipped.");

    traitDetails[tokenId].equipped = true;
    equippedItems[ownerOf(tokenId)][typeToEquip] = tokenId;
  }


  function unequip(uint256 tokenId) public {
    require(ownerOf(tokenId) == msg.sender, "You don't own this token");
    string memory typeOfTrait = _pluck(tokenId, "TYPE", traitStorage.getTraitTypes());
    require(equippedItems[ownerOf(tokenId)][typeOfTrait] != 0, "Item is not equipped.");

    traitDetails[tokenId].equipped = false;
    equippedItems[ownerOf(tokenId)][typeOfTrait] = 0;
  }

  function tokenURI(uint256 tokenId) override public view returns (string memory) {
    TraitDetails memory data = traitDetails[tokenId];

    string[4] memory parts;
    parts[0] = svgStorageBase.OPEN_TAG();
    parts[1] = string(abi.encodePacked('<text x="10" y="20" class="base left">',data.traitType,'</text>'));
    parts[2] = string(abi.encodePacked('<text x="340" y="20" class="base right">',data.name,'</text>'));
    parts[3] = svgStorageBase.CLOSE_TAG();

    string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3]));

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
    for (uint i = 0; i < traitStorage.getTraitTypes().length; i++) {
      if (equippedItems[_owner][traitStorage.getTraitTypes()[i]] != 0) {
        count++;
      }
    }

    // Initialize array of equipped item IDs
    uint256[] memory equippedItemIDs = new uint256[](count);

    // Populate the array with IDs of equipped items
    uint256 index = 0;
    for (uint i = 0; i < traitStorage.getTraitTypes().length; i++) {
      uint256 tokenId = equippedItems[_owner][traitStorage.getTraitTypes()[i]];
      if (tokenId != 0) {
        equippedItemIDs[index] = tokenId;
        index++;
      }
    }

    return equippedItemIDs;
  }

  function _mint(address to) internal {
    uint256 tokenId = _tokenCount.current();
    string memory traitType = _pluck(tokenId, "TYPE", traitStorage.getTraitTypes());
    traitDetails[tokenId] = TraitDetails(traitType, getItem(tokenId), false);
    _mint(to, tokenId);
    _tokenCount.increment();
  }

  function mint() public {
    _mint(msg.sender);
  }

  function mint(address to) public {
    _mint(to);
  }

  function _beforeTokenTransfer(
    address from,
    address to,
    uint256 tokenId,
    uint256 batchSize
  ) internal override {
    // Need to call parent transfer hook
    super._beforeTokenTransfer(from, to, tokenId, batchSize);

    if (traitDetails[tokenId].equipped) {
        string memory typeOfTrait = _pluck(tokenId, "TYPE", traitStorage.getTraitTypes());
        traitDetails[tokenId].equipped = false;
        equippedItems[ownerOf(tokenId)][typeOfTrait] = 0;
    }
  }
}
