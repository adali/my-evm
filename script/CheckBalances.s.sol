// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/TokenSwap.sol"; // Assuming your TokenSwap.sol is in the src directory
import "../src/TokenA.sol"; // Assuming your TokenA.sol is in the src directory

contract CheckBalances is Script {
    TokenA tokenA;
    TokenSwap tokenSwap;
    
    address owner = address(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266); // Anvil 1
    address user = address(0x70997970C51812dc3A010C7d01b50e0d17dc79C8); // Anvil 2

    function run() external {
        console.log("Owner ETH balance:", owner.balance);
        console.log("User ETH balance:", address(user).balance); // Replace with actual user address
    
        vm.startBroadcast(owner); // Start broadcasting as the owner

        // Deploy TokenA and TokenSwap contracts
        tokenA = new TokenA(owner);
        tokenSwap = new TokenSwap(tokenA);

        // Mint tokens for the owner and approve them for use by TokenSwap
        tokenA.mint(owner, 1000 * 10 ** 18);
        tokenA.approve(address(tokenSwap), 1000 * 10 ** 18);
        tokenSwap.depositTokenA(1000 * 10 ** 18);

        // Display the token balances
        uint256 ownerTokenBalance = tokenA.balanceOf(owner);
        uint256 userTokenBalance = tokenA.balanceOf(user);
        uint256 tokenSwapTokenBalance = tokenA.balanceOf(address(tokenSwap));
        
        console.log("Owner TokenA balance: ", ownerTokenBalance);
        console.log("User TokenA balance: ", userTokenBalance);
        console.log("TokenSwap TokenA balance: ", tokenSwapTokenBalance);

        tokenSwap.swapETHForTokenA{value: 5 ether}();

        // Display the Ether balances
        uint256 ownerEthBalance = owner.balance;
        uint256 userEthBalance = user.balance;
        uint256 tokenSwapEthBalance = address(tokenSwap).balance;
        
        console.log("Owner ETH balance: ", ownerEthBalance);
        console.log("Owner TokenA balance: ", tokenA.balanceOf(owner));
        console.log("User ETH balance: ", userEthBalance);
        console.log("TokenSwap ETH balance: ", tokenSwapEthBalance);

        vm.stopBroadcast(); // Stop broadcasting
    }
}
