// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import {
    PoolAddressesProvider,
    Ownable
} from "@aave/contracts/protocol/configuration/PoolAddressesProvider.sol";
import {
    ACLManager,
    AccessControl
} from "@aave/contracts/protocol/configuration/ACLManager.sol";
// import {
//     PoolAddressesProviderRegistry,
//     Ownable
// } from "@aave/contracts/protocol/configuration/PoolAddressesProviderRegistry.sol";

contract Proposal is SeamlessGovProposal {
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    // 0x12ad05bde78c5ab75238ce885307f96ecd482bb402ef831f99e7018a0f169b7b
    bytes32 public constant POOL_ADMIN_ROLE = keccak256("POOL_ADMIN");
    // 0x5c91514091af31f62f596a314af7d5be40146b2f2355969392f055e12e0982fb
    bytes32 public constant EMERGENCY_ADMIN_ROLE = keccak256("EMERGENCY_ADMIN");
    // 0x8aa855a911518ecfbe5bc3088c8f3dda7badf130faaf8ace33fdc33828e18167
    bytes32 public constant RISK_ADMIN_ROLE = keccak256("RISK_ADMIN");
    // 0x939b8dfb57ecef2aea54a93a15e86768b9d4089f1ba61c245e6ec980695f4ca4
    bytes32 public constant FLASH_BORROWER_ROLE = keccak256("FLASH_BORROWER");
    // 0x08fb31c3e81624356c3314088aa971b73bcc82d22bc3e3b184b4593077ae3278
    bytes32 public constant BRIDGE_ROLE = keccak256("BRIDGE");
    // 0x19c860a63258efbd0ecb7d55c626237bf5c2044c26c073390b74f0c13c857433
    bytes32 public constant ASSET_LISTING_ADMIN_ROLE =
        keccak256("ASSET_LISTING_ADMIN");

    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        // Remove ACL roles
        _addAction(
            SeamlessAddressBook.ACL_MANAGER,
            abi.encodeWithSelector(
                AccessControl.revokeRole.selector,
                EMERGENCY_ADMIN_ROLE,
                SeamlessAddressBook.GUARDIAN_MULTISIG
            )
        );

        _addAction(
            SeamlessAddressBook.ACL_MANAGER,
            abi.encodeWithSelector(
                AccessControl.revokeRole.selector,
                EMERGENCY_ADMIN_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );

        _addAction(
            SeamlessAddressBook.ACL_MANAGER,
            abi.encodeWithSelector(
                AccessControl.revokeRole.selector,
                RISK_ADMIN_ROLE,
                SeamlessAddressBook.CAPS_PLUS_RISK_STEWARD
            )
        );

        _addAction(
            SeamlessAddressBook.ACL_MANAGER,
            abi.encodeWithSelector(
                AccessControl.revokeRole.selector,
                RISK_ADMIN_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );

        _addAction(
            SeamlessAddressBook.ACL_MANAGER,
            abi.encodeWithSelector(
                AccessControl.revokeRole.selector,
                ASSET_LISTING_ADMIN_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );

        _addAction(
            SeamlessAddressBook.ACL_MANAGER,
            abi.encodeWithSelector(
                AccessControl.revokeRole.selector,
                POOL_ADMIN_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );

        _addAction(
            SeamlessAddressBook.ACL_MANAGER,
            abi.encodeWithSelector(
                AccessControl.revokeRole.selector,
                DEFAULT_ADMIN_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );

        // Set ACL admin to 0 address
        _addAction(
            SeamlessAddressBook.POOL_ADDRESSES_PROVIDER,
            abi.encodeWithSelector(
                PoolAddressesProvider.setACLAdmin.selector, address(0)
            )
        );

        // Renounce ownership of Emission Manager
        _addAction(
            SeamlessAddressBook.EMISSION_MANAGER,
            abi.encodeWithSelector(Ownable.renounceOwnership.selector)
        );

        // Renounce ownership of Ecosystem Reserve Controller
        _addAction(
            SeamlessAddressBook.SEAMLESS_TREASURY_ADMIN,
            abi.encodeWithSelector(Ownable.renounceOwnership.selector)
        );

        // Renounce ownership of pool address provider
        _addAction(
            SeamlessAddressBook.POOL_ADDRESSES_PROVIDER,
            abi.encodeWithSelector(Ownable.renounceOwnership.selector)
        );

        // Renounce ownership of pool addresses provider registry
        _addAction(
            SeamlessAddressBook.POOL_ADDRESSES_PROVIDER_REGISTRY,
            abi.encodeWithSelector(Ownable.renounceOwnership.selector)
        );
    }
}
