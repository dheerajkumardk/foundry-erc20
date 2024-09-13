// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {DeployApnaToken} from "../script/DeployApnaToken.s.sol";
import {ApnaToken} from "../src/ApnaToken.sol";

interface MintableToken {
    function mint(address, uint256) external;
}

contract ApnaTokenTest is Test {
    uint256 public constant INITIAL_SUPPLY = 1000 ether;
    uint256 public ALICE_STARTING_BALANCE = 500 ether;

    ApnaToken public token;
    DeployApnaToken deployToken;
    address alice;
    address bob;

    function setUp() public {
        deployToken = new DeployApnaToken();
        token = deployToken.run();

        alice = makeAddr("alice");
        bob = makeAddr("bob");

        vm.prank(msg.sender);
        token.transfer(alice, ALICE_STARTING_BALANCE);
    }

    // tests
    function testTokenNameAndSymbol() public {
        string memory name = "Apna Token";
        string memory symbol = "AT";

        assertEq(token.name(), name);
        assertEq(token.symbol(), symbol);
    }

    function testInitialSupply() public {
        assertEq(token.totalSupply(), INITIAL_SUPPLY);
    }

    function testBalanceOfMsgSender() public {
        assert(token.balanceOf(msg.sender) == INITIAL_SUPPLY - ALICE_STARTING_BALANCE);
    }

    function testUsersCantMint() public {
        vm.expectRevert();
        MintableToken(address(token)).mint(bob, 100);
    }

    function testApproveCheckAllowance() public {
        uint256 allowanceAmount = 125 ether;

        vm.prank(alice);
        token.approve(bob, allowanceAmount);

        // Assert
        assertEq(token.allowance(alice, bob), allowanceAmount);
    }

    function testApproveAndTransferFrom() public {
        uint256 allowanceAmount = 125 ether;

        vm.prank(alice);
        token.approve(bob, allowanceAmount);

        // Transfer
        vm.prank(bob);
        token.transferFrom(alice, bob, allowanceAmount);

        // Assert
        // Check balances and allowance mapping
        assertEq(token.allowance(alice, bob), 0);
        assertEq(token.balanceOf(bob), allowanceAmount);
        assertEq(token.balanceOf(alice), ALICE_STARTING_BALANCE - allowanceAmount);
    }

    function testBalanceUpdatesOnTransfer() public {
        uint256 amount = 7 ether;

        vm.prank(alice);
        token.transfer(bob, amount);

        // Assert
        assertEq(token.balanceOf(alice), ALICE_STARTING_BALANCE - amount);
        assertEq(token.balanceOf(bob),amount);
    }




}
