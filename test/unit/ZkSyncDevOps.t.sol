// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {ZkSyncChainChecker} from "foundry-devops/src/ZkSyncChainChecker.sol";
import {FoundryZkSyncChecker} from "foundry-devops/src/FoundryZkSyncChecker.sol";

contract ZkSyncDevOpsTest is Test, ZkSyncChainChecker, FoundryZkSyncChecker {
    function testZkSyncChainFails() public skipZkSync {
        uint256 x = 1;
        uint256 y = 2;
        assertEq(x + y, 3);
    }

    function testOnlyZkSync() public onlyZkSync {
        assertTrue(block.chainid > 0);
    }

    function testOnlyVanillaFoundry() public onlyVanillaFoundry {
        assertEq(uint256(1), uint256(1));
    }

    function testOnlyFoundryZkSync() public onlyFoundryZkSync {
        assertEq(uint256(2), uint256(2));
    }
}
