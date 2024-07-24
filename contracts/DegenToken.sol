// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    
    enum Item { None, ProPlayer, SuperNinja, DegenCap }

    mapping(Item => uint) public itemPrices;

    constructor() ERC20("Degen", "DGN") {
        itemPrices[Item.ProPlayer] = 200;
        itemPrices[Item.SuperNinja] = 100;
        itemPrices[Item.DegenCap] = 75;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function transferTokens(address _receiver, uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        transfer(_receiver, amount);
    }

    function checkBalance() external view returns (uint) {
        return balanceOf(msg.sender);
    }

    function burnTokens(uint amount) external {
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
    }

    function gameStore() public pure returns (string memory) {
        return "1. ProPlayer NFT value = 200\n2. SuperNinja value = 100\n3. DegenCap value = 75";
    }

    function redeemTokens(uint choice) external {
        require(choice > 0 && choice <= 3, "Invalid selection");
        Item item = Item(choice);
        uint price = itemPrices[item];
        require(balanceOf(msg.sender) >= price, "Insufficient balance");
        transfer(owner(), price);
    }
}
