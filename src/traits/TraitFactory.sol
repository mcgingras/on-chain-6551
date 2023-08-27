// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./TraitData.sol";


contract TraitFactory {
  address[] public traitContracts;

  function createTrait(
    string[] memory _traits,
    string memory _traitType,
    string memory name,
    string memory symbol,
    address implementation
  ) public returns (address) {
      TraitData newTrait = new TraitData(_traits, _traitType, name, symbol, implementation);
      traitContracts.push(address(newTrait));
      return address(newTrait);
  }
}

// membership = address(new ERC1967Proxy(membershipImpl(), bytes("")));
// emit MembershipCreated(membership);
// IERC721Mage(membership).initialize(membershipOwner, name, symbol, initData);