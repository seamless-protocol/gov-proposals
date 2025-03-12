// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { IMetaMorphoV1_1 } from
    "@seamless-governance/interfaces/IMetaMorphoV1_1.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        // vm.rollFork(27470920);
        proposal = new Proposal();
    }

    function test_feeRecipientIsSetCorrectly_afterPassingProposal() public {
        // Pass the proposal
        _passProposalShortGov(proposal);

        IMetaMorphoV1_1 seamlessUSDCVault =
            IMetaMorphoV1_1(SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT);
        IMetaMorphoV1_1 seamlesscbBTCVault =
            IMetaMorphoV1_1(SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT);
        IMetaMorphoV1_1 seamlessWETHVault =
            IMetaMorphoV1_1(SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT);

        assertEq(
            seamlessUSDCVault.feeRecipient(),
            SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT_FEE_SPLITTER
        );
        assertEq(
            seamlesscbBTCVault.feeRecipient(),
            SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT_FEE_SPLITTER
        );
        assertEq(
            seamlessWETHVault.feeRecipient(),
            SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT_FEE_SPLITTER
        );
    }
}
