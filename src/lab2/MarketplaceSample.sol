// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/utils/structs/EnumerableSet.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "./IMarketplace.sol";

/**
 * @dev Represents a marketplace for trading ERC721 tokens
 */
contract MarketplaceSample is ERC721Holder, Context, IMarketplace {
    using EnumerableSet for EnumerableSet.UintSet;

    error NotSellerError();
    error InvalidParamError();

    IERC721 public ntfContract;
    /** @dev store the listed tokens */
    EnumerableSet.UintSet private tokenIdSet;
    /** @dev tokenId to SaleItem mapping */
    mapping(uint256 => SaleItem) private saleItems;

    constructor(address contractAddress) {
        ntfContract = IERC721(contractAddress);
    }

    function numberOfItems() external view returns (uint256) {
        return tokenIdSet.length();
    }

    function itemAtIndex(
        uint256 index
    ) external view returns (SaleItem memory) {
        // 1. Check if the index is valid
        if (index >= tokenIdSet.length()) {
            revert InvalidParamError();
        }
        // 2. Get the token ID
        uint256 tokenId = tokenIdSet.at(index);
        if (tokenId == 0) {
            revert InvalidParamError();
        }
        // 3. Get the sale item
        SaleItem memory saleItem = saleItems[tokenId];
        return saleItem;
    }

    function list(uint256 tokenId, uint256 price) external {
        // 0. Check if the price is valid
        if (price == 0) {
            revert InvalidParamError();
        }

        address owner = ntfContract.ownerOf(tokenId);
        address ourAddress = address(this);
        // 1. Check Ownership and if we can transfer the NFT to us
        if (
            owner != _msgSender() &&
            !ntfContract.isApprovedForAll(owner, ourAddress) &&
            ntfContract.getApproved(tokenId) != ourAddress
        ) {
            revert InvalidParamError();
        }
        // 2. Check if the NFT is already listed
        if (tokenIdSet.contains(tokenId)) {
            // already listed
            revert InvalidParamError();
        }

        // 3. Add the NFT to the list
        tokenIdSet.add(tokenId);
        saleItems[tokenId].tokenId = tokenId;
        saleItems[tokenId].seller = owner;
        saleItems[tokenId].price = price;

        // 4. Transfer the NFT to us
        ntfContract.safeTransferFrom(owner, ourAddress, tokenId);

        // 5. Emit the event
        emit ItemListed(tokenId, owner, price);
    }

    function delist(uint256 tokenId) external {
        // 1. Check if the NFT is listed
        if (!tokenIdSet.contains(tokenId)) {
            revert InvalidParamError();
        }
        // 2. Check if the caller is the seller
        if (saleItems[tokenId].seller != _msgSender()) {
            revert NotSellerError();
        }

        // 3. Remove the NFT from the list
        tokenIdSet.remove(tokenId);
        saleItems[tokenId].tokenId = 0;
        saleItems[tokenId].seller = address(0);
        saleItems[tokenId].price = 0;

        // 4. Transfer the NFT back to the owner
        ntfContract.safeTransferFrom(address(this), _msgSender(), tokenId);

        // 5. Emit the event
        emit ItemDelisted(tokenId, _msgSender());
    }

    function buy(uint256 tokenId) external payable {
        // 1. Check if the NFT is listed
        address ourAddress = address(this);
        if (!tokenIdSet.contains(tokenId)) {
            revert InvalidParamError();
        }
        // 2. Check if the caller is not the seller
        if (saleItems[tokenId].seller == _msgSender()) {
            revert InvalidParamError();
        }
        // 3. Check if the value is correct
        if (msg.value != saleItems[tokenId].price) {
            revert InvalidParamError();
        }

        // 4. Remove the NFT from the list
        address seller = saleItems[tokenId].seller;
        tokenIdSet.remove(tokenId);
        saleItems[tokenId].tokenId = 0;
        saleItems[tokenId].seller = address(0);
        saleItems[tokenId].price = 0;

        // 5. Transfer the NFT to the buyer
        ntfContract.safeTransferFrom(ourAddress, _msgSender(), tokenId);

        // 6. Transfer the value to the seller
        (bool success, ) = seller.call{value: msg.value}("");
        if (!success) {
            revert InvalidParamError();
        }

        // 7. Emit the event
        emit ItemSold(tokenId, seller, _msgSender(), msg.value);
    }
}
