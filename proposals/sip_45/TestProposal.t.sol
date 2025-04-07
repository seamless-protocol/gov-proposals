// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessGovProposal.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IPool } from "@aave/core-v3/contracts/interfaces/IPool.sol";
import { IPoolDataProvider } from
    "@aave/core-v3/contracts/interfaces/IPoolDataProvider.sol";
import { Errors } from
    "@aave/core-v3/contracts/protocol/libraries/helpers/Errors.sol";

contract TestProposal is GovTestHelper {
    IPool pool = IPool(SeamlessAddressBook.POOL);
    IPoolDataProvider poolDataProvider =
        IPoolDataProvider(SeamlessAddressBook.POOL_DATA_PROVIDER);

    Proposal public proposal;

    function setUp() public {
        vm.rollFork(28632117);
        proposal = new Proposal();
    }

    function test_freezeReserves() public {
        address[] memory assets = pool.getReservesList();

        // Check that all reserves are not frozen before the proposal
        for (uint256 i = 0; i < assets.length; i++) {
            (,,,,,,,,, bool isFrozen) =
                poolDataProvider.getReserveConfigurationData(assets[i]);
            assertEq(isFrozen, false);

            // Deal tokens to this contract for testing
            deal(assets[i], address(this), 2);

            // Approve the pool to spend tokens
            IERC20(assets[i]).approve(address(pool), type(uint256).max);

            // Supply tokens to the pool
            pool.supply(assets[i], 2, address(this), 0);

            // Check if the asset can be borrowed
            (,,,,,, bool borrowingEnabled,,,) =
                poolDataProvider.getReserveConfigurationData(assets[i]);

            if (borrowingEnabled) {
                // Borrow tokens from the pool
                pool.borrow(assets[i], 1, 2, 0, address(this));
            }
        }

        _passProposalShortGov(proposal);

        for (uint256 i = 0; i < assets.length; i++) {
            (,,,,,,,,, bool isFrozen) =
                poolDataProvider.getReserveConfigurationData(assets[i]);
            assertEq(isFrozen, true);

            // Check that supply and borrow operations revert when reserves are frozen
            vm.expectRevert(bytes(Errors.RESERVE_FROZEN));
            pool.supply(assets[i], 100, address(this), 0);

            vm.expectRevert(bytes(Errors.RESERVE_FROZEN));
            pool.borrow(assets[i], 100, 2, 0, address(this));

            // Check that withdraw and repay operations still work when reserves are frozen

            // Withdraw should still work
            pool.withdraw(assets[i], 2, address(this));

            // Repay should still work
            (,,,,,, bool borrowingEnabled,,,) =
                poolDataProvider.getReserveConfigurationData(assets[i]);

            if (borrowingEnabled) {
                // Get current debt before repaying
                (,, uint256 currentDebt,,,,,,) = poolDataProvider
                    .getUserReserveData(assets[i], address(this));

                if (currentDebt > 0) {
                    pool.repay(assets[i], 1, 2, address(this));
                }
            }
        }
    }
}
