pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./mToken.sol";

contract Pool {

    address public underlyingAssetAddress;
    address public mTokenAddress;
    uint256 public totalAsset;

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
}