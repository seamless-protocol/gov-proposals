# [SIP-29] Listing cbBTC and EURC

## Summary

The Seamless community would like to add cbBTC and EURC to Seamless lending markets as collateral and borrowable assets.

## Context and motivation

Both cbBTC and EURC are new and important assets on Base and should be listed on Seamless Protocol.

### Chaos Labs Recommendations

**cbBTC**

|Parameter | Value (Base)|
|--|--|
|Isolation Mode | No|
|Borrowable | Yes|
|Collateral Enabled | Yes|
|Supply Cap | 200|
|Borrow Cap | 20|
|Debt Ceiling | -|
|LTV | 73%|
|LT | 78%|
|Liquidation Bonus | 10%|
|Liquidation Protocl Fee | 10%|
|Variable Base | 0%|
|Variable Slope1 | 4%|
|Variable Slope2 | 300%|
|Uoptimal | 45%|
|Reserve Factor | 20%|

**EURC**

|Parameter| Value|
|--|--|
|Isolation Mode | No|
|Borrowable | Yes|
|Collateral Enabled | Yes|
|Supply Cap | 3,000,000|
|Borrow Cap | 2,700,000|
|Debt Ceiling | -|
|LTV | 65.00%|
|LT | 70.00%|
|Liquidation Bonus | 7.50%|
|Liquidation Protocol Fee | 10.00%|
|Reserve Factor | 20.00%|
|Variable Base | 0.00%|
|Variable Slope1 | 7.00%|
|Variable Slope2 | 75.00%|
|Uoptimal | 90.00%|

## Resources/References

- Discourse discussions: [cbBTC here](https://seamlessprotocol.discourse.group/t/pcp-support-cbbtc-on-seamless/571) and [EURC here](https://seamlessprotocol.discourse.group/t/pcp-support-eurc-on-seamless/567)
- This proposal is prepared with the [Seamless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)
- Proposal actions and tests can be found [here](https://github.com/seamless-protocol/gov-proposals/tree/main/proposals/sip_29_listing_cbBTC_and_EURC)
