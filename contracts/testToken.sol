pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract TestToken is ERC20("TEST","TEST"){
    function mint(address to, uint256 amount)public{
        _mint(to, amount);
    }
}