// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";

import { ISeamEmissionManager } from
    "@seamless-governance/interfaces/ISeamEmissionManager.sol";

contract Proposal is SeamlessGovProposal {
    constructor() {
        _makeProposal();
    }

    function _makeProposal() internal virtual override {
        _addAction(
            SeamlessAddressBook.SEAM_EMISSION_MANAGER_1,
            abi.encodeWithSelector(
                ISeamEmissionManager.claim.selector,
                SeamlessAddressBook.GUARDIAN_MULTISIG
            )
        );

        _addAction(
            SeamlessAddressBook.SEAM_EMISSION_MANAGER_2,
            abi.encodeWithSelector(
                ISeamEmissionManager.claim.selector,
                SeamlessAddressBook.GUARDIAN_MULTISIG
            )
        );
    }
}
