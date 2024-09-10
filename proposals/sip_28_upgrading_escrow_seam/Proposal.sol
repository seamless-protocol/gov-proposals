// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";

interface IUUPSUpgradeable {
    function upgradeToAndCall(address newImplementation, bytes memory data)
        external;
}

contract Proposal is SeamlessGovProposal {
    address constant newEscrowSeamAddress =
        address(0x78423BfC5053102A3087DAA978c2117a6809fBB1);

    constructor() {
        _makeProposal();
    }

    function _makeProposal() internal virtual override {
        _addAction(
            SeamlessAddressBook.ESSEAM,
            abi.encodeWithSelector(
                IUUPSUpgradeable.upgradeToAndCall.selector,
                newEscrowSeamAddress,
                ""
            )
        );
    }
}
