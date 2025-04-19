// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

contract DocumentHasher {

    address public contractOwner;

    constructor() {
        contractOwner = msg.sender;
    }

    struct Document {
        string owner;
        bytes32 documentHash;
        bool exists;
    }

    mapping(string => Document) private documentHashes;

    event DocumentHashCreated(string documentId, bytes32 documentHash);
    event DocumentHashUpdated(string documentId, bytes32 documentHash);
    event DocumentOwnerUpdated(string documentId, string owner);

    error DocumentAlreadyExist();
    error DocumentDoesNotExist();
    error NotDocumentOwner();

    function hashDocumentWithId(
        string memory _documentId,
        string memory _owner,
        string memory concatenatedString
    ) public returns(bytes32 documentHash_) {

        if(documentHashes[_documentId].exists) revert DocumentAlreadyExist();

        bytes32 hash = keccak256(abi.encodePacked(concatenatedString));

        Document memory document = Document({owner: _owner, documentHash: hash, exists: true});

        documentHashes[_documentId] = document;

        emit DocumentHashCreated(_documentId, hash);

        return hash;
    }

    function geDocumentOwner(
        string memory _documentId
    ) view public returns(string memory owner_) {
        if(!documentHashes[_documentId].exists) revert DocumentDoesNotExist();

        Document storage document = documentHashes[_documentId];

        return document.owner;
    }

    function updateDocumentHash(
        string memory _documentId,
        string memory _owner,
        string memory concatenatedString
    ) public returns(bytes32 documentHash_) {

        if(!documentHashes[_documentId].exists) revert DocumentDoesNotExist();

        Document storage document = documentHashes[_documentId];

        if(keccak256(abi.encodePacked(document.owner)) != keccak256(abi.encodePacked(_owner))) revert NotDocumentOwner();

        bytes32 hash = keccak256(abi.encodePacked(concatenatedString));

        document.documentHash = hash;

        emit DocumentHashUpdated(_documentId, hash);

        return hash;
    }

    function changeDocumentOwner(
        string memory _documentId,
        string memory _owner,
        string memory newOwner
    ) public {

        if(!documentHashes[_documentId].exists) revert DocumentDoesNotExist();

        Document storage document = documentHashes[_documentId];

        if(keccak256(abi.encodePacked(document.owner)) != keccak256(abi.encodePacked(_owner))) revert NotDocumentOwner();

        document.owner = newOwner;

        emit DocumentOwnerUpdated(_documentId, newOwner);
    }

    function getDocumentHash(
        string memory _documentId,
        string memory _owner
    ) view public returns(bytes32 document_) {

        if(!documentHashes[_documentId].exists) revert DocumentDoesNotExist();

        Document storage document = documentHashes[_documentId];

        if(keccak256(abi.encodePacked(document.owner)) != keccak256(abi.encodePacked(_owner))) revert NotDocumentOwner();

        return document.documentHash;
    }

    function verifyDocumentHash(
       string memory _documentId, 
       string memory concatenatedString
    ) view public returns(bool) {

        if(!documentHashes[_documentId].exists) revert DocumentDoesNotExist();

        Document storage document = documentHashes[_documentId];

        if(document.documentHash != keccak256(abi.encodePacked(concatenatedString))) return false;

        return true;
    }

    function verifyDocumentInputHash(
        string memory _documentId,
        bytes32 inputDocumentHash
    ) view public returns(bool) {

        if(!documentHashes[_documentId].exists) revert DocumentDoesNotExist();

        Document storage document = documentHashes[_documentId];

        if(document.documentHash != inputDocumentHash) return false;

        return true;
    }

}