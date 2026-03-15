// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {MultiSigErrors} from "../interfaces/MultiSigErrors.sol";

contract MultiSig is MultiSigErrors {
    /**
     * @dev An array that holds the addresses of the owners of the contract. These are the individuals who have the authority to propose and approve transactions.
     */
    address[] private _owners;

    /**
     * @dev A mapping that tracks whether a specific address is an owner of the contract. The key is the address of the owner, and the value is a boolean that indicates whether the address is an owner (true) or not (false). This mapping is used to manage access control for the contract, allowing only designated owners to propose and approve transactions.
     */
    mapping(address => bool) private _isOwner;

    /**
     * @dev The number of signatures required to execute a transaction.
     */
    uint256 private _requiredSignatures = 2;

    /**
     * @dev A counter to keep track of the number of transactions that have been proposed. This counter is incremented each time a new transaction is proposed, and it is used to assign a unique ID to each transaction.
     */
    uint256 private _transactionCount = 0;

    /**
     * @dev Event emitted when a new transaction is proposed by an owner.
     *
     * @param transactionId The unique identifier of the proposed transaction. This ID is used to reference the specific transaction in the transactions mapping.
     * @param proposer The address of the owner who proposed the transaction. This is the individual who initiated the proposal for the transaction to be executed.
     */
    event TransactionProposed(uint256 indexed transactionId, address indexed proposer);

    /**
     * @dev Event emitted when a transaction is executed.
     *
     * @param to The address to which the transaction will be sent. This is the address of the contract or account that will receive the transaction when it is executed.
     * @param data The data payload of the transaction, which can include function calls and parameters.
     */
    event TransactionExecuted(address indexed to, bytes data);

    struct Transaction {
        address to; // The address to which the transaction will be sent.
        bool executed; // A boolean flag indicating whether the transaction has been executed or not.
        bytes data; // The encoded data payload of the transaction, which can include function calls and parameters.
        uint256 signatureCount; // A counter to keep track of the number of signatures collected for the transaction.
    }

    /**
     * @dev A mapping that associates a unique transaction ID (uint256) with a Transaction struct. This mapping allows the contract to store and manage multiple transactions, each identified by its unique ID.
     */
    mapping(uint256 => Transaction) public transactions;

    /**
     * @dev A mapping that tracks whether a specific owner has signed a particular transaction.
     */
    mapping(uint256 => mapping(address => bool)) public isSigned;

    constructor(address[] memory signers) {
        // Check if the number of signers provided is less than the required number of signatures.
        if (signers.length < _requiredSignatures) {
            revert NotEnoughOwners(signers.length, _requiredSignatures);
        }

        // Initialize the _owners array and the _isOwner mapping based on the provided signers.
        _owners = signers;
        for (address owner: _owners) {
             if (owner == address(0)) {
                revert InvalidOwner(owner);
            }
            _isOwner[owner] = true;
        }
    }

    /**
     * @dev Returns the list of owners of the contract.
     * 
     * @return An array of addresses representing the owners of the contract.
     */
    function owners() external view returns (address[] memory) {
        return _owners;
    }

    /**
     * @dev Returns the number of signatures required to execute a transaction.
      *
      * @return A uint256 value representing the number of signatures required for transaction execution.
     */
    function requiredSignatures() external view returns (uint256) {
        return _requiredSignatures;
    }

    /**
     * @dev Allows an owner to sign a proposed transaction. The function checks if the caller is an owner, if the transaction has not already been executed, and if the caller has not already signed the transaction.
     * If all checks pass, the owner's signature is recorded, and the signature count for the transaction is incremented.
     * If the number of signatures collected for the transaction meets or exceeds the required number of signatures, the transaction is automatically executed.
     *
     * @param transactionId The unique identifier of the transaction that the owner wants to sign. This ID is used to reference the specific transaction in the transactions mapping.
     */
    function signTransaction(uint256 transactionId) public {
        address signer = msg.sender;
        // Check if the signer is an owner of the contract.
        if (!_isOwner[signer]) {
            revert NotAnOwner(signer);
        }

        Transaction storage transaction = transactions[transactionId];
        // Check if the transaction has already been executed or if the signer has already signed the transaction.
        if (transaction.executed) {
            revert TransactionAlreadyExecuted(transactionId);
        } else if (isSigned[transactionId][signer]) {
            revert OwnerAlreadySigned(signer, transactionId);
        }

        // Record the owner's signature and increment the signature count for the transaction.
        isSigned[transactionId][signer] = true;
        transaction.signatureCount++;

        // If the number of signatures collected for the transaction meets or exceeds the required number of signatures, execute the transaction.
        if (transaction.signatureCount >= _requiredSignatures) {
            executeTransaction(transactionId);
        }
    }

    /**
     * @dev Allows an owner to submit a new transaction proposal.
     *
     * @param functionSignature The function signature is a string that represents the function to be called on the token contract, along with its parameters. For example, if you want to call the `transfer` function of an ERC20 token, the function signature would be "transfer(address,uint256)". This signature is used to encode the function call and its parameters into a format that can be executed by the Ethereum Virtual Machine (EVM).
     * @param tokenContract The address of the token contract that the transaction will interact with. This is the contract that implements the ERC20 token standard, and it is where the specified function will be called.
     * @param receiver The address of the recipient who will receive the tokens as a result of the transaction. This address will be passed as a parameter to the function call specified in the function signature.
     * @param amount The amount of tokens to be transferred in the transaction. This value will also be passed as a parameter to the function call specified in the function signature. The amount should be specified in the smallest unit of the token (e.g., wei for Ether or the token's decimals for ERC20 tokens).
     */
    function submitTransaction(
        string memory functionSignature,
        address tokenContract,
        address receiver,
        uint256 amount
    ) public {
        // Check if the caller is an owner of the contract.
        if (!_isOwner[msg.sender]) {
            revert NotAnOwner(msg.sender);
        }

        // Encode the function call with the provided function signature and parameters (receiver and amount).
        bytes memory data = abi.encodeWithSignature(
            functionSignature,
            receiver,
            amount
        );

        // Create a new transaction proposal and store it in the transactions mapping with a unique transaction ID.
        transactions[_transactionCount] = Transaction({
            to: tokenContract,
            data: data,
            executed: false,
            signatureCount: 0
        });

        // Emit an event to signal that a new transaction has been proposed by the owner.
        emit TransactionProposed(_transactionCount, msg.sender);

        // Sign the transaction proposal by the owner who submitted it.
        signTransaction(_transactionCount);

        // Increment the transaction count to ensure that the next transaction proposal gets a unique ID.
        _transactionCount++;
    }

    /**
     * @dev Executes a transaction that has been proposed and has collected enough signatures from the owners. 
     *
     * @param transactionId The unique identifier of the transaction to be executed. This ID is used to reference the specific transaction in the transactions mapping.
     */
    function executeTransaction(uint256 transactionId) internal {
        Transaction storage transaction = transactions[transactionId];

        // Check if the transaction has already been executed or if it has collected enough signatures to be executed.
        if (transaction.executed) {
            revert TransactionAlreadyExecuted(transactionId);
        } else if (transaction.signatureCount < _requiredSignatures) {
            revert NotEnoughSignatures(
                transactionId,
                transaction.signatureCount,
                _requiredSignatures
            );
        }

        // Mark the transaction as executed before making the external call to prevent reentrancy attacks.
        transaction.executed = true;

        // Execute the transaction by making a low-level call to the specified address with the encoded data.
        bool success = transaction.to.call{value: 0}(transaction.data);

        // Check if the transaction execution was successful.
        if (!success) {
            revert TransactionExecutionFailed(transactionId);
        }

        // Emit an event to signal that the transaction has been executed, including the address it was sent to and the data payload.
        emit TransactionExecuted(transaction.to, transaction.data);
    }
}
