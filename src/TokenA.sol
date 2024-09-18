// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20, Ownable {
    constructor() ERC20("TokenA", "TKA") Ownable(msg.sender) {
        // Ownable's constructor is automatically called with msg.sender as the owner
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
