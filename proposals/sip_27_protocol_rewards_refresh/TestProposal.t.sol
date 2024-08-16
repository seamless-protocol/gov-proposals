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
        proposal = new Proposal();
    }

    function test_SeamTransferedToGuardian_afterPassingProposal() public {
        IERC20 seam = IERC20(SeamlessAddressBook.SEAM);

        uint256 balanceBefore =
            seam.balanceOf(SeamlessAddressBook.GUARDIAN_MULTISIG);

        _passProposalShortGov(proposal);

        uint256 balanceAfter =
            seam.balanceOf(SeamlessAddressBook.GUARDIAN_MULTISIG);

        uint256 addedBalance = balanceAfter - balanceBefore;

        assertEq(addedBalance, 500_000 * 1e18);
    }

    function test_BothSeamEmissionManagersCalled() public {
        _passProposalShortGov(proposal);
        ISeamEmissionManager emissionManager1 =
            ISeamEmissionManager(SeamlessAddressBook.SEAM_EMISSION_MANAGER_1);
        ISeamEmissionManager emissionManager2 =
            ISeamEmissionManager(SeamlessAddressBook.SEAM_EMISSION_MANAGER_2);

        assertEq(emissionManager1.getLastClaimedTimestamp(), block.timestamp);
        assertEq(emissionManager2.getLastClaimedTimestamp(), block.timestamp);
    }
}
