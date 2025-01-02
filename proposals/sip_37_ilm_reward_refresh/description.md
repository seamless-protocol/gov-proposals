# [SIP-37] ILM Reward Refresh test

## Summary

Per the most recent token emission schedule, ILM rewards are currently ending soon. This is a proposal proposing an extension of the ILM reward budget by claiming more SEAM from the master emissions vesting smart contract.

The following proposal outlines adjustments to the SEAM emissions budget for ILM rewards. The proposed plan is in line with ongoing token emission expansion (see [this](https://seamlessprotocol.discourse.group/t/gp-7-expanding-protocol-reward-categories-increasing-token-emission-budget-for-seamless/605) proposal for more details).

Proposal Highlights:

1. **Continue ILM (v1.0) Rewards?** YES
2. **Schedule?** Implement a quarterly cadence while retaining the flexibility to adjust on a monthly basis. The proposed schedule would allocate rewards from January 1, 2025, to March 31, 2025.
3. **Reward Type?** Utilize primarily esSEAM for rewards, ensuring alignment with current DAO strategies.
4. **Proposed Amount?** Allocate 125,000 esSEAM (41,666.67 esSEAM per month) to the ILM pools for Q1 2025. This proposed amount is in line with the increased budget described in the recently passed token emissions proposal found [here](https://seamlessprotocol.discourse.group/t/gp-expanding-protocol-reward-categories-increasing-token-emission-budget-for-seamless/605).

This proposal leans into the protocol’s most effective TVL-per-reward ILMs, incorporates rewards to ALL ILMs, and reserves the flexibility to adjust the program based on performance metrics or market conditions.

## Context and motivation

Please reference the wider token emissions discussion [here](https://seamlessprotocol.discourse.group/t/gp-expanding-protocol-reward-categories-increasing-token-emission-budget-for-seamless/605) for additional context. The TLDR is:

The DAO’s strategic priority is to accelerate growth during an anticipated period of heightened crypto momentum. The motivation for this proposal stems from:

1. **Market Opportunity:** With bullish sentiment due to macroeconomic trends, now is an opportune moment to position Seamless Protocol for capturing increased TVL and user activity.
2. **Product Expansion:** The addition of new markets, new ILMs, and new products requires competitive incentives to drive adoption.
3. **Sustainable Growth:** With [~55% of token supply](https://docs.seamlessprotocol.com/governance/seam-tokenomics) held by the DAO and budgeted for rewards, turning up emissions in the early years, the DAO can maximize market presence while building a long-term framework for emissions decay and sustainability over time. The current market environment offers a rare “stars-aligning” chance to capitalize on increased activity and user interest in Base. By ramping up emissions in the near term, Seamless can amplify its total value locked (TVL), attract new users, and strengthen its competitive position as the go-to lending/borrowing platform on Base. This approach will allow the protocol to regain mindshare and establish itself as a top choice for users and liquidity providers as Base continues its growth trajectory. In the medium to longer term this should translate to increased fee generation and rewards via tokenomics.
4. **Incorporating community feedback/learnings:** The Seamless community has voiced their support for rewards in the past and to extend reward schedules vs. letting them expire. Taking this learning, pushing this proposal forward aligns with sentiment on past proposals.

As per before, rewards schedules will be based on recommendations from ecosystem partners/contributors, and this represents a maximum ~3.5 month budget (it is possible less rewards are emitted during this time, and a “surplus” is run if needed).

## Specifications/Technicals

Under this proposal, 41,666.67 esSEAM per month will be allocated for ILM pool rewards, totaling 125,000 esSEAM for the quarter (1/1/2025 to 3/31/2025). Per the previously executed SIPs, reward schedules will continue to be set by the Guardian Multisig. esSEAM would be loaded into the esSEAM reward smart contracts of the ILM markets to provide esSEAM rewards.

A suggested breakdown of these rewards across existing ILMs as follows:

| ILM                                          | Current (Monthly) esSEAM Budget | Proposed (Monthly) esSEAM Budget | Delta      |
| -------------------------------------------- | ------------------------------- | -------------------------------- | ---------- |
| WSTETH/ETH                                   | 8,000                           | 7,500                            | -500       |
| 1.5x ETH Long                                | 8,000                           | 7,000                            | -1,000     |
| 3.0x ETH Long                                | 3,000                           | 5,000                            | +2,000     |
| 1.5x cbBTC Long                              | 8,000                           | 7,000                            | -1,000     |
| 3.0x cbBTC Long                              | 3,000                           | 4,000                            | +1,000     |
| 1.5x ETH Short                               | 0                               | 1,000                            | +1,000     |
| Misc to be budgeted based on ILM performance | 0                               | 10,166.67                        | +10,166.67 |
| **Total**                                    | 30,000                          | 41,666.67                        | +11,666.67 |

Technical specifications/payload will be presented as soon as possible if the discussion period ends with a positive support.

Given the current tight timelines, it is suggested this proposal be fast tracked or surplus reward SEAM budget will be utilized to tie over ILMs at current reward rates until 1/7/2025, to allow for this governance process to play out.

## Resources/References

- Discourse discussion [here](https://seamlessprotocol.discourse.group/t/pcp-seamless-protocol-ilm-rewards-refresh-q1-2025/712)
- This proposal is prepared with the [Seamless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)
- Proposal actions and tests can be found [here](https://github.com/seamless-protocol/gov-proposals/tree/main/proposals/sip_37_ilm_reward_refresh)
