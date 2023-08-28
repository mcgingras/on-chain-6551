// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/Base64.sol";


// todo: mark each trait as active?
contract Svg is ERC721Enumerable {
  using Strings for uint256;

    // would be cool to encode the type in here as well so it shows up in opensea as an attribute
    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[5] memory parts;
        parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><defs><style>@import url("https://fonts.googleapis.com/css2?family=IBM+Plex+Mono&display=swap"); .base { font-family: "IBM Plex Mono", monospace; font-size: 14px; text-transform: uppercase; } .left { fill: #ffffff70; } .right { fill: #fff; text-anchor: end; }</style></defs><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base left">';
        parts[1] = "Weapon";
        parts[2] = '</text><text x="340" y="20" class="base right">';
        parts[3] = "Crazy Cool Sword";
        parts[4] = '</text></svg>';

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2], parts[3], parts[4]));

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Token Bound Item #', tokenId.toString(), '", "description": "On-chain token bound loot item. Send this to a token bound account for it to dynamically appear on the base NFT.", "attributes": [{"trait_type": "Trait type", "value": "Weapon"}], "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function smallEncode() public pure returns (string memory) {
      string[1] memory parts;
      parts[0] = 'Hello, World!';
      string memory output = string(abi.encodePacked(parts[0]));
      string memory json = Base64.encode(bytes(string(abi.encodePacked('{"image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
      output = string(abi.encodePacked('data:application/json;base64,', json));
      return output;
    }

    function emptyEncode() public pure returns (string memory) {
      string memory empty = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { font-family: "IBM Plex Mono", monospace; font-size: 14px; text-transform: uppercase; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base left"></text></svg>';

      return Base64.encode(abi.encodePacked("data:image/svg+xml;base64,",bytes(empty)));
    }

    function mint(uint256 tokenId) public {
      _safeMint(_msgSender(), tokenId);
    }

    constructor() ERC721("Station Tokenbound Loot Demo", "STLD") {}
}
