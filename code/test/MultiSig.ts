import { expect } from "chai";
import hre from "hardhat";
import { SignerWithAddress } from "@nomicfoundation/hardhat-ethers/signers";
import { MultiSig, Community42 } from "../../types/ethers-contracts";

const { ethers } = await hre.network.connect();

describe("MultiSig Contract", function () {
    let multiSig: MultiSig;
    let token: Community42;
    let owner1: SignerWithAddress;
    let owner2: SignerWithAddress;
    let owner3: SignerWithAddress;
    let addr4: SignerWithAddress;
    let contractOwners: string[];

    beforeEach(async function () {
        [owner1, owner2, owner3, addr4] = await ethers.getSigners();

        const TokenFactory = await ethers.getContractFactory("Community42");
        token = await TokenFactory.deploy();

        const MultiSigFactory = await ethers.getContractFactory("MultiSig");
        multiSig = await MultiSigFactory.deploy([owner1.address, owner2.address, owner3.address], 2);

        const multisigAddress = await multiSig.getAddress();
        await token.transferOwnership(multisigAddress)

        contractOwners = await multiSig.owners();
    });

    it("Should have the correct owners and required confirmations", async function () {
        expect(contractOwners[0]).to.equal(owner1.address);
        expect(contractOwners[1]).to.equal(owner2.address);

        expect(await multiSig.requiredSignatures()).to.equal(2);
    });

    describe("submitTransaction", async function() {
        let tokenAddr: any;

        beforeEach(async function() {
            tokenAddr = await token.getAddress();
        });

        it("Should revert if the sender is not an owner", async function() {
            await expect(multiSig.connect(addr4).submitTransaction("mint(address,uint256)", tokenAddr, addr4, 10n))
            .to.be.revertedWithCustomError(multiSig, "NotAnOwner");
        });

        it("Should emit TransactionProposed if sender is an owner", async function() {
            await expect(multiSig.connect(owner1).submitTransaction("mint(address,uint256)", tokenAddr, addr4, 10n))
            .to.emit(multiSig, "TransactionProposed")
            .withArgs(0n, owner1);
        });

        describe("signTransaction", async function() {
            beforeEach(async function() {
                await multiSig.connect(owner1).submitTransaction("mint(address,uint256)", tokenAddr, addr4, 10n);
            });

            it("Should revert if the sender is not an owner", async function() {
                await expect(multiSig.connect(addr4).signTransaction(0n))
                .to.be.revertedWithCustomError(multiSig, "NotAnOwner");
            });

            it("Should revert if the sender has already signed", async function() {
                await expect(multiSig.connect(owner1).signTransaction(0n))
                .to.be.revertedWithCustomError(multiSig, "OwnerAlreadySigned");          
            });

            it("Should executeTransaction if the sender is an other owner and second required signature", async function() {
                const previousTotalSupply = await token.totalSupply();
                const previousBalanceAddr4 = await token.balanceOf(addr4);

                await expect(multiSig.connect(owner2).signTransaction(0n))
                .to.emit(multiSig, "TransactionExecuted");  

                const currentTotalSupply = await token.totalSupply();
                const currentBalanceAddr4 = await token.balanceOf(addr4);

                expect(currentTotalSupply).to.equals(previousTotalSupply + 10n);
                expect(currentBalanceAddr4).to.equals(previousBalanceAddr4 + 10n);
            });

            describe("When transaction is executed", async function() {
                beforeEach(async function() {
                    await expect(multiSig.connect(owner2).signTransaction(0n));
                });
                
                it("Should revert if the owner tries to sign transaction already executed", async function() {
                    await expect(multiSig.connect(owner3).signTransaction(0n))
                    .to.be.revertedWithCustomError(multiSig, "TransactionAlreadyExecuted")
                    .withArgs(0n);          
                });
            });
        });
    });
});