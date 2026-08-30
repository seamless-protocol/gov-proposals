# [SIP-53] Renounce Remaining Elevated Access Controls

## Summary

This proposal continues the Seamless DAO sunset started in SIP-52 by permanently removing remaining short-timelock administrative control over Seamless Morpho vaults and other protocol contracts that were not covered by SIP-52.

## Proposal

If approved, this proposal authorizes the short governor timelock to:

1. Clear curator and allocator roles on the Seamless USDC, cbBTC, and WETH Morpho vaults, submit guardian removal to `address(0)`, then renounce vault ownership
2. Renounce ownership of the Base Leverage Token Factory
3. Renounce ownership of the weETH/WETH 17x Rebalance Adapter
4. Revoke remaining Guardian roles on FeeKeeper and renounce all FeeKeeper roles held by the short timelock
5. Renounce remaining short-timelock roles on stkSEAM (`MANAGER_ROLE`, `PAUSER_ROLE`)
6. Renounce short-timelock roles on the Base Leverage Manager (`UPGRADER_ROLE`, `DEFAULT_ADMIN_ROLE`)

Note: Morpho vault guardian removal is timelocked (3 days). After execution, anyone can call `acceptGuardian()` once the vault timelock elapses. Until then, the current guardian retains revoke rights over the pending change.

## Context

SIP-52 revoked ACL roles and renounced ownership across the legacy lending stack. Elevated control still remained on Morpho vaults, leverage contracts, FeeKeeper, and short-timelock stkSEAM roles. This proposal removes those remaining short-timelock privileges.
