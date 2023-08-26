// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/Base64.sol";

// no owner protection or anything
// purely a quick and dirty experiment
contract Base is ERC721 {
    using Strings for uint256;
    address public renderer;
    address public registry;

    function setRenderer(address _renderer) public {
        renderer = _renderer;
    }

    function setRegistry(address _registry) public {
        registry = _registry;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
      Sub subContract = Sub(renderer);
      Registry registryContract = Registry(registry);
      address tba = registryContract.account(5, address(this), tokenId);
      uint256[] memory tokens = subContract.tokensOfOwner(tba);
      string[] memory parts = new string[](tokens.length*2 + 1);

      // if (tokens.length == 0) {
        // return empty or pending image, can hardcode this
        // return "data:application/json;base64,ewogICAgIm5hbWUiOiAiVG9rZW4gQm91bmQgTG9vdCIsCiAgICAiZGVzY3JpcHRpb24iOiAiT25saW5lIHRva2VuIGJvdW5kIGxvb3QuIiwKICAgICJpbWFnZSI6ICJkYXRhOmltYWdlL3N2Zyt4bWw7YmFzZTY0LFBITiI7Cn0=";
      // }
//
      parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

      for (uint256 index = 1; index < tokens.length*2 + 1; index += 2) {
            uint256 tokenIndex = index / 2;
            parts[index] = subContract.getItem(tokens[tokenIndex]);
            if (tokens.length > 1 && index < tokens.length*2) {
              uint256 y = 40 + index*20;
              parts[index+1] = string(abi.encodePacked('</text><text x="10" y="',y.toString(),'" class="base">'));
            }
        }

      parts[tokens.length*2] = '</text></svg>';

      bytes memory buffer;
      for (uint256 i = 0; i < parts.length; i++) {
          buffer = abi.encodePacked(buffer, parts[i]);
      }

      string memory output = string(buffer);
      string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Token Bound Loot #', tokenId.toString(), '", "description": "On-chain token bound loot.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
      output = string(abi.encodePacked('data:application/json;base64,', json));

      return output;
    }

    function mint(uint256 tokenId) public {
      _safeMint(_msgSender(), tokenId);
    }

    constructor(address _renderer) ERC721("Token Bound Loot", "TOOT") {
        renderer = _renderer;
    }
}

interface Sub {
  function getItem(uint256 tokenId) external view returns (string memory);
  function balanceOf(address _owner) external view returns (uint256);
  function tokensOfOwner(address _owner) external view returns (uint256[] memory);
}

interface Registry {
  function account(
        uint256 chainId,
        address tokenCollection,
        uint256 tokenId
    ) external view returns (address);
}