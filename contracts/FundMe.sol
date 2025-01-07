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

    address public Owner;

    //constructors run once the contract is deployed
    // the constuctor below will set the owner of thecontract
    // to the address used in deploying it
    constructor() {
        Owner = msg.sender;
    } 

    function Fund() public payable {
        require(msg.value.getConversionRate() >= minimumUsd, "not enough eth");
        funders.push(msg.sender);
        addresSTOAmountFunding[msg.sender] += msg.value;
    }

    function withdraw() public{
        //make sure only owner can call this function
        require(msg.sender == Owner, "you dont have the permission to call this function");
        for(uint256 i=0; i<funders.length; i++) {
            address funder = funders[i];
            addresSTOAmountFunding[funder] = 0;
        }

        funders = new address[](0);

        //this is the safest way to withdraw money in solidity since it also 

        //reverts if an errror should occour
        // payable(msg.sender).transfer(address(this).balance);

        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "call failed");

    }


    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }
}