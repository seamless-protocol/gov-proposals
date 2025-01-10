// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessGovProposal.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        vm.rollFork(24836504);
        proposal = new Proposal();
    }

    function test_SeamTransferedToAeraAdmin_afterPassingProposal() public {
        IERC20 seam = IERC20(SeamlessAddressBook.SEAM);

        uint256 aeraAdminBalanceBefore =
            seam.balanceOf(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN);
        uint256 timelockBalanceBefore =
            seam.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);

        _passProposalShortGov(proposal);

        uint256 aeraAdminBalanceAfter =
            seam.balanceOf(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN);
        uint256 timelockBalanceAfter =
            seam.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);

        assertEq(
            aeraAdminBalanceAfter - aeraAdminBalanceBefore, 1_250_000 * 1e18
        );
        assertEq(timelockBalanceBefore - timelockBalanceAfter, 1_250_000 * 1e18);
    }
}
