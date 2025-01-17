// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract Stake is ERC20 {
    uint256 public totalStaked;
    mapping(address => uint256) userBalance;
    mapping(address => uint) stakedTime;

    uint256 reward_constant = 1 ;
    uint public token_time = 604800; // 7 days in seconds

    event ETHStaked(address staker, uint256 _stakingValue);
    event ETHUnstaked(address unstaked, uint256 _unstakingValue);

    constructor() ERC20("StakingToken", "STAKE") {}

    function stake(uint256 _amount) public payable {
        require(_amount > 0, "Amount should be greater than zero");
        require(msg.value == _amount, "Amount should be equal to msg.value");
        totalStaked += _amount;
        userBalance[msg.sender] += _amount;
        mintTokens(_amount, msg.sender);
        stakedTime[msg.sender] = block.timestamp;

        emit ETHStaked(msg.sender, _amount)
    }

    function pingForGettingReward() public {
        require(block.timestamp >= token_time + stakedTime[msg.sender], "Time Remaining for the rewards");

        uint userStakedTime = (block.timestamp - stakedTime[msg.sender]) / 86400;
        uint256 tokenAmountToMint = userStakedTime * reward_constant * userBalance[msg.sender];
        stakedTime[msg.sender] = block.timestamp;
        mintTokens(tokenAmountToMint, msg.sender);
    }

    function unstake(uint256 _amount) public payable {
        require(_amount > 0, "Amount should be greater than zero");
        require(
            userBalance[msg.sender] >= _amount,
            "User Balance is insufficient"
        );
        totalStaked -= _amount;
        userBalance[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);

        emit ETHUnstaked(msg.sender, _amount);
    }

    function mintTokens(uint256 _amount, address toMintAccount) public {
        _mint(toMintAccount, _amount);
    }
}