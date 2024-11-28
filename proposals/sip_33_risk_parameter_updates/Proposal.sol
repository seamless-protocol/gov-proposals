// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { IPoolConfigurator } from
    "@aave/contracts/interfaces/IPoolConfigurator.sol";

contract Proposal is SeamlessGovProposal {
    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.CBETH,
                75_00,
                79_00,
                107_50
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.USDbC,
                75_00,
                80_00,
                105_00
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.WETH,
                80_00,
                83_00,
                105_00
            )
        );

        _addAction(
            SeamlessAddressBook.POOL_CONFIGURATOR,
            abi.encodeWithSelector(
                IPoolConfigurator.configureReserveAsCollateral.selector,
                SeamlessAddressBook.WSTETH,
                75_00,
                79_00,
                107_50
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
