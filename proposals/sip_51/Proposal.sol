// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {
    SeamlessGovProposal,
    SeamlessAddressBook
} from "../../helpers/SeamlessGovProposal.sol";
import {
    AaveEcosystemReserveController
} from "@aave/v3-periphery/contracts/treasury/AaveEcosystemReserveController.sol";

contract Proposal is SeamlessGovProposal {
    constructor() {
        _makeProposal();
    }

    /// @dev This contract is not deployed onchain, do not make transactions to other contracts
    /// or deploy a contract. Only the view/pure functions of deployed contracts can be called.
    function _makeProposal() internal virtual override {
        // Transfer all reserve factor assets to aera admin multisig
        _addAction(
            SeamlessAddressBook.SEAMLESS_TREASURY_ADMIN,
            abi.encodeWithSelector(
                AaveEcosystemReserveController.approve.selector,
                SeamlessAddressBook.SEAMLESS_TREASURY,
                0x53E240C0F985175dA046A62F26D490d1E259036e, // sUSDC
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                type(uint256).max
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_TREASURY_ADMIN,
            abi.encodeWithSelector(
                AaveEcosystemReserveController.approve.selector,
                SeamlessAddressBook.SEAMLESS_TREASURY,
                0x70C75D336a84060afb393a69273CfD9e8103f2f3, // sAERO
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                type(uint256).max
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_TREASURY_ADMIN,
            abi.encodeWithSelector(
                AaveEcosystemReserveController.approve.selector,
                SeamlessAddressBook.SEAMLESS_TREASURY,
                0x13A13869B814Be8F13B86e9875aB51bda882E391, // sUSDbC
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                type(uint256).max
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_TREASURY_ADMIN,
            abi.encodeWithSelector(
                AaveEcosystemReserveController.approve.selector,
                SeamlessAddressBook.SEAMLESS_TREASURY,
                0x7b35C044192b6399f5c646c68E83Df9316B56556, // sEURC
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                type(uint256).max
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_TREASURY_ADMIN,
            abi.encodeWithSelector(
                AaveEcosystemReserveController.approve.selector,
                SeamlessAddressBook.SEAMLESS_TREASURY,
                0x37eF72fAC21904EDd7e69f7c7AC98172849efF8e, // sDAI
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                type(uint256).max
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_TREASURY_ADMIN,
            abi.encodeWithSelector(
                AaveEcosystemReserveController.approve.selector,
                SeamlessAddressBook.SEAMLESS_TREASURY,
                0x48bf8fCd44e2977c8a9A744658431A8e6C0d866c, // sWETH
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                type(uint256).max
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_TREASURY_ADMIN,
            abi.encodeWithSelector(
                AaveEcosystemReserveController.approve.selector,
                SeamlessAddressBook.SEAMLESS_TREASURY,
                0xfA48A40DAD139e9B1aF8dc82F37Da58cC3cA2867, // swstETH
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                type(uint256).max
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_TREASURY_ADMIN,
            abi.encodeWithSelector(
                AaveEcosystemReserveController.approve.selector,
                SeamlessAddressBook.SEAMLESS_TREASURY,
                0x2c159A183d9056E29649Ce7E56E59cA833D32624, // scbETH
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                type(uint256).max
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_TREASURY_ADMIN,
            abi.encodeWithSelector(
                AaveEcosystemReserveController.approve.selector,
                SeamlessAddressBook.SEAMLESS_TREASURY,
                0x7b6E8F21103e475D7dADf2650fD9c6dd5357E04A, // scbBTC
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                type(uint256).max
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_TREASURY_ADMIN,
            abi.encodeWithSelector(
                AaveEcosystemReserveController.approve.selector,
                SeamlessAddressBook.SEAMLESS_TREASURY,
                0xAFfdD26Fb0CA4DC43432F810F5Fd6F6CeC84f795, // sweETH
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                type(uint256).max
            )
        );

        // Transfer all timelock assets to aera admin multisig
        _addAction(
            SeamlessAddressBook.USDC,
            abi.encodeWithSelector(
                IERC20.transfer.selector,
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                1646462000
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_USDC_MORPHO_VAULT,
            abi.encodeWithSelector(
                IERC20.transfer.selector,
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                21740000000000000000000
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_cbBTC_MORPHO_VAULT,
            abi.encodeWithSelector(
                IERC20.transfer.selector,
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                12463000000000000
            )
        );

        _addAction(
            SeamlessAddressBook.SEAMLESS_WETH_MORPHO_VAULT,
            abi.encodeWithSelector(
                IERC20.transfer.selector,
                SeamlessAddressBook.SEAMLESS_AERA_VAULT_ADMIN,
                2561400000000000000
            )
        );
    }
}
