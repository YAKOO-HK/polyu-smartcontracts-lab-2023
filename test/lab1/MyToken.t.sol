// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {stdStorage, Test, StdStorage} from "forge-std/Test.sol";
import {MyToken} from "src/lab1/MyToken.sol";
import {Utils} from "../Utils.sol";

contract MyTokenTest is Test {
    using stdStorage for StdStorage;

    Utils internal utils;
    address payable[] internal accounts;
    address internal owner;
    address internal alice;
    address internal bob;
    address internal carol;
    MyToken nft;

    function setUp() external {
        utils = new Utils();
        accounts = utils.createUsers(4);
        owner = accounts[0];
        alice = accounts[1];
        bob = accounts[2];
        carol = accounts[3];
        nft = new MyToken(address(owner), 2, 1, 0.1 ether);
    }

    function test_mint() external {
        nft.safeMint{value: 0.1 ether}(alice);
        assertEq(nft.balanceOf(alice), 1);
    }

    function test_mintLowValue() external {
        vm.expectRevert(MyToken.ValueTooLow.selector);
        nft.safeMint{value: 0.09 ether}(alice);
        assertEq(nft.balanceOf(alice), 0);
    }

    function test_mintOutOfQuota() external {
        nft.safeMint{value: 0.1 ether}(alice);
        assertEq(nft.balanceOf(alice), 1);

        vm.expectRevert(MyToken.OutOfQuota.selector);
        nft.safeMint{value: 0.1 ether}(alice);
        assertEq(nft.balanceOf(alice), 1);
    }

    function test_mintOutOfStock() external {
        nft.safeMint{value: 0.1 ether}(alice);
        assertEq(nft.balanceOf(alice), 1);
        nft.safeMint{value: 0.1 ether}(bob);
        assertEq(nft.balanceOf(bob), 1);

        vm.expectRevert(MyToken.OutOfStock.selector);
        nft.safeMint{value: 0.1 ether}(carol);
        assertEq(nft.balanceOf(carol), 0);
    }
}
