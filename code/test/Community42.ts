import { expect } from "chai";
import hre from "hardhat";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";


describe("Community42 Contract", function () {
    let ethers;
    let token: any;
    let owner: SignerWithAddress;
    let addr1: SignerWithAddress;
    let addr2: SignerWithAddress;

    beforeEach(async function () {
        ({ ethers } = await hre.network.connect());

        [owner, addr1, addr2] = await ethers.getSigners();

        const Community42Factory = await ethers.getContractFactory("Community42");
        token = await Community42Factory.deploy();
    });
    
    it("Should have the correct name and symbol", async function () {
        expect(await token.name()).to.equal("Community42");
        expect(await token.symbol()).to.equal("COMM42");
    });
    
    it("Should allow a user to signup and receive 5 tokens", async function () {
        await token.connect(addr1).signup();
        const balance = await token.balanceOf(addr1.address);
        expect(balance).to.equal(5n);
    });

    it("Should transfer and receive tokens", async function () {
        await token.connect(addr1).transfer()
    })

    // transfer an addr

    // mint without owner -> revert error

    // mint with owner -> mint and transfer at an addr

    // it("Should revert if a user tries to signup twice", async function () {
    //   await token.connect(addr1).signup();
    //   await expect(token.connect(addr1).signup())
    //     .to.be.revertedWithCustomError(token, "AlreadySignedUp");
    // });

});