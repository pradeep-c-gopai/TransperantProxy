const { ethers, upgrades } = require('hardhat');

const proxyBox = "0x6D4af017718fd5e07258F38149c16a2EAEb29DFB";

async function main() {
    console.log("Original Box proxy", proxyBox);
    const BoxV2 = await ethers.getContractFactory("MsgSenderContract");
    console.log("Upgrading to MsgSenderContract...");
    const boxV3 = await upgrades.upgradeProxy(proxyBox, BoxV2);
    boxV3.waitForDeployment();
    const boxV3Address = await boxV3.getAddress();
    console.log("MsgSenderContract Proxy address (will be same as box address): ", boxV3Address);
    console.log("Implementation address: ", await upgrades.erc1967.getImplementationAddress(boxV3Address));
    console.log("proxy admin address: ", await upgrades.erc1967.getAdminAddress(boxV3Address));
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
})