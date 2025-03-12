// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { SeamGovernorV2 } from "@seamless-governance/SeamGovernorV2.sol";
import { UUPSUpgradeable } from
    "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";

contract Proposal is SeamlessGovProposal {
    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        _addAction(
            SeamlessAddressBook.GOVERNOR_SHORT,
            abi.encodeWithSelector(
                UUPSUpgradeable.upgradeToAndCall.selector,
                SeamlessAddressBook.SEAM_GOVERNOR_V2_IMPLEMENTATION,
                abi.encodeWithSelector(
                    SeamGovernorV2.initializeV2.selector,
                    SeamlessAddressBook.stkSEAM
                )
            )
        );

        _addAction(
            SeamlessAddressBook.GOVERNOR_LONG,
            abi.encodeWithSelector(
                UUPSUpgradeable.upgradeToAndCall.selector,
                SeamlessAddressBook.SEAM_GOVERNOR_V2_IMPLEMENTATION,
                abi.encodeWithSelector(
                    SeamGovernorV2.initializeV2.selector,
                    SeamlessAddressBook.stkSEAM
                )
            )
        );
    }
}
