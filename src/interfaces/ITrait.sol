// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

interface Trait {
  function getTrait(uint256 tokenId, string memory traitType, string[] memory traits) external view returns (string memory);
  function generateTokenURI(uint256 tokenId, string memory trait) external view returns (string memory);
}