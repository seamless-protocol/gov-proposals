// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

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
            pool.getConfiguration(SeamlessAddressBook.CBETH);

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.CBETH,
                75_00,
                79_00,
                reserveConfig.getLiquidationBonus()
            )
        );

        reserveConfig = pool.getConfiguration(SeamlessAddressBook.USDbC);

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.USDbC,
                75_00,
                80_00,
                reserveConfig.getLiquidationBonus()
            )
        );

        reserveConfig = pool.getConfiguration(SeamlessAddressBook.WETH);

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.WETH,
                80_00,
                83_00,
                reserveConfig.getLiquidationBonus()
            )
        );

        reserveConfig = pool.getConfiguration(SeamlessAddressBook.WSTETH);

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.WSTETH,
                75_00,
                79_00,
                reserveConfig.getLiquidationBonus()
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveFactor.selector,
                SeamlessAddressBook.USDbC,
                25_00
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveFactor.selector,
                SeamlessAddressBook.USDC,
                10_00
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveInterestRateStrategyAddress.selector,
                SeamlessAddressBook.DAI,
                SeamlessAddressBook.DAI_INTEREST_RATE_STRATEGY
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveInterestRateStrategyAddress.selector,
                SeamlessAddressBook.USDC,
                SeamlessAddressBook.USDC_INTEREST_RATE_STRATEGY
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveInterestRateStrategyAddress.selector,
                SeamlessAddressBook.WETH,
                SeamlessAddressBook.WETH_INTEREST_RATE_STRATEGY
            )
        );
    }
}
