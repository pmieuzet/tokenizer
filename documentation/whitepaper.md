# White paper: Community42 (COMM42)

Social equity through decentralized service exchange.

## The problem

The systematic and centralized monetization of human interactions has eroded the local social fabric. Informal mutual-aid communities have become dependent on transactional systems. Furthermore, there are significant financial disparities. For marginalized populations or those with low incomes, access to certain services has thus become difficult or even impossible, creating a growing socioeconomic divide. 

Today, consumption patterns are shifting from individual behaviors toward collective systems, which is why it is time to build a new system for exchanging services based on a reliable and equitable currency of trust.

## The solution

In the 1980s, one response to this financial and social imbalance was the creation of time banking by Edgar Cahn in the United States; however, this initiative was unsuccessful, largely due to infrastructure shortcomings. Unfortunately, it was not sustainable at the time because record-keeping relied on human coordinators, which proved particularly time-consuming; the system lacked transparency and thus trust; and the lack of modern digital interfaces limited its use.

COMM42 is a modern solution to these challenges: a utility token that cannot be exchanged for fiat currency.
This solution combines the egalitarian philosophy of time-based exchanges with the security of decentralized blockchain technology and smart contracts.

Unlike speculative cryptocurrencies designed for the accumulation of financial capital, this token is designed exclusively to quantify, facilitate, and secure the exchange of time, skills, and social capital among community users.

### Features

Users can create services: events.
Users can participate in events created by other users.
Users can contribute to existing events.
Users can make donations to other members (intra-community philanthropy).

## Choice of technologies

### Blockchain: Ethereum

The Ethereum blockchain is a pioneer in the field of smart contracts, and as such enjoys significant recognition—a key factor in the creation of a trading token such as COMM42. 

Since 2022, Ethereum has changed its consensus mechanism and now operates on a proof-of-stake basis. This transition offers significant advantages for the development of our COMM42 token. Less energy-intensive than proof-of-work, it is also based on the principle of fairness, making it both attractive and inclusive.

#### Standard: ERC-20

Developed in 2015, the ERC20 standard enables the standardization of tokens on the Ethereum blockchain, allowing for the creation of fungible tokens based on a set of common rules that must be followed when writing smart contracts.
Among other things, this ensures compatibility among all tools and tokens within the Ethereum ecosystem. In particular, it allows users to use the same wallet to manage different tokens on the blockchain.

### Solidity and Hardhat

Solidity is the primary language used to develop smart contracts on the Ethereum blockchain.

Hardhat is a platform dedicated to developing smart contracts on Ethereum. It provides an environment that simplifies their deployment and enables efficient testing.

## Business model

The owner of the project and the smart contract is a non-profit association established under the French Law of 1901.

Blockchain is often used for financial purposes, with assets gaining value through user investments. This project takes the opposite approach: it aims to empower people for social purposes.
Blockchain serves as a trust facilitator for the exchange of services, with the financial aspect focusing not on the value of the token, but on rewards for cooperation and sharing.

COMM42 cannot be purchased; it operates on a circular economy model: every transaction involves a transfer of tokens.
COMM42 can be transferred free of charge.
COMM42 is inflationary: it is issued only when the identity of a user who has created an account is verified.

Participating in and organizing events involves no financial transactions—only token transactions.

The automatic initial allocation of 5 tokens per user upon account verification avoids the pitfall of a cold start. This allows new users to participate without any upfront investment.

### Security

Setting up a MultiSig contract enhances security, particularly for high-risk transactions that require the creation of new tokens (`mint`). The contract can be deployed with two or more signer addresses. Each transaction must be initiated by one of them and signed by two of them before it is executed. When the MultiSig contract is deployed, the owner of the COMM42 contract transfers their `owner` rights to the contract. Requests to mint new tokens will therefore go exclusively through the MultiSig contract.

This helps protect COMM42 from potential attacks and ensures that responsibility for actions is shared. Decisions are made collectively, which helps build trust within the community.

### COMM42 2.0

- Developed an accessible and modern digital interface to facilitate interactions.
- Provide for the automated transfer of tokens from the event creator to contributors (as opposed to participants).
- The Association’s operations and activities, as well as gas fees, will be funded exclusively by financial support from individuals, businesses, associations, and public entities (donations, sponsorships, grants, etc.)
- Provide for the escrow of tokens until participation is confirmed.
- Provide for the automation of identity verification for new users, while ensuring complete anonymization within the blockchain (identity hash based on an official document).
- Gamification of the experience: awarding of rewards for achieving defined milestones, such as donating points.


