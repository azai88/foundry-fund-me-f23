// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() public {
        fundMe = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    receive() external payable {}

    function testUserCanFund() public {
        address user = makeAddr("user");
        vm.deal(user, 10 ether);

        vm.prank(user);
        fundMe.fund{value: 1 ether}();

        assertEq(fundMe.addressToAmountFunded(user), 1 ether);
    }

    function testOwnerCanWithdraw() public {
        address user = makeAddr("user");
        vm.deal(user, 10 ether);

        vm.prank(user);
        fundMe.fund{value: 1 ether}();

        uint256 startingOwnerBalance = address(fundMe.owner()).balance;

        fundMe.withdraw();

        uint256 endingOwnerBalance = address(fundMe.owner()).balance;

        assertEq(endingOwnerBalance, startingOwnerBalance + 1 ether);
    }
}
