import { expect } from "chai";
import hre from "hardhat";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";
import { Community42 } from "../../types/ethers-contracts";

const { ethers } = await hre.network.connect();

describe("Community42 Contract", function () {
    let token: Community42;
    let owner: SignerWithAddress;
    let addr1: SignerWithAddress;
    let addr2: SignerWithAddress;
    let addr3: SignerWithAddress;
    beforeEach(async function () {
        [owner, addr1, addr2, addr3] = await ethers.getSigners();

        const Community42Factory = await ethers.getContractFactory("Community42");
        token = await Community42Factory.deploy();
    });


    it("Should have the correct name and symbol", async function () {
        expect(await token.name()).to.equal("Community42");
        expect(await token.symbol()).to.equal("COMM42");
    });

    describe("Signup", async function () {
        beforeEach(async function () {
            await token.connect(addr1).signup();
        });

        it("Should allow a user to signup and receive 5 tokens", async function () {
            const balance = await token.balanceOf(addr1.address);
            expect(balance).to.equal(5n);
        });

        it("Should revert if a user tries to signup twice", async function () {
            await expect(token.connect(addr1).signup()).to.be.revertedWithCustomError(token, "AlreadySignedUp");
        });
    });

    describe("Transfer", async function () {
        beforeEach(async function () {
            await token.connect(addr1).signup();
        });

        it("Should transfer tokens between users", async function () {
            await expect(token.connect(addr1).transfer(addr2.address, 2n))
                .to.emit(token, "Transfer")
                .withArgs(addr1.address, addr2.address, 2n);

            const balanceAddr1 = await token.balanceOf(addr1.address);
            const balanceAddr2 = await token.balanceOf(addr2.address);
            expect(balanceAddr1).to.equal(3n);
            expect(balanceAddr2).to.equal(2n);
        });

        it("Should revert if a user tries to transfer more tokens than they have", async function () {
            await expect(token.connect(addr1).transfer(addr2.address, 10n)).to.be.revertedWithCustomError(token, "ERC20InsufficientBalance");
        });
    });

    describe("Approve and TransferFrom", async function () {
        beforeEach(async function () {
            await token.connect(addr1).signup();
        });

        it("Should approve and transfer tokens on behalf of another user", async function () {
            await token.connect(addr1).approve(addr2.address, 3n);
            await expect(token.connect(addr2).transferFrom(addr1.address, addr2.address, 2n))
                .to.emit(token, "Transfer")
                .withArgs(addr1.address, addr2.address, 2n);

            const balanceAddr1 = await token.balanceOf(addr1.address);
            const balanceAddr2 = await token.balanceOf(addr2.address);
            expect(balanceAddr1).to.equal(3n);
            expect(balanceAddr2).to.equal(2n);
        });

        it("Should revert if a user tries to transfer more tokens than they are approved for", async function () {
            await token.connect(addr1).approve(addr2.address, 2n);
            await expect(token.connect(addr2).transferFrom(addr1.address, addr2.address, 3n)).to.be.revertedWithCustomError(token, "ERC20InsufficientAllowance");
        });
    });

    describe("Mint", async function () {
        beforeEach(async function () {
            await token.connect(addr1).signup();
        });

        it("Should mint and update total supply with owner addr", async function () {
            await token.connect(owner).mint(addr1.address, 20n);

            expect(await token.balanceOf(addr1.address)).to.equal(25n);
            expect(await token.totalSupply()).to.equal(25n);
        });

        it("Should revert if a not owner tries to mint", async function () {
            await expect(token.connect(addr1).mint(addr1.address, 20n)).to.revert(ethers);
        });
    });

    describe("Create Event", async function () {
        beforeEach(async function () {
            await token.connect(addr1).signup();
            await token.connect(addr2).signup();
        });

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

    });

    describe("Participate in Event", async function () {
        beforeEach(async function () {
            await token.connect(addr1).signup();
            await token.connect(addr2).signup();

            await token.connect(addr1).createEvent(ethers.encodeBytes32String("test"), 2n, 1n);
        });


        it("Should revert if tries to participate of unknow event", async function () {
            await expect(token.connect(addr1).participateInEvent(ethers.encodeBytes32String("other"))).to.be.revertedWithCustomError(token, "EventDoesNotExist");
        });

        it("Should transfer token if a user participate in event", async function () {
            await expect(token.connect(addr2).participateInEvent(ethers.encodeBytes32String("test")))
                .to.emit(token, "Transfer")
                .withArgs(addr2, addr1, 1n);

            expect(await token.balanceOf(addr1)).to.equal(6n);
            expect(await token.balanceOf(addr2)).to.equal(4n);
        });

        it("Should revert if tries to participate of already full event", async function () {
            await token.connect(addr2).participateInEvent(ethers.encodeBytes32String("test"));
            await token.connect(addr2).participateInEvent(ethers.encodeBytes32String("test"));
            await expect(token.connect(addr2).participateInEvent(ethers.encodeBytes32String("test"))).to.be.revertedWithCustomError(token, "EventFull");
        });

        it("Should revert if tries to participate wihtout enough balance", async function () {
            await expect(token.connect(addr3).participateInEvent(ethers.encodeBytes32String("test"))).to.be.revertedWithCustomError(token, "InsufficientBalance");
        });
    });
});