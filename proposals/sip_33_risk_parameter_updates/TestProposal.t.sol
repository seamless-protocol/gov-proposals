// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {
    GovTestHelper, SeamlessAddressBook
} from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { IPoolAddressesProvider } from
    "@aave/contracts/interfaces/IPoolAddressesProvider.sol";
import { ReserveConfiguration } from
    "@aave/contracts/protocol/libraries/configuration/ReserveConfiguration.sol";
import { DataTypes } from
    "@aave/contracts/protocol/libraries/types/DataTypes.sol";
import { IPool } from "@aave/contracts/interfaces/IPool.sol";
import { IDefaultInterestRateStrategy } from
    "@aave/contracts/interfaces/IDefaultInterestRateStrategy.sol";

contract TestProposal is GovTestHelper {
    using ReserveConfiguration for DataTypes.ReserveConfigurationMap;

    Proposal public proposal;

    IPool pool = IPool(SeamlessAddressBook.POOL);

    function setUp() public {
        vm.rollFork(22990066);
        proposal = new Proposal();
    }

    function test_cbETH() public {
        DataTypes.ReserveConfigurationMap memory reserveConfigBefore =
            pool.getConfiguration(SeamlessAddressBook.CBETH);

        _passProposalShortGov(proposal);

        DataTypes.ReserveConfigurationMap memory reserveConfigAfter =
            pool.getConfiguration(SeamlessAddressBook.CBETH);

        assertEq(reserveConfigAfter.getLtv(), 75_00); // 75%
        assertEq(reserveConfigAfter.getLiquidationThreshold(), 79_00); // 79%
        assertEq(
            reserveConfigAfter.getLiquidationProtocolFee(),
            reserveConfigBefore.getLiquidationProtocolFee()
        );
    }

    function test_DAI() public {
        DataTypes.ReserveData memory reserveDataBefore =
            pool.getReserveData(SeamlessAddressBook.DAI);

        IDefaultInterestRateStrategy interestRateStrategyBefore =
        IDefaultInterestRateStrategy(
            reserveDataBefore.interestRateStrategyAddress
        );

        _passProposalShortGov(proposal);

        DataTypes.ReserveData memory reserveDataAfter =
            pool.getReserveData(SeamlessAddressBook.DAI);

        assertNotEq(reserveDataAfter.interestRateStrategyAddress, address(0));

        IDefaultInterestRateStrategy interestRateStrategyAfter =
        IDefaultInterestRateStrategy(reserveDataAfter.interestRateStrategyAddress);

        assertEq(
            interestRateStrategyAfter.OPTIMAL_USAGE_RATIO(),
            interestRateStrategyBefore.OPTIMAL_USAGE_RATIO()
        );
        assertEq(
            interestRateStrategyAfter.getBaseVariableBorrowRate(),
            interestRateStrategyBefore.getBaseVariableBorrowRate()
        );
        assertEq(interestRateStrategyAfter.getVariableRateSlope1(), 5.5e25); // 5%
        assertEq(
            interestRateStrategyAfter.getVariableRateSlope2(),
            interestRateStrategyBefore.getVariableRateSlope2()
        );
    }

    function test_checkUSDBC() public {
        DataTypes.ReserveConfigurationMap memory reserveConfigBefore =
            pool.getConfiguration(SeamlessAddressBook.USDbC);

        _passProposalShortGov(proposal);

        DataTypes.ReserveConfigurationMap memory reserveConfigAfter =
            pool.getConfiguration(SeamlessAddressBook.USDbC);

        assertEq(reserveConfigAfter.getLtv(), 75_00); // 75%
        assertEq(
            reserveConfigAfter.getLiquidationThreshold(),
            reserveConfigBefore.getLiquidationThreshold()
        );
        assertEq(
            reserveConfigAfter.getLiquidationProtocolFee(),
            reserveConfigBefore.getLiquidationProtocolFee()
        );

        assertEq(reserveConfigAfter.getReserveFactor(), 25_00); // 25%
    }

    function test_checkUSDC() public {
        DataTypes.ReserveData memory reserveDataBefore =
            pool.getReserveData(SeamlessAddressBook.USDC);

        IDefaultInterestRateStrategy interestRateStrategyBefore =
        IDefaultInterestRateStrategy(
            reserveDataBefore.interestRateStrategyAddress
        );

        _passProposalShortGov(proposal);

        DataTypes.ReserveData memory reserveDataAfter =
            pool.getReserveData(SeamlessAddressBook.USDC);

        assertNotEq(reserveDataAfter.interestRateStrategyAddress, address(0));

        IDefaultInterestRateStrategy interestRateStrategyAfter =
        IDefaultInterestRateStrategy(reserveDataAfter.interestRateStrategyAddress);

        assertEq(
            interestRateStrategyAfter.OPTIMAL_USAGE_RATIO(),
            interestRateStrategyBefore.OPTIMAL_USAGE_RATIO()
        );
        assertEq(
            interestRateStrategyAfter.getBaseVariableBorrowRate(),
            interestRateStrategyBefore.getBaseVariableBorrowRate()
        );
        assertEq(interestRateStrategyAfter.getVariableRateSlope1(), 8e25); // 5%
        assertEq(interestRateStrategyAfter.getVariableRateSlope2(), 75e25); // 75%

        assertEq(reserveDataAfter.configuration.getReserveFactor(), 10_00); // 10%
    }

    function test_checkWETH() public {
        DataTypes.ReserveData memory reserveDataBefore =
            pool.getReserveData(SeamlessAddressBook.WETH);

        IDefaultInterestRateStrategy interestRateStrategyBefore =
        IDefaultInterestRateStrategy(
            reserveDataBefore.interestRateStrategyAddress
        );

        _passProposalShortGov(proposal);

        DataTypes.ReserveData memory reserveDataAfter =
            pool.getReserveData(SeamlessAddressBook.WETH);

        assertNotEq(reserveDataAfter.interestRateStrategyAddress, address(0));

        IDefaultInterestRateStrategy interestRateStrategyAfter =
        IDefaultInterestRateStrategy(reserveDataAfter.interestRateStrategyAddress);

        assertEq(reserveDataAfter.configuration.getLtv(), 80_00); // 80%
        assertEq(reserveDataAfter.configuration.getLiquidationThreshold(), 83_00); // 83%
        assertEq(
            reserveDataAfter.configuration.getLiquidationBonus(),
            reserveDataBefore.configuration.getLiquidationBonus()
        );

        assertEq(interestRateStrategyAfter.OPTIMAL_USAGE_RATIO(), 9e26); // 90%
        assertEq(
            interestRateStrategyAfter.getBaseVariableBorrowRate(),
            interestRateStrategyBefore.getBaseVariableBorrowRate()
        );
        assertEq(
            interestRateStrategyAfter.getVariableRateSlope1(),
            interestRateStrategyBefore.getVariableRateSlope1()
        );
        assertEq(
            interestRateStrategyAfter.getVariableRateSlope2(),
            interestRateStrategyBefore.getVariableRateSlope2()
        );
    }

    function test_checkWSETH() public {
        DataTypes.ReserveConfigurationMap memory reserveConfigBefore =
            pool.getConfiguration(SeamlessAddressBook.WSTETH);

        _passProposalShortGov(proposal);

        DataTypes.ReserveConfigurationMap memory reserveConfigAfter =
            pool.getConfiguration(SeamlessAddressBook.WSTETH);

        assertEq(reserveConfigAfter.getLtv(), 75_00); // 75%
        assertEq(reserveConfigAfter.getLiquidationThreshold(), 79_00); // 79%
        assertEq(
            reserveConfigAfter.getLiquidationProtocolFee(),
            reserveConfigBefore.getLiquidationProtocolFee()
        );
    }
}
