const { ethers } = require('hardhat');

let num = 0;
const MAX_NUM = 50;

async function main() {
    try {
        const RandomContractFactory = await ethers.getContractFactory('RandomNumberGenerator');
        const RandomContract = await RandomContractFactory.attach("0x76dC54A262E1103733171857766c6d320d2A418c");
        const tx = await RandomContract.generateRandomNumber();
        console.log(tx);
        await tx.wait(5);
        console.log(await RandomContract.getRandomNumbers());
        console.log('increementing num by + 1')
        num += 1;
        setTimeout(() => {
            console.log(`waited for 3 sec after success`);
            recursionCall();
        }, 3000);
    } catch (error) {
        console.log('reverted..........................');
        console.log(error);
        setTimeout(() => {
            console.log(`waited for 3 sec after revert`);
            recursionCall();
        }, 3000);
        return; // Exit the function after setting the timeout
    }
}

function recursionCall() {
    // Call main() recursively if num is less than or equal to MAX_NUM
    if (num <= MAX_NUM) {
        main();
    } else {
        process.exit(1);
    }
}

main();
