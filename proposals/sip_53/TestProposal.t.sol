// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IAccessControl } from
    "@openzeppelin/contracts/access/IAccessControl.sol";
import { IMetaMorphoV1_1 } from
    "@seamless-governance/interfaces/IMetaMorphoV1_1.sol";

interface IMetaMorphoPendingGuardian {
    function pendingGuardian()
        external
        view
        returns (address pendingGuardian, uint64 validAt);
}

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant REWARD_SETTER_ROLE = keccak256("REWARD_SETTER_ROLE");

    function setUp() public {
        vm.rollFork(50528700);
        proposal = new Proposal();
    }

    function test_renounceOwnershipOfMorphoVaults() public {
        assertEq(
            Ownable(SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT).owner(),
            SeamlessAddressBook.TIMELOCK_SHORT
        );
        assertEq(
            Ownable(SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT).owner(),
            SeamlessAddressBook.TIMELOCK_SHORT
        );
        assertEq(
            Ownable(SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT).owner(),
            SeamlessAddressBook.TIMELOCK_SHORT
        );

        _passProposalShortGov(proposal);

        assertEq(
            Ownable(SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT).owner(),
            address(0)
        );
        assertEq(
            Ownable(SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT).owner(),
            address(0)
        );
        assertEq(
            Ownable(SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT).owner(),
            address(0)
        );
    }

    function test_clearMorphoVaultRoles() public {
        address[3] memory vaults = [
            SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT,
            SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT,
            SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT
        ];
        address[3] memory vaultAllocators = [
            SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT_ALLOCATOR,
            SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT_ALLOCATOR,
            SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT_ALLOCATOR
        ];

        for (uint256 i = 0; i < vaults.length; i++) {
            IMetaMorphoV1_1 vault = IMetaMorphoV1_1(vaults[i]);

            assertEq(vault.owner(), SeamlessAddressBook.TIMELOCK_SHORT);
            assertEq(
                vault.curator(),
                SeamlessAddressBook.SEAMLESS_MORPHO_VAULT_CURATOR
            );
            assertTrue(vault.isAllocator(vaultAllocators[i]));
            assertTrue(
                vault.isAllocator(SeamlessAddressBook.MORPHO_PUBLIC_ALLOCATOR)
            );
            assertEq(
                vault.guardian(),
                SeamlessAddressBook.SEAMLESS_MORPHO_VAULT_GUARDIAN
            );

            (address pendingGuardianBefore, uint64 validAtBefore) =
                IMetaMorphoPendingGuardian(vaults[i]).pendingGuardian();
            assertEq(pendingGuardianBefore, address(0));
            assertEq(validAtBefore, 0);
        }

        _passProposalShortGov(proposal);

        uint256 maxTimelock;
        for (uint256 i = 0; i < vaults.length; i++) {
            IMetaMorphoV1_1 vault = IMetaMorphoV1_1(vaults[i]);

            assertEq(vault.curator(), address(0));
            assertFalse(vault.isAllocator(vaultAllocators[i]));
            assertFalse(
                vault.isAllocator(SeamlessAddressBook.MORPHO_PUBLIC_ALLOCATOR)
            );
            assertEq(
                vault.guardian(),
                SeamlessAddressBook.SEAMLESS_MORPHO_VAULT_GUARDIAN
            );

            (address pendingGuardian, uint64 validAt) =
                IMetaMorphoPendingGuardian(vaults[i]).pendingGuardian();
            assertEq(pendingGuardian, address(0));
            assertGt(validAt, 0);

            if (vault.timelock() > maxTimelock) {
                maxTimelock = vault.timelock();
            }
        }

        skip(maxTimelock + 1);

        for (uint256 i = 0; i < vaults.length; i++) {
            IMetaMorphoV1_1 vault = IMetaMorphoV1_1(vaults[i]);
            vault.acceptGuardian();
            assertEq(vault.guardian(), address(0));
        }
    }

    function test_renounceOwnershipOfLeverageTokenFactory() public {
        assertEq(
            Ownable(SeamlessAddressBook.BASE_LEVERAGE_TOKEN_FACTORY_PROXY)
                .owner(),
            SeamlessAddressBook.TIMELOCK_SHORT
        );

        _passProposalShortGov(proposal);

        assertEq(
            Ownable(SeamlessAddressBook.BASE_LEVERAGE_TOKEN_FACTORY_PROXY)
                .owner(),
            address(0)
        );
    }

    function test_renounceOwnershipOfRebalanceAdapter() public {
        assertEq(
            Ownable(SeamlessAddressBook.WEETH_WETH_17X_REBALANCE_ADAPTER)
                .owner(),
            SeamlessAddressBook.TIMELOCK_SHORT
        );

        _passProposalShortGov(proposal);

        assertEq(
            Ownable(SeamlessAddressBook.WEETH_WETH_17X_REBALANCE_ADAPTER)
                .owner(),
            address(0)
        );
    }

    function test_renounceFeeKeeperRoles() public {
        IAccessControl feeKeeper =
            IAccessControl(SeamlessAddressBook.FEE_KEEPER);

        assertTrue(
            feeKeeper.hasRole(
                DEFAULT_ADMIN_ROLE, SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
        assertTrue(
            feeKeeper.hasRole(MANAGER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT)
        );
        assertTrue(
            feeKeeper.hasRole(UPGRADER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT)
        );
        assertTrue(
            feeKeeper.hasRole(PAUSER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT)
        );
        assertTrue(
            feeKeeper.hasRole(
                REWARD_SETTER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
        assertTrue(
            feeKeeper.hasRole(
                PAUSER_ROLE, SeamlessAddressBook.GUARDIAN_MULTISIG
            )
        );
        assertTrue(
            feeKeeper.hasRole(
                REWARD_SETTER_ROLE, SeamlessAddressBook.GUARDIAN_MULTISIG
            )
        );

        _passProposalShortGov(proposal);

        assertFalse(
            feeKeeper.hasRole(
                DEFAULT_ADMIN_ROLE, SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
        assertFalse(
            feeKeeper.hasRole(MANAGER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT)
        );
        assertFalse(
            feeKeeper.hasRole(UPGRADER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT)
        );
        assertFalse(
            feeKeeper.hasRole(PAUSER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT)
        );
        assertFalse(
            feeKeeper.hasRole(
                REWARD_SETTER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
        assertFalse(
            feeKeeper.hasRole(
                PAUSER_ROLE, SeamlessAddressBook.GUARDIAN_MULTISIG
            )
        );
        assertFalse(
            feeKeeper.hasRole(
                REWARD_SETTER_ROLE, SeamlessAddressBook.GUARDIAN_MULTISIG
            )
        );
    }

    function test_renounceStkSEAMShortTimelockRoles() public {
        IAccessControl stkSEAM = IAccessControl(SeamlessAddressBook.stkSEAM);

        assertTrue(
            stkSEAM.hasRole(MANAGER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT)
        );
        assertTrue(
            stkSEAM.hasRole(PAUSER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT)
        );

        _passProposalShortGov(proposal);

        assertFalse(
            stkSEAM.hasRole(MANAGER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT)
        );
        assertFalse(
            stkSEAM.hasRole(PAUSER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT)
        );
    }

    function test_renounceLeverageManagerRoles() public {
        IAccessControl leverageManager =
            IAccessControl(SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY);

        assertTrue(
            leverageManager.hasRole(
                DEFAULT_ADMIN_ROLE, SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
        assertTrue(
            leverageManager.hasRole(
                UPGRADER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT
            )
        );

        _passProposalShortGov(proposal);

        assertFalse(
            leverageManager.hasRole(
                DEFAULT_ADMIN_ROLE, SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
        assertFalse(
            leverageManager.hasRole(
                UPGRADER_ROLE, SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
    }
}
