// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {
    
    enum Item { None, ProPlayer, SuperNinja, DegenCap }

    struct PlayerItems {
        uint proPlayer;
        uint superNinja;
        uint degenCap;
    }

    mapping(Item => uint) public itemPrices;
    mapping(address => PlayerItems) public playerItems;  // Tracks the quantity of items owned by players

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
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
        burn(amount);
    }

    function gameStore() public pure returns (string memory) {
        return "1. ProPlayer NFT value = 200\n2. SuperNinja value = 100\n3. DegenCap value = 75";
    }

    function redeemTokens(uint choice) external {
        require(choice > 0 && choice <= 3, "Invalid selection");
        Item item = Item(choice);

        // Update the player's inventory
        if (item == Item.ProPlayer) {
            playerItems[msg.sender].proPlayer += 1;
            burn(200);
        } else if (item == Item.SuperNinja) {
            playerItems[msg.sender].superNinja += 1;
            burn(100);
        } else if (item == Item.DegenCap) {
            playerItems[msg.sender].degenCap += 1;
            burn(75);
        }
    }

    function getPlayerItems() external view returns (uint proPlayer, uint superNinja, uint degenCap) {
        PlayerItems storage items = playerItems[msg.sender];
        return (items.proPlayer, items.superNinja, items.degenCap);
    }
}
