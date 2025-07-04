// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessGovProposal.sol";

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        vm.rollFork(32430994);
        proposal = new Proposal();
    }

    function test_seamAndEsseamClaimedAndTransferedToTimelock_afterPassingProposal()
        public
    {
        IERC20 seam = IERC20(SeamlessAddressBook.SEAM);

        uint256 seamTransferStrategySeamBalance = IERC20(
            SeamlessAddressBook.SEAM
        ).balanceOf(SeamlessAddressBook.SEAM_TRANSFER_STRATEGY);

        uint256 esseamTransferStrategyEsseamBalance = IERC20(
            SeamlessAddressBook.SEAM
        ).balanceOf(SeamlessAddressBook.ESSEAM_TRANSFER_STRATEGY);

        uint256 timelockBalanceBefore =
            seam.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);

        _passProposalShortGov(proposal);

        uint256 timelockBalanceAfter =
            seam.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);

        assertEq(
            timelockBalanceAfter,
            timelockBalanceBefore + seamTransferStrategySeamBalance + esseamTransferStrategyEsseamBalance
        );
        assertEq(seam.balanceOf(SeamlessAddressBook.SEAM_TRANSFER_STRATEGY), 0);
        assertEq(seam.balanceOf(SeamlessAddressBook.ESSEAM_TRANSFER_STRATEGY), 0);
    }

    function test_usdcClaimedAndTransferedToTimelock_afterPassingProposal()
        public
    {
        IERC20 usdc = IERC20(SeamlessAddressBook.USDC);

        uint256 usdcTransferStrategyUsdcBalance = IERC20(
            SeamlessAddressBook.USDC
        ).balanceOf(SeamlessAddressBook.USDC_TRANSFER_STRATEGY);

        uint256 timelockBalanceBefore =
            usdc.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);

        _passProposalShortGov(proposal);

        uint256 timelockBalanceAfter =
            usdc.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);

        assertEq(
            timelockBalanceAfter,
            timelockBalanceBefore + usdcTransferStrategyUsdcBalance
        );
        assertEq(usdc.balanceOf(SeamlessAddressBook.USDC_TRANSFER_STRATEGY), 0);
    }

    function test_brettClaimedAndTransferedToTimelock_afterPassingProposal()
        public
    {
        IERC20 brett = IERC20(SeamlessAddressBook.BRETT);

        uint256 brettTransferStrategyBrettBalance = IERC20(
            SeamlessAddressBook.BRETT
        ).balanceOf(SeamlessAddressBook.BRETT_TRANSFER_STRATEGY);

        uint256 timelockBalanceBefore =
            brett.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);

        _passProposalShortGov(proposal);

        uint256 timelockBalanceAfter =
            brett.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);

        assertEq(
            timelockBalanceAfter,
            timelockBalanceBefore + brettTransferStrategyBrettBalance
        );
        assertEq(brett.balanceOf(SeamlessAddressBook.BRETT_TRANSFER_STRATEGY), 0);
    }
}
