// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IAccessControl } from
    "@openzeppelin/contracts/access/IAccessControl.sol";
import { IMetaMorphoV1_1Base } from
    "@seamless-governance/interfaces/IMetaMorphoV1_1.sol";

contract Proposal is SeamlessGovProposal {
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
    bytes32 public constant REWARD_SETTER_ROLE = keccak256("REWARD_SETTER_ROLE");

    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        // Clear Morpho vault roles, then renounce ownership
        _clearMorphoVaultRoles(
            SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT,
            SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT_ALLOCATOR
        );
        _clearMorphoVaultRoles(
            SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT,
            SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT_ALLOCATOR
        );
        _clearMorphoVaultRoles(
            SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT,
            SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT_ALLOCATOR
        );

        // Renounce ownership of Leverage Token Factory
        _addAction(
            SeamlessAddressBook.BASE_LEVERAGE_TOKEN_FACTORY_PROXY,
            abi.encodeWithSelector(Ownable.renounceOwnership.selector)
        );

        // Renounce ownership of weETH/WETH 17x Rebalance Adapter
        _addAction(
            SeamlessAddressBook.WEETH_WETH_17X_REBALANCE_ADAPTER,
            abi.encodeWithSelector(Ownable.renounceOwnership.selector)
        );

        // Revoke Guardian roles on FeeKeeper, then renounce all short timelock roles
        _addAction(
            SeamlessAddressBook.FEE_KEEPER,
            abi.encodeWithSelector(
                IAccessControl.revokeRole.selector,
                PAUSER_ROLE,
                SeamlessAddressBook.GUARDIAN_MULTISIG
            )
        );
        _addAction(
            SeamlessAddressBook.FEE_KEEPER,
            abi.encodeWithSelector(
                IAccessControl.revokeRole.selector,
                REWARD_SETTER_ROLE,
                SeamlessAddressBook.GUARDIAN_MULTISIG
            )
        );
        _addAction(
            SeamlessAddressBook.FEE_KEEPER,
            abi.encodeWithSelector(
                IAccessControl.renounceRole.selector,
                MANAGER_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
        _addAction(
            SeamlessAddressBook.FEE_KEEPER,
            abi.encodeWithSelector(
                IAccessControl.renounceRole.selector,
                UPGRADER_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
        _addAction(
            SeamlessAddressBook.FEE_KEEPER,
            abi.encodeWithSelector(
                IAccessControl.renounceRole.selector,
                PAUSER_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
        _addAction(
            SeamlessAddressBook.FEE_KEEPER,
            abi.encodeWithSelector(
                IAccessControl.renounceRole.selector,
                REWARD_SETTER_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
        _addAction(
            SeamlessAddressBook.FEE_KEEPER,
            abi.encodeWithSelector(
                IAccessControl.renounceRole.selector,
                DEFAULT_ADMIN_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );

        // Renounce remaining short timelock roles on stkSEAM
        _addAction(
            SeamlessAddressBook.stkSEAM,
            abi.encodeWithSelector(
                IAccessControl.renounceRole.selector,
                MANAGER_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
        _addAction(
            SeamlessAddressBook.stkSEAM,
            abi.encodeWithSelector(
                IAccessControl.renounceRole.selector,
                PAUSER_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );

        // Renounce short timelock roles on Leverage Manager
        _addAction(
            SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY,
            abi.encodeWithSelector(
                IAccessControl.renounceRole.selector,
                UPGRADER_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
        _addAction(
            SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY,
            abi.encodeWithSelector(
                IAccessControl.renounceRole.selector,
                DEFAULT_ADMIN_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );
    }

    function _clearMorphoVaultRoles(
        address vault,
        address vaultAllocator
    )
        internal
    {
        _addAction(
            vault,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.setCurator.selector, address(0)
            )
        );
        _addAction(
            vault,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.setIsAllocator.selector,
                vaultAllocator,
                false
            )
        );
        _addAction(
            vault,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.setIsAllocator.selector,
                SeamlessAddressBook.MORPHO_PUBLIC_ALLOCATOR,
                false
            )
        );
        // Guardian removal is timelocked; this submits address(0) as pending guardian.
        // Anyone can call acceptGuardian() after the vault timelock elapses.
        _addAction(
            vault,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.submitGuardian.selector, address(0)
            )
        );
        _addAction(
            vault, abi.encodeWithSelector(Ownable.renounceOwnership.selector)
        );
    }
}
