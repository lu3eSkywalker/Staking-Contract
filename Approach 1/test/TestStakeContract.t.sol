// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Stake} from "../src/StakeContract.sol";

contract TestStakeContract is Test {
    Stake stakeContract;

    function setUp() public {
        stakeContract = new Stake();
    }

    receive() external payable {}

    fallback() external payable {}

    function test_stakeFunction() public {
        stakeContract.stake{value: 10 ether}(10 ether);
        assertEq(stakeContract.totalStaked(), 10 ether, "OK");
        assertEq(stakeContract.balanceOf(address(this)), 10 * 10 ** 18, "OK");
    }

    function test_unstakeFunction() public {
        vm.deal(0x70997970C51812dc3A010C7d01b50e0d17dc79C8, 1000 ether);
        vm.startPrank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        stakeContract.stake{value: 10 ether}(10 ether);
        assertEq(stakeContract.totalStaked(), 10 ether, "OK");
        assertEq(stakeContract.balanceOf(address(0x70997970C51812dc3A010C7d01b50e0d17dc79C8)), 10 * 10 ** 18, "OK");

        stakeContract.unstake(5 ether);
        assertEq(stakeContract.totalStaked(), 5 ether, "OK");
    }

    function test_pingForGettingReward() public {
        vm.deal(0x70997970C51812dc3A010C7d01b50e0d17dc79C8, 1000 ether);
        vm.startPrank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        stakeContract.stake{value: 10 ether}(10 ether);
        assertEq(stakeContract.totalStaked(), 10 ether, "OK");
        assertEq(stakeContract.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8), 10 * 10 ** 18, "OK");

        uint userBalance = stakeContract.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8) / 10 ** 18;

        uint tokenTime = stakeContract.token_time();
        vm.warp(block.timestamp + tokenTime + 1);
        uint userTimeStaked = tokenTime + 1;
        uint expectedReward = calculateReward(userTimeStaked/86400, stakeContract.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8) / 10**18);
        console.log("This is the expected reward: ", expectedReward);

        stakeContract.pingForGettingReward();
        console.log("This is the balace after pinging the smart contract for rewards: ", stakeContract.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8) / 10 ** 18);
        assertEq(stakeContract.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8) / 10 ** 18, expectedReward + userBalance,"OK");
    }

    function calculateReward(uint userStakedTime, uint256 userBalance) public pure returns(uint) {
        uint rewardTokenAmount = userStakedTime * 1 * userBalance;
        return rewardTokenAmount;
    }
}
