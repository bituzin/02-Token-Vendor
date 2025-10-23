pragma solidity 0.8.20;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract YourToken is ERC20 {
    constructor() ERC20("Bituzin", "BTZ") {
        _mint(msg.sender, 1000 * 10 ** 18); // Zmienione na msg.sender zamiast stałego adresu
    }
}