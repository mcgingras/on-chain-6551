// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./TraitData.sol";

contract TraitFactory {
    function createTrait(
      string[] memory _traits,
      string memory _traitType,
      string memory name,
      string memory symbol,
      address implementation
    ) public returns (address) {
        TraitData newTrait = new TraitData(_traits, _traitType, name, symbol, implementation);
        return address(newTrait);
    }
}