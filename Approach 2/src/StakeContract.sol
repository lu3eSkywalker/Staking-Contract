// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Stake is ERC20 {
    uint256 public totalStaked;
    mapping(address => uint256) userBalance;
    mapping(address => uint) stakedTime;

    uint public locking_period = 1814400; // 21 days in seconds

    event ETHStaked(address staker, uint256 _stakingValue);
    event ETHUnstaked(address unstaked, uint256 _unstakingValue);

    constructor() ERC20("StakingToken", "STAKE") {}

    function stake(uint256 _amount) public payable {
        require(_amount > 0, "Amount should be greater than zero");
        require(msg.value == _amount, "Amount should be equal to msg.value");
        totalStaked += _amount;
        userBalance[msg.sender] += _amount;
        stakedTime[msg.sender] = block.timestamp;

        emit ETHStaked(msg.sender, _amount);
    }

    function pingForGettingRewards() public {
        require(block.timestamp >= locking_period + stakedTime[msg.sender], "Time Remaining for the rewards");

        uint userStakedTime = block.timestamp - (stakedTime[msg.sender] + locking_period);
        uint userStakedTimeToDays = userStakedTime / (60 * 60 * 24);
        stakedTime[msg.sender] = block.timestamp;
        uint userBalanceNew = userBalance[msg.sender] / 10 ** 18;
        uint tokensToMint = userBalanceNew + userStakedTimeToDays;

        mintTokens(tokensToMint * 10 ** 18, msg.sender);
    }

    function unstake(uint256 _amount) public payable {
        require(_amount > 0, "Amount should be greater than zero");
        require(block.timestamp >= stakedTime[msg.sender] + locking_period, "Time Remaining");
        require(userBalance[msg.sender] >= _amount, "User Balance is insufficient");
        totalStaked -= _amount;
        userBalance[msg.sender] -= _amount;
        stakedTime[msg.sender] = block.timestamp;
        payable(msg.sender).transfer(_amount);

        emit ETHUnstaked(msg.sender, _amount);
    }

    function mintTokens(uint256 _amount, address toMintAccount) internal {
        _mint(toMintAccount, _amount);
    }
}