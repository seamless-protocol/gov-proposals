// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";
import { ISeamEmissionManager } from
    "@seamless-governance/interfaces/ISeamEmissionManager.sol";

contract Proposal is SeamlessGovProposal {
    uint256 public constant budgetAmount = 3_327_030_27 * 1e16;
    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        _addAction(
            SeamlessAddressBook.SEAM_EMISSION_MANAGER_2,
            abi.encodeWithSelector(
                ISeamEmissionManager.claim.selector,
                SeamlessAddressBook.TIMELOCK_SHORT
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
