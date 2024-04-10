const { ethers, upgrades } = require('hardhat');

async function main() {
    const Box = await ethers.getContractFactory("Box");
    console.log('deploying box...');
    const BoxDeployed = await upgrades.deployProxy(Box, [42], { initializer: 'store' });

    console.log(BoxDeployed);
    const boxAddress = await BoxDeployed.getAddress();
    console.log('Box proxy deployed to:', boxAddress);

    // Additional wait if needed
    await BoxDeployed.waitForDeployment();

    // Use 'box.address' instead of 'Box.address' in the following lines
    console.log(await upgrades.erc1967.getImplementationAddress(boxAddress), "box implementation address");
    console.log(await upgrades.erc1967.getAdminAddress(boxAddress), "admin address");
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
