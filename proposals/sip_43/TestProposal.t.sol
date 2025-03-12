// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { IMetaMorphoV1_1 } from
    "@seamless-governance/interfaces/IMetaMorphoV1_1.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";
import { IFeeKeeper } from "@seamless-governance/interfaces/IFeeKeeper.sol";
import { IRewardsDistributor } from
    "@aave/v3-periphery/contracts/rewards/interfaces/IRewardsDistributor.sol";

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        vm.rollFork(27510935);
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

    function test_timelockIsSetCorrectly_afterPassingProposal() public {
        // Pass the proposal
        _passProposalShortGov(proposal);

        IMetaMorphoV1_1 seamlessUSDCVault =
            IMetaMorphoV1_1(SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT);
        IMetaMorphoV1_1 seamlesscbBTCVault =
            IMetaMorphoV1_1(SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT);
        IMetaMorphoV1_1 seamlessWETHVault =
            IMetaMorphoV1_1(SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT);

        assertEq(seamlessUSDCVault.timelock(), 3 days);
        assertEq(seamlesscbBTCVault.timelock(), 3 days);
        assertEq(seamlessWETHVault.timelock(), 3 days);
    }

    function test_tokenForManualRateIsSetCorrectly_afterPassingProposal()
        public
    {
        // Pass the proposal
        _passProposalShortGov(proposal);

        IFeeKeeper feeKeeper = IFeeKeeper(SeamlessAddressBook.FEE_KEEPER);

        assertTrue(
            feeKeeper.getIsAllowedForManualRate(SeamlessAddressBook.SEAM)
        );
        assertTrue(
            feeKeeper.getIsAllowedForManualRate(SeamlessAddressBook.ESSEAM)
        );
    }

    function test_guardianCanConfigureAssetForSEAM_afterPassingProposal()
        public
    {
        // Test that guardian can configure SEAM asset
        IFeeKeeper feeKeeper = IFeeKeeper(SeamlessAddressBook.FEE_KEEPER);

        // Set some test values for configureAsset
        uint88 testRate = 1e18;
        uint32 distributionEnd = uint32(block.timestamp + 30 days);
        address transferStrategy = makeAddr("transferStrategy");
        vm.etch(transferStrategy, abi.encodePacked("some bytes"));
        address oracle = address(feeKeeper.getOracle());

        // Test that configureAsset reverts with SetManualRateNotAuthorized before proposal passes
        vm.startPrank(SeamlessAddressBook.GUARDIAN_MULTISIG);

        vm.expectRevert(IFeeKeeper.SetManualRateNotAuthorized.selector);
        feeKeeper.configureAsset(
            SeamlessAddressBook.SEAM,
            testRate,
            distributionEnd,
            transferStrategy,
            oracle
        );

        vm.expectRevert(IFeeKeeper.SetManualRateNotAuthorized.selector);
        feeKeeper.configureAsset(
            SeamlessAddressBook.ESSEAM,
            testRate,
            distributionEnd,
            transferStrategy,
            oracle
        );

        vm.stopPrank();

        // Pass the proposal
        _passProposalShortGov(proposal);

        // Impersonate guardian
        vm.startPrank(SeamlessAddressBook.GUARDIAN_MULTISIG);

        // Verify guardian can call configureAsset for SEAM and esSEAM
        feeKeeper.configureAsset(
            SeamlessAddressBook.SEAM,
            testRate,
            distributionEnd,
            transferStrategy,
            oracle
        );
        feeKeeper.configureAsset(
            SeamlessAddressBook.ESSEAM,
            testRate,
            distributionEnd,
            transferStrategy,
            oracle
        );

        vm.stopPrank();

        // Get rewards controller from feekeeper
        IRewardsDistributor rewardsController =
            IRewardsDistributor(feeKeeper.getController());

        (, uint256 actualEmissionPerSecond,, uint256 actualDistributionEnd) =
        rewardsController.getRewardsData(
            SeamlessAddressBook.stkSEAM, SeamlessAddressBook.SEAM
        );
        assertEq(actualEmissionPerSecond, testRate);
        assertEq(actualDistributionEnd, distributionEnd);

        (, actualEmissionPerSecond,, actualDistributionEnd) = rewardsController
            .getRewardsData(SeamlessAddressBook.stkSEAM, SeamlessAddressBook.ESSEAM);
        assertEq(actualEmissionPerSecond, testRate);
        assertEq(actualDistributionEnd, distributionEnd);
    }
}
