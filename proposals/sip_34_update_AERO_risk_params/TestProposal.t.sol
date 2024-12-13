// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    GovTestHelper, SeamlessAddressBook
} from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { ReserveConfiguration } from
    "@aave/contracts/protocol/libraries/configuration/ReserveConfiguration.sol";
import { DataTypes } from
    "@aave/contracts/protocol/libraries/types/DataTypes.sol";
import { IPool } from "@aave/contracts/interfaces/IPool.sol";

contract TestProposal is GovTestHelper {
    using ReserveConfiguration for DataTypes.ReserveConfigurationMap;

    Proposal public proposal;

    IPool pool = IPool(SeamlessAddressBook.POOL);

    function setUp() public {
        vm.rollFork(23630736);
        proposal = new Proposal();
    }

    function test_AERO() public {
        DataTypes.ReserveConfigurationMap memory reserveConfigBefore =
            pool.getConfiguration(SeamlessAddressBook.AERO);

        _passProposalShortGov(proposal);

        DataTypes.ReserveConfigurationMap memory reserveConfigAfter =
            pool.getConfiguration(SeamlessAddressBook.AERO);

        assertEq(reserveConfigAfter.getLtv(), 67_50); // 67.5%
        assertEq(reserveConfigAfter.getLiquidationThreshold(), 72_50); // 72.5%
        assertEq(
            reserveConfigAfter.getLiquidationBonus(),
            reserveConfigBefore.getLiquidationBonus()
        );
    }
}
