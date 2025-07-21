# Ethereum Crowdfunding Smart Contract

A decentralized crowdfunding smart contract on Ethereum using Chainlink price feeds to dynamically convert USD goals to ETH.

---

## Features

- Campaign creation with real-time USD to ETH conversion using Chainlink
- Secure ETH contributions with reentrancy protection
- Time-based tracking for campaign deadlines
- Automatic success verification based on raised amount
- Refunds for contributors if the campaign fails
- ETH withdrawals by campaign creators if the goal is met
- Emission of events for transparency and off-chain indexing
- Integration of Chainlink’s ETH/USD price feed

---

## Tech Stack

- Solidity (v0.8.19)
- Chainlink Price Feeds
- Remix or Hardhat for development and testing
- Ethereum testnets (e.g., Sepolia, Goerli)
- MetaMask or WalletConnect for interacting with the dApp

---

## Weekly Progress

### Week 1: Introduction to Blockchain and Solidity

- Learned the basics of blockchain, Ethereum, and smart contracts
- Understood how Solidity works and wrote simple functions
- Explored variables, data types, and state-changing functions

### Week 2: Contract Fundamentals

- Implemented structs and mappings to store data
- Explored access control with `msg.sender`
- Wrote basic campaign storage and user tracking logic

### Week 3: Contribution System and Modifiers

- Added ETH contributions and validation
- Learned about `payable`, modifiers, and event emission
- Handled edge cases like invalid contributions and expired campaigns

### Week 4: Campaign Deadlines and Goal Tracking

- Implemented time-based conditions using `block.timestamp`
- Added campaign status tracking (active, funded, closed)
- Integrated ETH goal comparison logic

### Week 5: Withdrawals, Refunds, and Security

- Added logic for campaign creators to withdraw ETH
- Developed refund logic for contributors if the campaign fails
- Introduced reentrancy protection using a locking mechanism

### Week 6: Chainlink Price Feed Integration

- Integrated Chainlink ETH/USD price feed
- Wrote a utility function to convert USD to ETH in real-time
- Ensured campaigns are created with live exchange rates

### Week 7: Testing on Testnets

- Deployed contracts to Ethereum testnets like Sepolia
- Tested all contract flows: create, contribute, withdraw, refund
- Validated contract behavior using Remix and Hardhat

### Week 8: Finalization and Optimization

- Optimized gas usage and contract readability
- Implemented public view functions for frontend integration
- Finalized event handling for all critical state changes
- Prepared for frontend integration and potential mainnet deployment

---

## Future Improvements :
- Web Deployment using Ether.js
