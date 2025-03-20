// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { IMetaMorphoV1_1Base } from
    "@seamless-governance/interfaces/IMetaMorphoV1_1.sol";
import { IFeeKeeper } from "@seamless-governance/interfaces/IFeeKeeper.sol";
import { UUPSUpgradeable } from
    "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import { IAccessControl } from
    "@openzeppelin/contracts/access/IAccessControl.sol";

contract Proposal is SeamlessGovProposal {
    bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER_ROLE");
    bytes32 public constant UPGRADER_ROLE = keccak256("UPGRADER_ROLE");
    bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        _addAction(
            SeamlessAddressBook.stkSEAM,
            abi.encodeWithSelector(
                UUPSUpgradeable.upgradeToAndCall.selector,
                SeamlessAddressBook.stkSEAM_IMPLEMENTATION,
                ""
            )
        );

        _addAction(
            SeamlessAddressBook.stkSEAM,
            abi.encodeWithSelector(
                IAccessControl.grantRole.selector,
                DEFAULT_ADMIN_ROLE,
                SeamlessAddressBook.TIMELOCK_LONG
            )
        );

        _addAction(
            SeamlessAddressBook.stkSEAM,
            abi.encodeWithSelector(
                IAccessControl.grantRole.selector,
                MANAGER_ROLE,
                SeamlessAddressBook.TIMELOCK_LONG
            )
        );

        _addAction(
            SeamlessAddressBook.stkSEAM,
            abi.encodeWithSelector(
                IAccessControl.grantRole.selector,
                UPGRADER_ROLE,
                SeamlessAddressBook.TIMELOCK_LONG
            )
        );

        _addAction(
            SeamlessAddressBook.stkSEAM,
            abi.encodeWithSelector(
                IAccessControl.grantRole.selector,
                PAUSER_ROLE,
                SeamlessAddressBook.TIMELOCK_LONG
            )
        );

        _addAction(
            SeamlessAddressBook.stkSEAM,
            abi.encodeWithSelector(
                IAccessControl.renounceRole.selector,
                DEFAULT_ADMIN_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );

        _addAction(
            SeamlessAddressBook.stkSEAM,
            abi.encodeWithSelector(
                IAccessControl.renounceRole.selector,
                UPGRADER_ROLE,
                SeamlessAddressBook.TIMELOCK_SHORT
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.setFeeRecipient.selector,
                SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT_FEE_SPLITTER
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.submitTimelock.selector, 3 days
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.setFeeRecipient.selector,
                SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT_FEE_SPLITTER
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.submitTimelock.selector, 3 days
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.setFeeRecipient.selector,
                SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT_FEE_SPLITTER
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT,
            abi.encodeWithSelector(
                IMetaMorphoV1_1Base.submitTimelock.selector, 3 days
            )
        );

        _addAction(
            SeamlessAddressBook.FEE_KEEPER,
            abi.encodeWithSelector(
                IFeeKeeper.setTokenForManualRate.selector,
                SeamlessAddressBook.SEAM,
                true
            )
        );

        _addAction(
            SeamlessAddressBook.FEE_KEEPER,
            abi.encodeWithSelector(
                IFeeKeeper.setTokenForManualRate.selector,
                SeamlessAddressBook.ESSEAM,
                true
            )
        );
    }
}
