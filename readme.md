# On-Chain 6551

Attempting to create an NFT that derives it's image fully on-chain from tokens that it holds in a 6551 TBA.

Current state of the art for showing the contents of a 6551 is to use `animation_url` to return an iframe that is responsible for polling the contents of the TBA. An example can be found [here](https://opensea.io/assets/ethereum/0x26727ed4f5ba61d3772d1575bca011ae3aef5d36/3305). Perhaps a more elegant solution would be for the base NFT to derive it's image entirely on-chain depending on the NFTs that are in the TBA associated with the base NFT.

This repo is an attempt at doing just that. It takes inspiration from [Loot](https://opensea.io/collection/lootproject)

### Glossary

#### Character.sol

The base NFT contract. This is the primary NFT that renders it's children. It is originally blank, but as sub NFTs are sent to the TBA for the base NFT, each sub NFT renders on the base NFT. Since this is inspired by Loot, we can image the base NFT as an empty character, and the sub NFTs are traits that the character collects. As the character collects the traits, they render on the character (in the form of white text on a black background)

#### Trait.sol

The sub NFT contract. Following the Loot example, these are the traits that render on the base NFT. These NFTs have their own image property so they render on their own.
These NFTs must exist in the TBA of a given base NFT to show up on the base NFT.

#### TraitStorage.sol

Storage for the trait details.

#### SVGStorageBase.sol

Storage for SVG details.

#### SVGStorageEmpty.sol

Storage for "empty" SVG

## Contract Links

[Trait](https://basescan.org/address/0xb7d488da393b4f34813dabeb295931a2b86ea505)
[Registry](https://basescan.org/address/0x1b7424e264890950ddfa61c2eed28c9676b9205f)
[Account Implementation](https://basescan.org/address/0xf21074833502cbb87d69b7e865c19852a63ca34b)
[Character](https://basescan.org/address/0x6dE9ee54E8FF85D78E20DaE243a5D1565bF8d741)
