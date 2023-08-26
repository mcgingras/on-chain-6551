// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "openzeppelin-contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "../interfaces/ITrait.sol";

contract TraitData is ERC1967Proxy {
    string[] public traits;
    string public traitType;

    // do we need to initialize the ERC721 as well from the impl?
    // I think we need to make trait initializable with empty constructor
    // then in our factory we create a new 1967 proxy of data then call initialize on it
    constructor(
      string[] memory _traits,
      string memory _traitType,
      address impl
    ) ERC1967Proxy(impl, bytes("")) {
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
