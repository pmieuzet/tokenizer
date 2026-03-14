// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC20Errors} from "@openzeppelin/contracts/interfaces/draft-IERC6093.sol";

/**
 * @title Community42
 * @author pmieuzet
 * @notice This contract implements an ERC-20 token named "Community42" with the symbol "COMM42".
 * This implementation includes the standard ERC-20 functions and events, as well as custom errors for better error handling.
 * The token has a name, symbol, and a fixed number of decimals.
 * The total supply of tokens can be increased by the owner through the `mint` function.
 */
contract Community42 is IERC20, IERC20Errors, Ownable {
    /**
     * @dev Struct representing an event in the community.
     * Each event has an organizer, a list of participants, a maximum number of participants, and a price for attending the event.
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
     * @dev The total number of tokens in existence.
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
     * @dev Mapping from event names to their corresponding Event struct, which contains details about the event such as organizer, participants, maximum number of participants, and price.
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
        _balances[from] -= value;
        _balances[to] += value;

        emit Transfer(from, to, value);
        return true;
    }

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the allowance mechanism.
     * `value` is then deducted from the caller's allowance.
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

        _balances[from] -= value;
        _balances[to] += value;

        _allowances[from][spender] -= value;

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
     * - `ERC20InvalidOwner` if `owner` is the zero address.
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
        _allowances[owner][spender] = value;

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
    ) internal onlyOwner returns (bool) {
        _totalSupply += amount;
        _balances[to] += amount;

        emit Transfer(address(0), to, amount);
        return true;
    }

    /**
     * @dev Register a new user by minting a signup bonus of tokens to their address.
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
     * @param to The address of the new user to receive the signup bonus tokens.
     *eventKey
     * @return A boolean value indicating whether the operation succeeded.
     */
    function signup() external returns (bool) {
        return mint(msg.sender, SIGNUP_BONUS);
    }

    /**
     * @dev Creates a new event with the specified parameters.
     * The caller of this function will be set as the organizer of the event. The event is identified by a unique `eventKey`,
     * and it has a maximum number of participants and a price for attending the event.
     *
     * @param eventKey The unique identifier for the event to be created. It should be a non-empty string that distinguishes this event from others.
     * @param maxParticipants The maximum number of participants allowed to join the event. This should be a positive integer that limits the number of attendees for the event.
     * @param price The price in tokens that participants must pay to join the event.
     * This should be a non-negative integer representing the cost of attending the event in terms of the Community42 tokens.
     */
    function createEvent(
        string memory eventKey,
        uint8 maxParticipants,
        uint256 price
    ) external {
        if (
            bytes(eventKey).length == 0 ||
            _events[eventKey].organizer != address(0)
        ) {
            revert("Event with the same key already exists");
        }

        _events[eventKey] = Event({
            organizer: msg.sender,
            participants: new address[](0),
            maxParticipants: maxParticipants,
            price: price
        });
    }

    /**
     * @dev Allows a user to participate in an existing event by paying the required price in tokens.
     *
     * @param eventKey The unique identifier for the event that the user wants to participate in.
     */
    function participateInEvent(string memory eventKey) external {
        Event storage eventInfo = _events[eventKey];
        if (eventInfo.organizer == address(0)) {
            revert("Event does not exist");
        } else if (eventInfo.participants.length >= eventInfo.maxParticipants) {
            revert("Event is full");
        } else if (_balances[msg.sender] < eventInfo.price) {
            revert("Insufficient balance to participate in the event");
        }

        if (eventInfo.price != 0) {
            transfer(eventInfo.organizer, eventInfo.price);
        }

        eventInfo.participants.push(msg.sender);
    }
}
