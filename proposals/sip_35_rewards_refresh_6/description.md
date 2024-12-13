# [SIP-35] Protocol Rewards Refresh 6

## Summary

Platform reward emissions are ending on January 1, 2025. Proposing an extension of the platform reward budget by drawing down on the SEAM in the short governor timelock and claiming more SEAM from the master emissions vesting smart contract.

Proposal for platforms rewards are:

- **Continue rewards?** YES
- **Schedule?** Extend the schedule to align to a quarterly cadence, this aligns lend/borrow platform rewards schedules and refreshes to align with ongoing discussions on expanding token emissions categories and taking a quarterly cadence across all categories (see [this](https://seamlessprotocol.discourse.group/t/gp-7-expanding-protocol-reward-categories-increasing-token-emission-budget-for-seamless/605) proposal for more details) - this means rewards would start on 12/20/24 and go until 3/31/2025 - to now align with a quarterly schedule. Community re-examination and discussion to occur once a month or as-needed, as reward schedules can be updated/modified by Community Guardian (as of [SIP-7] execution).
- **Reward type?** Utilize primarily esSEAM (with a small SEAM budget that will default to esSEAM if not utilized)
- **Amount?** 3,000,000 \* (1/4) = 750,000 + 125,000 = 825,000 SEAM tokens. The current suggestion is to pre-emptively implement the increased budget described in the current outstanding (to be voted on soon) token emissions proposal found [here](https://seamlessprotocol.discourse.group/t/gp-7-expanding-protocol-reward-categories-increasing-token-emission-budget-for-seamless/605), which budgets 3M SEAM tokens per year, or 750k SEAM tokens per quarter. Additionally, the 1 month of additional emissions from December to January would follow the previous emission schedule (500,000 per two months, for 2 weeks this would be ~125,000 SEAM tokens). This SEAM would be sourced from the Guardian (which has custodied SEAM for this specific reason) and the short governor timelock to be utilized as a three month budget across all existing/to-be-launched markets on Seamless Protocol during this time period

## Context and motivation

Please reference the wider token emissions discussion [here](https://seamlessprotocol.discourse.group/t/gp-7-expanding-protocol-reward-categories-increasing-token-emission-budget-for-seamless/605) for additional context. The TLDR is:

The DAO’s strategic priority is to accelerate growth during an anticipated period of heightened crypto momentum. The motivation for this proposal stems from:

1. **Market Opportunity:** With bullish sentiment due to macroeconomic trends, now is an opportune moment to position Seamless Protocol for capturing increased TVL and user activity.
2. **Product Expansion:** The addition of new markets, new ILMs, and new products requires competitive incentives to drive adoption.
3. **Sustainable Growth:** With [~55% of token supply](https://docs.seamlessprotocol.com/governance/seam-tokenomics) held by the DAO and budgeted for rewards, turning up emissions in the early years, the DAO can maximize market presence while building a long-term framework for emissions decay and sustainability over time. The current market environment offers a rare “stars-aligning” chance to capitalize on increased activity and user interest in Base. By ramping up emissions in the near term, Seamless can amplify its total value locked (TVL), attract new users, and strengthen its competitive position as the go-to lending/borrowing platform on Base. This approach will allow the protocol to regain mindshare and establish itself as a top choice for users and liquidity providers as Base continues its growth trajectory. In the medium to longer term this should translate to increased fee generation and rewards via tokenomics.

As per before, rewards schedules will be based on recommendations from ecosystem partners/contributors, and this represents a maximum ~3.5 month budget (it is possible less rewards are emitted during this time, and a “surplus” is run).

## Resources/References

- Discourse discussion [here](https://seamlessprotocol.discourse.group/t/pcp-seamless-protocol-legacy-lend-borrow-platform-rewards-refresh-6/620)
- This proposal is prepared with the [Seamless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)
- Proposal actions and tests can be found [here](https://github.com/seamless-protocol/gov-proposals/tree/main/proposals/sip_335_protocol_rewards_refresh_6)
