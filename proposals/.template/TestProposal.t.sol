// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { Test, console } from "forge-std/Test.sol";
import { Proposal } from "./Proposal.sol";

contract TestProposal is Test {
    Proposal public proposal;

    function setUp() public {
        proposal = new Proposal();
    }

    function test() public { }
}
