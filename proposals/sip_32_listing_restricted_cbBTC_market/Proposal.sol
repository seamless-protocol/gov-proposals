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

    uint8 constant cbBTC_DECIMALS = 8;

    ConfiguratorInputTypes.InitReserveInput initReserveInput =
    ConfiguratorInputTypes.InitReserveInput({
        aTokenImpl: SeamlessAddressBook.A_TOKEN_IMPLEMENTATION,
        stableDebtTokenImpl: SeamlessAddressBook.STABLE_DEBT_TOKEN_IMPLEMENTATION,
        variableDebtTokenImpl: SeamlessAddressBook
            .VARIABLE_DEBT_TOKEN_IMPLEMENTATION,
        underlyingAssetDecimals: cbBTC_DECIMALS,
        interestRateStrategyAddress: SeamlessAddressBook
            .CBBTC_INTEREST_RATE_STRATEGY,
        underlyingAsset: SeamlessAddressBook.SEAMLESS_RESERVED_CBBTC,
        treasury: SeamlessAddressBook.SEAMLESS_TREASURY,
        incentivesController: SeamlessAddressBook.INCENTIVES_CONTROLLER,
        aTokenName: "Seamless rcbBTC",
        aTokenSymbol: "srcbBTC",
        variableDebtTokenName: "Seamless Variable Debt rcbBTC",
        variableDebtTokenSymbol: "variableDebtSeamrcbBTC",
        stableDebtTokenName: "Seamless Stable Debt rcbBTC",
        stableDebtTokenSymbol: "stableDebtSeamrcbBTC",
        params: ""
    });

    // the same parameters as for cbBTC market
    uint256 constant rcbBTC_LTV = 78_00; // LTV to 78%
    uint256 constant rcbBTC_LT = 78_00; // Liquidation threshold to 78%
    uint256 constant rcbBTC_LB = 110_00; // Liquidation bonus to 5%

    uint256 constant supplyCap = 200; // Supply cap to 200 cbBTC

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
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
                SeamlessAddressBook.SEAMLESS_RESERVED_CBBTC,
                rcbBTC_LTV,
                rcbBTC_LT,
                rcbBTC_LB
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.setSupplyCap.selector,
                SeamlessAddressBook.SEAMLESS_RESERVED_CBBTC,
                supplyCap
            )
        );

        address[] memory assets = new address[](1);
        assets[0] = SeamlessAddressBook.SEAMLESS_RESERVED_CBBTC;

        address[] memory sources = new address[](1);
        sources[0] = IAaveOracle(SeamlessAddressBook.AAVE_ORACLE)
            .getSourceOfAsset(SeamlessAddressBook.CBBTC);

        _addAction(
            SeamlessAddressBook.AAVE_ORACLE,
            abi.encodeWithSelector(
                IAaveOracle.setAssetSources.selector, assets, sources
            )
        );
    }
}
