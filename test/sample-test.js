const { expect } = require("chai");
const { ethers } = require("hardhat");


function sleep(ms) {
  return new Promise(resolve => setTimeout(resolve, ms));
}

describe("Greeter", async function () {
  it("Should return the new greeting once it's changed", async function () {
    // const Greeter = await ethers.getContractFactory("Greeter");
    // const greeter = await Greeter.deploy("Hello, world!");

    // await greeter.deployed();
    // expect(await greeter.greet()).to.equal("Hello, world!");

    // await greeter.setGreeting("Hola, mundo!");
    // expect(await greeter.greet()).to.equal("Hola, mundo!");

    const signer = await ethers.getSigner();
    const user = await signer.getAddress();

    const TestToken = await ethers.getContractFactory("TestToken");
    const testToken = await TestToken.deploy();
    await testToken.deployed();
    const mintTx = await testToken.mint(user, 100000000000000);
    const mintReceipt = await mintTx.wait();

    console.log("balance: ", await testToken.balanceOf(user));

    const MToken = await ethers.getContractFactory("MToken");
    const mtoken = await MToken.deploy();
    await mtoken.deployed();

    const Pool = await ethers.getContractFactory("Pool");
    const pool = await Pool.deploy(testToken.address, mtoken.address);
    await pool.deployed();

    const approveTx = await testToken.approve(pool.address, 100000000000000);
    const approveReceipt = await approveTx.wait();
    console.log("approve receipt status: ", approveReceipt.status);

    const depositTx = await pool.deposit(100000000000000, 10);
    const depositTeceipt = await depositTx.wait();
    console.log("deposit receipt status: ", depositTeceipt.status);

    const withdrawApproveTx = await mtoken.approve(pool.address, 0);
    const withdrawApproveReceipt = await withdrawApproveTx.wait()
    console.log("withdrawApproveStatus: ",withdrawApproveReceipt.status)

    await sleep(10000)

    const withdrawTx = await pool.withdraw(0);
    const withdrawReceipt = await withdrawTx.wait();
    console.log("withdraw status: ", withdrawReceipt.status);

    console.log(await pool.totalAsset());
  });
});
