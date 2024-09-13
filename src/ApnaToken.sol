// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {ERC20} from 'openzeppelin-contracts/contracts/token/ERC20/ERC20.sol';

contract ApnaToken is ERC20 {
    constructor (uint256 initialSupply) ERC20("Apna Token", "AT") {
        _mint(msg.sender, initialSupply);
    }

    // If not added -> Tokens could not be minted externally
    // function mint(address to, uint256 amount) external {
    //     _mint(to, amount);
    // }
}