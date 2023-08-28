// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import { Svg } from "src/Svg.sol";

contract SvgRendererTest is Test {
  // function testRenderer() public {
  //   Svg renderer = new Svg();
  //   string memory uri = renderer.tokenURI(1);
  //   console.log(uri);
  // }

  function testRenderer() public {
    Svg renderer = new Svg();
    string memory uri = renderer.emptyEncode();
    console.log(uri);
  }
}