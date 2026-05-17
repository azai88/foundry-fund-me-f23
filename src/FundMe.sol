// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {PriceConverter} from "./PriceConverter.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant MINIMUM_USD = 5e18;

    address public immutable i_owner;
    mapping(address => uint256) public addressToAmountFunded;

    AggregatorV3Interface private s_priceFeed;

    constructor(address priceFeed) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(priceFeed);
    }

    function fund() public payable {
        require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "Didn't send enough ETH");

        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public {
        if (msg.sender != i_owner) revert NotOwner();

        (bool success,) = payable(i_owner).call{value: address(this).balance}("");

        require(success, "Withdraw failed");
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }
}
