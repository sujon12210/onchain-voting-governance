# On-Chain Voting Governance

This repository provides a robust, decentralized governance framework similar to Compound or Uniswap governance models. It allows token holders to participate in the decision-making process of a protocol by voting on specific proposals.

## Features
* **Token-Weighted Voting:** Voting power is proportional to the number of governance tokens held.
* **Proposal Lifecycle:** Integrated states: Pending, Active, Defeated, Succeeded, and Executed.
* **Quorum Support:** Configurable minimum participation requirements for proposal validity.
* **Flat Directory:** All smart contracts and scripts are in the root for easy integration.

## How it Works
1. **Propose:** A user with sufficient tokens submits a proposal (target address, value, and data).
2. **Vote:** Token holders cast 'For', 'Against', or 'Abstain' votes during the voting period.
3. **Queue/Execute:** If the proposal passes and reaches quorum, it can be executed to interact with other smart contracts.
