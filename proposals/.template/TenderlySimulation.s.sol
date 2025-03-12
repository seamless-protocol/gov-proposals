// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { Script, console } from "forge-std/Script.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { IVotes } from "@openzeppelin/contracts/governance/utils/IVotes.sol";
import { Proposal } from "./Proposal.sol";
import { IGovernor } from "@openzeppelin/contracts/governance/IGovernor.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";
import { IVotes } from "@openzeppelin/contracts/governance/utils/IVotes.sol";

contract TenderlySimulation is Script {
    // Change this to GOVERNOR_LONG if the proposal is made on the long governor
    IGovernor governance = IGovernor(SeamlessAddressBook.GOVERNOR_SHORT);
    IVotes seam = IVotes(SeamlessAddressBook.SEAM);

    Proposal proposal = new Proposal();

    address proposerAddress = 0x67b6dB42115d94Cc3FE27E92a3d12bB224041ac0;
    uint256 proposerPk =
        0x82fe25cccae9752b856c8857de74671320277f92e737b2116a5d9739dec59a26;

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

    function setupProposer() public {
        console.log("Setting up proposer");

        _fundETH();
        _fundSEAM();

        vm.startBroadcast(proposerPk);
        seam.delegate(proposerAddress);
        vm.stopBroadcast();
    }

    function _fundSEAM() public {
        string memory params = string.concat(
            "[\"",
            Strings.toHexString(address(seam)),
            "\",[\"",
            Strings.toHexString(proposerAddress),
            "\"],\"0x13DA329B6336471800000\"]" // 1.5M SEAM which is quorum
        );
        vm.rpc("tenderly_setErc20Balance", params);
    }

    function _fundETH() public {
        string memory params = string.concat(
            "[[\"",
            Strings.toHexString(proposerAddress),
            "\"],\"0xDE0B6B3A7640000\"]" // 1 ETH
        );
        vm.rpc("tenderly_setBalance", params);
    }

    function createProposal(string memory descriptionPath) public {
        string memory description = vm.readFile(descriptionPath);

        vm.startBroadcast(proposerPk);
        governance.propose(
            proposal.getTargets(),
            proposal.getValues(),
            proposal.getCalldatas(),
            description
        );
        vm.stopBroadcast();
    }

    function increaseTimeVotingDelay() public {
        console.log("Increasing voting delay");
        string memory params = string.concat(
            "[",
            Strings.toString(block.timestamp + governance.votingDelay() + 1),
            "]"
        );
        vm.rpc("evm_setNextBlockTimestamp", params);
        vm.rpc("evm_mine", "[]");
    }

    function castVote(string memory descriptionPath) public {
        console.log("Casting vote");
        (uint256 proposalId,) = _getProposalData(descriptionPath);

        vm.startBroadcast(proposerPk);
        governance.castVote(proposalId, 1);
        vm.stopBroadcast();
    }

    function increaseTimeVotingPeriod() public {
        console.log("Increasing voting period");
        string memory params = string.concat(
            "[",
            Strings.toString(block.timestamp + governance.votingPeriod() + 1),
            "]"
        );
        vm.rpc("evm_setNextBlockTimestamp", params);
        vm.rpc("evm_mine", "[]");
    }

    function queueProposal(string memory descriptionPath) public {
        console.log("Queueing proposal");
        (, bytes32 descriptionHash) = _getProposalData(descriptionPath);

        vm.startBroadcast(proposerPk);
        governance.queue(
            proposal.getTargets(),
            proposal.getValues(),
            proposal.getCalldatas(),
            descriptionHash
        );
        vm.stopBroadcast();
    }

    function setTimeToProposalEta(string memory descriptionPath) public {
        console.log("Setting time to proposal eta");
        (uint256 proposalId,) = _getProposalData(descriptionPath);
        string memory params = string.concat(
            "[", Strings.toString(governance.proposalEta(proposalId) + 1), "]"
        );
        vm.rpc("evm_setNextBlockTimestamp", params);
        vm.rpc("evm_mine", "[]");
    }

    function executeProposal(string memory descriptionPath) public {
        console.log("Executing proposal");
        (, bytes32 descriptionHash) = _getProposalData(descriptionPath);

        vm.startBroadcast(proposerPk);
        governance.execute(
            proposal.getTargets(),
            proposal.getValues(),
            proposal.getCalldatas(),
            descriptionHash
        );
        vm.stopBroadcast();
    }
}
