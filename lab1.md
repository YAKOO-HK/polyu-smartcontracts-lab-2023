## Lab 1 : ERC-721 Non-Fungible Token (NFT) Standard

### Lab Target:
1. Understand the ERC-721 standard
2. Understand basic syntax of Solidity
3. Implement ERC-721 standard in Solidity with @OpenZeppelin

#### Basic Setup
1. Create a new Remix IDE [https://remix.ethereum.org](https://remix.ethereum.org) workspace via @OpenZeppelin ERC-721 template:  
  a) From @OpenZeppelin Wizard [https://docs.openzeppelin.com/contracts/5.x/wizard](https://docs.openzeppelin.com/contracts/5.x/wizard)  
  b) From Remix IDE Workspace Template
2. Compile and deploy to Remix VM
3. Transact with the contract

#### Tasks
1. Add a LIMIT constant to the contract, which will limit the total number of tokens that can be minted.
2. Add minting rules for each address (e.g. 10 tokens per address)
3. Add a price to mint a token (e.g. 0.1 ETH) and send the ETH to the contract owner
4. Implement a custom URL for tokenURI(tokenId)

#### Bonus Tasks
1. Instead of limited mint by strict limit, progressive increase the price of the minting.
2. Instead of using ETH, use ERC20 token as the payment method.
3. Implement tokenURI(tokenId) with Base64 encoded SVG image to make the token fully on-chain.


### Resources:
1. Solidity - [https://docs.soliditylang.org/en/v0.8.23/](https://docs.soliditylang.org/en/v0.8.23/)
2. OpenZeppelin Contracts - [https://docs.openzeppelin.com/contracts/5.x/](https://docs.openzeppelin.com/contracts/5.x/)
3. Remix IDE - [https://remix.ethereum.org](https://remix.ethereum.org)
4. ERCs & EIPs - [https://eips.ethereum.org/erc](https://eips.ethereum.org/erc)
5. Metadata Standard (Opensea) - [https://docs.opensea.io/docs/metadata-standards](https://docs.opensea.io/docs/metadata-standards)

