# [SIP-27] Protocol Rewards Refresh 4

## Summary

Platform reward emissions are ending on August 20th (in 12 days). Proposing an extension of the platform reward budget by drawing down on the SEAM in the short governor timelock and claiming more SEAM from the master emissions vesting smart contract.

Proposal for platforms rewards are:
- **Continue rewards?** YES
- **Schedule?** To be consistent with previous requests, continuing the cadence of 60 days (~2 months) - starting 8/20/24 (ASAP given the governance process timelines). Community re-examination and discussion to occur once a month or as-needed, as reward schedules can be updated/modified by Community Guardian (as of [SIP-7] execution).
- **Reward type?** Utilize primarily esSEAM (with a small SEAM budget that will default to esSEAM if not utilized)
- **Amount?** Current suggestion is to use 500,000 SEAM from the short governor timelock to be utilized as a two month budget across all existing/to-be-launched markets on Seamless Protocol during this time period


## Context and motivation

[Rewards refresh #3](https://seamlessprotocol.discourse.group/t/pcp-21-protocol-rewards-refresh-3-base-onchain-summer-is-here/509/11) 1 was launched with the introduction of support from Gauntlet Network for community-level reward optimization analysis. This resulted in immediate impacts to Seamless Protocol, as the protocol grew (to almost $100m TVL) and more effectively was able to utilize rewards. Despite the latest market trends, Seamless TVL has been more robust/resilient to other similar platforms on Base.

As Gauntlet will continue to provide monthly reward optimization recommendations and the platform looks to maintain its position and also grow in certain areas (i.e. ILMs), this proposal suggests another reward budget renewal at the previous budget of 500,000 SEAM (holding steady from the previous request). The DAO will primarily convert 480,000 SEAM to esSEAM, with the remaining 20,000 SEAM available as liquid rewards. If there is any unused SEAM from this 20k, it will also be converted to esSEAM.

As per before, rewards schedules will be based on recommendations from ecosystem partners/contributors, and this represents a maximum 2 month budget (it is possible less rewards are emitted during this time, and a “surplus” is run).

Specifications/Technicals
Under this proposal, the rewards pool for markets on Seamless Protocol will gain an additional 500,000 SEAM budget to be deployed over two months. This SEAM will be sourced from the short governor timelock (and in a corresponding move, the short governor timelock will claim some of the DAO vested SEAM back into the wallet). Per the previously executed SIPs, reward schedules continued to be set by the Guardian Multisig.

## Resources/References

- This proposal is prepared with the [Seamless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)
- Proposal actions and tests can be found [here](https://github.com/seamless-protocol/gov-proposals/tree/main/proposals/sip_27_sip_27_protocol_rewards_refresh)
