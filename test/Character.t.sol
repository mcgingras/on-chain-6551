// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Character} from "../src/Character.sol";
import {Trait} from "../src/Trait.sol";
import {SimpleERC6551AccountRegistry} from "../src/AccountRegistry.sol";
import {SimpleERC6551Account} from "../src/Account.sol";

contract CharacterTest is Test {
    Character public character;
    Trait public trait;
    SimpleERC6551AccountRegistry public registry;

    function setUp() public {
      SimpleERC6551Account account = new SimpleERC6551Account();
      registry = new SimpleERC6551AccountRegistry(address(account));
      trait = new Trait(address(0), address(0));
      character = new Character(address(trait), address(registry), address(0));
    }

    function testTokenURI() public {
      // token URI should return the empty case when no traits are minted towards it
      string memory emptyTokenURI = character.tokenURI(0);
      assertEq(emptyTokenURI, "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHByZXNlcnZlQXNwZWN0UmF0aW89InhNaW5ZTWluIG1lZXQiIHZpZXdCb3g9IjAgMCAzNTAgMzUwIj48c3R5bGU+LmJhc2UgeyBmb250LWZhbWlseTogIklCTSBQbGV4IE1vbm8iLCBtb25vc3BhY2U7IGZvbnQtc2l6ZTogMTJweDsgdGV4dC10cmFuc2Zvcm06IHVwcGVyY2FzZTsgZmlsbDogI0ZGRiB9PC9zdHlsZT48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJibGFjayIgLz48dGV4dCB4PSIxMCIgeT0iMjAiIGNsYXNzPSJiYXNlIGxlZnQiPkVtcHR5PC90ZXh0Pjwvc3ZnPg==");

      // mint a trait of token 0
      // assuming goerli (this is baked into contract rn)
      address tba = registry.account(5, address(character), 0);
      trait.mint(tba);
      trait.equip(1);

      // token URI should return some value
      string memory tokenURI = character.tokenURI(0);
      // console.log(tokenURI);
      assertNotEq(tokenURI, emptyTokenURI);
    }
}