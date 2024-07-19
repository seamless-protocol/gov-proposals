// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import {SeamlessGovProposal, SeamlessAddressBook} from "../../helpers/SeamlessGovProposal.sol";
import {IPoolConfigurator} from "@aave/contracts/interfaces/IPoolConfigurator.sol";

contract Proposal is SeamlessGovProposal {
  constructor() {
    _makeProposal();
  }

  // reserved wstETH market
  uint256 constant rwstETH_LTV = 9000;    // LTV to 90%
  uint256 constant rwstETH_LT = 9300;     // Liquidation threshold to 93%
  uint256 constant rwstETH_LB = 10500;    // Liquidation bonus to 105%

  // reserved WETH market
  uint256 constant rWETH_LTV = 9000;      // LTV to 90%
  uint256 constant rWETH_LT = 9300;       // Liquidation threshold to 93%
  uint256 constant rWETH_LB = 10500;      // Liquidation bonus to 105%

  function _makeProposal() internal virtual override {
    _addAction_configureReserveAsCollateral(
      SeamlessAddressBook.SEAMLESS_RESERVED_WSTETH,
      rwstETH_LTV,
      rwstETH_LT,
      rwstETH_LB
    );

    _addAction_configureReserveAsCollateral(
      SeamlessAddressBook.SEAMLESS_RESERVED_WETH,
      rWETH_LTV,
      rWETH_LT,
      rWETH_LB
    );
  }

  function _addAction_configureReserveAsCollateral(
    address asset,
    uint256 ltv,
    uint256 liquidationThreshold,
    uint256 liquidationBonus
  ) internal {
    _addAction(
      SeamlessAddressBook.POOL_CONFIGURATOR,
      abi.encodeWithSelector(
        IPoolConfigurator.configureReserveAsCollateral.selector,
        asset,
        ltv,
        liquidationThreshold,
        liquidationBonus
      )
    );
  }
}