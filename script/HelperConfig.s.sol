// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // 🔥 CONSTANTES (NO MAGIC NUMBERS)
    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    NetworkConfig internal s_activeNetworkConfig;
    MockV3Aggregator public mockPriceFeed;

    constructor() {
        if (block.chainid == 11155111) {
            s_activeNetworkConfig = getSepoliaEthConfig();
        } else {
            s_activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        return
            NetworkConfig({
                priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
            });
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // 🧠 evita redeploy de mock si ya existe
        if (s_activeNetworkConfig.priceFeed != address(0)) {
            return s_activeNetworkConfig;
        }

        vm.startBroadcast();

        mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);

        vm.stopBroadcast();

        s_activeNetworkConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });

        return s_activeNetworkConfig;
    }

    function activeNetworkConfig()
        external
        view
        returns (NetworkConfig memory)
    {
        return s_activeNetworkConfig;
    }
}
