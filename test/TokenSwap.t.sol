// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/TokenA.sol";
import "../src/TokenSwap.sol";

contract TokenSwapTest is Test {
    TokenA tokenA;
    TokenSwap tokenSwap;

    address owner = address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266); // Anvil 1, EOA External Owned Account
    address user = address(0x70997970C51812dc3A010C7d01b50e0d17dc79C8); // Anvil 2, EOA External Owned Account
    
    function setUp() public {
        // Deploy TokenA and TokenSwap contracts
        tokenA = new TokenA();
        tokenSwap = new TokenSwap(tokenA);

        // Get the contract's owner
        address contractOwner = address(tokenA.owner());

        // Use vm.startPrank with the contract owner
        vm.startPrank(contractOwner);

        // Mint tokens for owner
        tokenA.mint(contractOwner, 1000 * 10 ** 18); // Mint tokens for owner
        tokenA.approve(address(tokenSwap), 1000 * 10 ** 18); // Approve TokenSwap to spend owner's tokens
        tokenSwap.depositTokenA(1000 * 10 ** 18); // Deposit 1000 TokenA into the swap contract

        vm.stopPrank();

        // Assume TokenA is pre-funded or deposited tokens manually
        // Simulate a deposit of 1000 TokenA to TokenSwap
        // vm.startPrank(owner);
        // tokenA.transfer(address(tokenSwap), 1000 * 10 ** 18); // Transfer 1000 TokenA to TokenSwap
        // vm.stopPrank();        
    }

    function testSwapETHForTokenA() public payable {
        // Arrange
        uint256 amountETH = 1 ether;
        uint256 expectedTokenAmount = amountETH * tokenSwap.rate();

        // Act
        vm.deal(user, amountETH); // Provide ETH to user
        vm.startPrank(user);
        (bool success, ) = address(tokenSwap).call{value: amountETH}(abi.encodeWithSignature("swapETHForTokenA()"));
        require(success, "Swap failed");
        vm.stopPrank();

        // Assert
        assertEq(tokenA.balanceOf(user), expectedTokenAmount, "User should receive the correct amount of TokenA");
    }

    function testWithdrawETH() public {
        // Arrange
        uint256 initialBalance = address(owner).balance;
        uint256 amountETH = 1 ether;
        vm.deal(address(tokenSwap), amountETH); // Deposit ETH into TokenSwap contract

        // Act
        vm.startPrank(owner);
        tokenSwap.withdrawETH();
        vm.stopPrank();

        // Assert
        assertEq(address(owner).balance, initialBalance + amountETH, "Owner should receive the withdrawn ETH");
        assertEq(address(tokenSwap).balance, 0, "TokenSwap contract should have no ETH left");
    }

    function testDepositTokenA() public {
        // Arrange
        uint256 depositAmount = 500 * 10 ** 18;

        // Act
        vm.startPrank(owner);
        tokenA.approve(address(tokenSwap), depositAmount);
        tokenSwap.depositTokenA(depositAmount);
        vm.stopPrank();

        // Assert
        assertEq(tokenA.balanceOf(address(tokenSwap)), depositAmount, "TokenSwap contract should hold the deposited TokenA");
    }

    function testFailSwapETHForTokenAWithoutEnoughTokens() public payable {
        // Arrange
        uint256 amountETH = 1 ether;

        // Act
        vm.deal(user, amountETH);
        vm.startPrank(user);
        tokenSwap.swapETHForTokenA(); // Expect failure
        vm.stopPrank();
    }

    function testFailWithdrawETHByNonOwner() public {
        // Act
        vm.startPrank(user);
        vm.expectRevert("Only owner can withdraw");
        tokenSwap.withdrawETH(); // Expect failure
        vm.stopPrank();
    }
}
