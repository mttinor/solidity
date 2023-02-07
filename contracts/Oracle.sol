// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;



contract Oracle {
    address public owner;
    uint256 private price;
    constructor(){
        owner  = msg.sender;
    }

    function getPrice() external view returns (uint256){
        return price;
    }

    function setPrice(uint256 newPrice) public {
        require(msg.sender == owner,"Oracle: only owner");
        price = newPrice;
    }
}