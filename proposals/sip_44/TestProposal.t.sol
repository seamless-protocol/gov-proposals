// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessGovProposal.sol";
import { ISeamEmissionManager } from
    "@seamless-governance/interfaces/ISeamEmissionManager.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        vm.rollFork(28034664);
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
        uint256 emissionManagerBalanceBefore1 =
            seam.balanceOf(SeamlessAddressBook.SEAM_EMISSION_MANAGER_1);
        uint256 emissionManagerBalanceBefore2 =
            seam.balanceOf(SeamlessAddressBook.SEAM_EMISSION_MANAGER_2);

        uint256 expectedEmissionClaimAmount1 =
            _expectedEmissionManagerClaimAmount(ISeamEmissionManager(SeamlessAddressBook.SEAM_EMISSION_MANAGER_1));

        uint256 expectedEmissionClaimAmount2 =
            _expectedEmissionManagerClaimAmount(ISeamEmissionManager(SeamlessAddressBook.SEAM_EMISSION_MANAGER_2));

        _passProposalShortGov(proposal);

        uint256 guardianBalanceAfter =
            seam.balanceOf(SeamlessAddressBook.GUARDIAN_MULTISIG);
        uint256 timelockBalanceAfter =
            seam.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);
        uint256 emissionManagerBalanceAfter1 =
                seam.balanceOf(SeamlessAddressBook.SEAM_EMISSION_MANAGER_1);
        uint256 emissionManagerBalanceAfter2 =
            seam.balanceOf(SeamlessAddressBook.SEAM_EMISSION_MANAGER_2);

        assertEq(guardianBalanceAfter, guardianBalanceBefore + (2_000_000 * 1e18));
        assertEq(
            timelockBalanceAfter,
            timelockBalanceBefore + expectedEmissionClaimAmount1 + expectedEmissionClaimAmount2
                - (2_000_000 * 1e18)
        );
        assertEq(
            emissionManagerBalanceBefore1 - emissionManagerBalanceAfter1,
            expectedEmissionClaimAmount1
        );
        assertEq(
            emissionManagerBalanceBefore2 - emissionManagerBalanceAfter2,
            expectedEmissionClaimAmount2
        );
    }

    function _expectedEmissionManagerClaimAmount(ISeamEmissionManager emissionManager) internal returns (uint256) {
        uint256 snapshotId = vm.snapshot();

        _passProposalShortGov(proposal);

        uint64 currentTimestamp = uint64(block.timestamp);

        require(vm.revertToAndDelete(snapshotId), "Failed to revert to snapshot");

        uint256 emissionPerSecond = emissionManager.getEmissionPerSecond();
        uint64 lastClaimedTimestamp =
            emissionManager.getLastClaimedTimestamp();

        return (currentTimestamp - lastClaimedTimestamp) * emissionPerSecond;
    }
}
