import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DocumentHasherModule = buildModule("DocumentHasherModule", (m) => {
    const documentHasher = m.contract("DocumentHasher");

    return {documentHasher};
})

export default DocumentHasherModule;

// 0x47E3d6b491881D9a2dd5a706b0B2f8Dc0FdFBE4f
// 0x49dBd468c0219315750E75Fc8Dc319F27b4cB6aB