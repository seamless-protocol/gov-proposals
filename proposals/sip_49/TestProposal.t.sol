// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";
import { UpgradeableBeacon } from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import { ERC1967Utils } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import { IAccessControl } from "@openzeppelin/contracts/access/IAccessControl.sol";

contract TestProposal is GovTestHelper {
    // ERC1967 implementation slot for UUPS proxy
    bytes32 constant ERC1967_IMPLEMENTATION_SLOT =
        0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    Proposal public proposal;

    // Expected new implementation addresses from the proposal
    address constant EXPECTED_NEW_BASE_LEVERAGE_TOKEN_IMPLEMENTATION = 0x603Da735780e6bC7D04f3FB85C26dccCd4Ff0a82;
    address constant EXPECTED_NEW_BASE_LEVERAGE_MANAGER_IMPLEMENTATION = 0xfE9101349354E278970489F935a54905DE2E1856;

    function setUp() public {
        vm.rollFork(36538639);
        proposal = new Proposal();
    }

    function test_baseLeverageTokenImplementationIsUpgraded_afterPassingProposal() public {
        // Get the beacon proxy instance
        UpgradeableBeacon beacon = UpgradeableBeacon(SeamlessAddressBook.BASE_LEVERAGE_TOKEN_FACTORY_PROXY);
        
        // Get current implementation from the beacon
        address implementationBefore = beacon.implementation();
        
        // Verify it's not already the new implementation
        assertNotEq(
            implementationBefore, 
            EXPECTED_NEW_BASE_LEVERAGE_TOKEN_IMPLEMENTATION,
            "Base Leverage Token implementation should not be upgraded yet"
        );

        // Pass the proposal
        _passProposalShortGov(proposal);

        // Get the implementation after the proposal
        address implementationAfter = beacon.implementation();
        
        // Verify the implementation has been upgraded to the expected address
        assertEq(
            implementationAfter,
            EXPECTED_NEW_BASE_LEVERAGE_TOKEN_IMPLEMENTATION,
            "Base Leverage Token implementation should be upgraded to the new implementation"
        );
    }

    function test_baseLeverageManagerImplementationIsUpgraded_afterPassingProposal() public {
        // Get current implementation from the UUPS proxy storage slot
        address implementationBefore = address(
            uint160(
                uint256(
                    vm.load(
                        SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY,
                        ERC1967_IMPLEMENTATION_SLOT
                    )
                )
            )
        );
        
        // Verify it's not already the new implementation
        assertNotEq(
            implementationBefore, 
            EXPECTED_NEW_BASE_LEVERAGE_MANAGER_IMPLEMENTATION,
            "Base Leverage Manager implementation should not be upgraded yet"
        );

        // Pass the proposal
        _passProposalShortGov(proposal);

        // Get the implementation after the proposal
        address implementationAfter = address(
            uint160(
                uint256(
                    vm.load(
                        SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY,
                        ERC1967_IMPLEMENTATION_SLOT
                    )
                )
            )
        );
        
        // Verify the implementation has been upgraded to the expected address
        assertEq(
            implementationAfter,
            EXPECTED_NEW_BASE_LEVERAGE_MANAGER_IMPLEMENTATION,
            "Base Leverage Manager implementation should be upgraded to the new implementation"
        );
    }

    function test_bothImplementationsAreUpgraded_afterPassingProposal() public {
        // Get beacon for Base Leverage Token
        UpgradeableBeacon beacon = UpgradeableBeacon(SeamlessAddressBook.BASE_LEVERAGE_TOKEN_FACTORY_PROXY);
        
        // Store both implementations before the proposal
        address tokenImplementationBefore = beacon.implementation();
        address managerImplementationBefore = address(
            uint160(
                uint256(
                    vm.load(
                        SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY,
                        ERC1967_IMPLEMENTATION_SLOT
                    )
                )
            )
        );

        // Verify neither implementation is already upgraded
        assertNotEq(tokenImplementationBefore, EXPECTED_NEW_BASE_LEVERAGE_TOKEN_IMPLEMENTATION);
        assertNotEq(managerImplementationBefore, EXPECTED_NEW_BASE_LEVERAGE_MANAGER_IMPLEMENTATION);

        // Pass the proposal
        _passProposalShortGov(proposal);

        // Get both implementations after the proposal
        address tokenImplementationAfter = beacon.implementation();
        address managerImplementationAfter = address(
            uint160(
                uint256(
                    vm.load(
                        SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY,
                        ERC1967_IMPLEMENTATION_SLOT
                    )
                )
            )
        );

        // Verify both implementations have been upgraded correctly
        assertEq(
            tokenImplementationAfter,
            EXPECTED_NEW_BASE_LEVERAGE_TOKEN_IMPLEMENTATION,
            "Base Leverage Token implementation should be upgraded"
        );
        
        assertEq(
            managerImplementationAfter,
            EXPECTED_NEW_BASE_LEVERAGE_MANAGER_IMPLEMENTATION,
            "Base Leverage Manager implementation should be upgraded"
        );
    }

    function test_proposalActionsMatchExpected() public view {
        // The proposal now needs to read the UPGRADER_ROLE from itself
        bytes32 upgraderRole = proposal.UPGRADER_ROLE();
        
        // Verify the proposal has exactly 3 actions (no revoke action)
        assertEq(proposal.getTargets().length, 3, "Proposal should have exactly 3 actions");
        
        // Action 1: Grant UPGRADER_ROLE to timelock
        assertEq(
            proposal.getTargets()[0],
            SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY,
            "First target should be Base Leverage Manager Proxy (grant role)"
        );
        bytes memory expectedCalldata1 = abi.encodeWithSelector(
            bytes4(keccak256("grantRole(bytes32,address)")),
            upgraderRole,
            SeamlessAddressBook.TIMELOCK_SHORT
        );
        assertEq(
            proposal.getCalldatas()[0],
            expectedCalldata1,
            "First action should grant UPGRADER_ROLE to timelock"
        );
        
        // Action 2: Upgrade Base Leverage Token Factory
        assertEq(
            proposal.getTargets()[1],
            SeamlessAddressBook.BASE_LEVERAGE_TOKEN_FACTORY_PROXY,
            "Second target should be Base Leverage Token Factory Proxy"
        );
        bytes memory expectedCalldata2 = abi.encodeWithSelector(
            UpgradeableBeacon.upgradeTo.selector,
            EXPECTED_NEW_BASE_LEVERAGE_TOKEN_IMPLEMENTATION
        );
        assertEq(
            proposal.getCalldatas()[1],
            expectedCalldata2,
            "Second action calldata should match expected upgradeTo call"
        );
        
        // Action 3: Upgrade Base Leverage Manager
        assertEq(
            proposal.getTargets()[2],
            SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY,
            "Third target should be Base Leverage Manager Proxy (upgrade)"
        );
        bytes memory expectedCalldata3 = abi.encodeWithSelector(
            bytes4(keccak256("upgradeToAndCall(address,bytes)")),
            EXPECTED_NEW_BASE_LEVERAGE_MANAGER_IMPLEMENTATION,
            ""
        );
        assertEq(
            proposal.getCalldatas()[2],
            expectedCalldata3,
            "Third action calldata should match expected upgradeToAndCall call"
        );
        
        // Note: The timelock will retain this role for future upgrades
    }

    function test_accessControlIsHandledCorrectly() public {
        bytes32 upgraderRole = proposal.UPGRADER_ROLE();
        
        // Check that the timelock doesn't have the UPGRADER_ROLE initially
        bool hasRoleBefore = IAccessControl(SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY)
            .hasRole(upgraderRole, SeamlessAddressBook.TIMELOCK_SHORT);
        assertFalse(hasRoleBefore, "Timelock should not have UPGRADER_ROLE before proposal");
        
        // Pass the proposal
        _passProposalShortGov(proposal);
        
        // After the proposal, the timelock should have been granted the role
        // and it should STILL have the role (not revoked)
        bool hasRoleAfter = IAccessControl(SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY)
            .hasRole(upgraderRole, SeamlessAddressBook.TIMELOCK_SHORT);
        assertTrue(hasRoleAfter, "Timelock should have UPGRADER_ROLE after proposal (not revoked)");
    }
}
