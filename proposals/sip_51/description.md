# [SIP-51] Treasury Wind Down & Distribution Plan

## Summary
This proposal seeks to:

1. Convert all treasury assets into USDC
2. Cover remaining bad debt incurred due to the Resolv hack in the Seamless USDC Vault on Morpho
3. Fund essential wind-down operations
4. Distribute remaining treasury funds to SEAM and stkSEAM holders

This proposal prioritizes user protection, responsible closure of operations, and value return to long-term supporters.

## Background & motivation

Following the [announcement](https://x.com/SeamlessFi/status/2041572728239747558) of the Seamless Protocol sunset on April 7, 2026, the Seamless UI was officially taken offline on July 1, 2026, marking the completion of the [protocol’s winddown](https://x.com/SeamlessFi/status/2072441319205818875). Up to date:

- Most core contributor and third-party contracts have been terminated
- The remaining contributors have continued working to ensure a smooth wind-down
- Final legal, technical, and operational tasks must still be completed

Separately, the Seamless USDC Vault on Morpho (curated by Gauntlet) accumulated 381,904.41592 USDC in bad debt, due to exposure to Resolv Morpho markets. In accordance with the agreement between Resolv and Gauntlet, Resolv will cover a portion of the bad debt incurred by the Seamless USDC Vault. For additional details, please refer to [Gauntlet’s](https://x.com/gauntlet_xyz/status/2062185818698223704) and [Resolv’s](https://x.com/ResolvCore/status/2059298604595269830) announcements.

The DAO now faces three priorities:

1. Protect users affected by the vault bad debt
2. Ensure an orderly and compliant wind-down, including the settlement of all outstanding obligations to counterparties, the resolution of any remaining legal matters, and the fulfillment of all regulatory and compliance requirements
3. Return remaining value to token holders

## Proposal Details

### Step 1: Treasury Consolidation into USDC

The current state of the treasury includes the following assets:

USDC: 615,319.60
weETH: 91.34
veAERO*: 471,116.41
WETH: 10.51
AERO: 26,344.85
USDbC: 6,610.42
wstETH: 2.52
EURC: 4,069.11
cbBTC: 0.05
DAI: 585.38
BRETT: 30,407.07
VIRTUAL: 718.73
MORPHO: 111.14
cbETH: 0.10
ABX: 90,532.00
COMP: 3.13
ETH: 0.01

All assets currently held in the Seamless DAO treasury will be converted into USDC to:

- Simplify accounting and distribution
- Reduce volatility risk during wind-down
- Ensure liquidity for obligations

Once the conversion process is complete, the total amount of USDC received will be published in a separate comment on this proposal and announced in the Seamless Discord server.

* If this proposal is agreed to, core contributors would be tasked with identifying and executing on the best opportunities to sell the locked veAERO position. Since veAERO is an NFT representing a locked AERO position, it cannot be traded on either centralized or decentralized exchanges. Therefore, any sale must be conducted over the counter (OTC), with the exchange rate determined by the terms agreed between the buyer and the seller.

### Step 2: USDC Vault Bailout
The DAO will allocate treasury funds to cover the remaining 190,925 USDC in bad debt associated with the Seamless USDC Vault on Morpho in order to ensure all vault users can withdraw funds in full.

### Step 3: Wind-Down Budget Allocation
A total of $254,943 are to be allocated to fund essential shutdown operations: engineering, security, operational and legal. Refer to this [document](https://docs.google.com/spreadsheets/d/1Ty7zsTa3U_mYUTIPrHUZaYacOQ5gW5fTmXbqcgZkBAs/edit?usp=sharing) for a cost breakdown.

### Step 4: Distribution to SEAM & stkSEAM Holders
All remaining treasury funds after Steps 2 and 3 will be distributed to:

- SEAM token holders
- stkSEAM holders

Key Conditions:

- A snapshot will be taken on July 24, 2026, to give users who hold SEAM on centralized exchanges (CEXs) sufficient time to withdraw their tokens to self-custodied wallets. If you hold SEAM on Ethereum mainnet, you will remain eligible to claim your allocation.
- Distribution claims will be processed on Base through https://app.merkl.xyz/.
- Users with smart contract wallets on Ethereum mainnet should ensure they control the same address on Base, or migrate their wallet before the snapshot.
- Exchanges (both CEXes and DEXes), aggregators, certain smart contracts (deemed unable to claim) and other protocols are excluded from the distribution. Please withdraw your tokens to self-custodied wallets before July 24, 2026.
- If you hold stkSEAM, no further action is required on your part.
- Wallets associated with the Seamless Protocol, its Core Contributors, or other affiliated entities are excluded from this distribution.
- To be eligible for the airdrop, a wallet must hold at least 25 SEAM or stkSEAM on July 24, 2026.Funds will be distributed pro-rata across SEAM and stkSEAM holders.
- Distribution of funds will be processed via Merkl. No claim deadline will be imposed, allowing eligible recipients to claim their allocation at any time. Please note that Merkl may charge a small fee for facilitating the distribution. The exact fee will be agreed upon with Merkl once the final amount to be distributed has been determined and will be deducted from the distribution pool.
- If you are a holder of esSEAM, make sure to claim your vested amounts into SEAM before the snapshot.

## Implementation Details
### Proposal Actions

1. Withdraw all assets from the DAO contracts
2. Core contributors to sell these assets into USDC
3. Core contributors to allocate USDC for Morpho vault bad debt
4. Core contributors to allocate USDC for wind down costs
5. Core contributors to setup airdrop through Merkl for remaining USDC