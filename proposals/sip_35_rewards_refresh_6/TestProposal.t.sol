// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { Test, console } from "forge-std/Test.sol";
import { Proposal } from "./Proposal.sol";
import { ISeamEmissionManager } from
    "@seamless-governance/interfaces/ISeamEmissionManager.sol";
import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessGovProposal.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";
import { IGovernor } from "@openzeppelin/contracts/governance/IGovernor.sol";

contract TestProposal is Test, GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        vm.rollFork(23585681);
        proposal = new Proposal();
    }

    function test_seamClaimedAndTransferedToGuardian_afterPassingProposal()
        public
    {
        IERC20 seam = IERC20(SeamlessAddressBook.SEAM);

        uint256 guardianBalanceBefore =
            seam.balanceOf(SeamlessAddressBook.GUARDIAN_MULTISIG);
        uint256 timelockBalanceBefore =
            seam.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);
        uint256 emissionManagerBalanceBefore =
            seam.balanceOf(SeamlessAddressBook.SEAM_EMISSION_MANAGER_2);

        uint256 expectedEmissionClaimAmount =
            _expectedEmissionManagerClaimAmount();

        _passProposalShortGov(proposal);

        uint256 guardianBalanceAfter =
            seam.balanceOf(SeamlessAddressBook.GUARDIAN_MULTISIG);
        uint256 timelockBalanceAfter =
            seam.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);
        uint256 emissionManagerBalanceAfter =
            seam.balanceOf(SeamlessAddressBook.SEAM_EMISSION_MANAGER_2);

        assertEq(guardianBalanceAfter - guardianBalanceBefore, 750_000 * 1e18);
        assertEq(
            timelockBalanceAfter,
            timelockBalanceBefore + expectedEmissionClaimAmount
                - (750_000 * 1e18)
        );
        assertEq(
            emissionManagerBalanceBefore - emissionManagerBalanceAfter,
            expectedEmissionClaimAmount
        );
    }

    function _expectedEmissionManagerClaimAmount() internal returns (uint256) {
        uint256 snapshotId = vm.snapshot();

        _passProposalShortGov(proposal);

        uint64 currentTimestamp = uint64(block.timestamp);

        vm.revertTo(snapshotId);

        ISeamEmissionManager seamEmissionManager2 =
            ISeamEmissionManager(SeamlessAddressBook.SEAM_EMISSION_MANAGER_2);

        uint256 emissionPerSecond = seamEmissionManager2.getEmissionPerSecond();
        uint64 lastClaimedTimestamp =
            seamEmissionManager2.getLastClaimedTimestamp();

        return (currentTimestamp - lastClaimedTimestamp) * emissionPerSecond;
    }
}
