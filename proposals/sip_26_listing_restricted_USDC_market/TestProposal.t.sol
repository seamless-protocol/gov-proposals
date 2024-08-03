pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {Proposal} from "./Proposal.sol";
import {GovTestHelper} from "../../helpers/GovTestHelper.sol";
import {IPoolDataProvider} from "@aave/contracts/interfaces/IPoolDataProvider.sol";
import {SeamlessAddressBook} from "../../helpers/SeamlessAddressBook.sol";

contract TestProposal is Test, GovTestHelper {
    Proposal public proposal;

    function setUp() public {
      proposal = new Proposal();
    }

    function test_checkMarketListing_afterPassingProposal() public {
      _passProposal(proposal);
    }
}