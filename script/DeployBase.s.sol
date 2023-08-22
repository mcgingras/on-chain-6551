// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Base.sol";

// forge script --keystores $ETH_KEYSTORE --sender $ETH_FROM --broadcast --fork-url $GOERLI_RPC_URL script/DeployBase.s.sol:Deploy
// forge verify-contract --chain 5 --etherscan-api-key $ETHERSCAN_API_KEY 0xb7539fbfcbe9e64e85ea865980cd47e0962aae6d src/Base.sol:Base
// latest -- 0x746950c4cd575d641afd10cbd675b8e327ab9a3c

contract Deploy is Script {
    function run() public {
        vm.startBroadcast();
        // Base base = new Base(0xF40543a338a670be62BF15fFebdc671af1f8c099);
        // base.mint(0);

        // Sub subContract = Sub(0xF40543a338a670be62BF15fFebdc671af1f8c099);
        Base base = Base(0x746950C4cD575D641AFD10cBd675b8E327Ab9a3C);

        string memory uri = base.tokenURI(0);
        console.log(uri);
        vm.stopBroadcast();
    }
}
