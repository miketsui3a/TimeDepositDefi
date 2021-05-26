pragma solidity ^0.8.0;
import "./pool.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./IBorrower.sol";

contract Borrower is IBorrower{
    function borrow(address _pool, uint256 amonut)public{
        Pool(_pool).flashLoan(amonut);
    }

    function flashLoanOperation(address _underlyingAsset, uint256 amount)external override{
        // arbitrage login here:




        ERC20(_underlyingAsset).transfer(msg.sender, amount);
    }
}