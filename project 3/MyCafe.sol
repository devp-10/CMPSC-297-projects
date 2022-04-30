// SPDX-License-Identifier: MIT

// Only allow compiler versions from 0.7.0 to (not including) 0.9.0
pragma solidity >=0.7.0 <0.9.0;

contract MyCafe {

    // State variables
    address public owner; // Owner
    bool cafeIsOpen; //Check if cafe is open

    //drinks
    mapping (address => uint) coldBrewStock;
    mapping (address => uint) macchiatoStock;
    mapping (address => uint) latteStock;

    //bakery
    mapping (address => uint) croissantStock;
    mapping (address => uint) bagelStock;
    
    // On creation...
    constructor () {
        // Set the owner as the contract's deployer
        owner = msg.sender;

        // Set initial cafe stock
        coldBrewStock[address(this)] = 60;
        macchiatoStock[address(this)] = 50;
        latteStock[address(this)] = 70;
        croissantStock[address(this)] = 40;
        bagelStock[address(this)] = 30;

        // The cafe is initially opened
        cafeIsOpen = true;
    }

    // Function to compare two strings
    function compareStrings(string memory a, string memory b) private pure returns (bool) {
        return (keccak256(abi.encodePacked((a))) == keccak256(abi.encodePacked(b)));
    }

    // Let the owner restock the cafe
    function restock(uint amount, string memory menu) public {
        // Only the owner can restock!
        require(msg.sender == owner, "Only the owner can restock the machine!");

        // Refill the stock based on the type passed in
        if (compareStrings(menu, "coldBrew")) {
            coldBrewStock[address(this)] += amount;
        } else if (compareStrings(menu, "macchiato")) {
            macchiatoStock[address(this)] += amount;
        } else if (compareStrings(menu, "latte")) {
            latteStock[address(this)] += amount;
        } else if (compareStrings(menu, "croissant")) {
            croissantStock[address(this)] += amount;
        } else if (compareStrings(menu, "bagel")) {
            bagelStock[address(this)] += amount;
        } else if (compareStrings(menu, "all")) {
            coldBrewStock[address(this)] += amount;
            macchiatoStock[address(this)] += amount;
            latteStock[address(this)] += amount;
            croissantStock[address(this)] += amount;
            bagelStock[address(this)] += amount;
        }
    }

    // Let the owner open and close the cafe
    function openOrCloseCafe() public returns (string memory) {
        if (cafeIsOpen) {
            cafeIsOpen = false;
            return "Cafe is now closed.";
        } else {
            cafeIsOpen = true;
            return "Cafe is now open.";
        }
    }

    // Purchase from the cafe
    function purchase(uint amount, string memory menu) public payable {
        require(cafeIsOpen == true, "The cafe is closed.");
        require(msg.value >= amount * 0.5 ether, "You must pay at least 0.5 ETH!");

        // Sell item from menu
        if (compareStrings(menu, "coldBrew")) {
            coldBrewStock[address(this)] -= amount;
            coldBrewStock[msg.sender] += amount;
        } else if (compareStrings(menu, "macchiato")) {
            macchiatoStock[address(this)] -= amount;
            macchiatoStock[msg.sender] += amount;
        } else if (compareStrings(menu, "latte")) {
            latteStock[address(this)] -= amount;
            latteStock[msg.sender] += amount;
        } else if (compareStrings(menu, "croissant")) {
            croissantStock[address(this)] -= amount;
            croissantStock[msg.sender] += amount;
        } else if (compareStrings(menu, "bagel")) {
            bagelStock[address(this)] -= amount;
            bagelStock[msg.sender] += amount;
        }
    }

    // Get stock of items from menu
    function getStock(string memory menu) public view returns (uint) {
        // Get stock of items based on the type passed in
        if (compareStrings(menu, "coldBrew")) {
            return coldBrewStock[address(this)];
        } else if (compareStrings(menu, "macchiato")) {
            return macchiatoStock[address(this)];
        } else if (compareStrings(menu, "latte")) {
            return latteStock[address(this)];
        } else if (compareStrings(menu, "croissant")) {
            return croissantStock[address(this)];
        } else if (compareStrings(menu, "bagel")) {
            return bagelStock[address(this)];
        } else {
            return 0;
        }
    }
}
