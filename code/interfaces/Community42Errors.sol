interface Community42Errors {
    /**
     * @dev Indicates that an address has already signed up and received the signup bonus.
     * @param user The address of the user who has already signed up and received the signup bonus.
     */
    error AlreadySignedUp(address user);

    /**
     * @dev Indicates that an event with the same name already exists.
     * @param eventName The name of the event that already exists.
     */
    error EventAlreadyExists(bytes32 eventName);

    /**
     * @dev Indicates that an event with the specified name does not exist.
     * @param eventName The name of the event that does not exist.
     */
    error EventDoesNotExist(bytes32 eventName);

    /**
     * @dev Indicates that an event has reached its maximum number of participants.
     * @param eventName The name of the event that is full.
     */
    error EventFull(bytes32 eventName);

    /**
     * @dev Indicates that a user has insufficient balance to participate in an event.
     * @param user The address of the user with insufficient balance.
     * @param balance The current balance of the user.
     * @param required The amount of tokens required to participate in the event.
     */
    error InsufficientBalance(address user, uint256 balance, uint256 required);
}
