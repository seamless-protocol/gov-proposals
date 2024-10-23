// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { Script, console } from "forge-std/Script.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { IVotes } from "@openzeppelin/contracts/governance/utils/IVotes.sol";
import { Proposal } from "./Proposal.sol";
import { IGovernor } from "@openzeppelin/contracts/governance/IGovernor.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";

/// @dev Requires that SIM_VOTER_ADDRESS already has enough delegated votes
/// to be able to pass proposal by being the only voter
contract TenderlySimulation is Script {
    // Change this to GOVERNOR_LONG if the proposal is made on the long governor
    IGovernor governance = IGovernor(SeamlessAddressBook.GOVERNOR_SHORT);

    Proposal proposal = new Proposal();

    function _getProposalData(string memory descriptionPath)
        internal
        view
        returns (uint256 proposalId, bytes32 descriptionHash)
    {
        string memory description = vm.readFile(descriptionPath);
        descriptionHash = keccak256(bytes(description));

        proposalId = governance.hashProposal(
            proposal.getTargets(),
            proposal.getValues(),
            proposal.getCalldatas(),
            descriptionHash
        );
    }

    function increaseTimeVotingDelay() public {
        string memory params = string.concat(
            "[",
            Strings.toString(block.timestamp + governance.votingDelay() + 1),
            "]"
        );
        vm.rpc("evm_setNextBlockTimestamp", params);
        vm.rpc("evm_mine", "[]");
    }

    function castVote(string memory descriptionPath) public {
        (uint256 proposalId,) = _getProposalData(descriptionPath);

        address proposerAddress = vm.envAddress("SIM_VOTER_ADDRESS");
        vm.startBroadcast(proposerAddress);
        governance.castVote(proposalId, 1);
        vm.stopBroadcast();
    }

    function increaseTimeVotingPeriod() public {
        string memory params = string.concat(
            "[",
            Strings.toString(block.timestamp + governance.votingPeriod() + 1),
            "]"
        );
        vm.rpc("evm_setNextBlockTimestamp", params);
        vm.rpc("evm_mine", "[]");
    }

    function queueProposal(string memory descriptionPath) public {
        (, bytes32 descriptionHash) = _getProposalData(descriptionPath);

        address proposerAddress = vm.envAddress("SIM_VOTER_ADDRESS");
        vm.startBroadcast(proposerAddress);
        governance.queue(
            proposal.getTargets(),
            proposal.getValues(),
            proposal.getCalldatas(),
            descriptionHash
        );
        vm.stopBroadcast();
    }

    function setTimeToProposalEta(string memory descriptionPath) public {
        (uint256 proposalId,) = _getProposalData(descriptionPath);
        string memory params = string.concat(
            "[", Strings.toString(governance.proposalEta(proposalId) + 1), "]"
        );
        vm.rpc("evm_setNextBlockTimestamp", params);
        vm.rpc("evm_mine", "[]");
    }

    function executeProposal(string memory descriptionPath) public {
        (, bytes32 descriptionHash) = _getProposalData(descriptionPath);

        address proposerAddress = vm.envAddress("SIM_VOTER_ADDRESS");
        vm.startBroadcast(proposerAddress);
        governance.execute(
            proposal.getTargets(),
            proposal.getValues(),
            proposal.getCalldatas(),
            descriptionHash
        );
        vm.stopBroadcast();
    }
}
