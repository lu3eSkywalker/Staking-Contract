// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {console} from "forge-std/console.sol";

contract Stake is ERC20 {
    address public tokenAddress;
    uint256 public totalStaked;
    mapping(address => uint) stakedTime;
    mapping(address => uint256) public tokenBalanceOfUser;

    event tokenStakedEvent(address staker, uint256 tokenValue);
    event tokenUnstakedEvent(address unstaker, uint256 tokenValue);

    constructor(address _tokenAddress) ERC20("Staked Token", "STAKE") {
        tokenAddress = _tokenAddress;
    }

    function stake(address _tokenAddress, uint256 _tokenValue) external {
        require(_tokenAddress == tokenAddress, "The Tokens address should be the same");
        require(_tokenValue > 0, "Token value should be greater than 0");
        IERC20 token = IERC20(_tokenAddress);

        require(token.allowance(address(msg.sender), address(this)) >= _tokenValue, "Token Allowance is required");

        bool success = token.transferFrom(address(msg.sender), address(this), _tokenValue);

        require(success, "Token Transfer failed");

        tokenBalanceOfUser[msg.sender] += _tokenValue;
        totalStaked += _tokenValue;

        mintTokens(msg.sender, _tokenValue);
        emit tokenStakedEvent(msg.sender, _tokenValue);
    }

    function unstake(uint _amount) public {
        require(tokenBalanceOfUser[msg.sender] >= _amount, "Insufficient Tokens");
        require(_amount > 0, "Amount should be greater than 0");

        tokenBalanceOfUser[msg.sender] -= _amount;
        totalStaked -= _amount;

        IERC20 token = IERC20(tokenAddress);
        token.transfer(msg.sender, _amount);

        emit tokenUnstakedEvent(msg.sender, _amount);
    }

    function mintTokens(address account, uint256 value) internal {
        _mint(account, value);
    }
}