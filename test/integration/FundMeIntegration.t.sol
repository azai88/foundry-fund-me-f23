// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {FundMe} from "../../src/FundMe.sol";

contract FundMeIntegrationTest is Test {
    FundMe fundMe;
    DeployFundMe deployer;

    address alice = makeAddr("alice");
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant SEND_VALUE = 0.1 ether;

    function setUp() public {
        deployer = new DeployFundMe();
        fundMe = deployer.run();

        vm.deal(alice, STARTING_BALANCE);
    }

    function testUserCanFundAndOwnerWithdraw() public {
        uint256 initialAliceBalance = alice.balance;
        uint256 initialOwnerBalance = fundMe.getOwner().balance;

        vm.prank(alice);
        fundMe.fund{value: SEND_VALUE}();

        WithdrawFundMe withdrawScript = new WithdrawFundMe();
        withdrawScript.withdrawFundMe(address(fundMe));

        uint256 finalAliceBalance = alice.balance;
        uint256 finalOwnerBalance = fundMe.getOwner().balance;

        assert(address(fundMe).balance == 0);
        assert(finalOwnerBalance > initialOwnerBalance);
    }
}
