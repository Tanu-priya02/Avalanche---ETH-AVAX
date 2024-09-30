// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.4.0/contracts/access/Ownable.sol";

contract SimpleToken is ERC20, Ownable {
    struct Item {
        string name;
        uint256 price;
    }

    Item[] public items;
    mapping(address => mapping(uint256 => bool)) public redeemed;

    constructor() ERC20("SimpleToken", "STK") {
        addItems();
    }

    function addItems() internal {
        items.push(Item("Item A", 100));
        items.push(Item("Item B", 200));
        items.push(Item("Item C", 300));
        items.push(Item("Item D", 400));
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function transferTokens(address to, uint256 amount) external onlyOwner {
        _transfer(msg.sender, to, amount);
    }

    function claim(uint256 itemId) external {
        require(itemId < items.length, "Item not found");
        require(balanceOf(msg.sender) >= items[itemId].price, "Not enough tokens");
        require(!redeemed[msg.sender][itemId], "Already claimed");

        // Burn tokens to pay for the item
        _burn(msg.sender, items[itemId].price);
        
        // Mark item as claimed
        redeemed[msg.sender][itemId] = true;
    }

    function getClaims(address user) external view returns (bool[] memory) {
        bool[] memory claims = new bool[](items.length);
        for (uint256 i = 0; i < items.length; i++) {
            claims[i] = redeemed[user][i];
        }
        return claims;
    }
}
