// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { IPoolConfigurator } from
    "@aave/contracts/interfaces/IPoolConfigurator.sol";
import { IPool } from "@aave/contracts/interfaces/IPool.sol";
import { ConfiguratorInputTypes } from
    "@aave/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol";
import { IAaveOracle } from "@aave/contracts/interfaces/IAaveOracle.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Proposal is SeamlessGovProposal {
    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        // Oracles

        address[] memory assets = new address[](2);
        assets[0] = SeamlessAddressBook.WEETH;
        assets[1] = SeamlessAddressBook.SEAMLESS_RESERVED_WEETH;

        address[] memory sources = new address[](2);
        sources[0] = SeamlessAddressBook.WEETH_ORACLE_ADAPTER;
        sources[1] = SeamlessAddressBook.WEETH_ORACLE_ADAPTER;

        _addAction(
            SeamlessAddressBook.AAVE_ORACLE,
            abi.encodeWithSelector(
                IAaveOracle.setAssetSources.selector, assets, sources
            )
        );

        // Init reserves

        ConfiguratorInputTypes.InitReserveInput[] memory initReserveInputs =
            new ConfiguratorInputTypes.InitReserveInput[](2);

        // weETH
        initReserveInputs[0] = ConfiguratorInputTypes.InitReserveInput({
            aTokenImpl: SeamlessAddressBook.A_TOKEN_IMPLEMENTATION,
            stableDebtTokenImpl: SeamlessAddressBook
                .STABLE_DEBT_TOKEN_IMPLEMENTATION,
            variableDebtTokenImpl: SeamlessAddressBook
                .VARIABLE_DEBT_TOKEN_IMPLEMENTATION,
            underlyingAssetDecimals: 18,
            interestRateStrategyAddress: SeamlessAddressBook
                .WEETH_INTEREST_RATE_STRATEGY,
            underlyingAsset: SeamlessAddressBook.WEETH,
            treasury: SeamlessAddressBook.SEAMLESS_TREASURY,
            incentivesController: SeamlessAddressBook.INCENTIVES_CONTROLLER,
            aTokenName: "Seamless weETH",
            aTokenSymbol: "sweETH",
            variableDebtTokenName: "Seamless Variable Debt weETH",
            variableDebtTokenSymbol: "variableDebtSeamweETH",
            stableDebtTokenName: "Seamless Stable Debt weETH",
            stableDebtTokenSymbol: "stableDebtSeamweETH",
            params: ""
        });

        // Reserved weETH
        initReserveInputs[1] = ConfiguratorInputTypes.InitReserveInput({
            aTokenImpl: SeamlessAddressBook.A_TOKEN_IMPLEMENTATION,
            stableDebtTokenImpl: SeamlessAddressBook
                .STABLE_DEBT_TOKEN_IMPLEMENTATION,
            variableDebtTokenImpl: SeamlessAddressBook
                .VARIABLE_DEBT_TOKEN_IMPLEMENTATION,
            underlyingAssetDecimals: 18,
            interestRateStrategyAddress: SeamlessAddressBook
                .WEETH_INTEREST_RATE_STRATEGY,
            underlyingAsset: SeamlessAddressBook.SEAMLESS_RESERVED_WEETH,
            treasury: SeamlessAddressBook.SEAMLESS_TREASURY,
            incentivesController: SeamlessAddressBook.INCENTIVES_CONTROLLER,
            aTokenName: "Seamless rweETH",
            aTokenSymbol: "srweETH",
            variableDebtTokenName: "Seamless Variable Debt rweETH",
            variableDebtTokenSymbol: "variableDebtSeamrweETH",
            stableDebtTokenName: "Seamless Stable Debt rweETH",
            stableDebtTokenSymbol: "stableDebtSeamrweETH",
            params: ""
        });

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.initReserves.selector, initReserveInputs
            )
        );

        // Enable collateral

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.WEETH,
                72_50, // LTV
                75_00, // LT
                107_50 // Liquidation Bonus
            )
        );

        // The reserved market params are more aggressive but not as aggressive as e-mode even though the reserve market will only borrow ETH which is correlated
        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.SEAMLESS_RESERVED_WEETH,
                80_00, // LTV
                83_00, // LT
                107_50 // Liquidation Bonus
            )
        );

        // Supply Caps

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setSupplyCap.selector,
                SeamlessAddressBook.WEETH,
                900
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setSupplyCap.selector,
                SeamlessAddressBook.SEAMLESS_RESERVED_WEETH,
                900
            )
        );

        // Borrow Caps

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setBorrowCap.selector,
                SeamlessAddressBook.WEETH,
                450
            )
        );

        // Enable borrowing

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveBorrowing.selector,
                SeamlessAddressBook.WEETH,
                true
            )
        );

        // Enable flash loans

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveFlashLoaning.selector,
                SeamlessAddressBook.WEETH,
                true
            )
        );

        // Set reserve factor

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveFactor.selector,
                SeamlessAddressBook.WEETH,
                45_00
            )
        );

        // Set liquidation protocol fee

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setLiquidationProtocolFee.selector,
                SeamlessAddressBook.WEETH,
                10_00
            )
        );

        // Seed markets

        _addAction(
            SeamlessAddressBook.WEETH,
            abi.encodeWithSelector(
                IERC20.approve.selector, SeamlessAddressBook.POOL, 0.001 ether
            )
        );

        _addAction(
            SeamlessAddressBook.POOL,
            abi.encodeWithSelector(
                IPool.supply.selector,
                SeamlessAddressBook.WEETH,
                0.001 ether,
                SeamlessAddressBook.TIMELOCK_SHORT,
                0
            )
        );

        // e-mode

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setAssetEModeCategory.selector,
                SeamlessAddressBook.WEETH,
                1 // ETH Correlated e-mode category
            )
        );
    }
}
