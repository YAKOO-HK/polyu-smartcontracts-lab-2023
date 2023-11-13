// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract MyToken is ERC721, ERC721Pausable, Ownable, ERC721Burnable {
    using Strings for uint256;

    error OutOfStock();
    error OutOfQuota();
    error ValueTooLow();
    error TransferError();

    uint256 public totalSupply;
    uint256 public mintLimit;
    uint256 public mintPrice;
    uint256 private _nextTokenId;
    mapping(address => uint256) private mintLog;

    constructor(
        address initialOwner,
        uint256 initialTotalSupply,
        uint256 initialMintLimit,
        uint256 initialMintPrice
    ) ERC721("PolyU Token", "POLYU") Ownable(initialOwner) {
        totalSupply = initialTotalSupply;
        mintLimit = initialMintLimit;
        mintPrice = initialMintPrice;
        _nextTokenId = 1;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        _requireOwned(tokenId);
        return
            string.concat(
                "https://app.moa.udlr.xyz/api/moa/token/",
                tokenId.toString(),
                "/metadata.json"
            );
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function safeMint(address to) public payable whenNotPaused {
        if (_nextTokenId > totalSupply) {
            revert OutOfStock();
        }
        if (mintLog[to] >= mintLimit) {
            revert OutOfQuota();
        }
        if (msg.value != mintPrice) {
            revert ValueTooLow();
        }

        mintLog[to] = mintLog[to] + 1;
        uint256 tokenId = _nextTokenId++;

        address ownerAddress = owner();
        (bool success, ) = ownerAddress.call{value: msg.value}("");
        if (!success) {
            revert TransferError();
        }

        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Pausable) returns (address) {
        return super._update(to, tokenId, auth);
    }
}
