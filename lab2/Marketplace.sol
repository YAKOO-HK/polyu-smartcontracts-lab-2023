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
        revert NotImplementedError();
    }

    function delist(uint256 tokenId) external {
        revert NotImplementedError();
    }

    function buy(uint256 tokenId) external payable {
        revert NotImplementedError();
    }
}
