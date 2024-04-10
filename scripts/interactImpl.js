const { ethers, upgrades } = require('hardhat');

async function main(){
    const Box = await ethers.getContractFactory("BoxV3");
    // console.log('Deploying box...');
    // const box = await upgrades.deployProxy(Box, [42], { initializer: 'store' });
    // console.log('Box proxy deployed to:', await box.getAddress());
    // console.log(await upgrades.erc1967.getImplementationAddress(await box.getAddress()), "box implementation address");
    // console.log(await upgrades.erc1967.getAdminAddress(await box.getAddress()), "admin address");

    const BoxInstance = Box.attach("0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512");

    const tx = await BoxInstance.increement.send();

    await tx.wait(5);

    // Call the retrieve function on the implementation contract via the proxy
    const retrievedValue = await BoxInstance.retrieve();
    console.log('Impl: ', await upgrades.erc1967.getImplementationAddress(await BoxInstance.getAddress()));
    console.log('Retrieved value:', retrievedValue.toString());

    // If you want to call other functions on the implementation contract, you can do so using the proxy
    // For example, assuming you have a function called `increment` in the implementation contract:
    // await box.increment();
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
