// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/TokenA.sol";
import "../src/TokenSwap.sol";

contract TokenSwapScript is Script {
    function run() external {
        vm.startBroadcast();

        // Deploy TokenA contract
        TokenA tokenA = new TokenA();

        // Deploy TokenSwap contract with TokenA address
        TokenSwap tokenSwap = new TokenSwap(tokenA);

        // Mint some TokenA for the swap contract
        tokenA.mint(address(tokenSwap), 1_000_000 * 10 ** tokenA.decimals());

        // Simulate sending 5 ETH from the first address to the TokenSwap contract
        address firstAccount = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // Replace with actual address from Anvil
        vm.deal(firstAccount, 5 ether); // Ensure first account has 5 ETH
        vm.startPrank(firstAccount); // Act as the first account
        tokenSwap.swapETHForTokenA{value: 5 ether}();

        vm.stopBroadcast();
    }
}
