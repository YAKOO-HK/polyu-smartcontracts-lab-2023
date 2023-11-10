// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {stdStorage, Test, StdStorage} from "forge-std/Test.sol";
import {MyToken} from "src/lab1/MyToken.sol";
import {IMarketplace} from "src/lab2/IMarketplace.sol";
import {MarketplaceSample} from "src/lab2/MarketplaceSample.sol";
import {Utils} from "../Utils.sol";

contract MarketplaceTest is Test {
    using stdStorage for StdStorage;

    Utils internal utils;
    address payable[] internal accounts;
    address internal owner;
    address internal alice;
    address internal bob;
    address internal carol;
    MyToken nft;
    IMarketplace marketplace;

    function setUp() external {
        utils = new Utils();
        accounts = utils.createUsers(4);
        owner = accounts[0];
        alice = accounts[1];
        bob = accounts[2];
        carol = accounts[3];
        nft = new MyToken(address(owner), 666, 10, 0.1 ether);
        marketplace = new MarketplaceSample(address(nft));

        nft.safeMint{value: 0.1 ether}(alice);
    }

    function test_list() external {
        vm.prank(alice);
        nft.approve(address(marketplace), 1);
        marketplace.list(1, 1 ether);
        assertEq(nft.ownerOf(1), address(marketplace));
        assertEq(marketplace.numberOfItems(), 1);
        assertEq(marketplace.itemAtIndex(0).tokenId, 1);
    }

    function test_delist() external {
        vm.prank(alice);
        nft.approve(address(marketplace), 1);
        marketplace.list(1, 1 ether);
        assertEq(nft.ownerOf(1), address(marketplace));
        assertEq(marketplace.numberOfItems(), 1);

        vm.prank(alice);
        marketplace.delist(1);
        assertEq(nft.ownerOf(1), address(alice));
        assertEq(marketplace.numberOfItems(), 0);
    }

    function test_buy() external {
        vm.prank(alice);
        nft.approve(address(marketplace), 1);
        marketplace.list(1, 1 ether);
        assertEq(nft.ownerOf(1), address(marketplace));
        assertEq(marketplace.numberOfItems(), 1);

        uint beforeBalance = alice.balance;
        vm.prank(bob);
        marketplace.buy{value: 1 ether}(1);
        assertEq(nft.ownerOf(1), address(bob));
        assertEq(marketplace.numberOfItems(), 0);
        assertEq(alice.balance, beforeBalance + 1 ether);
    }
}
