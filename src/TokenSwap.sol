// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./TokenA.sol";

contract TokenSwap {
    TokenA public tokenA;
    address public owner;
    uint256 public rate = 100; // 1 ETH = 100 TokenA

    constructor(TokenA _tokenA) {
        tokenA = _tokenA;
        owner = msg.sender;
    }

    // Exchange ETH for TokenA
    function swapETHForTokenA() external payable {
        require(msg.value > 0, "You need to send some ETH");
        uint256 tokenAmount = msg.value * rate;

        // Ensure the contract has enough tokens
        require(tokenA.balanceOf(address(this)) >= tokenAmount, "Not enough tokens in the contract");
        
        // Transfer TokenA to the user
        tokenA.transfer(msg.sender, tokenAmount);
    }

    // Allow owner to withdraw ETH from the contract
    function withdrawETH() external {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }

    // Allow owner to deposit TokenA into the contract for swapping
    function depositTokenA(uint256 amount) external {
        require(msg.sender == owner, "Only owner can deposit tokens");
        tokenA.transferFrom(msg.sender, address(this), amount);
    }
}
