# [SIP-32] Listing Restricted cbBTC Market

## Summary

Seamless core contributors propose the introduction of a restricted cbBTC market to be used for new ILM strategies. This would enable the creation of long cbBTC ILM strategies.

## Context and motivation

Aligning with [Seamless Protocol’s vision and mission](https://docs.seamlessprotocol.com/innovative-opportunities/vision-and-mission) to deliver a seamless DeFi experience, there has been a sharpened focus on developing more Integrated Liquidity Markets (ILMs). Following the successful rollout of the [custom wstETH market ](https://seamlessprotocol.discourse.group/t/pcp-2-market-parameter-adjustments-and-introduction-of-custom-wsteth-in-preparation-for-ilms/214), [custom WETH market](https://seamlessprotocol.discourse.group/t/pcp-5-introduction-of-custom-eth-market-to-be-used-for-ilms/262), [custom rUSDC](https://seamlessprotocol.discourse.group/t/pcp-introduction-of-restricted-usdc-market-to-be-used-for-ilms/536) and the launch of multiple ILM strategies, core contributors are now proposing the introduction of an isolated cbBTC market. This market will facilitate the creation of new strategies utilizing cbBTC as a collateral asset.

The aim of introducing this market is to ensure that cbBTC collateralized in ILM strategies cannot be borrowed further (i.e.: no rehypothecation). This setup ensures that strategies consistently maintain available collateral for withdrawals and debt repayment, thereby safeguarding against potential liquidation risks during rebalancing.

**Here are the proposed specifications for the restricted cbBTC market:**

* Supply cap: 200
* LTV: 78%
* LT: 78%
* Liquidation Bonus: 10%
* Isolation Mode: no
* Borrowable: no
* Flashloanable: no
* Collateral Enabled: yes

## Resources/References

* ILM Github - [GitHub - seamless-protocol/ilm: integrated liquidity market ](https://github.com/seamless-protocol/ilm)
* ILM specs - [ilm/SPECS.md at main · seamless-protocol/ilm · GitHub](https://github.com/seamless-protocol/ilm/blob/main/SPECS.md)
* How the permissioned cbBTC would work - [ilm/src/tokens/WrappedERC20PermissionedDeposit.sol at main · seamless-protocol/ilm · GitHub](https://github.com/seamless-protocol/ilm/blob/main/src/tokens/WrappedERC20PermissionedDeposit.sol)
* This proposal is prepared with the [Seamless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)
* Proposal actions and tests can be found [here](https://github.com/seamless-protocol/gov-proposals/tree/main/proposals/sip_32_listing_restricted_cbBTC_market)
* Discourse thread can be found [here](https://seamlessprotocol.discourse.group/t/pcp-introduction-of-restricted-cbbtc-market-to-be-used-for-ilms/582)
