# Technical specifications

`Community42` contract is a custom implementation of the ERC-20 standard.

- __name__: `Community42`
- __symbol__: `COMM42`
- __decimals__: `0`
- __initial supply__: `0` (indivisible)

## ERC-20 Standard

The Community42 token implements the standard ERC-20 interface, ensuring its compatibility with the Ethereum ecosystem. As such, methods for managing balances, transfers, and authorizations must be defined to comply with this universal protocol.

- __totalSupply()__:
    - scope: `external view` 
    - functionality: Returns the number of tokens in circulation, which is growing through minting
    - return: `uint256`
- __balanceOf(address account)__: 
    - scope: `external view` 
    - parameters: 
        - `account`: The address of the account to query the balance of
    - functionnality: Returns the number of tokens the account has
    - return: `uint256` value indicating the number of tokens the account has
- __transfer(address to, uint256 value)__:
    - scope: `public`
    - parameters: Moves a `value` amount of tokens from the caller's account to `to`
        - `to`: The address of the recipient of the tokens
        - `value`: The amount of tokens to transfer
    - functionnality: 
    - return: `bool` value indicating whether the operation succeeded
- __transferFrom(address from, address to, uint256 value)__:
    - scope: `public`
    - parameters:
        - `from`: The address of the account to transfer tokens from
        - `to`: The address of the recipient of the tokens
        - `value`: The amount of tokens to transfer
    - functionnality: Moves a `value` amount of tokens from `from` to `to` using the allowance mechanism
    - return: `bool` value indicating whether the operation succeeded
- __approve(address spender, uint256 value)__:
    - scope: `public`
    - parameters:
        - `spender`: The address of the account able to transfer the tokens
        - `value`: The amount of tokens to be approved for transfer
    - functionnality: Sets a `value` amount of tokens as the allowance of `spender` over the caller's tokens
    - return: `bool` value indicating whether the operation succeeded
- __allowance(address owner, address spender)__:
    - scope: `public view`
    - parameters:
        - `owner`: The address of the account owning tokens
        - `spender`: The address of the account able to transfer the tokens
    - functionnality:
    - return: `uint256` value of tokens that `spender` will be allowed to spend


## Specific features

In addition to standard transfer features, the contract incorporates business logic specific to its community through dedicated functions, for the automatic issuance of a sign-up bonus and the management of a micro-economy for events directly on the blockchain. 

- __SIGNUP_BONUS__: The signup bonus amount of tokens to be minted for new users upon registration (value = `5`)

- __mint(address to, uint256 amount)__:
    - scope: `external`
    - parameters:
        - `to`: The address of the account to receive the newly minted tokens
        - `amount`: The amount of tokens to mint
    - functionnality: Creates `amount` tokens and assigns them to `to`, increasing the total supply
    - access : only the owner can perform this action (`ownerOnly`)
    - return: `bool` value indicating whether the operation succeeded
- __signup()__:
    - scope: `external`
    - functionnality: Register a new user by minting a signup bonus of tokens to their address and increasing the total supply
    - return: `bool` value indicating whether the operation succeeded
- __createEvent(string eventKey, uint8 maxParticipants, uint256 price)__:
    - scope: `external`
    - parameters:
        - `eventKey`: The unique identifier for the event to be created
        - `maxParticipants`: The maximum number of participants allowed to join the event
        - `price`: The price in tokens that participants must pay to join the event (limit price is 100)
    - functionnality: Creates a new event with the specified parameters. The caller of this function will be set as the organizer of the event
    - return: `bool` value indicating whether the operation succeeded
- __participateInEvent(string eventKey)__:
    - scope: `external`
    - parameters:
        - `eventKey`: The unique identifier for the event to be created
    - functionnality: Allows a user to participate in an existing event by paying the required price in tokens
    - return: `bool` value indicating whether the operation succeeded


## MultiSig

To decentralize decision-making and eliminate any single points of failure, governance is managed through a MultiSig contract: once designated as the token’s `onlyOwner`, this digital vault requires a quorum of multiple signatures validated by administrators to authorize any sensitive action, such as the issuance of new tokens (`mint`).

- __owners__: The list of addresses of the owners of the contract, who have the authority to propose and approve transactions
- __requiredSignatures__: The number of signatures required to execute a transaction (default value = `2`)

- __submitTransaction(string functionSignature, address tokenContract, address receiver, uint256 amount)__:
    - scope: `external`
    - parameters: 
        - `functionSignature`: The function signature is a string that represents the function to be called on the token contract, along with its parameters
        - `tokenContract`: The address of the token contract that the transaction will interact with.
        - `receiver`: The address of the recipient who will receive the tokens as a result of the transaction
        - `amount`: The amount of tokens to be transferred in the transaction
    - functionnality: Allows an owner to submit a new transaction proposal
- __signTransaction(uint256 transactionId)__:
    - scope: `public`
    - parameters: 
        - `transactionId`: The unique identifier of the transaction to be executed
    - functionnality: Allows an owner to sign a proposed transaction
- __executeTransaction(uint256 transactionId)__:
    - scope: `internal`
    - parameters: 
        - `transactionId`: The unique identifier of the transaction to be executed
    - functionnality: Executes a transaction that has been proposed and has collected enough signatures from the owners