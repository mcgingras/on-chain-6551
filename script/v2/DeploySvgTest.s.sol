// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../../src/Svg.sol";

// forge script --keystores $ETH_KEYSTORE --sender $ETH_FROM --broadcast --fork-url $GOERLI_RPC_URL script/v2/DeploySvgTest.s.sol:Deploy
// forge verify-contract --chain 5 --etherscan-api-key $ETHERSCAN_API_KEY 0xb7539fbfcbe9e64e85ea865980cd47e0962aae6d src/Character.sol:Character
// latest -- 0x746950c4cd575d641afd10cbd675b8e327ab9a3c

contract Deploy is Script {
    function run() public {
        vm.startBroadcast();
        // Svg svg = new Svg();
        // svg.mint(0);

        Svg svg = Svg(0xbD4756d3D7c8f9426224292FFad56C1490328bDF);
        string memory uri = svg.tokenURI(0);
        console.log(uri);
        vm.stopBroadcast();
    }
}
