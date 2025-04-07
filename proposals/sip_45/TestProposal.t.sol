// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessGovProposal.sol";
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
        _passProposalShortGov(proposal);

        address[] memory assets = pool.getReservesList();
        for (uint256 i = 0; i < assets.length; i++) {
            (,,,,,,,,, bool isFrozen) =
                poolDataProvider.getReserveConfigurationData(assets[i]);
            assertEq(isFrozen, true);

            // Check that supply and borrow operations revert when reserves are frozen
            vm.expectRevert(bytes(Errors.RESERVE_FROZEN));
            pool.supply(assets[i], 100, address(this), 0);

            vm.expectRevert(bytes(Errors.RESERVE_FROZEN));
            pool.borrow(assets[i], 100, 2, 0, address(this));
        }
    }
}
