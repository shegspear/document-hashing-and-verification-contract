// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StringHasher {

    struct User {
        string id;
        bytes32 documentHash;
        bool exists;
    }

    struct Document {
        string owner;
        bytes32 documentHash;
        bool exists;
    }

    // Mapping to store hashed data
    mapping(bytes32 => bool) private hashes;

    mapping(string => User) private userHashes;

    mapping(string => Document) private documentHashes;

    event UserHashAdded(string userId, bytes32 hash);
    event UserHashUpdated(string userId, bytes32 hash);

    event DocumentHashCreated(string documentId, bytes32 documentHash);
    event DocumentHashUpdated(string documentId, bytes32 documentHash);
    event DocumentOwnerUpdated(string documentId, string owner);

    error UserAlreadyExist();
    error UserDoesNotExist();

    error DocumentAlreadyExist();
    error DocumentDoesNotExist();
    error NotDocumentOwner();

    /**
     * @dev Hashes a concatenated string and stores it on the blockchain.
     * @param concatenatedString The concatenated string to hash and store.
     */
    function hashAndStore(string memory concatenatedString) public returns(bytes32) {
        // Hash the concatenated string
        bytes32 hash = keccak256(abi.encodePacked(concatenatedString));

        // Store the hash in the mapping
        hashes[hash] = true;

        return hash;
    }

    /**
     * @dev Validates if a given string exists in the hashed data.
     * @param inputString The string to validate.
     * @return bool True if the string exists, false otherwise.
    */
    function validateString(string memory inputString) public view returns (bool) {
        // Hash the input string
        bytes32 hash = keccak256(abi.encodePacked(inputString));

        // Check if the hash exists in the mapping
        return hashes[hash];
    }

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
        string memory _owner
    ) public {

        if(!documentHashes[_documentId].exists) revert DocumentDoesNotExist();

        Document storage document = documentHashes[_documentId];

        if(keccak256(abi.encodePacked(document.owner)) != keccak256(abi.encodePacked(_owner))) revert NotDocumentOwner();

        document.owner = _owner;

        emit DocumentOwnerUpdated(_documentId, _owner);
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

    function hashAndStoreWithId(
        string memory _id, 
        string memory concatenatedString
    ) public returns(bytes32) {

        if(userHashes[_id].exists) revert UserAlreadyExist();

        bytes32 hash = keccak256(abi.encodePacked(concatenatedString));

        User memory user = User({id: _id, documentHash: hash, exists: true}); 
    
        userHashes[_id] = user;

        emit UserHashAdded(_id, hash);

        return hash;
    }

    function updateUserHash(
       string memory _id, 
       string memory concatenatedString 
    ) public returns(bytes32 userHash) {

        if(!userHashes[_id].exists) revert UserDoesNotExist();

        bytes32 hash = keccak256(abi.encodePacked(concatenatedString));

        userHashes[_id].documentHash = hash;

        emit UserHashUpdated(_id, hash);

        return hash;
    }

    function getUserHash(
        string memory _id
    ) view public returns(bytes32 userHash) {
        User storage user = userHashes[_id];

        if(!user.exists) revert UserDoesNotExist();

        return user.documentHash;
    } 

    function verifyUserHash(
       string memory _id, 
       string memory concatenatedString
    ) view public returns(bool) {
        User storage user = userHashes[_id];

        if(!user.exists) revert UserDoesNotExist();

        bytes32 hash = keccak256(abi.encodePacked(concatenatedString));

        return user.documentHash == hash;
    }
    
    function verifyUserInputHash(
        string memory _id, 
       bytes32 inputHash
    ) view public returns(bool) {
        User storage user = userHashes[_id];

        if(!user.exists) revert UserDoesNotExist();

        return user.documentHash == inputHash;
    }

}