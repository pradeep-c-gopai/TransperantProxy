const { ethers, upgrades } = require('hardhat');

async function main(){
    const Box = await ethers.getContractFactory("MsgSenderContract");
    // console.log('Deploying box...');
    // const box = await upgrades.deployProxy(Box, [42], { initializer: 'store' });
    // console.log('Box proxy deployed to:', await box.getAddress());
    // console.log(await upgrades.erc1967.getImplementationAddress(await box.getAddress()), "box implementation address");
    // console.log(await upgrades.erc1967.getAdminAddress(await box.getAddress()), "admin address");

    const BoxInstance = Box.attach("0x6D4af017718fd5e07258F38149c16a2EAEb29DFB");

    // const tx = await BoxInstance.increement.send(10);

    // await tx.wait(5);

    // Call the retrieve function on the implementation contract via the proxy
    const [msgSender, txOrigin] = await BoxInstance.retrieveMsgSender();
    console.log('Impl: ', await upgrades.erc1967.getImplementationAddress(await BoxInstance.getAddress()));
    console.log('Retrieved value: ', msgSender, txOrigin);

    // If you want to call other functions on the implementation contract, you can do so using the proxy
    // For example, assuming you have a function called `increment` in the implementation contract:
    // await box.increment();
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
