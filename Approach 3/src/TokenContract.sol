// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TokenContract is ERC20 {

    constructor() ERC20("USDT", "USDT") {}

    function mint(address account, uint256 value) public {
        _mint(account, value);
    }
}