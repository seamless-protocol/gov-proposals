// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    IPoolDataProvider
} from "@aave/contracts/interfaces/IPoolDataProvider.sol";
import { IPool } from "@aave/contracts/interfaces/IPool.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { AToken } from "@aave/contracts/protocol/tokenization/AToken.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";
import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        proposal = new Proposal();
    }

    function test_transferAllReserveFactorAssets() public {
        IPoolDataProvider poolDataProvider =
            IPoolDataProvider(SeamlessAddressBook.POOL_DATA_PROVIDER);
        IPoolDataProvider.TokenData[] memory aTokens =
            poolDataProvider.getAllATokens();

        _passProposalShortGov(proposal);

        for (uint256 i = 0; i < aTokens.length; i++) {
            vm.startPrank(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN);
            uint256 balanceBefore = IERC20(aTokens[i].tokenAddress)
                .balanceOf(SeamlessAddressBook.SEAMLESS_TREASURY);

            IERC20(aTokens[i].tokenAddress)
                .transferFrom(
                    SeamlessAddressBook.SEAMLESS_TREASURY,
                    SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                    balanceBefore
                );

            assertEq(
                IERC20(aTokens[i].tokenAddress)
                    .balanceOf(SeamlessAddressBook.SEAMLESS_TREASURY),
                0
            );
            assertEq(
                IERC20(aTokens[i].tokenAddress)
                    .balanceOf(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN),
                balanceBefore
            );

            // Withdraw the aToken by calling withdraw() on the pool
            if (balanceBefore == 0) {
                // skip tokens with no balance
                continue;
            }

            address assetAddress =
                AToken(aTokens[i].tokenAddress).UNDERLYING_ASSET_ADDRESS();
            IPool(SeamlessAddressBook.POOL)
                .withdraw(
                    assetAddress,
                    1e6,
                    SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN
                );
            // assertEq(
            //     IERC20(aTokens[i].tokenAddress)
            //         .balanceOf(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN),
            //     0
            // );
            vm.stopPrank();
        }
    }

    function test_transferAllTimelockAssets() public {
        uint256 usdcBalanceBefore = IERC20(SeamlessAddressBook.USDC)
            .balanceOf(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN);
        uint256 seamlessUsdcMorphoVaultBalanceBefore = IERC20(
                SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT
            ).balanceOf(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN);
        uint256 seamlessCbbtcMorphoVaultBalanceBefore = IERC20(
                SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT
            ).balanceOf(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN);
        uint256 seamlessWethMorphoVaultBalanceBefore = IERC20(
                SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT
            ).balanceOf(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN);

        uint256 usdcBalanceTimelock = IERC20(SeamlessAddressBook.USDC)
            .balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);
        uint256 seamlessUsdcMorphoVaultBalanceTimelock = IERC20(
                SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT
            ).balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);
        uint256 seamlessCbbtcMorphoVaultBalanceTimelock = IERC20(
                SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT
            ).balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);
        uint256 seamlessWethMorphoVaultBalanceTimelock = IERC20(
                SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT
            ).balanceOf(SeamlessAddressBook.TIMELOCK_SHORT);

        _passProposalShortGov(proposal);

        assertEq(
            IERC20(SeamlessAddressBook.USDC)
                .balanceOf(SeamlessAddressBook.TIMELOCK_SHORT),
            0
        );
        assertEq(
            IERC20(SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT)
                .balanceOf(SeamlessAddressBook.TIMELOCK_SHORT),
            0
        );
        assertEq(
            IERC20(SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT)
                .balanceOf(SeamlessAddressBook.TIMELOCK_SHORT),
            0
        );
        assertEq(
            IERC20(SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT)
                .balanceOf(SeamlessAddressBook.TIMELOCK_SHORT),
            0
        );

        assertEq(
            IERC20(SeamlessAddressBook.USDC)
                .balanceOf(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN),
            usdcBalanceBefore + usdcBalanceTimelock
        );
        assertEq(
            IERC20(SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT)
                .balanceOf(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN),
            seamlessUsdcMorphoVaultBalanceBefore
                + seamlessUsdcMorphoVaultBalanceTimelock
        );
        assertEq(
            IERC20(SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT)
                .balanceOf(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN),
            seamlessCbbtcMorphoVaultBalanceBefore
                + seamlessCbbtcMorphoVaultBalanceTimelock
        );
        assertEq(
            IERC20(SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT)
                .balanceOf(SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN),
            seamlessWethMorphoVaultBalanceBefore
                + seamlessWethMorphoVaultBalanceTimelock
        );
    }
}
