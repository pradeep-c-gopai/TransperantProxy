const { ethers, upgrades } = require('hardhat');

const proxyBox = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

async function main() {
    console.log("Original Box proxy", proxyBox);
    const BoxV2 = await ethers.getContractFactory("BoxV3");
    console.log("Upgrading to BoxV3...");
    const boxV3 = await upgrades.upgradeProxy(proxyBox, BoxV2);
    boxV3.waitForDeployment();
    const boxV3Address = await boxV3.getAddress();
    console.log("boxV3 address (will be same as box address): ", boxV3Address);
    console.log("Implementation address: ", await upgrades.erc1967.getImplementationAddress(boxV3Address));
    console.log("proxy admin address: ", await upgrades.erc1967.getAdminAddress(boxV3Address));
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
})