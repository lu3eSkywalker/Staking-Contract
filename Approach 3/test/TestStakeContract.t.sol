// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import {Test} from "forge-std/Test.sol";
import {console} from "forge-std/console.sol";
import {Stake} from "../src/StakeContract.sol";
import {TokenContract} from "../src/TokenContract.sol";

contract TestStakeContract is Test {
    Stake stakeContract;
    TokenContract tokenContract;

    function setUp() public {
        tokenContract = new TokenContract();
        stakeContract = new Stake(address(tokenContract));
    }

    function test_stake() public {
        tokenContract.mint(address(this), 10 * 10**18);
        uint tokenBalanceOfUser = tokenContract.balanceOf(address(this));
        console.log(tokenBalanceOfUser / 10 ** 18);

        tokenContract.approve(address(stakeContract), 5 * 10 ** 18);
        stakeContract.stake(address(tokenContract), 5 * 10 ** 18);

        uint balanceOfTokens = tokenContract.balanceOf(address(stakeContract)) / 10 ** 18;

        uint256 balanceOfUsers = stakeContract.tokenBalanceOfUser(address(this)) / 10 ** 18;

        uint256 balanceOfStakingToken = stakeContract.balanceOf(address(this));
        console.log("Balance of Staking Token: ", balanceOfStakingToken);

        assertEq(balanceOfStakingToken, 5 ether, "OK");
        assertEq(balanceOfTokens, 5, "OK");
        assertEq(balanceOfUsers, 5, "OK");
    }

        function test_unstake() public {
        tokenContract.mint(address(this), 10 * 10**18);
        uint tokenBalanceOfUser = tokenContract.balanceOf(address(this));
        console.log(tokenBalanceOfUser / 10 ** 18);

        tokenContract.approve(address(stakeContract), 5 ether);
        stakeContract.stake(address(tokenContract), 5 ether);

        uint balanceOfTokens = tokenContract.balanceOf(address(stakeContract)) / 10 ** 18;

        uint256 balanceOfUsers = stakeContract.tokenBalanceOfUser(address(this)) / 10 ** 18;

        assertEq(balanceOfTokens, 5, "OK");
        assertEq(balanceOfUsers, 5, "OK");

        uint amountToGive = 4.5 ether;

        stakeContract.unstake(amountToGive);

        uint balanceOfTokensAgain = tokenContract.balanceOf(address(stakeContract));
        assertEq(balanceOfTokensAgain, 0.5 ether, "OK");
        assertEq(stakeContract.totalStaked(), 0.5 ether, "OK");
    }


// Tests as users simulations
    function test_stakeForUserTest() public {
        vm.startPrank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        tokenContract.mint(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 10 * 10**18);
        uint tokenBalanceOfUser = tokenContract.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        console.log(tokenBalanceOfUser / 10 ** 18);

        tokenContract.approve(address(stakeContract), 5 * 10 ** 18);
        stakeContract.stake(address(tokenContract), 5 * 10 ** 18);

        uint balanceOfTokens = tokenContract.balanceOf(address(stakeContract)) / 10 ** 18;

        uint256 balanceOfUsers = stakeContract.tokenBalanceOfUser(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) / 10 ** 18;

        uint256 balanceOfStakingToken = stakeContract.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        console.log("Balance of Staking Token: ", balanceOfStakingToken);

        assertEq(balanceOfStakingToken, 5 ether, "OK");
        assertEq(balanceOfTokens, 5, "OK");
        assertEq(balanceOfUsers, 5, "OK");
    }

    function test_unstakeForUserTest() public {
        vm.startPrank(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        tokenContract.mint(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266, 10 * 10**18);
        uint tokenBalanceOfUser = tokenContract.balanceOf(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266);
        console.log(tokenBalanceOfUser / 10 ** 18);

        tokenContract.approve(address(stakeContract), 5 ether);
        stakeContract.stake(address(tokenContract), 5 ether);

        uint balanceOfTokens = tokenContract.balanceOf(address(stakeContract)) / 10 ** 18;

        uint256 balanceOfUsers = stakeContract.tokenBalanceOfUser(0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266) / 10 ** 18;

        assertEq(balanceOfTokens, 5, "OK");
        assertEq(balanceOfUsers, 5, "OK");

        uint amountToGive = 4.5 ether;

        stakeContract.unstake(amountToGive);

        uint balanceOfTokensAgain = tokenContract.balanceOf(address(stakeContract));
        assertEq(balanceOfTokensAgain, 0.5 ether, "OK");
        assertEq(stakeContract.totalStaked(), 0.5 ether, "OK");
    }
}