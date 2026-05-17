// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;

    address USER = makeAddr("user");

    function setUp() public {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public view {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.deal(USER, 10 ether);

        vm.prank(USER);
        fundMe.fund{value: 1 ether}();

        assertEq(fundMe.addressToAmountFunded(USER), 1 ether);
    }

    function testOnlyOwnerCanWithdraw() public {
        vm.deal(USER, 10 ether);

        vm.prank(USER);
        fundMe.fund{value: 1 ether}();

        vm.prank(USER);
        vm.expectRevert();

        fundMe.withdraw();
    }

    function testOwnerCanWithdraw() public {
        vm.deal(USER, 10 ether);

        vm.prank(USER);
        fundMe.fund{value: 1 ether}();

        uint256 startingOwnerBalance = fundMe.i_owner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;

        vm.prank(fundMe.i_owner());
        fundMe.withdraw();

        uint256 endingOwnerBalance = fundMe.i_owner().balance;

        assertEq(address(fundMe).balance, 0);
        assertEq(
            endingOwnerBalance,
            startingOwnerBalance + startingFundMeBalance
        );
    }

    function testPriceFeedVersionIsAccurate() public view {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    receive() external payable {}
}
