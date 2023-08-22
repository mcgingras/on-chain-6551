// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/token/ERC721/ERC721.sol";

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}


// no owner protection or anything
// purely a quick and dirty experiment
contract Base is ERC721 {
    address public renderer;
    address public registry;

    function setRenderer(address _renderer, address _registry) public {
        renderer = _renderer;
        registry = _registry;
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

      parts[0] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: white; font-family: serif; font-size: 14px; }</style><rect width="100%" height="100%" fill="black" /><text x="10" y="20" class="base">';

      for (uint256 index = 1; index < tokens.length*2 + 1; index += 2) {
            uint256 tokenIndex = index / 2;
            parts[index] = subContract.getItem(tokens[tokenIndex]);
            if (tokens.length > 1 && index < tokens.length*2) {
              uint256 y = 40 + index*20;
              parts[index+1] = string(abi.encodePacked('</text><text x="10" y="',toString(y),'" class="base">'));
            }
        }

      parts[tokens.length*2] = '</text></svg>';

      bytes memory buffer;
      for (uint256 i = 0; i < parts.length; i++) {
          buffer = abi.encodePacked(buffer, parts[i]);
      }

      string memory output = string(buffer);
      string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Token Bound Loot #', toString(tokenId), '", "description": "On-chain token bound loot.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
      output = string(abi.encodePacked('data:application/json;base64,', json));

      return output;
    }

    function toString(uint256 value) internal pure returns (string memory) {
      // Pulled from LOOT
      // Inspired by OraclizeAPI's implementation - MIT license
      // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

      if (value == 0) {
          return "0";
      }
      uint256 temp = value;
      uint256 digits;
      while (temp != 0) {
          digits++;
          temp /= 10;
      }
      bytes memory buffer = new bytes(digits);
      while (value != 0) {
          digits -= 1;
          buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
          value /= 10;
      }
      return string(buffer);
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