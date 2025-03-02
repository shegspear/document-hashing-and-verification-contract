// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract StringHasher {

    struct User {
        string id;
        bytes32 documentHash;
        bool exists;
    }

    // Mapping to store hashed data
    mapping(bytes32 => bool) private hashes;

    mapping(string => User) private userHashes;

    event UserHashAdded(string userId, bytes32 hash);
    event UserHashUpdated(string userId, bytes32 hash);

    error UserAlreadyExist();
    error UserDoesNotExist();

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