/* solhint-disable no-inline-assembly */
pragma solidity 0.5.0;


/**
 * @title A simple example to illustrate meta-transactions
 * @dev This contract is the base of our project
 */
contract MetaDapp {
    uint256 private storedNumber;

    mapping (address => uint256) private nonces;

    /**
     * @dev Sets the number
     * @param newNumber The new number to store
     */
    function setNumber(uint256 newNumber) external {
        storedNumber = newNumber;
    }

    function metaSetNumber(bytes calldata signature, uint256 newNumber, uint256 nonce) external returns (bool) {
        bytes32 metaSetNumberHash = createMetaSetNumberHash(newNumber, nonce);

        address signer = getSigner(metaSetNumberHash, signature);

        require(signer != address(0));

        storedNumber = newNumber;
    }

    /**
     * @dev Gets the stored number
     * @return The number as an uint
     */
    function getNumber() external view returns (uint256) {
        return storedNumber;
    }

    function createMetaSetNumberHash(
        uint256 newNumber,
        uint256 nonce
    ) public view returns (bytes32) {
        return keccak256(abi.encodePacked(address(this), "metaSetNumber", newNumber, nonce));
    }

    function getSigner(bytes32 _hash, bytes memory _signature) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;

        if (_signature.length != 65) {
            return address(0);
        }

        assembly {
            r := mload(add(_signature, 32))
            s := mload(add(_signature, 64))
            v := byte(0, mload(add(_signature, 96)))
        }

        if (v < 27) {
            v += 27;
        }

        if (v != 27 && v != 28) {
            return address(0);
        } else {
            return ecrecover(keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", _hash)
            ), v, r, s);
        }
    }
}
