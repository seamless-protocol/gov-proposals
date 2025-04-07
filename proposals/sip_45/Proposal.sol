// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { IPoolConfigurator } from
    "@aave/core-v3/contracts/interfaces/IPoolConfigurator.sol";
import { IPool } from "@aave/core-v3/contracts/interfaces/IPool.sol";

contract Proposal is SeamlessGovProposal {
    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        address[] memory assets =
            IPool(SeamlessAddressBook.POOL).getReservesList();

        for (uint256 i = 0; i < assets.length; i++) {
            _addAction(
                SeamlessAddressBook.POOL_CONFIGURATOR,
                abi.encodeWithSelector(
                    IPoolConfigurator.setReserveFreeze.selector, assets[i], true
                )
            );
        }
    }
}
