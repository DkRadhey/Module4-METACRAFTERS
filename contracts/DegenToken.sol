// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DegenToken is ERC20,Ownable,ERC20Burnable{

    constructor() ERC20("Degen", "DGN") Ownable(msg.sender){}

     // Items name available for Loot
    enum loot{common,rare,unique,legend}

     struct Player{
     address toAddress;
     uint amount;

    }

   //The queue of player for buying degenToken 
    Player[] public players;

    struct PlayerLoot{
        
        uint common;
        uint rare;
        uint unique;
        uint legend;        
    }

    //To store the redeemed player loot cards
    mapping (address=>PlayerLoot) public playerCards;

    function buyDegen(address _toAddress,uint _amount)public{
        players.push(Player({toAddress:_toAddress,amount:_amount}));
    }

    //minting of tokens for the buyers in the queue
    function mintToken() public onlyOwner {
        //loop to mint tokens for buyers in queue
        while (players.length!=0) {
            uint i = players.length -1;
            if (players[i].toAddress != address(0)) { // Check for non-zero address
            _mint(players[i].toAddress, players[i].amount);
            players.pop();
            }
        }
    }
    
    //Transfer function for transferring tokens to other player
    function transferDegen(address _to, uint _amount)public {
        require(_amount<=balanceOf(msg.sender),"INSUFFICIENT");
        _transfer(msg.sender, _to, _amount);
    }



    //Redeem different loot cards
    function redeemyourloot( loot _card)public{
        if(_card == loot.common){
            require(balanceOf(msg.sender)>=15,"INSUFFICIENT");
            playerCards[msg.sender].common +=1;
            burn(15);
        }else if(_card == loot.rare){
            require(balanceOf(msg.sender)>=25,"Insufficient");
            playerCards[msg.sender].rare +=1;
            burn(25);
        }else if(_card == loot.unique){
            require(balanceOf(msg.sender)>=35,"INSUFFICIENT");
            playerCards[msg.sender].unique +=1;
            burn(35);
        }else if(_card == loot.legend){
            require(balanceOf(msg.sender)>=60,"INSUFFICIENT");
            playerCards[msg.sender].legend +=1;
            burn(60);
        }else{
            revert("NOT AMONGST AVAILABLE CARDS");
        }
    }

    //function to burn token
    function burnDegen(address _of, uint amount)public {
        _burn(_of, amount);
    }

    //function to check the balance of tokens
    function checkYourBalance()public view returns(uint){
        return balanceOf(msg.sender);
    }
}
