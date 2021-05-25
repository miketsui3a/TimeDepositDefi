const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Greeter", function() {
  it("Should return the new greeting once it's changed", async function() {
    // const Greeter = await ethers.getContractFactory("Greeter");
    // const greeter = await Greeter.deploy("Hello, world!");
    
    // await greeter.deployed();
    // expect(await greeter.greet()).to.equal("Hello, world!");

    // await greeter.setGreeting("Hola, mundo!");
    // expect(await greeter.greet()).to.equal("Hola, mundo!");

    const user = await ethers.getSigner().address

    const TestToken = await ethers.getContractFactory("TestToken");
    const testToken = await TestToken.deploy();
    await testToken.deployed();
    const mintTx = await testToken.mint("0xD572273BD83B9A6D92F48c7dA548DB5D3ce3A175",100000000000000)
    const mintReceipt = await mintTx.wait()

    console.log("balance: ", await testToken.balanceOf("0xD572273BD83B9A6D92F48c7dA548DB5D3ce3A175"))

    const MToken = await ethers.getContractFactory("MToken");
    const mtoken = await MToken.deploy();
    await mtoken.deployed();

    const Pool = await ethers.getContractFactory("Pool");
    const pool = await Pool.deploy(testToken.address,mtoken.address)
    await pool.deployed();


    const approveTx = await testToken.approve(pool.address,100000000000000)
    const approveReceipt = await approveTx.wait()
    console.log("approve receipt status: ",approveReceipt.status)

    const depositTx = await pool.deposit(100000000000000, 100)
    const depositTeceipt = await depositTx.wait()
    console.log("deposit receipt status: ",depositTeceipt.status)

    console.log(await mtoken.ownerOf(0))


  });
});
