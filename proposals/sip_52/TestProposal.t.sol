// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { ACLManager } from "@aave/contracts/protocol/configuration/ACLManager.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";
import { PoolAddressesProvider } from "@aave/contracts/protocol/configuration/PoolAddressesProvider.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        vm.rollFork(49593834);
        proposal = new Proposal();
    }

    function test_removeACLRoles() public {
        _passProposalShortGov(proposal);

        address[] memory admins = new address[](2);
        admins[0] = SeamlessAddressBook.GUARDIAN_MULTISIG;
        admins[1] = SeamlessAddressBook.TIMELOCK_SHORT;

        for (uint256 i = 0; i < admins.length; i++) {
            assertFalse(ACLManager(SeamlessAddressBook.ACL_MANAGER).hasRole(0x00, admins[i]));
            assertFalse(ACLManager(SeamlessAddressBook.ACL_MANAGER).hasRole(keccak256("POOL_ADMIN"), admins[i]));
            assertFalse(ACLManager(SeamlessAddressBook.ACL_MANAGER).hasRole(keccak256("EMERGENCY_ADMIN"), admins[i]));
            assertFalse(ACLManager(SeamlessAddressBook.ACL_MANAGER).hasRole(keccak256("RISK_ADMIN"), admins[i]));
            assertFalse(ACLManager(SeamlessAddressBook.ACL_MANAGER).hasRole(keccak256("FLASH_BORROWER"), admins[i]));
            assertFalse(ACLManager(SeamlessAddressBook.ACL_MANAGER).hasRole(keccak256("BRIDGE"), admins[i]));
            assertFalse(ACLManager(SeamlessAddressBook.ACL_MANAGER).hasRole(keccak256("ASSET_LISTING_ADMIN"), admins[i]));
        }
    }

    function test_setACLAdminToZeroAddress() public {
        _passProposalShortGov(proposal);

        address aclAdmin = PoolAddressesProvider(SeamlessAddressBook.POOL_ADDRESSES_PROVIDER).getACLAdmin();
        assertEq(aclAdmin, address(0));
    }

    function test_renounceOwnershipOfEmissionManager() public {
        _passProposalShortGov(proposal);

        assertEq(Ownable(SeamlessAddressBook.EMISSION_MANAGER).owner(), address(0));
    }

    function test_renounceOwnershipOfSeamlessTreasuryAdmin() public {
        _passProposalShortGov(proposal);

        assertEq(Ownable(SeamlessAddressBook.SEAMLESS_TREASURY_ADMIN).owner(), address(0));
    }

    function test_renounceOwnershipOfPoolAddressesProvider() public {
        _passProposalShortGov(proposal);

        assertEq(Ownable(SeamlessAddressBook.POOL_ADDRESSES_PROVIDER).owner(), address(0));
    }
    
    function test_renounceOwnershipOfPoolAddressesProviderRegistry() public {
        _passProposalShortGov(proposal);

        assertEq(Ownable(SeamlessAddressBook.POOL_ADDRESSES_PROVIDER_REGISTRY).owner(), address(0));
    }
}
