const { ethers, upgrades } = require('hardhat');

async function main() {
    const RandomContractFactory = await ethers.getContractFactory("RandomNumberGenerator");
    console.log('deploying RandomContractFactory...');
    const RandomContract = await RandomContractFactory.deploy();
    console.log("RandomContractFactory deployed to: ", await RandomContract.getAddress());
    // Additional wait if needed
    await RandomContract.waitForDeployment();
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
