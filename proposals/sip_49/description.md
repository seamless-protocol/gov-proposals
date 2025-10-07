# [SIP-49] Upgrade Base Leverage Token and Manager Implementations

## Summary

This proposal upgrades the Seamless Leverage Token infrastructure on Base by updating both the Base Leverage Token implementation and the Base Leverage Manager implementation to their latest versions. These upgrades bring improvements in user experience, protocol integration capabilities, gas optimizations, and alignment with the Ethereum mainnet deployment.

## Context and Motivation

Seamless Leverage Tokens are ERC20 tokenized representations of leveraged positions between two assets, providing users with simple, liquid exposure to leveraged strategies without managing complex DeFi positions directly. Since the initial Base deployment in June 2025, the protocol has undergone optimization based on user feedback, and preparation for the Ethereum mainnet launch.

The upgrades proposed in this SIP represent four months of development work ([base-deploy-jun-02-2025](https://github.com/seamless-protocol/leverage-tokens/tree/base-deploy-jun-02-2025) → [base-deploy-oct-7-2025](https://github.com/seamless-protocol/leverage-tokens/tree/base-deploy-oct-7-2025)) and are essential for:

1. **Cross-chain consistency**: Aligning Base deployment with the upcoming Ethereum mainnet launch
2. **Performance improvements**: Reducing gas costs for common operations
3. **Feature parity**: Ensuring Base users have access to the latest protocol capabilities deployed on Ethereum

## Technical Overview

### Contracts Being Upgraded

1. **Base Leverage Token Implementation**
   - Current: Previous implementation from June 2025 deployment
   - New: `0x057A2a1CC13A9Af430976af912A27A05DE537673`
   - Upgrade mechanism: Beacon Proxy pattern via `UpgradeableBeacon`

2. **Base Leverage Manager Implementation**
   - Current: Previous implementation from June 2025 deployment
   - New: `0xeb0221bf6cdaa74c94129771d5b0c9a994bb2b7c`
   - Upgrade mechanism: UUPS Proxy pattern

### Key Improvements

1. Enhanced user experience and third party integration ease

2. Fee calculation improvements

3. Gas optimizations

4. Code quality and edge cases

### Breaking Changes

While these upgrades introduce breaking changes to the smart contract interfaces, they are fully backward compatible from a user perspective:

- **UI Compatibility**: The Seamless UI has been updated to support the new interfaces
- **Token Compatibility**: Existing leverage tokens remain fully functional
- **Position Safety**: All existing positions are preserved and protected during the upgrade

## Security Considerations

### Audit Status
The upgraded implementations have undergone comprehensive security review by Cantina (September, 2025). Full audit report available at [Cantina Security Report](https://cantina.xyz/portfolio/6291d7fa-62ac-4e18-9c2d-1403bfdd3c6c)

## Implementation Details

### Proposal Actions

The proposal will execute the following actions through the Seamless governance timelock:

1. **Grant UPGRADER_ROLE** to the timelock (required for UUPS upgrade)
2. **Upgrade Base Leverage Token** implementation via beacon proxy
3. **Upgrade Base Leverage Manager** implementation via UUPS proxy

Note: The `UPGRADER_ROLE` is retained by the timelock after execution to facilitate future upgrades if needed.

## Conclusion

This upgrade represents an important step in the evolution of Seamless Leverage Tokens on Base. By implementing these improvements, we ensure that Base users have access to an optimized, user-friendly, and feature-complete version of the protocol that matches the Ethereum mainnet deployment. The upgrades have been thoroughly tested and audited, with careful consideration given to maintaining backward compatibility.

We encourage the community to review the technical details and participate in the governance vote to advance the Seamless protocol on Base.

## References

- [Seamless Leverage Tokens Repository](https://github.com/seamless-protocol/leverage-tokens)
- [Old Implementation (June 2025)](https://github.com/seamless-protocol/leverage-tokens/tree/base-deploy-jun-02-2025)
- [New Implementation (October 2025)](https://github.com/seamless-protocol/leverage-tokens/tree/base-deploy-oct-7-2025)
- [Upgrade Diff: base-deploy-jun-02-2025 → base-deploy-oct-7-2025](https://github.com/seamless-protocol/leverage-tokens/compare/base-deploy-jun-02-2025...base-deploy-oct-7-2025)
- [Cantina Security Audit (September 2025)](https://cantina.xyz/portfolio/6291d7fa-62ac-4e18-9c2d-1403bfdd3c6c)
- [Audit Reports](https://github.com/seamless-protocol/leverage-tokens/tree/main/audits)
- [Technical Documentation](https://github.com/seamless-protocol/leverage-tokens/tree/main/docs)