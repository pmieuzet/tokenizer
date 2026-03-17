// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";
import {Community42Errors} from "../interfaces/Community42Errors.sol";

/**
 * @title Community42
 * @author pmieuzet
 * @notice This contract implements an ERC-20 token named "Community42" with the symbol "COMM42".
 * @dev This implementation includes the standard ERC-20 functions and events.
 */
contract Community42 is IERC20, IERC20Errors, Ownable, Community42Errors {
    /**
     * @dev Struct representing an event in the community.
     */
    struct Event {
        address organizer;
        uint8 maxParticipants;
        uint256 price;
        address[] participants;
    }

    /**
     * @dev The name of the token.
     */
    string private _name = "Community42";
    /**
     * @dev The symbol of the token.
     */
    string private _symbol = "COMM42";

    /**
     * @dev The number of decimals used to get its user representation.
     */
    uint256 private _decimals = 0;
    /**
     * @dev The total number of tokens in existence. This value is updated whenever new tokens are minted.
     */
    uint256 private _totalSupply = 0;

    /**
     * @dev The signup bonus amount of tokens to be minted for new users upon registration.
     */
    uint8 private SIGNUP_BONUS = 5;

    /**
     * @dev Mapping from account addresses to their current balance.
     */
    mapping(address => uint256) private _balances;
    /**
     * @dev Mapping from account addresses to a mapping of spender addresses to their current allowance.
     */
    mapping(address => mapping(address => uint256)) private _allowances;

    /**
     * @dev Mapping to track whether an address has already signed up and received the signup bonus.
     */
    mapping(address => bool) private _hasSignedUp;

    /**
     * @dev Mapping from event names to their corresponding Event struct, which contains details about the event.
     */
    mapping(bytes32 => Event) private _events;

    constructor() Ownable(msg.sender) {}

    /**
     * @dev Returns the total number of tokens in existence.
     */
    function totalSupply() external view override returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     */
    function decimals() external view returns (uint256) {
        return _decimals;
    }

    /**
     * @dev Returns the balance of the specified account.
     *
     * @param account The address of the account to query the balance of.
     */
    function balanceOf(
        address account
    ) external view override returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `value`.
     *
     * Reverts with custom errors:
     * - `ERC20InvalidReceiver` if `to` is the zero address.
     * - `ERC20InsufficientBalance` if the caller's balance is less than `value`.
     *
     * @param to The address of the recipient of the tokens.
     * @param value The amount of tokens to transfer.
     *
     * @return A boolean value indicating whether the operation succeeded.
     */
    function transfer(
        address to,
        uint256 value
    ) public override returns (bool) {
        address from = msg.sender;
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }

        uint256 balance = _balances[from];
        if (balance < value) {
            revert ERC20InsufficientBalance(from, balance, value);
        }

        // Perform the token transfer by updating the balances of the sender and recipient.
        _balances[from] -= value;
        _balances[to] += value;

        // Emit a Transfer event to signal that the transfer has occurred, including the sender, recipient, and amount transferred.
        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the allowance mechanism.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - the caller must have an allowance for `from`'s tokens of at least `value`.
     * - `from` must have a balance of at least `value`.
     *
     * Reverts with custom errors:
     * - `ERC20InvalidSender` if `from` is the zero address.
     * - `ERC20InvalidReceiver` if `to` is the zero address.
     * - `ERC20InsufficientAllowance` if the caller's allowance for `from` is less than `value`.
     * - `ERC20InsufficientBalance` if `from`'s balance is less than `value`.
     *
     * @param from The address of the account to transfer tokens from.
     * @param to The address of the recipient of the tokens.
     * @param value The amount of tokens to transfer.
     *
     * @return A boolean value indicating whether the operation succeeded.
     */
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public override returns (bool) {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        } else if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }

        address spender = msg.sender;
        uint256 currentAllowance = allowance(from, spender);
        if (currentAllowance < value) {
            revert ERC20InsufficientAllowance(from, currentAllowance, value);
        }

        uint256 currentBalance = _balances[from];
        if (currentBalance < value) {
            revert ERC20InsufficientBalance(from, currentBalance, value);
        }

        // Perform the token transfer by updating the balances of `from` and `to`.
        _balances[from] -= value;
        _balances[to] += value;

        // Update the allowance of the caller for `from`'s tokens by deducting the transferred amount.
        _allowances[from][spender] -= value;

        // Emit a Transfer event to signal that the transfer has occurred, including the sender, recipient, and amount transferred.
        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @dev Returns the remaining number of tokens that `spender` will be allowed to spend on behalf of `owner` through {transferFrom}. This is zero by default.
     *
     * Requirements:
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     *
     * Reverts with custom errors:
     * - `ERC20InvalidApprover` if `owner` is the zero address.
     * - `ERC20InvalidSpender` if `spender` is the zero address.
     *
     * @param owner The address of the account owning tokens.
     * @param spender The address of the account able to transfer the tokens.
     *
     * @return The remaining number of tokens that `spender` will be allowed to spend on behalf of `owner` through {transferFrom}. This is zero by default.
     */
    function allowance(
        address owner,
        address spender
    ) public view override returns (uint256) {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        } else if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }

        return _allowances[owner][spender];
    }

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the caller's tokens.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     * - `spender` cannot be the zero address.
     *
     * Reverts with custom errors:
     * - `ERC20InvalidSpender` if `spender` is the zero address.
     *
     * @param spender The address of the account able to transfer the tokens.
     * @param value The amount of tokens to be approved for transfer.
     *
     * @return A boolean value indicating whether the operation succeeded.
     */
    function approve(
        address spender,
        uint256 value
    ) public override returns (bool) {
        if (spender == address(0)) {
            revert ERC20InvalidSender(address(0));
        }

        address owner = msg.sender;
        // Set the allowance of `spender` over the caller's tokens to the specified `value`.
        _allowances[owner][spender] = value;

        // Emit an Approval event to signal that the approval has occurred, including the owner, spender, and amount approved.
        emit Approval(owner, spender, value);
        return true;
    }

    /**
     * @dev Creates `amount` tokens and assigns them to `to`, increasing the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     * - `to` cannot be the zero address.
     * - the caller must be the owner of the contract.
     *
     * Reverts with custom errors:
     * - `ERC20InvalidReceiver` if `to` is the zero address.
     *
     * @param to The address of the account to receive the newly minted tokens.
     * @param amount The amount of tokens to mint.
     *
     * @return A boolean value indicating whether the operation succeeded.
     */
    function mint(
        address to,
        uint256 amount
    ) external onlyOwner returns (bool) {
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }

        // Perform the minting by increasing the total supply and updating the balance of the recipient address.
        _totalSupply += amount;
        _balances[to] += amount;

        // Emit a Transfer event to signal that the minting has occurred, including the zero address as the sender, the recipient address, and the amount minted.
        emit Transfer(address(0), to, amount);
        return true;
    }

    /**
     * @dev Register a new user by minting a signup bonus of tokens to their address.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements:
     * - The caller must not have already signed up and received the signup bonus.
     *
     * Reverts with custom errors:
     * - `AlreadySignedUp` if the caller has already signed up and received the signup bonus.
     *
     * @return A boolean value indicating whether the operation succeeded.
     */
    function signup() external returns (bool) {
        address to = msg.sender;
        if (_hasSignedUp[to]) {
            revert AlreadySignedUp(to);
        }

        // Mark the caller as having signed up to prevent them from receiving the signup bonus multiple times.
        _hasSignedUp[to] = true;

        // Perform the signup bonus minting by increasing the total supply and updating the balance of the caller's address with the predefined SIGNUP_BONUS amount.
        _totalSupply += SIGNUP_BONUS;
        _balances[to] += SIGNUP_BONUS;

        // Emit a Transfer event to signal that the signup bonus minting has occurred, including the zero address as the sender, the caller's address as the recipient, and the amount of the signup bonus.
        emit Transfer(address(0), to, SIGNUP_BONUS);
        return true;
    }

    /**
     * @dev Creates a new event with the specified parameters.
     * The caller of this function will be set as the organizer of the event. The event is identified by a unique `eventKey`, and it has a maximum number of participants and a price for attending the event.
     *
     * Reverts with custom errors:
     * - `EventAlreadyExists` if an event with the same `eventKey` already exists.
     * - `InvalidMaxParticipants` if the `maxParticipants` parameter is set to zero, which is not a valid value for the maximum number of participants.
     *
     * @param eventKey The unique identifier for the event to be created. It should be a non-empty string that distinguishes this event from others.
     * @param maxParticipants The maximum number of participants allowed to join the event. This should be a positive integer that limits the number of attendees for the event.
     * @param price The price in tokens that participants must pay to join the event.
     * This should be a non-negative integer representing the cost of attending the event in terms of the Community42 tokens.
     *
     * @return A boolean value indicating whether the operation succeeded.
     */
    function createEvent(
        bytes32 eventKey,
        uint8 maxParticipants,
        uint256 price
    ) external returns (bool) {
        if (
            eventKey.length == 0 ||
            _events[eventKey].organizer != address(0)
        ) {
            revert EventAlreadyExists(eventKey);
        }

        if (maxParticipants == 0) {
            revert InvalidMaxParticipants(eventKey);
        }

        // Cap the price at 100 tokens to prevent excessively high prices for attending events.
        if (price > 100) {
            price = 100;
        }

        // Create a new event by initializing the Event struct with the organizer's address, an empty list of participants, the specified maximum number of participants, and the price for attending the event. The event is stored in the _events mapping using the provided eventKey as the key.
        _events[eventKey] = Event({
            organizer: msg.sender,
            participants: new address[](0),
            maxParticipants: maxParticipants,
            price: price
        });
        return true;
    }

    /**
     * @dev Allows a user to participate in an existing event by paying the required price in tokens.
     *
     * Reverts with custom errors:
     * - `EventDoesNotExist` if the event with the specified `eventKey` does not exist (i.e., there is no organizer associated with the event).
     * - `EventFull` if the number of participants for the event has already reached the maximum allowed (`maxParticipants`).
     * - `InsufficientBalance` if the user's balance is less than the price required to participate in the event.
     *
     * @param eventKey The unique identifier for the event that the user wants to participate in.
     *
     * @return A boolean value indicating whether the operation succeeded.
     */
    function participateInEvent(
        bytes32 eventKey
    ) external returns (bool) {
        Event storage eventInfo = _events[eventKey];
        if (eventInfo.organizer == address(0)) {
            revert EventDoesNotExist(eventKey);
        } else if (eventInfo.participants.length >= eventInfo.maxParticipants) {
            revert EventFull(eventKey);
        } else if (_balances[msg.sender] < eventInfo.price) {
            revert InsufficientBalance(
                msg.sender,
                _balances[msg.sender],
                eventInfo.price
            );
        }

        // Transfer the required price from the participant to the event organizer. This is done by calling the transfer function, which will update the balances accordingly and emit a Transfer event.
        if (eventInfo.price != 0) {
            transfer(eventInfo.organizer, eventInfo.price);
        }

        // The participant's address is added to the list of participants for the event.
        eventInfo.participants.push(msg.sender);
        return true;
    }
}
