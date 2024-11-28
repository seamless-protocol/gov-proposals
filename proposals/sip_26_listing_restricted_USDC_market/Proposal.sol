// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { IPoolConfigurator } from
    "@aave/contracts/interfaces/IPoolConfigurator.sol";
import { IAaveOracle } from "@aave/contracts/interfaces/IAaveOracle.sol";
import { ConfiguratorInputTypes } from
    "@aave/contracts/protocol/libraries/types/ConfiguratorInputTypes.sol";

contract Proposal is SeamlessGovProposal {
    constructor() {
        _makeProposal();
    }

    address constant USDC_INTEREST_RATE_STRATEGY =
        0x1163E8455d44F63E04726D6719BF0c6741095531;

    ConfiguratorInputTypes.InitReserveInput initReserveInput =
    ConfiguratorInputTypes.InitReserveInput({
        aTokenImpl: SeamlessAddressBook.A_TOKEN_IMPLEMENTATION,
        stableDebtTokenImpl: SeamlessAddressBook.STABLE_DEBT_TOKEN_IMPLEMENTATION,
        variableDebtTokenImpl: SeamlessAddressBook
            .VARIABLE_DEBT_TOKEN_IMPLEMENTATION,
        underlyingAssetDecimals: 6,
        interestRateStrategyAddress: USDC_INTEREST_RATE_STRATEGY,
        underlyingAsset: SeamlessAddressBook.SEAMLESS_RESERVED_USDC,
        treasury: SeamlessAddressBook.SEAMLESS_TREASURY,
        incentivesController: SeamlessAddressBook.INCENTIVES_CONTROLLER,
        aTokenName: "Seamless rUSDC",
        aTokenSymbol: "srUSDC",
        variableDebtTokenName: "Seamless Variable Debt rUSDC",
        variableDebtTokenSymbol: "variableDebtSeamrUSDC",
        stableDebtTokenName: "Seamless Stable Debt rUSDC",
        stableDebtTokenSymbol: "stableDebtSeamrUSDC",
        params: ""
    });

    uint256 constant rUSDC_LTV = 75_00; // LTV to 75%
    uint256 constant rUSDC_LT = 78_00; // Liquidation threshold to 78%
    uint256 constant rUSDC_LB = 105_00; // Liquidation bonus to 5%

    uint256 constant supplyCap = 40_000_000; // Supply cap to 40m USDC

    function _makeProposal() internal virtual override {
        ConfiguratorInputTypes.InitReserveInput[] memory initReserveInputs =
            new ConfiguratorInputTypes.InitReserveInput[](1);

        initReserveInputs[0] = initReserveInput;

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.initReserves.selector, initReserveInputs
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.SEAMLESS_RESERVED_USDC,
                rUSDC_LTV,
                rUSDC_LT,
                rUSDC_LB
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setSupplyCap.selector,
                SeamlessAddressBook.SEAMLESS_RESERVED_USDC,
                supplyCap
            )
        );

        address[] memory assets = new address[](1);
        assets[0] = SeamlessAddressBook.SEAMLESS_RESERVED_USDC;

        address[] memory sources = new address[](1);
        sources[0] = IAaveOracle(SeamlessAddressBook.AAVE_ORACLE)
            .getSourceOfAsset(SeamlessAddressBook.USDC);

        _addAction(
            SeamlessAddressBook.AAVE_ORACLE,
            abi.encodeWithSelector(
                IAaveOracle.setAssetSources.selector, assets, sources
            )
        );
    }
}
