// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { Script, console } from "forge-std/Script.sol";
import { StdCheats } from "forge-std/StdCheats.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";
import { Proposal } from "./Proposal.sol";
import { IGovernor } from "@openzeppelin/contracts/governance/IGovernor.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";
import {IVotes} from "@openzeppelin/contracts/governance/utils/IVotes.sol";

contract DeployProposal is Script, StdCheats {
    function setUp() public { }

    function run(string memory descriptionPath, bool simulateExecution) public {
        Proposal proposal = new Proposal();

        console.log("simulating: ", simulateExecution);

        // Change this to GOVERNOR_LONG if you want to make proposal on the long governor
        IGovernor governance = IGovernor(SeamlessAddressBook.GOVERNOR_SHORT);

        string memory description = vm.readFile(descriptionPath);
        
        address proposerAddress = vm.envAddress("PROPOSER_ADDRESS");
        console.log(proposerAddress);
        vm.startBroadcast(proposerAddress);
        uint256 proposalId = governance.propose(
            proposal.getTargets(),
            proposal.getValues(),
            proposal.getCalldatas(),
            description
        );
        vm.stopBroadcast();

        if (simulateExecution) {
            bytes32 descriptionHash = keccak256(bytes(description));
            _tenderlyVotingAndExecution(proposal, proposalId, governance, descriptionHash);
        }
    }

    function increaseTimeVotingDelay() public {
        vm.rpc("evm_increaseTime", '["0x2A301\"]');
        vm.rpc("evm_mine", "[]");
    }   

    function _tenderlyVotingAndExecution(
        Proposal proposal, 
        uint256 proposalId,
        IGovernor governance,
        bytes32 descriptionHash
    ) internal {
        // vm.rpc("tenderly_addBalance", '[["0x4dafb91f6682136032c004768837e60bc099e52c"], "0x084595161401484a000000"]');

        (address voter, uint256 voterPk) = makeAddrAndKey("voter");
        vm.startBroadcast(voterPk);

        // deal 10m SEAM to voter and delegate voting power
        // deal(SeamlessAddressBook.SEAM, voter, 1e7 ether);
        // string memory params = string.concat(
        //     '["',
        //     _addressToString(SeamlessAddressBook.SEAM),
        //     '", "',
        //     _addressToString(voter),
        //     '", "',
        //     Strings.toHexString(1e7 ether),
        //     '"]'
        // );

        // console.log(params);
        // vm.rpc("tenderly_setErc20Balance", '["0x1c7a460413dd4e964f96d8dfc56e7223ce88cd85", "0x4dafb91f6682136032c004768837e60bc099e52c", "0x084595161401484a000000"]');

        // IVotes(SeamlessAddressBook.SEAM).delegate(voter);

        // // skip a bit of time to be able to make proposal after getting voting power
        // skip(100);  
        // vm.rpc("evm_increaseTime", '["0x64"]');
        // vm.rpc("evm_mine", "[]");

        // skip(governance.votingDelay() + 1);
        // vm.rpc("evm_increaseTime", '["0x2A301\"]');
        // vm.rpc("evm_mine", "[]");

        // governance.castVote(proposalId, 1);

        // // skip(governance.votingPeriod() + 1);
        // vm.rpc("evm_increaseTime", '["0x3F480"]'');
        // vm.rpc("evm_mine", "[]");

        // governance.queue(
        //     proposal.getTargets(),
        //     proposal.getValues(),
        //     proposal.getCalldatas(),
        //     descriptionHash
        // );

        // vm.warp(governance.proposalEta(proposalId) + 1);
        // vm.rpc("evm_setNextBlockTimestamp", '[1729800678]'');
        // vm.rpc("evm_mine", "[]");

        // governance.execute(
        //     proposal.getTargets(),
        //     proposal.getValues(),
        //     proposal.getCalldatas(),
        //     descriptionHash
        // );

        vm.stopBroadcast();
    }

    function _addressToString(address _address) internal pure returns(string memory) {
        return Strings.toHexString(uint256(uint160(_address)), 20);
    }
}
