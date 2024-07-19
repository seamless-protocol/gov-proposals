# [SIP-26] LTV Parameter Adjustments of Custom rwstETH and rWETH

## Summary
- Increase LTV and liquidation threshold parameters on the custom rwstETH and rWETH markets

## Context and motivation
Discourse [link](https://seamlessprotocol.discourse.group/t/pcp-ltv-parameter-adjustments-of-custom-rwsteth-and-rweth-markets-for-new-ilms/530)

Making these updates to LTV and corresponding liquidation thresholds will allow for future new ILM strategies to be launched, most notably higher leverage strategies of the current wsteth/eth and eth/usdc ILMs.
Liquidation bonus is adjusted up to the limitation of new liquidation threshold.

This proposal is to set the following parameters:

[1] custom wstETH market (rwstETH):
- LTV to 90%
- Liquidation threshold to 93%
- Liquidation bonus to 105%

[2] custom WETH market (rWETH):
- LTV to 90%
- Liquidation threshold to 93%
- Liquidation bonus to 105%

## Resources/References
- This proposal is prepared with the [Samless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)
- Proposal actions and tests can be found [here](https://github.com/seamless-protocol/gov-proposals/pull/2)
