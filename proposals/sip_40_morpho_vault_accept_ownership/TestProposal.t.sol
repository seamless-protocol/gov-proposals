// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessGovProposal.sol";

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        vm.rollFork(26300545);
        proposal = new Proposal();
    }

    function test_morphoVaultOwnershipAccepted_afterPassingProposal() public {
        Ownable2Step cbBTCVault =
            Ownable2Step(SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT);
        
        Ownable2Step wethVault =
            Ownable2Step(SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT);

        assertEq(cbBTCVault.pendingOwner(), SeamlessAddressBook.TIMELOCK_SHORT);

        assertEq(wethVault.pendingOwner(), SeamlessAddressBook.TIMELOCK_SHORT);

        _passProposalShortGov(proposal);

        assertEq(cbBTCVault.pendingOwner(), address(0));
        assertEq(cbBTCVault.owner(), SeamlessAddressBook.TIMELOCK_SHORT);

        assertEq(wethVault.pendingOwner(), address(0));
        assertEq(wethVault.owner(), SeamlessAddressBook.TIMELOCK_SHORT);
    }
}
