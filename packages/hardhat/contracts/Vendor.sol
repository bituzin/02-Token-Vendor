pragma solidity 0.8.20;
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH); // DODAJ EVENT

    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;

    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }

    function buyTokens() public payable {
        require(msg.value > 0, "Must send ETH to buy tokens");
        uint256 amountOfTokens = msg.value * tokensPerEth;
        require(yourToken.balanceOf(address(this)) >= amountOfTokens, "Vendor has insufficient tokens");
        yourToken.transfer(msg.sender, amountOfTokens);
        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }

    // DODAJ FUNKCJĘ sellTokens
    function sellTokens(uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than 0");
        uint256 ethAmount = _amount / tokensPerEth;
        require(address(this).balance >= ethAmount, "Vendor has insufficient ETH");
        
        // Przenieś tokeny od użytkownika do Vendor
        bool success = yourToken.transferFrom(msg.sender, address(this), _amount);
        require(success, "Transfer failed - check approval");
        
        // Wyślij ETH do użytkownika
        payable(msg.sender).transfer(ethAmount);
        emit SellTokens(msg.sender, _amount, ethAmount);
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;
        require(amount > 0, "No ETH to withdraw");
        payable(owner()).transfer(amount);
    }
}