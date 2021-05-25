pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MToken is ERC721("mToken","MTK"){

    mapping(uint256=>mapping(string=>uint256)) public tokenData;
    uint256 count;

    modifier isWithdrawValid(uint256 id){
        require(block.timestamp>=(tokenData[id]["duration"]+tokenData[id]["startTime"]),"time deposit not yet mature");
        _;
    }

    function mint(address to, uint256 volumn, uint256 rate, uint256 duration)public{
        _safeMint(to, count);
        tokenData[count]["volumn"] = volumn;
        tokenData[count]["rate"] = rate;
        tokenData[count]["duration"] = duration;
        tokenData[count]["startTime"] = block.timestamp;
        count++;
    }

    function burn(uint256 id)public isWithdrawValid(id) returns(uint256 volumn, uint256 rate, uint256 duration){
        _burn(id);
        volumn = tokenData[id]["volumn"];
        rate = tokenData[id]["rate"];
        duration = tokenData[id]["duration"];
    }

}

