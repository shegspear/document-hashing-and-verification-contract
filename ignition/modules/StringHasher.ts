import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const StringHasherModule = buildModule("StringHasherModule", (m) => {
    const stringHasher = m.contract("StringHasher");

    return {stringHasher};
})

export default StringHasherModule;

// contract address on lisk sepolia network : 0x1312b18b23Be3f51a7ae048e374Fc5BDf229eFA6