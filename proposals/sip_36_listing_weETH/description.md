# [SIP-36] Listing weETH

## Summary

The Seamless community would like to add weETH to the Seamless lending markets as a collateral and borrow asset.

## Context and motivation

weETH is an important asset on Base and should be listed on Seamless Protocol. Additionally, the community believes a restricted version of weETH should also be listed in preparation to launch an ILM vault using weETH as collateral.

### Risk Parameters

**weETH**

| Parameter                | Value          |
| ------------------------ | -------------- |
| Isolation Mode           | No             |
| Borrowable               | Yes            |
| Collateral Enabled       | Yes            |
| Supply Cap               | 900            |
| Borrow Cap               | 450            |
| Debt Ceiling             | -              |
| LTV                      | 72.5%          |
| LT                       | 75%            |
| Liquidation Bonus        | 7.50%          |
| Liquidation Protocol Fee | 10.00%         |
| Reserve Factor           | 45.00%         |
| Variable Base            | 0.00%          |
| Variable Slope1          | 7.00%          |
| Variable Slope2          | 75.00%         |
| Uoptimal                 | 45.00%         |
| E-Mode Category          | ETH Correlated |

**rweETH**

| Parameter                | Value  |
| ------------------------ | ------ |
| Isolation Mode           | No     |
| Borrowable               | No     |
| Collateral Enabled       | Yes    |
| Supply Cap               | 900    |
| Borrow Cap               | 0      |
| Debt Ceiling             | -      |
| LTV                      | 75%    |
| LT                       | 75%    |
| Liquidation Bonus        | 7.50%  |
| Liquidation Protocol Fee | 10.00% |
| Reserve Factor           | 45.00% |
| Variable Base            | 0.00%  |
| Variable Slope1          | 7.00%  |
| Variable Slope2          | 75.00% |
| Uoptimal                 | 45.00% |

## Resources/References

- ILM Github - [GitHub - seamless-protocol/ilm: integrated liquidity market ](https://github.com/seamless-protocol/ilm)
- ILM specs - [ilm/SPECS.md at main · seamless-protocol/ilm · GitHub](https://github.com/seamless-protocol/ilm/blob/main/SPECS.md)
- How the permissioned weETH would work - [ilm/src/tokens/WrappedERC20PermissionedDeposit.sol at main · seamless-protocol/ilm · GitHub](https://github.com/seamless-protocol/ilm/blob/main/src/tokens/WrappedERC20PermissionedDeposit.sol)
- This proposal is prepared with the [Seamless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)
- Proposal actions and tests can be found [here](https://github.com/seamless-protocol/gov-proposals/tree/main/proposals/sip_36_listing_weETH)
- Discourse thread can be found [here](https://seamlessprotocol.discourse.group/t/pcp-support-weeth-on-seamless/591)
