// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { Test, console } from "forge-std/Test.sol";
import { Proposal } from "./Proposal.sol";
import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";
import { ERC1967Utils } from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";

contract TestProposal is Test, GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        proposal = new Proposal();
    }

    function test_implementationAddressChanged_afterPassingProposal() public {
        _passProposalLongGov(proposal);

        assertEq(
            _getImplementationAddress(SeamlessAddressBook.ESSEAM),
            address(0x78423BfC5053102A3087DAA978c2117a6809fBB1)
        );
    }

    function _getImplementationAddress(address proxy)
        internal
        view
        returns (address)
    {
        bytes32 implementationAddress =
            vm.load(proxy, ERC1967Utils.IMPLEMENTATION_SLOT);
        return address(uint160(uint256(implementationAddress)));
    }
}
