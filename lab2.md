## Lab 2 : Delegated Marketplace Contracts for your ERC-721

### Overview
In this lab, you will create a delegated marketplace contract for your ERC-721. This will allow users to buy and sell your ERC-721 token. 

### Interface
[IMarketplace.sol](./src/lab2/IMarketplace.sol)

| Function | Description | Event emitted |
|-----------------|-----------------| --- |
| list(tokenId,price) | List an ERC-721 token for sale | ItemListed(tokenId,seller,price) |
| buy(tokenId) | Buy an ERC-721 token that is for sale | ItemSold(tokenId,seller,buyer,price) |
| delist(tokenId) | Delist a sale | ItemDelisted(tokenId,seller) |
| numberOfItems() + itemAtIndex(index) | For iteration | - |

### Assignments
Implement [Marketplace.sol](./src/lab2/Marketplace.sol)

### Bonus Tasks
1. Add a "owner" address to the Marketplace contract and charge a (fixed/%) fee for each sale.
2. Instead of listing tokens for sale, allow buyers to make a bid for a token. The seller can then accept the highest bid.