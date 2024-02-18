
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import { Test } from "forge-std/Test.sol";

// Deploying to Goerli
// forge script --keystores $ETH_KEYSTORE --sender $ETH_FROM --broadcast --fork-url $GOERLI_RPC_URL script/v3/DeploySuite.s.sol:Deploy

contract Deploy is Script {
    struct Hand {
      uint256 timestamp;
      uint8 sum;
    }

    Hand[] streak;

    function valueOf(uint8 card, bool isBigAce) internal pure returns (uint8) {
      uint8 value = card / 4;
      if (value == 0 || value == 11 || value == 12) { // Face cards
        return 10;
      }
      if (value == 1 && isBigAce) { // Ace is worth 11
        return 11;
      }
      return value;
    }

    function getCardForTimestamp(uint256 timestamp, address player, uint8 cardNumber) internal pure returns (uint8) {
      uint8 zero  = 0;
      uint8 card = uint8(uint256(keccak256(abi.encodePacked(zero, player, cardNumber, timestamp))) % 52);
      return card;
    }

    function getHandForTimeStamp(uint256 timestamp, address player) internal pure returns (uint8[3] memory) {
      uint8[3] memory hand;
      hand[0] = getCardForTimestamp(timestamp, player, 0);
      hand[1] = getCardForTimestamp(timestamp, player, 2);
      hand[2] = getCardForTimestamp(timestamp, player, 3);
      return hand;
    }

    function sumOfHand(uint8[3] memory hand) internal pure returns (uint8) {
      uint8 sum = 0;
      for (uint8 i = 0; i < hand.length; i++) {
        bool isBigAce = i == 1 && hand[0] == 1;
        sum += valueOf(hand[i], isBigAce);
        if (i == 1 && sum > 15) {
          break;
        }
      }
      return sum;
    }

    function getSumsForNext100Timestamps(uint256 timestamp, address player) internal {
      for (uint256 i = 0; i < 1500; i++) {
        uint8[3] memory hand = getHandForTimeStamp(timestamp + i, player);
        uint8 handSum = sumOfHand(hand);

        if (handSum == 19 || handSum == 20 || handSum == 21) {
          Hand memory handStruct = Hand(timestamp + i, handSum);
          streak.push(handStruct);
        } else {
          delete streak;
        }
      
        if (streak.length == 6) {
          console.log("FOUND STREAK");
          for (uint8 j = 0; j < streak.length; j++) {
            console.logUint(streak[j].timestamp);
            console.logUint(streak[j].sum);
          }
          break;
        }
      }
    }

    function run() public {
        vm.startBroadcast();

        uint256 timestamp = 1698536315;
        address player = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        getSumsForNext100Timestamps(timestamp, player);
        vm.stopBroadcast();
    }
}
