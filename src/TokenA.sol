// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20, Ownable {
    // Pass initial owner to the Ownable constructor
    constructor(address initialOwner) ERC20("TokenA", "TKA") Ownable(initialOwner) {
        // The owner is explicitly set during contract deployment
    }

    // Mint new tokens, only the owner can call this function
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
