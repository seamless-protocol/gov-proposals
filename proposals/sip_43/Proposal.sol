// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { IMetaMorphoV1_1Base } from
    "@seamless-governance/interfaces/IMetaMorphoV1_1.sol";

contract Proposal is SeamlessGovProposal {
    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        _addAction(
            SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.setFeeRecipient.selector,
                SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT_FEE_SPLITTER
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.setFeeRecipient.selector,
                SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT_FEE_SPLITTER
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.setFeeRecipient.selector,
                SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT_FEE_SPLITTER
            )
        );
    }
}
