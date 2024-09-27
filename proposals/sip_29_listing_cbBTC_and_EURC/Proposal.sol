// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { IPoolConfigurator } from
    "@aave/contracts/interfaces/IPoolConfigurator.sol";
import { IPool } from "@aave/contracts/interfaces/IPool.sol";
import { IPoolAddressesProvider } from
    "@aave/contracts/interfaces/IPoolAddressesProvider.sol";
import { ConfiguratorInputTypes } from
    "@aave/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol";
import { DefaultReserveInterestRateStrategy } from
    "@aave/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol";
import { WadRayMath } from
    "@aave/contracts/protocol/libraries/math/WadRayMath.sol";
import { IAaveOracle } from "@aave/contracts/interfaces/IAaveOracle.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Proposal is SeamlessGovProposal {
    constructor() {
        _makeProposal();
    }

    function _makeProposal() internal virtual override {
        // Oracles

        address[] memory assets = new address[](2);
        assets[0] = SeamlessAddressBook.CBBTC;
        assets[1] = SeamlessAddressBook.EURC;

        address[] memory sources = new address[](2);
        sources[0] = 0x64c911996D3c6aC71f9b455B1E8E7266BcbD848F; // Chainlink BTC/USD feed - https://data.chain.link/feeds/base/base/btc-usd
        sources[1] = 0xDAe398520e2B67cd3f27aeF9Cf14D93D927f8250; // Chainlink EURC/USD feed - https://data.chain.link/feeds/base/base/eurc-usd

        _addAction(
            SeamlessAddressBook.AAVE_ORACLE,
            abi.encodeWithSelector(
                IAaveOracle.setAssetSources.selector, assets, sources
            )
        );

        // Init reserves

        ConfiguratorInputTypes.InitReserveInput[] memory initReserveInputs =
            new ConfiguratorInputTypes.InitReserveInput[](2);

        // BTC

        DefaultReserveInterestRateStrategy interestStrategycbBTC = new DefaultReserveInterestRateStrategy(
            IPoolAddressesProvider(SeamlessAddressBook.POOL_ADDRESSES_PROVIDER),
            _bpsToRay(45_00),
            0,
            _bpsToRay(4_00),
            _bpsToRay(300_00),
            0,
            0,
            0,
            0,
            0
        );

        initReserveInputs[0] = ConfiguratorInputTypes.InitReserveInput({
            aTokenImpl: SeamlessAddressBook.A_TOKEN_IMPLEMENTATION,
            stableDebtTokenImpl: SeamlessAddressBook
                .STABLE_DEBT_TOKEN_IMPLEMENTATION,
            variableDebtTokenImpl: SeamlessAddressBook
                .VARIABLE_DEBT_TOKEN_IMPLEMENTATION,
            underlyingAssetDecimals: 8,
            interestRateStrategyAddress: address(interestStrategycbBTC),
            underlyingAsset: SeamlessAddressBook.CBBTC,
            treasury: SeamlessAddressBook.SEAMLESS_TREASURY,
            incentivesController: SeamlessAddressBook.INCENTIVES_CONTROLLER,
            aTokenName: "Seamless cbBTC",
            aTokenSymbol: "scbBTC",
            variableDebtTokenName: "Seamless Variable Debt cbBTC",
            variableDebtTokenSymbol: "variableDebtSeamcbBTC",
            stableDebtTokenName: "Seamless Stable Debt cbBTC",
            stableDebtTokenSymbol: "stableDebtSeamcbBTC",
            params: ""
        });

        // EURC

        DefaultReserveInterestRateStrategy interestStrategyEURC = new DefaultReserveInterestRateStrategy(
            IPoolAddressesProvider(SeamlessAddressBook.POOL_ADDRESSES_PROVIDER),
            _bpsToRay(90_00),
            0,
            _bpsToRay(7_00),
            _bpsToRay(75_00),
            0,
            0,
            0,
            0,
            0
        );

        initReserveInputs[1] = ConfiguratorInputTypes.InitReserveInput({
            aTokenImpl: SeamlessAddressBook.A_TOKEN_IMPLEMENTATION,
            stableDebtTokenImpl: SeamlessAddressBook
                .STABLE_DEBT_TOKEN_IMPLEMENTATION,
            variableDebtTokenImpl: SeamlessAddressBook
                .VARIABLE_DEBT_TOKEN_IMPLEMENTATION,
            underlyingAssetDecimals: 6,
            interestRateStrategyAddress: address(interestStrategyEURC),
            underlyingAsset: SeamlessAddressBook.EURC,
            treasury: SeamlessAddressBook.SEAMLESS_TREASURY,
            incentivesController: SeamlessAddressBook.INCENTIVES_CONTROLLER,
            aTokenName: "Seamless EURC",
            aTokenSymbol: "sEURC",
            variableDebtTokenName: "Seamless Variable Debt EURC",
            variableDebtTokenSymbol: "variableDebtSeamEURC",
            stableDebtTokenName: "Seamless Stable Debt EURC",
            stableDebtTokenSymbol: "stableDebtSeamEURC",
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
                SeamlessAddressBook.CBBTC,
                73_00, // LTV
                78_00, // LT
                110_00 // Liquidation Bonus
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.EURC,
                65_00, // LTV
                70_00, // LT
                107_50 // Liquidation Bonus
            )
        );

        // Supply Caps

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setSupplyCap.selector,
                SeamlessAddressBook.CBBTC,
                200
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setSupplyCap.selector,
                SeamlessAddressBook.EURC,
                3_000_000
            )
        );

        // Borrow Caps

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setBorrowCap.selector,
                SeamlessAddressBook.CBBTC,
                20
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setBorrowCap.selector,
                SeamlessAddressBook.EURC,
                2_700_000
            )
        );

        // Enable borrowing

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveBorrowing.selector,
                SeamlessAddressBook.CBBTC,
                true
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveBorrowing.selector,
                SeamlessAddressBook.EURC,
                true
            )
        );

        // Enable flash loans

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveFlashLoaning.selector,
                SeamlessAddressBook.CBBTC,
                true
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveFlashLoaning.selector,
                SeamlessAddressBook.EURC,
                true
            )
        );

        // Set reserve factor

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveFactor.selector,
                SeamlessAddressBook.CBBTC,
                20_00
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setReserveFactor.selector,
                SeamlessAddressBook.EURC,
                20_00
            )
        );

        // Set liquidation protocol fee

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setLiquidationProtocolFee.selector,
                SeamlessAddressBook.CBBTC,
                10_00
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setLiquidationProtocolFee.selector,
                SeamlessAddressBook.EURC,
                10_00
            )
        );

        // Seed markets

        _addAction(
            SeamlessAddressBook.CBBTC,
            abi.encodeWithSelector(
                IERC20.approve.selector, SeamlessAddressBook.POOL, 2e5
            )
        );

        _addAction(
            SeamlessAddressBook.EURC,
            abi.encodeWithSelector(
                IERC20.approve.selector, SeamlessAddressBook.POOL, 1e6
            )
        );

        _addAction(
            SeamlessAddressBook.POOL,
            abi.encodeWithSelector(
                IPool.supply.selector,
                SeamlessAddressBook.CBBTC,
                2e5,
                SeamlessAddressBook.TIMELOCK_SHORT,
                0
            )
        );

        _addAction(
            SeamlessAddressBook.POOL,
            abi.encodeWithSelector(
                IPool.supply.selector,
                SeamlessAddressBook.EURC,
                1e6,
                SeamlessAddressBook.TIMELOCK_SHORT,
                0
            )
        );
    }

    function _bpsToRay(uint256 amount) internal pure returns (uint256) {
        return (amount * WadRayMath.RAY) / 10_000;
    }
}
