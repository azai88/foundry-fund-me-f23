// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public minimumUsd = 5 * 1e18;
    address public owner;
    mapping(address => uint256) public addressToAmountFunded;

    AggregatorV3Interface public priceFeed;

    constructor(address priceFeedAddress) {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    function fund() public payable {
        // require(
        //     msg.value.getConversionRate(priceFeed) >= minimumUsd,
        //     "Didn't send enough ETH"
        // );

        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public {
        if (msg.sender != owner) {
            revert NotOwner();
        }

        (bool success, ) = payable(owner).call{value: address(this).balance}(
            ""
        );
        require(success, "Call failed");
    }
}
