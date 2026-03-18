import { expect } from "chai";
import hre from "hardhat";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";

describe("MultiSig Contract", function () {
    let ethers: any;
    let multiSig: any;
    let contractOwners: SignerWithAddress[];

    beforeEach(async function () {
        ({ ethers } = await hre.network.connect());

        const MultiSigFactory = await ethers.getContractFactory("MultiSig");
        multiSig = await MultiSigFactory.deploy([contractOwners[0], contractOwners[1]], 2);

        const contractOwners = await multiSig.owners();

    });

    it("Should have the correct owners and required confirmations", async function () {
        expect(await multiSig.owners(0)).to.equal(owner.address);
        expect(await multiSig.owners(1)).to.equal(addr1.address);
        expect(await multiSig.requiredSignatures()).to.equal(2);
    });
});