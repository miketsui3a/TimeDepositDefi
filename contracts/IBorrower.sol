pragma solidity ^0.8.0;

interface IBorrower {
   function flashLoanOperation(address, uint256) external;
}