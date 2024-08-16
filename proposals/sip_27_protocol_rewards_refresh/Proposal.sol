// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { ISeamEmissionManager } from
    "@seamless-governance/interfaces/ISeamEmissionManager.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Proposal is SeamlessGovProposal {
    uint256 public constant budgetAmount = 500_000 * 1e18;

    constructor() {
        _makeProposal();
    }

    function _makeProposal() internal virtual override {
        _addAction(
            SeamlessAddressBook.SEAM_EMISSION_MANAGER_1,
            abi.encodeWithSelector(
                ISeamEmissionManager.claim.selector,
                SeamlessAddressBook.GOVERNOR_SHORT
            )
        );

        _addAction(
            SeamlessAddressBook.SEAM_EMISSION_MANAGER_2,
            abi.encodeWithSelector(
                ISeamEmissionManager.claim.selector,
                SeamlessAddressBook.GOVERNOR_SHORT
            )
        );

        _addAction(
            SeamlessAddressBook.SEAM,
            abi.encodeWithSelector(
                IERC20.transfer.selector,
                SeamlessAddressBook.GUARDIAN_MULTISIG,
                budgetAmount
            )
        );
    }
}
