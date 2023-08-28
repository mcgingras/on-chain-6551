// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/Base64.sol";

import "./Trait.sol";


// no owner protection or anything
// purely a quick and dirty experiment
contract Character is ERC721 {
  using Strings for uint256;
  address public renderer;
  address public registry;

  // todo: figure out how to declare this in one spot
  struct TraitDetails {
    string traitType;
    string name;
    bool equipped;
  }

  function setRenderer(address _renderer) public {
      renderer = _renderer;
  }

  function setRegistry(address _registry) public {
      registry = _registry;
  }

  function tokenURI(uint256 tokenId) override public view returns (string memory) {
    Trait traitContract = Trait(renderer);
    Registry registryContract = Registry(registry);
    address tba = registryContract.account(5, address(this), tokenId);
    uint256[] memory tokens = traitContract.tokensOfOwner(tba);

    if (tokens.length == 0) {
      return "ZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCw8c3ZnIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgcHJlc2VydmVBc3BlY3RSYXRpbz0ieE1pbllNaW4gbWVldCIgdmlld0JveD0iMCAwIDM1MCAzNTAiPjxzdHlsZT4uYmFzZSB7IGZvbnQtZmFtaWx5OiAiSUJNIFBsZXggTW9ubyIsIG1vbm9zcGFjZTsgZm9udC1zaXplOiAxNHB4OyB0ZXh0LXRyYW5zZm9ybTogdXBwZXJjYXNlOyB9PC9zdHlsZT48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJibGFjayIgLz48dGV4dCB4PSIxMCIgeT0iMjAiIGNsYXNzPSJiYXNlIGxlZnQiPjwvdGV4dD48L3N2Zz4=";
    }

    string[] memory parts = new string[](tokens.length*4 + 1);
    parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { font-family: "IBM Plex Mono", monospace; font-size: 14px; text-transform: uppercase; } .left { fill: #ffffff70; } .right { fill: #fff; text-anchor: end; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base left">';

    for (uint256 index = 0; index < tokens.length; index++) {
      (string memory traitType, string memory name, bool _equipped) = traitContract.getTraitDetails(tokens[index]);
      uint256 offset = index*3 + 1;
      parts[offset] = traitType;
      parts[offset + 1] = '</text><text x="340" y="20" class="base right">';
      parts[offset + 2] = name;
      if (tokens.length > 1 && index < tokens.length - 1) {
        uint256 y = 40 + index*20;
        parts[offset+3] = string(abi.encodePacked('</text><text x="10" y="',y.toString(),'" class="base">'));
      }
    }

    parts[tokens.length*4] = '</text></svg>';

    bytes memory buffer;
    for (uint256 i = 0; i < parts.length; i++) {
        buffer = abi.encodePacked(buffer, parts[i]);
    }

    string memory output = string(buffer);
    string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Loot2 #', tokenId.toString(), '", "description": "On-chain token bound loot.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
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

// todo -- does erc6551 have a suggested and deployed registry + account impl
// so we don't have to deploy ourselves (probably should not do that)
interface Registry {
  function account(
        uint256 chainId,
        address tokenCollection,
        uint256 tokenId
    ) external view returns (address);
}