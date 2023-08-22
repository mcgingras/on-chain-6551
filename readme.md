# On-Chain 6551

Attempting to create an NFT that derives it's image fully on-chain from tokens that it holds in a 6551 TBA.

Current state of the art for showing the contents of a 6551 is to use `animation_url` to return an iframe that is responsible for polling the contents of the TBA. An example can be found [here](https://opensea.io/assets/ethereum/0x26727ed4f5ba61d3772d1575bca011ae3aef5d36/3305). Perhaps a more elegant solution would be for the base NFT to derive it's image entirely on-chain depending on the NFTs that are in the TBA associated with the base NFT.

This repo is an attempt at doing just that. It takes inspiration from [Loot](https://opensea.io/collection/lootproject) (and borrows some code... this is just meant to be a prototype.)

### Glossary

#### Base.sol

The base NFT contract. This is the primary NFT that renders it's children. It is originally blank, but as sub NFTs are sent to the TBA for the base NFT, each sub NFT renders on the base NFT. Since this is inspired by Loot, we can image the base NFT as an empty character, and the sub NFTs are traits that the character collects. As the character collects the traits, they render on the character (in the form of white text on a black background)

#### Sub.sol

The sub NFT contract. Following the Loot example, these are the traits that render on the base NFT. These NFTs have their own image property so they render on their own.
These NFTs must exist in the TBA of a given base NFT to show up on the base NFT.

### Notes

- This is a prototype, the solidity is quick and dirty, there are no permissions, optimizations, etc.
- This is meant to exist as a pairing between Base and Sub. Base renders Sub NFTs that exist in it's TBA for a given registry. It is not meant to render ALL NFTs in the TBA. This is by design and is meant to serve as a motivating example for a 6551 powered NFT that is utility driven for a certain use case (perhaps a character base NFT and in game accessory sub NFTs... the point is to make the character base NFT dynamic depending on the specific sub NFTs it holds, not ALL nfts it might hold.)
- It would be possible to create a dynamic NFT that is dependant on some other NFTs in an owners wallet, but the downside here is that if I transfer or sell the original base NFT the new owner would not get the same dynamic image since it depends on the sub NFTs that I still hold. With TBA, I can grant ownership of the sub NFTs to the base NFT's TBA, meaning if I sell or transfer the base NFT, the sub NFTs and dynamic image are not altered.
- I'm not sure what happens if you accumulate tons and tons of sub NFTs (more than what would render in the square on opensea). Try it out!

### Examples

- [Base](https://testnets.opensea.io/assets/goerli/0x746950c4cd575d641afd10cbd675b8e327ab9a3c/0)
- [TBA holding Subs for Base](https://testnets.opensea.io/0x9Df6118285fb50499d1f541bf0Ba499f6Fe2ED63)
- [Loom walkthrough](https://www.loom.com/share/5616f2613a2f4d48995b35b134b3eb13)
