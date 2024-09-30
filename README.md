# SimpleToken - ERC20 Token

SimpleToken is an ERC20 token smart contract written in Solidity. It provides functionality to mint, burn, transfer tokens, and allow users to claim predefined items by burning tokens. The contract uses OpenZeppelin's libraries for security and reliability.

### Features
1. **Minting**: The contract owner can mint tokens for players.
2. **Burning**: Any user can burn their tokens.
3. **Transferring**: Users can transfer tokens to others.
4. **Redeem Cards**: Users can redeem different types of cards by burning tokens.
   
### Prerequisites
Solidity version 0.8.18 or higher.
OpenZeppelin Libraries: The contract imports the ERC20 and Ownable contracts from OpenZeppelin.
Libraries Used
ERC20: Implements standard ERC20 functionality.
Ownable: Restricts some functions to the contract owner.
Contract Breakdown
1. **Item Structure**
The contract allows users to claim items using tokens. Each item has:

name: Name of the item.
price: Cost of the item in tokens.
2. **Minting Tokens**
Function: mint(address to, uint256 amount)
Description: Only the contract owner can mint tokens and assign them to a specific address.

3. **Burning Tokens**
Function: burn(uint256 amount)
Description: Any user can burn their tokens, reducing the total supply.

4. **Claiming Items**
Function: claim(uint256 itemId)
Description: Users can claim items by burning tokens equivalent to the item's price. Once claimed, the item is marked as redeemed for that user.

5. **Checking Claims**
Function: getClaims(address user)
Description: Returns an array indicating whether the user has claimed each item.

## Installation

1. Clone the repository or create a new file in Remix IDE.
2. Copy and paste the contract code into your new file.

### Contract Code
solidity
Copy code
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

        _burn(msg.sender, items[itemId].price);
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
### How to Use

**Deploy the Contract**: Deploy the SimpleToken contract using Remix IDE or a development environment like Hardhat.
**Mint Tokens**: The contract owner can mint new tokens by calling the mint() function.
**Burn Tokens**: Users can burn tokens they own by calling the burn() function.
**Claim Items**: Users can claim items by calling the claim() function and burning the appropriate amount of tokens.
**Check Claims**: Use the getClaims() function to view which items a user has claimed.

### License
This project is licensed under the MIT License.
