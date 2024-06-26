// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import {Script, console} from "forge-std/Script.sol";
import {Proposal} from "./Proposal.sol";
import {IGovernor} from "@openzeppelin/contracts/governance/IGovernor.sol";
import {SeamlessAddressBook} from "../../helpers/SeamlessAddressBook.sol";

contract ScriptPropose is Script {
    function setUp() public {}

    function run(string memory descriptionPath) public {
      Proposal proposal = new Proposal();

      IGovernor governance = IGovernor(SeamlessAddressBook.GOVERNOR_SHORT);

      string memory description = vm.readFile(descriptionPath);

      uint256 proposerPrivateKey = vm.envUint("PROPOSER_PK");
      vm.startBroadcast(proposerPrivateKey);
      governance.propose(
        proposal.getTargets(),
        proposal.getValues(),
        proposal.getCalldatas(),
        description
      );
      vm.stopBroadcast();
    }
}