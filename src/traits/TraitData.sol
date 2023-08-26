// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../interfaces/ITrait.sol";

contract TraitData is ERC1967Proxy {
    string[] public traits;
    string public traitType;

    // do we need to initialize the ERC721 as well from the impl?
    constructor(
      string[] memory _traits,
      string memory _traitType,
      string memory name,
      string memory symbol,
      address impl
    ) ERC1967Proxy(impl, "") {
        traits = _traits;
        traitType = _traitType;
    }

    function setTraits(string[] memory _traits) public {
      traits = _traits;
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
      address implementation = _getImplementation();
      string memory trait = Trait(implementation).getTrait(tokenId, traitType, traits);
      return Trait(implementation).generateTokenURI(tokenId, trait);
    }
}
