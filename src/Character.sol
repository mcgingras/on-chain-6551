// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "openzeppelin-contracts/utils/Strings.sol";
import "openzeppelin-contracts/utils/Base64.sol";
import "openzeppelin-contracts/utils/Counters.sol";
import "openzeppelin-contracts/access/Ownable.sol";

import "./Trait.sol";
import "./SVGStorage.sol";

// no owner protection or anything
// purely a quick and dirty experiment
contract Character is ERC721Enumerable, Ownable {
  using Strings for uint256;
  using Counters for Counters.Counter;

  Counters.Counter private _tokenCount = Counters.Counter(1);
  address public renderer;
  address public registry;
  SVGStorage public svgStorage;

  constructor(address _renderer, address _registry, address _svgStorage) ERC721("Loot2: Tokenbound Character", "LOOT2:C") {
    renderer = _renderer;
    registry = _registry;
    svgStorage = SVGStorage(_svgStorage);
  }

  function tokenURI(uint256 tokenId) override public view returns (string memory) {
    Trait traitContract = Trait(renderer);
    Registry registryContract = Registry(registry);
    // todo: remove chainId hardcoding
    address tba = registryContract.account(5, address(this), tokenId);
    uint256[] memory equippedTraits = traitContract.equippedTraitsOfOwner(tba);

    // pre-computed base64 encoding of "empty" SVG
    if (equippedTraits.length == 0) {
      return "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHByZXNlcnZlQXNwZWN0UmF0aW89InhNaW5ZTWluIG1lZXQiIHZpZXdCb3g9IjAgMCAzNTAgMzUwIj48c3R5bGU+LmJhc2UgeyBmb250LWZhbWlseTogIklCTSBQbGV4IE1vbm8iLCBtb25vc3BhY2U7IGZvbnQtc2l6ZTogMTJweDsgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsgZmlsbDogI0ZGRiB9PC9zdHlsZT48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJibGFjayIgLz48dGV4dCB4PSIxMCIgeT0iMjAiIGNsYXNzPSJiYXNlIGxlZnQiPkVtcHR5PC90ZXh0Pjwvc3ZnPg==";
    }


    string[] memory parts = new string[](equippedTraits.length*2 + 2);

    parts[0] = svgStorage.OPEN_TAG();

    for (uint256 index = 0; index < equippedTraits.length; index++) {
      TraitDetails memory details = traitContract.getTraitDetails(equippedTraits[index]);

      if(!details.equipped) { continue; }

      uint256 y = 20 + index*20;
      uint256 offset = index*2 + 1;

      parts[offset] = string(abi.encodePacked('<text x="10" y="',y.toString(),'" class="base left">',details.traitType,'</text>'));
      parts[offset + 1] = string(abi.encodePacked('<text x="340" y="',y.toString(),'" class="base right">',details.name,'</text>'));
    }

    parts[equippedTraits.length*2+1] = svgStorage.CLOSE_TAG();

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

interface Registry {
  function account(
    uint256 chainId,
    address tokenCollection,
    uint256 tokenId
  ) external view returns (address);
}