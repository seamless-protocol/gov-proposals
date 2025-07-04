// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import { ITransferStrategyBase } from
    "@seamless-governance/interfaces/ITransferStrategyBase.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Proposal is SeamlessGovProposal {
    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        uint256 seamTransferStrategySeamBalance =
            IERC20(SeamlessAddressBook.SEAM).balanceOf(SeamlessAddressBook.SEAM_TRANSFER_STRATEGY);

        _addAction(
            SeamlessAddressBook.SEAM_TRANSFER_STRATEGY,
            abi.encodeWithSelector(
                ITransferStrategyBase.emergencyWithdrawal.selector,
                SeamlessAddressBook.SEAM,
                SeamlessAddressBook.TIMELOCK_SHORT,
                seamTransferStrategySeamBalance
            )
        );

        uint256 esSeamTransferStrategySeamBalance =
            IERC20(SeamlessAddressBook.SEAM).balanceOf(SeamlessAddressBook.ESSEAM_TRANSFER_STRATEGY);

        _addAction(
            SeamlessAddressBook.ESSEAM_TRANSFER_STRATEGY,
            abi.encodeWithSelector(
                ITransferStrategyBase.emergencyWithdrawal.selector,
                SeamlessAddressBook.SEAM,
                SeamlessAddressBook.TIMELOCK_SHORT,
                esSeamTransferStrategySeamBalance
            )
        );

        uint256 usdcTransferStrategyUsdcBalance =
            IERC20(SeamlessAddressBook.USDC).balanceOf(SeamlessAddressBook.USDC_TRANSFER_STRATEGY);

        _addAction(
            SeamlessAddressBook.USDC_TRANSFER_STRATEGY,
            abi.encodeWithSelector(
                ITransferStrategyBase.emergencyWithdrawal.selector,
                SeamlessAddressBook.USDC,
                SeamlessAddressBook.TIMELOCK_SHORT,
                usdcTransferStrategyUsdcBalance
            )
        );

        uint256 brettTransferStrategySeamBalance =
            IERC20(SeamlessAddressBook.BRETT).balanceOf(SeamlessAddressBook.BRETT_TRANSFER_STRATEGY);

        _addAction(
            SeamlessAddressBook.BRETT_TRANSFER_STRATEGY,
            abi.encodeWithSelector(
                ITransferStrategyBase.emergencyWithdrawal.selector,
                SeamlessAddressBook.BRETT,
                SeamlessAddressBook.TIMELOCK_SHORT,
                brettTransferStrategySeamBalance
            )
        );
    }
}
