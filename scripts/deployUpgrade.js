const { ethers, upgrades } = require('hardhat');

const proxyBox = "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

async function main() {
    console.log("Original Box proxy", proxyBox);
    const BoxV2 = await ethers.getContractFactory("BoxV2");
    console.log("Upgrading to BoxV2...");
    const boxV2 = await upgrades.upgradeProxy(proxyBox, BoxV2);
    boxV2.waitForDeployment();
    const boxV2Address = await boxV2.getAddress();
    console.log("boxV2 address (will be same as box address): ", boxV2Address);
    console.log("Implementation address: ", await upgrades.erc1967.getImplementationAddress(boxV2Address));
    console.log("proxy admin address: ", await upgrades.erc1967.getAdminAddress(boxV2Address));
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
})