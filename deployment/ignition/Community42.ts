const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("Community42Module", (m: any) => {
    const community42 = m.contract("Community42");

    return { community42 };
});