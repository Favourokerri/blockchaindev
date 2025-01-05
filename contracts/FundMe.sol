// collect funds from users
// wdthraw funds to account
// set a minuimum amount users can send

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./priceConverter.sol";

contract FundMe {
    using PriceConverter for uint256; // to enable uint256 call this library
    uint256 public minimumUsd = 5e18;
    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addresSTOAmountFunding; 

    function Fund() public payable {
        require(msg.value.getConversionRate() >= minimumUsd, "not enough eth");
        funders.push(msg.sender);
        addresSTOAmountFunding[msg.sender] += msg.value;
    }

    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }
}