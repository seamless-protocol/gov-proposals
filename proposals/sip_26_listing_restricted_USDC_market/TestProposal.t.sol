pragma solidity ^0.8.21;

import { Test, console } from "forge-std/Test.sol";
import { Proposal } from "./Proposal.sol";
import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { IPoolDataProvider } from
    "@aave/contracts/interfaces/IPoolDataProvider.sol";
import { IAaveOracle } from "@aave/contracts/interfaces/IAaveOracle.sol";
import { IERC20Metadata } from
    "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";

contract TestProposal is Test, GovTestHelper {
    Proposal public proposal;

    IPoolDataProvider poolDataProvider =
        IPoolDataProvider(SeamlessAddressBook.POOL_DATA_PROVIDER);
    IAaveOracle aaveOracle = IAaveOracle(SeamlessAddressBook.AAVE_ORACLE);

    function setUp() public {
        vm.rollFork(18057033);
        proposal = new Proposal();
    }

    function test_checkAToken_afterPassingProposal() public {
        _passProposalShortGov(proposal);

        (address aTokenAddress,,) = poolDataProvider.getReserveTokensAddresses(
            SeamlessAddressBook.SEAMLESS_RESERVED_USDC
        );

        assertNotEq(aTokenAddress, address(0));

        IERC20Metadata aToken = IERC20Metadata(aTokenAddress);

        assertEq(aToken.name(), "Seamless rUSDC");
        assertEq(aToken.symbol(), "srUSDC");
        assertEq(aToken.decimals(), 6);
    }

    function test_checkReserveConfiguration_afterPassingProposal() public {
        _passProposalShortGov(proposal);

        (
            uint256 decimals,
            uint256 ltv,
            uint256 liquidationThreshold,
            uint256 liquidationBonus,
            uint256 reserveFactor,
            bool usageAsCollateralEnabled,
            bool borrowingEnabled,
            bool stableBorrowRateEnabled,
            bool isActive,
            bool isFrozen
        ) = poolDataProvider.getReserveConfigurationData(
            SeamlessAddressBook.SEAMLESS_RESERVED_USDC
        );

        assertEq(decimals, 6);
        assertEq(ltv, 75_00);
        assertEq(liquidationThreshold, 78_00);
        assertEq(liquidationBonus, 105_00);
        assertEq(reserveFactor, 0);
        assertEq(usageAsCollateralEnabled, true);
        assertEq(borrowingEnabled, false);
        assertEq(stableBorrowRateEnabled, false);
        assertEq(isActive, true);
        assertEq(isFrozen, false);

        (uint256 borrowCap, uint256 supplyCap) = poolDataProvider.getReserveCaps(
            SeamlessAddressBook.SEAMLESS_RESERVED_USDC
        );

        assertEq(borrowCap, 0);
        assertEq(supplyCap, 40_000_000);
    }

    function test_checkAssetSource_afterPassingProposal_sameAsUSDCSource()
        public
    {
        _passProposalShortGov(proposal);

        assertEq(
            aaveOracle.getSourceOfAsset(
                SeamlessAddressBook.SEAMLESS_RESERVED_USDC
            ),
            aaveOracle.getSourceOfAsset(SeamlessAddressBook.USDC)
        );
    }
}
