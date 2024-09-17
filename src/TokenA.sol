// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenA is ERC20 {
    address public owner;

    constructor() ERC20("TokenA", "TKA") {
        owner = msg.sender;
        _mint(msg.sender, 1_000_000_000 * 10 ** decimals()); // Mint 1 billion TokenA
    }

    function mint(address to, uint256 amount) external {
        require(msg.sender == owner, "Only owner can mint tokens");
        _mint(to, amount);
    }
}
