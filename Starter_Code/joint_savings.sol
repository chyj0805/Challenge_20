// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

contract JointBankAccount {
    // Declare two payable addresses for the account holders
    address payable primaryAccountHolder;
    address payable secondaryAccountHolder;

    // Variables to track the latest withdrawal details and account balance
    address public lastWithdrawalAccount;
    uint public lastWithdrawalAmount;
    uint public accountBalance;
    
    // Function to permit a withdrawal from the joint account
    function withdrawFunds(uint amount, address payable beneficiary) public {
        // Ensure the beneficiary is one of the account holders
        require(beneficiary == primaryAccountHolder || beneficiary == secondaryAccountHolder, "Unauthorized account!");
        
        // Ensure the contract contains enough funds for the withdrawal
        require(address(this).balance >= amount, "Insufficient funds!");
        
        // Update the last withdrawal account if it's different from the current beneficiary
        if (lastWithdrawalAccount != beneficiary) {
            lastWithdrawalAccount = beneficiary;
        }
        
        // Transfer the specified amount to the beneficiary
        beneficiary.transfer(amount);
        
        // Update the last withdrawal amount and account balance
        lastWithdrawalAmount = amount;
        accountBalance = address(this).balance;
    }
    
    // Function to deposit ether into the joint account
    function depositFunds() public payable {
        // Update the account balance with the deposited amount
        accountBalance = address(this).balance;
    }

    // Function to define the account holders
    function defineAccountHolders(address payable primaryHolder, address payable secondaryHolder) public {
        // Set the addresses of the primary and secondary account holders
        primaryAccountHolder = primaryHolder;
        secondaryAccountHolder = secondaryHolder;
    }

    // Fallback function to facilitate receiving ether
    function() external payable {}
}

