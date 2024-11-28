# [SIP-33] Risk Parameter Updates

## Summary

Chaos labs has shared some analysis with the community and recommends some adjustments to risk paramters. This proposal implements the recommendations posted and supported in discourse [here](https://seamlessprotocol.discourse.group/t/pcp-interest-rate-and-ltv-parameter-recommendations/589).

## Context and motivation

|  | LTV | LT | Reserve Factor | Slope1 | Slope2 | UOptimal |
|--|--|--|--|--|--|--|
|AERO | 30.0%  |40.0%  |20%|  9.00% | 300.00% | 45.0%|
|cbBTC | 73.0%|   78.0%  | 20% | 4.00%  | 300.00% | 45.0% |
|cbETH  |65.0% → 75.0%|  72.0% → 79.0%|  10% | 7.00% | 300.00% | 45.0%|
|DAI  |77.0%  |80.0% | 10% | 7.00% → 5.50% | 75.00% | 90.0%|
|EURC  |65.0%  |70.0%  |20% | 7.00% | 75.00%|  90.0%|
|USDbC  |77.0% → 75.0%|  80.0%|  15% → 25% | 7.00%  |75.00%  |90.0%|
|USDC  |77.0%  |80.0%  |5% → 10% | 7.00% → 8.00% | 300.00% → 75.0% | 90.0%|
|WETH  |75.0% → 80.0%|  80.0% → 83.0%|  10% | 2.50% | 80.00% | 80.0% → 90.0%|
|wstETH | 65.0% → 75.0%|  72.0% → 79.0% | 10%  |7.00%  |300.00% | 45.0%|

## Resources/References

- Discourse discussion: [here](https://seamlessprotocol.discourse.group/t/pcp-interest-rate-and-ltv-parameter-recommendations/589)
- This proposal is prepared with the [Seamless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)
- Proposal actions and tests can be found [here](https://github.com/seamless-protocol/gov-proposals/tree/main/proposals/sip_33_risk_parameter_updates)
