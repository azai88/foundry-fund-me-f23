// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() public {
        fundMe = new FundMe(address(1));
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.minimumUsd(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.owner(), address(this));
    }

    function testFundUpdatesFundedDataStructure() public {
        address user = makeAddr("user");
        vm.deal(user, 10 ether);

        vm.prank(user);
        fundMe.fund{value: 1 ether}();

        assertEq(fundMe.addressToAmountFunded(user), 1 ether);
    }

    function testOnlyOwnerCanWithdraw() public {
        address user = makeAddr("user");
        vm.deal(user, 10 ether);

        vm.prank(user);
        fundMe.fund{value: 1 ether}();

        vm.prank(user);
        vm.expectRevert();

        fundMe.withdraw();
    }

    function testOwnerCanWithdraw() public {
        address user = makeAddr("user");
        vm.deal(user, 10 ether);

        vm.prank(user);
        fundMe.fund{value: 1 ether}();

        uint256 startingOwnerBalance = address(fundMe.owner()).balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        fundMe.withdraw();

        uint256 endingOwnerBalance = address(fundMe.owner()).balance;
        uint256 endingFundMeBalance = address(fundMe).balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundMeBalance
        );
    }

    receive() external payable {}
}
