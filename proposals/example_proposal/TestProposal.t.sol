// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {Proposal} from "./Proposal.sol";
import {SeamlessAddressBook} from "../../helpers/SeamlessAddressBook.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";
import {GovTestHelper} from "../../helpers/GovTestHelper.sol";

contract TestProposal is Test, GovTestHelper {
    Proposal public proposal;

    function setUp() public {
      proposal = new Proposal();
    }

    function test_seamTransfered() public {
      address testWallet = 0xaAaAaAaaAaAaAaaAaAAAAAAAAaaaAaAaAaaAaaAa;
      IERC20 seam = IERC20(SeamlessAddressBook.SEAM);
      
      uint256 balanceBeforeGov = seam.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);
      uint256 balanceBeforeTestWallet = seam.balanceOf(testWallet);

      _passProposalShortGov(proposal);

      uint256 balanceAfterGov = seam.balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);
      uint256 balanceAfterTestWallet = seam.balanceOf(testWallet);

      assertEq(balanceAfterTestWallet - balanceBeforeTestWallet, 300 ether);
      assertEq(balanceBeforeGov - balanceAfterGov, 300 ether);
    }
}
