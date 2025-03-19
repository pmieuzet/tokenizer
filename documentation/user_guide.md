# Deployment

To enable deployment, you must:
- Create an Alchemy account and retrieve the API key to set it in the `ALCHEMY_APU_KEY` variable in the `.env` file
- Create an Etherscan account and retrieve the API key to set it in the `ETHERSCAN_API_KEY` variable in the `.env` file

## Required environment variables

- ALCHEMY_API_KEY=API_key_on_alchemy
- PRIVATE_KEY=private_key_for_wallet_account_on_metaMask
- PRIVATE_KEY_MULTISIG=private_key_for_second_wallet_account_on_metamask
- ETHERSCAN_API_KEY=API_key_on_etherscan

# COMM42

https://hardhat.org/ignition/docs/getting-started

1. First, update the necessary dependencies using the `npm install` command
2. Run the `npx hardhat ignition deploy ./deployment/ignition/modules/Community42.ts --network sepolia` command

![](./assets/contract-community42-deployment.png)

## MultiSig

In a terminal, run the command `npx hardhat ignition deploy ./deployment/ignition/modules/MultiSig.ts --network sepolia`

![](./assets/multisig-deployment.png)

# Tests

## Run unit tests on Hardhat

Run the command `npx hardhat test`

![](./assets/tests.png)

## Test on Etherscan with Metamask 

To properly test the token, you need to install the Metamask extension on your preferred browser and create a wallet with one or more accounts containing Sepolia ETH test currency ([click here to get some](https://cloud.google.com/application/web3/faucet/ethereum/sepolia)).

1. Run the command `npx hardhat verify --network sepolia <contract-address>`

2. Paste the link into a browser

3. Click `Connect to Web3` and test the methods

4. Add (sepolia)[https://www.datawallet.com/fr/crypto/ajouter-sepolia-%C3%A0-metamask] and COMM42 to Metamask

![](./assets/add-comm42-to-metamask.png)

5. Test the methods

signup example:

![](./assets/signup-step1.png)
![](./assets/signup-step2.png)
![](./assets/signup-step3.png)
![](./assets/signup-step4.png)

Create and participate in event example:

- Hash in bytes32 the event name
![](./assets/create-event-step1.png)

- Create the event on the token
![](./assets/create-event-step2.png)

- Participate in the event with an other account
![](./assets/participate-event-step3.png)

- Confirm transaction
![](./assets/participate-event-step4.png)

- The email address that participate for the event returned 2 COMM42.
![](./assets/create-and-participate-event-res1.png)

- The address that create the event received 2 COMM42s.
![](./assets/create-and-participate-event-res2.png)

### Testing multi-signature

1. Run the command `npx hardhat verify --network sepolia <contract-address>`

2. Go to the COMM42 contract and log in using the email address of the person who deployed the COMM42 contract.

3. In `Write Contract`, grant the `transferOwnership` permission to the multisignature contract address.

![](./assets/transfer_ownership.png)
![](./assets/transfer_ownership_res.png)
 
4. Submit a request via multi-signature

Example: 

- Request `mint` using the COMM42 contract address with an owner account
![](./assets/multisig-step1.png)

- Verify that the request has been acknowledged with an initial signature
![](./assets/multisig-step2.png)

- Approve the request using another owner account
![](./assets/multisig-step3.png)

- Verify that the account has received the transfer and that the totalSupply has also increased on the COMM42 contract
![](./assets/multisig-res.png)

