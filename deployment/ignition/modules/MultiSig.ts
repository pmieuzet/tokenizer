import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

module.exports = buildModule("MultiSigModule", (m: any) => {
    const owner1 = m.getAccount(0);
    const owner2 = m.getAccount(1);
    
    const multiSig = m.contract("MultiSig", [[owner1, owner2], 2]);

    return { multiSig };
});