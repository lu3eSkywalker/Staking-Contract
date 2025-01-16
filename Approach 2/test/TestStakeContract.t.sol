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
    }

    function test_unstakeFunction() public {
        stakeContract.stake{value: 10 ether}(10 ether);
        assertEq(stakeContract.totalStaked(), 10 ether, "OK");

        uint locking_period = stakeContract.locking_period();
        vm.warp(block.timestamp + locking_period + 1);
        stakeContract.unstake(5 ether);
        assertEq(stakeContract.totalStaked(), 5 ether, "OK");
    }

    function test_pingForGettingReward() public {
        vm.deal(0x70997970C51812dc3A010C7d01b50e0d17dc79C8, 1000 ether);
        vm.startPrank(0x70997970C51812dc3A010C7d01b50e0d17dc79C8);
        stakeContract.stake{value: 10 ether}(10 ether);
        assertEq(stakeContract.totalStaked(), 10 ether, "OK");

        uint userBalance = stakeContract.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8) / 10 ** 18;
        console.log("This is the balance of the user: ", userBalance);

        uint locking_period = stakeContract.locking_period();
        vm.warp(block.timestamp + locking_period + 1900799); // Setting the time after 43 days [3715200 seconds (43 days)]
        console.log("This is the current timestamp: ", block.timestamp);

        uint expectedTokensToMint = getRewards(10, 42);

        stakeContract.pingForGettingRewards();

        uint userBalanceAfterRewards = stakeContract.balanceOf(0x70997970C51812dc3A010C7d01b50e0d17dc79C8) / 10 ** 18;
        console.log("This is the balance of the user after getting staking tokens", userBalanceAfterRewards);

        assertEq(userBalanceAfterRewards, expectedTokensToMint, "OK");
    }

    function getRewards(uint stakedETH, uint daysStaked) public pure returns(uint) {
        uint tokensToMint = stakedETH + daysStaked - 21;
        return tokensToMint;
    }
}