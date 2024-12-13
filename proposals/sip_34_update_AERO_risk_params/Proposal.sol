// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { IPoolConfigurator } from
    "@aave/contracts/interfaces/IPoolConfigurator.sol";
import { DataTypes } from
    "@aave/contracts/protocol/libraries/types/DataTypes.sol";
import { ReserveConfiguration } from
    "@aave/contracts/protocol/libraries/configuration/ReserveConfiguration.sol";
import { IPool } from "@aave/contracts/interfaces/IPool.sol";

contract Proposal is SeamlessGovProposal {
    using ReserveConfiguration for DataTypes.ReserveConfigurationMap;

    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        IPool pool = IPool(SeamlessAddressBook.POOL);

        DataTypes.ReserveConfigurationMap memory reserveConfig =
            pool.getConfiguration(SeamlessAddressBook.AERO);

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.AERO,
                67_50,
                72_50,
                reserveConfig.getLiquidationBonus()
            )
        );
    }
}
