# [SIP-43] Activate stkSEAM Tokenomics

## Summary
This proposal activates the automatic reward distribution mechanism for stkSEAM holders, enabling protocol rewards from Seamless Morpho Vaults to be distributed to stakers without manual intervention.

## Context and Motivation
The Staking Safety Module is a fundamental component of Seamless tokenomics that empowers SEAM holders through staking rewards while enhancing protocol security. This proposal implements the reward distribution infrastructure necessary to make this system operational.

### Reward Distribution Mechanism
The implementation configures reward distribution to source rewards from Seamless Morpho Vaults (USDC, cbBTC, and WETH) by setting appropriate reward recipients for each vault to their respective reward splitter contracts. While the initial implementation focuses on Morpho Vaults, the architecture allows the DAO to add additional reward sources to the RewardKeeper contract as the protocol expands.

### Staking Safety Module
The Staking Safety Module offers SEAM holders several benefits:
- **Staking**: Lock SEAM tokens to receive stkSEAM, which retains voting power and provides access to rewards
- **Rewards**: Earn a pro-rata share of DAO-generated rewards from Morpho Vaults and potentially other sources
- **Security**: Implement a 7-day cooldown period for unstaking to ensure protocol stability
- **Safety Mechanism**: Staked SEAM serves as a security buffer that could be used, via DAO vote, to mitigate the impact of potential exploits

### Contract Architecture
The system consists of three primary components:

1. **stkSEAM**:
   - ERC20 token with governance voting power
   - Features a two-step unstaking process with cooldown and unstake window

2. **RewardKeeper**:
   - Collects rewards from protocol revenue sources
   - Allows governance to add or remove reward sources
   - Distributes rewards to stakers over 24-hour periods

3. **RewardsController**:
   - Manages distribution of rewards to stkSEAM holders
   - Allows holders to claim rewards in their original form (e.g., Seamless Morpho Vault LP tokens)


## Resources/References
- Relevant Discourse discussion: [here](https://seamlessprotocol.discourse.group/t/gp-activating-seam-tokenomics/585)
- This proposal is prepared with the [Seamless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)
- Proposal actions and tests can be found [here](https://github.com/seamless-protocol/gov-proposals/tree/main/proposals/sip_43)