const hre = require("hardhat");

async function main() {
    const Community42 = await hre.ethers.getContractFactory("Community42");

    const token = await Community42.deploy();

    await token.waitForDeployment();

    console.log("Community42 deployed to:", token.target);

    fs.writeFileSync("TOKEN_ADDR=", JSON.stringify(token.target))
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });