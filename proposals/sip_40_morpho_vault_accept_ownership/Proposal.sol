// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { Ownable2Step } from "@openzeppelin/contracts/access/Ownable2Step.sol";

contract Proposal is SeamlessGovProposal {
    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        _addAction(
            SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT,
            abi.encodeWithSelector(Ownable2Step.acceptOwnership.selector)
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT,
            abi.encodeWithSelector(Ownable2Step.acceptOwnership.selector)
        );
    }
}
