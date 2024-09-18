// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/TokenA.sol";
import "../src/TokenSwap.sol";
import "forge-std/console.sol";

contract DeployContracts is Script {
    function run() external {

        // 指定部署账户地址, 目的是部署后的合约地址保持不变
        address deployer = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // 使用Anvil的第一个账户地址

        // 设置固定的 nonce
        uint64 fixedNonce = 999;  // 替换为你希望的 nonce 值

        // 开始广播交易（指定特定的账户地址）
        vm.startBroadcast(deployer);

        // 设置固定的 nonce
        vm.setNonce(deployer, fixedNonce);        

        // 部署 TokenA 合约
        TokenA tokenA = new TokenA();
        console.log("TokenA Contract Address: %s", address(tokenA));

        // 部署 TokenSwap 合约，传入 TokenA 合约地址
        TokenSwap tokenSwap = new TokenSwap(tokenA);
        console.log("TokenSwap Contract Address: %s", address(tokenSwap));

        // 结束广播
        vm.stopBroadcast();
    }
}
