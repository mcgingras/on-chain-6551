// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";
import "openzeppelin-contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/Base64.sol";
import "openzeppelin-contracts/utils/Counters.sol";

import "./Trait.sol";

// no owner protection or anything
// purely a quick and dirty experiment
contract Character is ERC721Enumerable {
  using Strings for uint256;
  using Counters for Counters.Counter;

  Counters.Counter private _tokenCount;
  address public renderer;
  address public registry;

  // todo: figure out how to declare this in one spot
  struct TraitDetails {
    string traitType;
    string name;
    bool equipped;
  }

  constructor(address _renderer, address _registry) ERC721("Loot2: Tokenbound Character", "LOOT2:C") {
    renderer = _renderer;
    registry = _registry;
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
    // todo: remove chainId hardcoding
    address tba = registryContract.account(5, address(this), tokenId);
    uint256[] memory tokens = traitContract.tokensOfOwner(tba);

    // pre-computed base64 encoding of "empty" SVG
    if (tokens.length == 0) {
      return "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHByZXNlcnZlQXNwZWN0UmF0aW89InhNaW5ZTWluIG1lZXQiIHZpZXdCb3g9IjAgMCAzNTAgMzUwIj48c3R5bGU+LmJhc2UgeyBmb250LWZhbWlseTogIklCTSBQbGV4IE1vbm8iLCBtb25vc3BhY2U7IGZvbnQtc2l6ZTogMTJweDsgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsgZmlsbDogI0ZGRiB9PC9zdHlsZT48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJibGFjayIgLz48dGV4dCB4PSIxMCIgeT0iMjAiIGNsYXNzPSJiYXNlIGxlZnQiPkVtcHR5PC90ZXh0Pjwvc3ZnPg==";
    }


    // might over-allocate here since we skip unequipped traits, but this is the maximum length
    string[] memory parts = new string[](tokens.length*2 + 2);
    uint equippedItems = 0;

    parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { font-family: "IBM Plex Mono", monospace; font-size: 12px; text-transform: uppercase; } .left { fill: #ffffff70; } .right { fill: #fff; text-anchor: end; }</style><rect width="100%" height="100%" fill="black" />';

    for (uint256 index = 0; index < tokens.length; index++) {
      (string memory traitType, string memory name, bool equipped) = traitContract.getTraitDetails(tokens[index]);

      if(!equipped) { continue; }
      equippedItems++;

      uint256 y = 20 + index*20;
      uint256 offset = index*2 + 1;

      parts[offset] = string(abi.encodePacked('<text x="10" y="',y.toString(),'" class="base left">',traitType,'</text>'));
      parts[offset + 1] = string(abi.encodePacked('<text x="340" y="',y.toString(),'" class="base right">',name,'</text>'));
    }

    parts[equippedItems*2+1] = '</svg>';

    bytes memory buffer;
    for (uint256 i = 0; i < parts.length; i++) {
        buffer = abi.encodePacked(buffer, parts[i]);
    }

    string memory output = string(buffer);
    string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Loot2 #', tokenId.toString(), '", "description": "On-chain token bound loot.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
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

  function mint() public {
    _safeMint(_msgSender(), _tokenCount.current());
    _tokenCount.increment();
  }
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