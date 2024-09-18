// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "forge-std/console.sol";

// 与 TokenA 和 TokenSwap 合约交互的接口
interface ITokenA {
    function balanceOf(address account) external view returns (uint256);
}

interface ITokenSwap {
    function tokenA() external view returns (address);
}

contract CheckBalances is Script {
    function run() external {
        // 定义地址（使用正确的 checksum 地址）
        address firstAccount = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // 替换为Anvil 1账户地址
        address tokenSwapAddress = 0x132F7D9033b28B08cbc520e1cfD83c6dA3abfA36; // 替换为 TokenSwap 合约地址

        // 开始广播交易
        vm.startBroadcast();

        // 读取第一个账户的余额
        //uint256 firstAccountBalance = vm.balance(firstAccount);
        uint256 firstAccountBalance = address(firstAccount).balance;
        console.log("First Account Balance: %s ETH", firstAccountBalance / 1 ether);

        // 结束广播交易
        vm.stopBroadcast();

        // 创建 TokenSwap 合约实例
        ITokenSwap tokenSwap = ITokenSwap(tokenSwapAddress);

        // 检查 tokenA 方法是否返回有效地址
        address tokenAAddress = tokenSwap.tokenA();
        if (tokenAAddress == address(0)) {
            console.log("Erorr: TokenA address is zero. Please check the TokenSwap contract.");
            return;
        }

        console.log("TokenA contract address : %s", tokenAAddress);

        // 创建 TokenA 合约实例
        ITokenA tokenA = ITokenA(tokenAAddress);

        // 获取 TokenA 合约的余额
        uint256 tokenAContractBalance = tokenA.balanceOf(tokenSwapAddress);
        console.log("TokenA Contract Balance: %s TokenA", tokenAContractBalance);

        // 获取第一个账户的 TokenA 余额
        uint256 firstAccountTokenABalance = tokenA.balanceOf(firstAccount);
        console.log("First Anvil Account TokenA Balance: %s TokenA", firstAccountTokenABalance);
    }
}
