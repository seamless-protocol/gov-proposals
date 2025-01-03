// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessGovProposal.sol";
import { Proposal } from "./Proposal.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        vm.rollFork(24534330);
        proposal = new Proposal();
    }

    function test_seamTransferedToGuardian_afterPassingProposal() public {
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

        assertEq(guardianBalanceAfter - guardianBalanceBefore, 125_000 * 1e18);
        assertEq(timelockBalanceAfter, timelockBalanceBefore - (125_000 * 1e18));
    }
}
