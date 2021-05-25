pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract MToken is ERC721("mToken","MTK"){

    mapping(uint256=>mapping(string=>uint256)) public tokenData;
    uint256 count;

    function mint(address to, uint256 volumn, uint256 rate, uint256 duration)public{
        _safeMint(to, count);
        tokenData[count]["volumn"] = volumn;
        tokenData[count]["rate"] = rate;
        tokenData[count]["duration"] = duration;
        tokenData[count]["startTime"] = block.timestamp;
        count++;
    }

    function burn(uint256 id)public returns(uint256 volumn, uint256 rate, uint256 duration){
        require(block.timestamp>=tokenData[count]["duration"]+tokenData[count]["startTime"],"time deposit not yet mature");
        _burn(id);
        volumn = tokenData[count]["volumn"];
        rate = tokenData[count]["rate"];
        duration = tokenData[count]["duration"];
    }
}

