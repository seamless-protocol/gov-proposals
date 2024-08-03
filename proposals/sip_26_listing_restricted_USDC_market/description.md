# [SIP-26] Listing Restricted USDC Market

## Summary

Seamless core contributors propose the introduction of a restricted USDC market to be used for new ILM strategies. This would enable the creation of short ILM strategies.

## Context and motivation

Aligning with Seamless Protocol’s vision and mission to deliver a seamless DeFi experience, there has been a sharpened focus on developing more Integrated Liquidity Markets (ILMs). Following the successful rollout of the custom wstETH market , custom WETH market 1 and the launch of multiple ILM strategies, core contributors are now proposing the introduction of an isolated USDC market. This market will facilitate the creation of new strategies utilizing USDC as a collateral asset. Currently there exist only long (bullish) strategies, but many community members have been asking for short (bear) strategies.

The aim of introducing this market is to ensure that USDC collateralized in ILM strategies cannot be borrowed further. This setup ensures that strategies consistently maintain available collateral for withdrawals and debt repayment, thereby safeguarding against potential liquidation risks during rebalancing.

### Risk Analysis (from Chaos Labs)

After a review of on-chain liquidity and ILM strategies, Chaos Labs recommends slightly more conservative rUSDC parameters than those of USDC in the core Seamless market. It is prudent to set collateral parameters slightly more conservatively given the heightened risk in this market, whereas many USDC suppliers on Seamless maintain deposit-only positions or are looping USDC with itself. The recommended are battle-tested parameters that will properly protect the protocol during times of volatility. The LTV set to 75% will allow a max initial leverage in the market of 4x.

Given USDC’s strong liquidity and peg stability, we recommend a Liquidation Bonus of 5%. Additionally we recommend the supply cap be set according to our initial asset listing methodology, at 2x the amount of liquidity available below the liquidation bonus price impact. This leads us to a recommendation of 40M.

|Parameter |Value|
|--|--|
|Collateral Enabled|Yes|
|Borrowable|No|
|Isolation Mode|No|
|Flashloanable|No|
|LTV|75%|
|LT|78%|
|Liquidation Bonus|5%|
|Supply Cap|40,000,000|
|Borrow Cap|0|

## Resources/References
- This proposal is prepared with the [Samless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)
- Proposal actions and tests can be found [here](https://github.com/seamless-protocol/gov-proposals/tree/main/proposals/sip_26_listing_restricted_USDC_market)