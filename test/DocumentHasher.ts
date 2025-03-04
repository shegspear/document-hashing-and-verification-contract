import {
  time,
  loadFixture,
} from "@nomicfoundation/hardhat-toolbox/network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import hre from "hardhat";

describe("DocumentHasher", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshot in every test.
  async function deployDocumentHasher() {
    const [owner] = await hre.ethers.getSigners();

    const documentHasherFactory = await hre.ethers.getContractFactory("DocumentHasher");

    const documentHasher = await documentHasherFactory.deploy();

    return{documentHasher, owner};
  }

  describe("Deployment", function() {
    it("Should have correct owner", async function() {
      const {documentHasher, owner} = await loadFixture(deployDocumentHasher);

      expect(await documentHasher.contractOwner()).to.equal(owner);
    })
  })

  describe("test hash document with id function", function() {
    it("should add a new document to document hashes mapping", async function() {
      const {documentHasher} = await loadFixture(deployDocumentHasher);

      await documentHasher.hashDocumentWithId("A1", "1", "file");

      expect(await documentHasher.getDocumentHash("A1", "1")).to.exist;
    })
  })

  describe("test update document hash function", function() {
    it("should update document hash", async function() {
      const {documentHasher} = await loadFixture(deployDocumentHasher);

      await documentHasher.hashDocumentWithId("A1", "1", "file");

      const hash1 = await documentHasher.getDocumentHash("A1", "1");

      const hash2 = await documentHasher.updateDocumentHash("A1", "1", "File");

      expect(hash1).to.be.not.equal(hash2);
    })
  })

  describe("test change document owner", function() {
    it("should successfully change document owner", async function() {
      const {documentHasher} = await loadFixture(deployDocumentHasher);

      await documentHasher.hashDocumentWithId("A1", "1", "file");

      await documentHasher.changeDocumentOwner("A1", "1", "2");

      await expect(documentHasher.getDocumentHash("A1", "1")).revertedWithCustomError(documentHasher, 'NotDocumentOwner()');
    })
  })

  describe("test get document hash function", function() {
    it("should return a hash", async function() {
      const {documentHasher} = await loadFixture(deployDocumentHasher);

      await documentHasher.hashDocumentWithId("A1", "1", "file");

      await expect(documentHasher.getDocumentHash("A1", "1")).to.exist;
    })
  })

  describe("test verify document hash function", function() {
    it("should return true for validating a plain text", async function() {
      const {documentHasher} = await loadFixture(deployDocumentHasher);

      await documentHasher.hashDocumentWithId("A1", "1", "file");

      expect(await documentHasher.verifyDocumentHash("A1", "file")).to.be.true;
    })
  })

  describe("test verify document input hash", function() {
    it("should retunr true for validating an input document hash", async function() {
      const {documentHasher} = await loadFixture(deployDocumentHasher);

      await documentHasher.hashDocumentWithId("A1", "1", "file");

      const hash = await documentHasher.getDocumentHash("A1", "1");

      expect(await documentHasher.verifyDocumentInputHash("A1", hash)).to.be.true;
    })
  })

});
