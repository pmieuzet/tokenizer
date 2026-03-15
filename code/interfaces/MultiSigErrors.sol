interface MultiSigErrors {
    /**
     * @dev Indicates that a transaction has already been executed.
     * @param transactionId The ID of the transaction that has already been executed.
     */
    error TransactionAlreadyExecuted(uint256 transactionId);

    /**
     * @dev Indicates that an owner has already signed a transaction.
     * @param owner The address of the owner who has already signed the transaction.
     * @param transactionId The ID of the transaction that has already been signed by the owner.
     */
    error OwnerAlreadySigned(address owner, uint256 transactionId);

    /**
     * @dev Indicates that a non-owner is attempting to sign a transaction.
     * @param sender The address of the sender who is not an owner.
     */
    error NotAnOwner(address sender);

    /**
     * @dev Indicates that there are not enough owners to create a multi-signature wallet.
     * @param requiredSignatures The number of signatures required to execute a transaction.
     */
    error NotEnoughOwners(uint256 ownerCount, uint256 requiredSignatures);

    /**
     * @dev Indicates that a transaction does not have enough signatures to be executed.
     * @param transactionId The ID of the transaction that does not have enough signatures.
     */
    error TransactionExecutionFailed(uint256 transactionId);

    /**
     * @dev Indicates that an invalid owner address was provided.
     * @param owner The invalid owner address that was provided.
     */
    error InvalidOwner(address owner);
}
