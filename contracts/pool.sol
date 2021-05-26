pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./mToken.sol";
import "./IBorrower.sol";

contract Pool {

    using SafeMath for uint256;

    address public underlyingAssetAddress;
    address public mTokenAddress;
    uint256 public totalAsset;

    uint256 private flashLoanRateCap = 5;

    constructor(address _underlyingAssetAddress, address _mTokenAddress){
        underlyingAssetAddress = _underlyingAssetAddress;
        mTokenAddress = _mTokenAddress;
    }

    function deposit(uint256 amount, uint256 duration)public{
        require(ERC20(underlyingAssetAddress).transferFrom(msg.sender, address(this), amount),"cannot transfer");
        totalAsset += amount;
        MToken(mTokenAddress).mint(msg.sender, amount, 10, duration);
    }

    function withdraw(uint256 id)public {
        address _mTokenAddress = mTokenAddress; // reduce gas

        MToken(_mTokenAddress).transferFrom(msg.sender, address(this), id);
        (uint256 volumn, uint256 rate, uint256 duration) = MToken(_mTokenAddress).burn(id);

        require(ERC20(underlyingAssetAddress).transfer(msg.sender, volumn),"Withdraw failed");
        totalAsset -= volumn;
    }

    function flashLoan(uint256 amount)public {
        require(amount<=totalAsset,"flash loan amount exceed total asset");
        ERC20(underlyingAssetAddress).transfer(msg.sender, amount);

        uint256 fee = amount.mul(flashLoanRateCap).div(100);
        uint256 repayAmount = amount+fee;

        IBorrower(msg.sender).flashLoanOperation(underlyingAssetAddress,repayAmount);

        require(ERC20(underlyingAssetAddress).balanceOf(address(this))>=totalAsset+fee, "flash loan did not repay");
        totalAsset += fee;
    }

    function getFlashLoanFee(uint256 amount)public view returns(uint256 fee){
        fee = amount.mul(flashLoanRateCap).div(100);
    }
}