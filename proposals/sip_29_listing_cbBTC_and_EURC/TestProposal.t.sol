// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { Test, console } from "forge-std/Test.sol";
import { Proposal } from "./Proposal.sol";
import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { IPoolDataProvider } from
    "@aave/contracts/interfaces/IPoolDataProvider.sol";
import { IAaveOracle } from "@aave/contracts/interfaces/IAaveOracle.sol";
import { IDefaultInterestRateStrategy } from
    "@aave/contracts/interfaces/IDefaultInterestRateStrategy.sol";
import { IPool } from "@aave/contracts/interfaces/IPool.sol";
import { DataTypes } from
    "@aave/contracts/protocol/libraries/types/DataTypes.sol";
import { ReserveConfiguration } from
    "@aave/contracts/protocol/libraries/configuration/ReserveConfiguration.sol";
import { IERC20Metadata } from
    "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";

contract TestProposal is Test, GovTestHelper {
    using ReserveConfiguration for DataTypes.ReserveConfigurationMap;

    Proposal public proposal;

    IPoolDataProvider poolDataProvider =
        IPoolDataProvider(SeamlessAddressBook.POOL_DATA_PROVIDER);
    IAaveOracle aaveOracle = IAaveOracle(SeamlessAddressBook.AAVE_ORACLE);
    IPool pool = IPool(SeamlessAddressBook.POOL);

    function setUp() public {
        vm.rollFork(20303742);
        proposal = new Proposal();

        deal(SeamlessAddressBook.CBBTC, SeamlessAddressBook.TIMELOCK_SHORT, 2e5);
        deal(SeamlessAddressBook.EURC, SeamlessAddressBook.TIMELOCK_SHORT, 1e6);
    }

    function test_cbBTCTokens_afterPassingProposal() public {
        _passProposalShortGov(proposal);

        (address collateralTokenAddress,, address variableDebtTokenAddress) =
        poolDataProvider.getReserveTokensAddresses(SeamlessAddressBook.CBBTC);

        assertNotEq(collateralTokenAddress, address(0));

        IERC20Metadata collateralToken = IERC20Metadata(collateralTokenAddress);

        assertEq(collateralToken.name(), "Seamless cbBTC");
        assertEq(collateralToken.symbol(), "scbBTC");
        assertEq(collateralToken.decimals(), 8);

        assertNotEq(variableDebtTokenAddress, address(0));

        IERC20Metadata variableDebtToken =
            IERC20Metadata(variableDebtTokenAddress);

        assertEq(variableDebtToken.name(), "Seamless Variable Debt cbBTC");
        assertEq(variableDebtToken.symbol(), "variableDebtSeamcbBTC");
        assertEq(variableDebtToken.decimals(), 8);
    }

    function test_eurcTokens_afterPassingProposal() public {
        _passProposalShortGov(proposal);

        (address collateralTokenAddress,, address variableDebtTokenAddress) =
            poolDataProvider.getReserveTokensAddresses(SeamlessAddressBook.EURC);

        assertNotEq(collateralTokenAddress, address(0));

        IERC20Metadata collateralToken = IERC20Metadata(collateralTokenAddress);

        assertEq(collateralToken.name(), "Seamless EURC");
        assertEq(collateralToken.symbol(), "sEURC");
        assertEq(collateralToken.decimals(), 6);

        assertNotEq(variableDebtTokenAddress, address(0));

        IERC20Metadata variableDebtToken =
            IERC20Metadata(variableDebtTokenAddress);

        assertEq(variableDebtToken.name(), "Seamless Variable Debt EURC");
        assertEq(variableDebtToken.symbol(), "variableDebtSeamEURC");
        assertEq(variableDebtToken.decimals(), 6);
    }

    function test_cbBTCConfig_afterPassingProposal() public {
        _passProposalShortGov(proposal);

        address priceFeedAddress =
            aaveOracle.getSourceOfAsset(SeamlessAddressBook.CBBTC);

        assertEq(priceFeedAddress, 0x64c911996D3c6aC71f9b455B1E8E7266BcbD848F);

        DataTypes.ReserveData memory reserveData =
            pool.getReserveData(SeamlessAddressBook.CBBTC);

        assertNotEq(reserveData.interestRateStrategyAddress, address(0));

        IDefaultInterestRateStrategy interestRateStrategy =
        IDefaultInterestRateStrategy(reserveData.interestRateStrategyAddress);

        assertEq(interestRateStrategy.OPTIMAL_USAGE_RATIO(), 0.45e27);
        assertEq(interestRateStrategy.getBaseVariableBorrowRate(), 0);
        assertEq(interestRateStrategy.getVariableRateSlope1(), 0.04e27);
        assertEq(interestRateStrategy.getVariableRateSlope2(), 3e27);

        DataTypes.ReserveConfigurationMap memory reserveConfig =
            pool.getConfiguration(SeamlessAddressBook.CBBTC);

        assertEq(
            reserveConfig.getDecimals(),
            IERC20Metadata(SeamlessAddressBook.CBBTC).decimals()
        );
        assertEq(reserveConfig.getBorrowingEnabled(), true);
        assertEq(reserveConfig.getFlashLoanEnabled(), true);
        assertEq(reserveConfig.getBorrowableInIsolation(), false);
        assertEq(reserveConfig.getBorrowCap(), 20);
        assertEq(reserveConfig.getSupplyCap(), 200);
        assertEq(reserveConfig.getLiquidationBonus(), 110_00);
        assertEq(reserveConfig.getDebtCeiling(), 0);
        assertEq(reserveConfig.getLiquidationProtocolFee(), 10_00);
        assertEq(reserveConfig.getLiquidationThreshold(), 78_00);
        assertEq(reserveConfig.getLtv(), 73_00);
        assertEq(reserveConfig.getReserveFactor(), 20_00);
    }

    function test_cbBTCSeeded_afterPassingProposal() public {
        _passProposalShortGov(proposal);

        assertEq(
            poolDataProvider.getATokenTotalSupply(SeamlessAddressBook.CBBTC),
            2e5
        );
    }

    function test_supplyBorrowcbBTC_afterPassingProposal() public {
        _passProposalShortGov(proposal);

        address user = makeAddr("user");

        deal(SeamlessAddressBook.CBBTC, user, 1e8);

        vm.startPrank(user);

        IERC20Metadata(SeamlessAddressBook.CBBTC).approve(address(pool), 1e8);

        pool.supply(SeamlessAddressBook.CBBTC, 1e8, user, 0);

        (,,,,, uint256 healthFactor) = pool.getUserAccountData(user);

        assertEq(healthFactor, type(uint256).max);

        pool.borrow(SeamlessAddressBook.CBBTC, 1e4, 2, 0, user);

        (,,,,, healthFactor) = pool.getUserAccountData(user);

        assertLt(healthFactor, type(uint256).max);

        vm.stopPrank();
    }

    function test_eurcConfig_afterPassingProposal() public {
        _passProposalShortGov(proposal);

        address priceFeedAddress =
            aaveOracle.getSourceOfAsset(SeamlessAddressBook.EURC);

        assertEq(priceFeedAddress, 0xDAe398520e2B67cd3f27aeF9Cf14D93D927f8250);

        DataTypes.ReserveData memory reserveData =
            pool.getReserveData(SeamlessAddressBook.EURC);

        assertNotEq(reserveData.interestRateStrategyAddress, address(0));

        IDefaultInterestRateStrategy interestRateStrategy =
        IDefaultInterestRateStrategy(reserveData.interestRateStrategyAddress);

        assertEq(interestRateStrategy.OPTIMAL_USAGE_RATIO(), 0.9e27);
        assertEq(interestRateStrategy.getBaseVariableBorrowRate(), 0);
        assertEq(interestRateStrategy.getVariableRateSlope1(), 0.07e27);
        assertEq(interestRateStrategy.getVariableRateSlope2(), 0.75e27);

        DataTypes.ReserveConfigurationMap memory reserveConfig =
            pool.getConfiguration(SeamlessAddressBook.EURC);

        assertEq(
            reserveConfig.getDecimals(),
            IERC20Metadata(SeamlessAddressBook.EURC).decimals()
        );
        assertEq(reserveConfig.getBorrowingEnabled(), true);
        assertEq(reserveConfig.getFlashLoanEnabled(), true);
        assertEq(reserveConfig.getBorrowableInIsolation(), false);
        assertEq(reserveConfig.getBorrowCap(), 2_700_000);
        assertEq(reserveConfig.getSupplyCap(), 3_000_000);
        assertEq(reserveConfig.getLiquidationBonus(), 107_50);
        assertEq(reserveConfig.getDebtCeiling(), 0);
        assertEq(reserveConfig.getLiquidationProtocolFee(), 10_00);
        assertEq(reserveConfig.getLiquidationThreshold(), 70_00);
        assertEq(reserveConfig.getLtv(), 65_00);
        assertEq(reserveConfig.getReserveFactor(), 20_00);
    }

    function test_eurcSeeded_afterPassingProposal() public {
        _passProposalShortGov(proposal);

        assertEq(
            poolDataProvider.getATokenTotalSupply(SeamlessAddressBook.EURC), 1e6
        );
    }

    function test_supplyBorrowEURC_afterPassingProposal() public {
        _passProposalShortGov(proposal);

        address user = makeAddr("user");

        deal(SeamlessAddressBook.EURC, user, 1e8);

        vm.startPrank(user);

        IERC20Metadata(SeamlessAddressBook.EURC).approve(address(pool), 1e8);

        pool.supply(SeamlessAddressBook.EURC, 1e8, user, 0);

        (,,,,, uint256 healthFactor) = pool.getUserAccountData(user);

        assertEq(healthFactor, type(uint256).max);

        pool.borrow(SeamlessAddressBook.EURC, 1e4, 2, 0, user);

        (,,,,, healthFactor) = pool.getUserAccountData(user);

        assertLt(healthFactor, type(uint256).max);

        vm.stopPrank();
    }
}
