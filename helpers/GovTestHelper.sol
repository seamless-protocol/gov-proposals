// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {SeamlessAddressBook} from "./SeamlessAddressBook.sol";
import {ISeamlessGovProposal} from "./ISeamlessGovProposal.sol";
import {IGovernor} from "@openzeppelin/contracts/governance/IGovernor.sol";
import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract GovTestHelper is Test  {
  function _passProposal(
    ISeamlessGovProposal proposal,
    IGovernor governance
  ) internal {
      address voter = makeAddr("voter");

      vm.startPrank(voter);

      // deal 10m SEAM to voter and delegate voting power
      deal(SeamlessAddressBook.SEAM, voter, 1e7 ether);
      IVotes(SeamlessAddressBook.SEAM).delegate(voter);

      // skip a bit of time to be able to make proposal after getting voting power
      skip(100);  

      // make proposal
      string memory description = "";
      bytes32 descriptionHash = keccak256(bytes(description));

      uint256 proposalId = governance.propose(
        proposal.getTargets(),
        proposal.getValues(),
        proposal.getCalldatas(),
        description
      );

      // pass voting delay time
      skip(governance.votingDelay() + 1);

      // vote and make sure voter has enough power to pass quorum alone
      governance.castVote(proposalId, 1);

      // pass voting period time
      skip(governance.votingPeriod() + 1);

      // queue proposal
      governance.queue(
        proposal.getTargets(),
        proposal.getValues(),
        proposal.getCalldatas(),
        descriptionHash
      );

      // set time to 
      vm.warp(governance.proposalEta(proposalId) + 1);

      // execute proposal
      governance.execute(
        proposal.getTargets(),
        proposal.getValues(),
        proposal.getCalldatas(),
        descriptionHash
      );

      vm.stopPrank();
    }

    function _passProposalShortGov(ISeamlessGovProposal proposal) internal {
      _passProposal(
        proposal,
        IGovernor(SeamlessAddressBook.GOVERNOR_SHORT)
      );
    }

    function _passProposalLongGov(ISeamlessGovProposal proposal) internal {
      _passProposal(
        proposal,
        IGovernor(SeamlessAddressBook.GOVERNOR_LONG)
      );
    }
}