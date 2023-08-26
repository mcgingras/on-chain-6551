// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/proxy/utils/Initializable.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/Base64.sol";

// @dev -- does the order of inheritance matter here?
contract Trait is Initializable, ERC721Enumerable {
  using Strings for uint256;

  constructor() Initializable() {}

  function initialize(string calldata _name, string calldata _symbol)
        external
        initializer
    {
        _setName(_name);
        _setSymbol(_symbol);
    }

  function _random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  function getTrait(uint256 tokenId, string memory traitType, string[] memory traits) public pure returns (string memory) {
    return _pluck(tokenId, traitType, traits);
  }

  function _pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal pure returns (string memory) {
    uint256 rand = _random(string(abi.encodePacked(keyPrefix, tokenId.toString())));
    string memory output = sourceArray[rand % sourceArray.length];
    return output;
  }

  function generateTokenURI(uint256 tokenId, string memory trait) public pure returns (string memory) {
    string[3] memory parts;
    parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';
    parts[1] = trait;
    parts[2] = '</text></svg>';

    string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2]));

    string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Token Bound Item #', tokenId.toString(), '", "description": "On-chain token bound loot item. Send this to a token bound account for it to dynamically appear on the base NFT.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
    output = string(abi.encodePacked('data:application/json;base64,', json));

    return output;
  }

  function tokensOfOwner(address _owner) external view returns(uint256[] memory) {
    uint256 tokenCount = balanceOf(_owner);

    if (tokenCount == 0) {
        // Return an empty array
        return new uint256[](0);
    } else {
        uint256[] memory result = new uint256[](tokenCount);
        for (uint256 index = 0; index < tokenCount; index++) {
            result[index] = tokenOfOwnerByIndex(_owner, index);
        }
        return result;
    }
  }

  function mint(uint256 tokenId) public {
    _safeMint(_msgSender(), tokenId);
  }
}
