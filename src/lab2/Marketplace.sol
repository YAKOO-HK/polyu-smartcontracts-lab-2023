// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IMarketplace.sol";

/**
 * @dev Represents a marketplace for trading ERC721 tokens
 */
contract Marketplace is IMarketplace {
    error NotImplementedError();

    constructor() {}

    function numberOfItems() external view returns (uint256) {
        revert NotImplementedError();
    }

    function itemAtIndex(
        uint256 index
    ) external view returns (SaleItem memory) {
        revert NotImplementedError();
    }

    function list(uint256 tokenId, uint256 price) external {
        // 1. Check Ownership and if we can transfer the NFT to us
        // 2. Check if the NFT is already listed
        // 3. Add the NFT to the list
        // 4. Transfer the NFT to us
        // 5. Emit the event
        revert NotImplementedError();
    }

    function delist(uint256 tokenId) external {
        // 1. Check if the NFT is listed
        // 2. Check if the caller is the seller
        // 3. Remove the NFT from the list
        // 4. Transfer the NFT back to the owner
        // 5. Emit the event
        revert NotImplementedError();
    }

    function buy(uint256 tokenId) external payable {
        // 1. Check if the NFT is listed
        // 2. Check if the caller is not the seller
        // 3. Check if the value is correct
        // 4. Remove the NFT from the list
        // 5. Transfer the NFT to the buyer
        // 6. Transfer the value to the seller
        // 7. Emit the event
        revert NotImplementedError();
    }
}
