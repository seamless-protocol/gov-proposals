// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        proposal = new Proposal();
    }

    function test() public { }
}
