const hre = require("hardhat");
require('dotenv').config();

async function main() {
    const TOKEN_ADDR = process.env.TOKEN_ADDR;

    const [owner1, owner2] = await hre.ethers.getSigners();
    const MultiSig = await hre.ethers.getContractFactory("MultiSig");

    const multisig = await MultiSig.deploy([owner1.address, owner2.address], 2);
    await multisig.waitForDeployment();
    const multisigAddress = await multisig.getAddress();

    const token = await hre.ethers.getContractAt("Community42", TOKEN_ADDRESS);

    const tx = await token.transferOwnership(multisigAddress);
    await tx.wait();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });