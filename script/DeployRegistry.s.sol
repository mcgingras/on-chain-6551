// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "../src/Account.sol";
import "../src/AccountRegistry.sol";
import "openzeppelin-contracts/token/ERC721/ERC721.sol";



// forge script --keystores $ETH_KEYSTORE --sender $ETH_FROM --broadcast --fork-url $GOERLI_RPC_URL script/DeployRegistry.s.sol:Deploy
// 0x509f027c5E26eA6Ce1F4354aBDE668647563B7F6 -- account
// 0x7c84F7499f964965c938c44E1560E426d81080d2 -- registry
// 0x9Df6118285fb50499d1f541bf0Ba499f6Fe2ED63 -- tba
contract Deploy is Script {
    function run() public {
        vm.startBroadcast();
        // SimpleERC6551Account account = SimpleERC6551Account(0x509f027c5E26eA6Ce1F4354aBDE668647563B7F6);
        // SimpleERC6551AccountRegistry registry = SimpleERC6551AccountRegistry(0x7c84F7499f964965c938c44E1560E426d81080d2);
        // registry.createAccount(5, 0x746950C4cD575D641AFD10cBd675b8E327Ab9a3C, 0);
        // address tba = registry.account(0x746950C4cD575D641AFD10cBd675b8E327Ab9a3C, 0);
        // console.log(tba);

        ERC721 collection = ERC721(0xF40543a338a670be62BF15fFebdc671af1f8c099);
        collection.transferFrom(msg.sender, 0x9Df6118285fb50499d1f541bf0Ba499f6Fe2ED63, 8);
        collection.transferFrom(msg.sender, 0x9Df6118285fb50499d1f541bf0Ba499f6Fe2ED63, 9);
        vm.stopBroadcast();
    }
}
