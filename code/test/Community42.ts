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
    
    // Signup
    it("Should allow a user to signup and receive 5 tokens", async function () {
        await token.connect(addr1).signup();
        const balance = await token.balanceOf(addr1.address);
        expect(balance).to.equal(5n);
    });

    it("Should revert if a user tries to signup twice", async function () {
        await token.connect(addr1).signup();
        await expect(token.connect(addr1).signup()).to.be.revertedWithCustomError(token, "AlreadySignedUp");
    });

    // Transfer
    it("Should transfer and receive tokens", async function () {
        await token.connect(addr1).signup();

        const previousBalanceAddr1 = await token.balanceOf(addr1);
        const previousBalanceAddr2 = await token.balanceOf(addr2);

        await expect(token.connect(addr1).transfer(addr2, 1n))
        .to.emit(token, "Transfer")
        .withArgs(addr1, addr2, 1n);
;
        const currentBalanceAddr1 = await token.balanceOf(addr1);
        const currentBalanceAddr2 = await token.balanceOf(addr2);

        expect(currentBalanceAddr1).to.equal(previousBalanceAddr1 - 1n);
        expect(currentBalanceAddr2).to.equal(previousBalanceAddr2 + 1n);
    })

    it("Should revert if a user tries to transfer with insuffisant token", async function () {
        const previousBalanceAddr1 = await token.balanceOf(addr1);
        const previousBalanceAddr2 = await token.balanceOf(addr2);

        await expect(token.connect(addr1).transfer(addr2, 1n)).to.be.revertedWithCustomError(token, "ERC20InsufficientBalance");
    });

    // Mint
    it("Should mint and update total supply with owner addr", async function () {
        await token.connect(owner).mint(addr1, 20);

        expect(await token.balanceOf(addr1)).to.equal(20);
        expect(await token.totalSupply()).to.equal(20);
    });

    it("Should revert if a not owner tries to mint", async function () {
        await expect(token.connect(addr1).mint(addr1, 20)).to.revert(ethers);
    });

    // Create event
    it("Should revert if a user tries to create even with 0 participant", async function () {
        await expect(token.connect(addr1).createEvent(ethers.encodeBytes32String("test"), 0n, 0n)).to.be.revertedWithCustomError(token, "InvalidMaxParticipants");
    });

    it("Should return true if user create event", async function () {
        expect(await token.connect(addr1).createEvent.staticCall(ethers.encodeBytes32String("test"), 2n, 5n)).to.equal(true);
    });

    it("Should revert if a user tries to create even with the same event key of an other event", async function () {
        await token.connect(addr1).createEvent(ethers.encodeBytes32String("test"), 2n, 5n);

        await expect(token.connect(addr1).createEvent(ethers.encodeBytes32String("test"), 2n, 4n)).to.be.revertedWithCustomError(token, "EventAlreadyExists");
    });

    // Participate in event
    it("Should revert if tries to participate of unknow event", async function () {
        await expect(token.connect(addr1).participateInEvent(ethers.encodeBytes32String("test"))).to.be.revertedWithCustomError(token, "EventDoesNotExist");
    });

    it("Should transfer token if a user participate in event", async function () {
        await token.connect(addr2).signup();
        await token.connect(addr1).createEvent(ethers.encodeBytes32String("test"), 1n, 3n);

        await expect(token.connect(addr2).participateInEvent(ethers.encodeBytes32String("test")))
        .to.emit(token, "Transfer")
        .withArgs(addr2, addr1, 3n);

        expect(await token.balanceOf(addr1)).to.equal(3n);
        expect(await token.balanceOf(addr2)).to.equal(2n);
    });

    it("Should revert if tries to participate of already full event", async function () {
        await token.connect(addr2).signup();
        await token.connect(addr1).createEvent(ethers.encodeBytes32String("test"), 1n, 1n);

        await token.connect(addr2).participateInEvent(ethers.encodeBytes32String("test"))
        await expect(token.connect(addr2).participateInEvent(ethers.encodeBytes32String("test"))).to.be.revertedWithCustomError(token, "EventFull");
    });

    it("Should revert if tries to participate wihtout enough balance", async function () {
        await token.connect(addr1).createEvent(ethers.encodeBytes32String("test"), 2n, 5n);

        await expect(token.connect(addr2).participateInEvent(ethers.encodeBytes32String("test"))).to.be.revertedWithCustomError(token, "InsufficientBalance");
    });
});