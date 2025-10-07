// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { UpgradeableBeacon } from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import { UUPSUpgradeable } from "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import { IAccessControl } from "@openzeppelin/contracts/access/IAccessControl.sol";

contract Proposal is SeamlessGovProposal {
    address constant NEW_BASE_LEVERAGE_TOKEN_IMPLEMENTATION = 0x603Da735780e6bC7D04f3FB85C26dccCd4Ff0a82;
    address constant NEW_BASE_LEVERAGE_MANAGER_IMPLEMENTATION = 0xfE9101349354E278970489F935a54905DE2E1856;
    
    // Access control role required for upgrading
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");

    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        // First, grant the UPGRADER_ROLE to the timelock so it can perform the upgrade
        _addAction(
            SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY,
            abi.encodeWithSelector(
                IAccessControl.grantRole.selector,
                UPGRADER_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );

        // Upgrade the Base Leverage Token implementation (beacon proxy)
        _addAction(
            SeamlessAddressBook.BASE_LEVERAGE_TOKEN_FACTORY_PROXY,
            abi.encodeWithSelector(
                UpgradeableBeacon.upgradeTo.selector,
                NEW_BASE_LEVERAGE_TOKEN_IMPLEMENTATION
            )
        );

        // Upgrade the Base Leverage Manager implementation (UUPS proxy)
        _addAction(
            SeamlessAddressBook.BASE_LEVERAGE_MANAGER_PROXY,
            abi.encodeWithSelector(
                UUPSUpgradeable.upgradeToAndCall.selector,
                NEW_BASE_LEVERAGE_MANAGER_IMPLEMENTATION,
                ""
            )
        );
        
        // Note: UPGRADER_ROLE is NOT revoked after the upgrade
        // The timelock will retain this role for future upgrades
    }
}
