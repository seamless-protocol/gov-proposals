// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessGovProposal.sol";

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        vm.rollFork(25010689);
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

        assertEq(guardianBalanceAfter - guardianBalanceBefore, 625_000 * 1e18);
        assertEq(timelockBalanceAfter, timelockBalanceBefore - (625_000 * 1e18));
    }

    function test_morphoVaultOwnershipAccepted_afterPassingProposal() public {
        Ownable2Step vault =
            Ownable2Step(SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT);

        assertEq(vault.pendingOwner(), SeamlessAddressBook.TIMELOCK_SHORT);

        _passProposalShortGov(proposal);

        assertEq(vault.pendingOwner(), address(0));
        assertEq(vault.owner(), SeamlessAddressBook.TIMELOCK_SHORT);
    }
}
