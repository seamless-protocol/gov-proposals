// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import { Test, console } from "forge-std/Test.sol";
import { Proposal } from "./Proposal.sol";
import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessGovProposal.sol";
import { ISeamEmissionManager } from
    "@seamless-governance/interfaces/ISeamEmissionManager.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract TestProposal is Test, GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        vm.rollFork(18529851);
        proposal = new Proposal();
    }

    function test_SeamTransferedToGuardian_afterPassingProposal() public {
        IERC20 seam = IERC20(SeamlessAddressBook.SEAM);

        uint256 guardianBalanceBefore =
            seam.balanceOf(SeamlessAddressBook.GUARDIAN_MULTISIG);
        uint256 timelockBalanceBefore =
            seam.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);

        _passProposalShortGov(proposal);

        uint256 guardianBalanceAfter =
            seam.balanceOf(SeamlessAddressBook.GUARDIAN_MULTISIG);
        uint256 timelockBalanceAfter =
            seam.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);

        assertEq(guardianBalanceAfter - guardianBalanceBefore, 500_000 * 1e18);
        assertEq(timelockBalanceBefore - timelockBalanceAfter, 500_000 * 1e18);
    }
}
