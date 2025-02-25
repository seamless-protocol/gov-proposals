# [SIP-41] Compensation for 3x ETH ILM Liquidation Event


## Summary

On February 2, 2025, the 3x ETH ILM experienced a rapid liquidation due to extreme market volatility, causing additional losses beyond normal 3x leverage drawdowns. This proposal seeks to compensate affected users with esSEAM tokens at 105% of the liquidation penalty incurred, using a reference price of $0.5573 per esSEAM. Only addresses eligible for at least 1 esSEAM will receive compensation. The total SEAM budget will be sent to the Seamless Guardian for distribution according to the provided spreadsheet and Dune query (see Discourse).

## Context and Motivation

The incident occurred when ETH prices dropped approximately 30% in under 5 minutes. High DEX slippage prevented proper ILM rebalancing, triggering a protective liquidation to avoid bad debt. The impact affected approximately 701 users:

- Standard losses: Users faced ~60% (3x) losses from the ETH price drop
- Additional protocol-level liquidation losses affected small accounts ($85 average loss), top 10 depositors ($5.2k each), and mid-level users

The compensation structure includes:

- Pro-rata distribution based on each address's percentage of liquidation-specific losses
- 105% coverage in esSEAM to account for vesting and reduced liquidity
- 12-month vesting schedule to ensure long-term alignment

This compensation is explicitly a one-off event and does not create a binding precedent. The scenario was extraordinarily rare, but compensation is warranted due to the protocol-level fault to maintain user confidence.

## Resources/References

- Relevant Discouse discussion: https://seamlessprotocol.discourse.group/t/proposal-compensation-for-3x-eth-ilm-liquidation-event/855/10 
- This proposal is prepared with the [Seamless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)
- Proposal actions and tests can be found [here](https://github.com/seamless-protocol/gov-proposals/tree/main/proposals/sip_41)