// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IMarketplace {
    /**
     * @dev Emits when an item is listed for sale
     */
    event ItemListed(
        uint256 indexed tokenId,
        address indexed seller,
        uint256 price
    );
    /**
     * @dev Emits when an item is sold
     */
    event ItemSold(
        uint256 indexed tokenId,
        address indexed seller,
        address indexed buyer,
        uint256 price
    );
    /**
     * @dev Emits when an item is delisted
     */
    event ItemDelisted(uint256 indexed tokenId, address indexed seller);

    /**
     * @dev Represents an item listed for sale
     */
    struct SaleItem {
        uint256 tokenId;
        address seller;
        uint256 price;
    }

    /**
     * @dev Returns the number of items listed for sale
     */
    function numberOfItems() external view returns (uint256);

    /**
     * @dev Returns the SaleItem for the given index
     */
    function itemAtIndex(uint256 index) external view returns (SaleItem memory);

    /**
     * @dev Lists the given item for sale
     */
    function list(uint256 tokenId, uint256 price) external;

    /**
     * @dev Delists the given item
     */
    function delist(uint256 tokenId) external;

    /**
     * @dev Buys the given item
     */
    function buy(uint256 tokenId) external payable;
}
