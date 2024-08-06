// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import { Script, console } from "forge-std/Script.sol";
import { Proposal } from "./Proposal.sol";
import { IGovernor } from "@openzeppelin/contracts/governance/IGovernor.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";

contract DeployProposal is Script {
    function setUp() public { }

    function run(string memory descriptionPath) public {
        Proposal proposal = new Proposal();

        // Change this to GOVERNOR_LONG if you want to make proposal on the long governor
        IGovernor governance = IGovernor(SeamlessAddressBook.GOVERNOR_SHORT);

        string memory description = vm.readFile(descriptionPath);

        address proposerAddress = vm.envAddress("PROPOSER_ADDRESS");
        vm.startBroadcast(proposerAddress);
        governance.propose(
            proposal.getTargets(),
            proposal.getValues(),
            proposal.getCalldatas(),
            description
        );
        vm.stopBroadcast();
    }
}
