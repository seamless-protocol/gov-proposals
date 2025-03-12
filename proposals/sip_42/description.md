# [SIP-42] Enable stkSEAM to be used for Governance

## Summary
Enable stkSEAM voting power to be counted in addition to SEAM and esSEAM voting power on Seamless governance proposals.

## Context and Motivation
The stkSEAM token is being introduced as part of the Seamless tokenomics proposal outlined in [this Discourse post](https://seamlessprotocol.discourse.group/t/gp-activating-seam-tokenomics/585). This token represents staked SEAM within the protocol.

Currently, the Seamless governance system only allows voting with SEAM and esSEAM tokens. This proposal aims to upgrade the Seamless governor contracts to enable stkSEAM as a votable token for governance alongside SEAM and esSEAM. This upgrade must be initiated through the Seamless long governor since it involves a fundamental change to the governance structure.

By implementing this change, stkSEAM holders will be able to participate in Seamless governance, ensuring that users who have demonstrated their commitment to the protocol through staking can have a voice in decision-making.

## Resources/References
- Relevant Discourse discussion: [here](https://seamlessprotocol.discourse.group/t/gp-activating-seam-tokenomics/585)
- This proposal is prepared with the [Seamless Governance Proposals tools](https://github.com/seamless-protocol/gov-proposals)
- Proposal actions and tests can be found [here](https://github.com/seamless-protocol/gov-proposals/tree/main/proposals/sip_42)