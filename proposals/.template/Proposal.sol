// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";

contract Proposal is SeamlessGovProposal {
    constructor() {
        _makeProposal();
    }

    function _makeProposal() internal virtual override { }
}
