# [SIP-45] Legacy Platform Freeze

## Summary

This proposal implements a freeze on all markets in the legacy Seamless lending platform as part of the previously approved sunset plan. The freeze will prevent new deposits and borrows while allowing users to continue withdrawing their assets and repaying loans. This action represents a key milestone in transitioning users from the legacy platform to Seamless Vaults built on Morpho, which offers improved capital efficiency, reduced gas costs, and enhanced risk management.


## Context and motivation

This proposal implements a freeze on all markets in the legacy Seamless lending platform as part of the previously approved ([Snapshot labs Vote](https://snapshot.box/#/s:seamlessprotocol.eth/proposal/0x901e2aed03877d64a0414496f69b7febb76272cf4a1526c6d3b8813dac455074)) sunset plan. The freeze will prevent new deposits and borrows while allowing users to continue withdrawing their assets and repaying loans.

The implementation calls `setReserveFreeze(true)` on all assets in the protocol via the PoolConfigurator contract. This action:

1. Prevents new supply/deposits to the affected markets
2. Prevents new borrows from the affected markets
3. Allows existing users to withdraw their supplied assets
4. Allows existing borrowers to repay their loans
5. Maintains all other functionality including liquidations

This freeze represents a key milestone in the Seamless sunset plan, which aims to gradually transition users from the legacy platform to Seamless Vaults on Morpho . By freezing the markets rather than pausing them, we ensure users maintain full access to their funds while preventing new positions from being opened.

The timing of this freeze aligns with our previously communicated timeline and follows extensive community discussion about the benefits of migrating to Morpho, which offers improved capital efficiency, reduced gas costs, and enhanced risk management.

## Resources & References

- [Snapshot labs Vote](https://snapshot.box/#/s:seamlessprotocol.eth/proposal/0x901e2aed03877d64a0414496f69b7febb76272cf4a1526c6d3b8813dac455074)
- [Governance Discussion](https://seamlessprotocol.discourse.group/t/gp-maximizing-borrower-value-why-the-move-to-morpho-matters/930/13)
- [Proposal Implementation](https://github.com/seamless-protocol/gov-proposals/tree/main/proposals/sip_45)
- Built using [Seamless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)