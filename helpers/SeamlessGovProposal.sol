// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import {ISeamlessGovProposal} from "./ISeamlessGovProposal.sol";
import {SeamlessAddressBook} from "./SeamlessAddressBook.sol";

abstract contract SeamlessGovProposal is ISeamlessGovProposal {
  address[] public targets;
  uint256[] public values;
  bytes[] public calldatas;

  function _makeProposal() internal virtual;

  function _addAction(address target, uint256 value, bytes memory calldata_) internal {
    targets.push(target);
    values.push(value);
    calldatas.push(calldata_);
  }

  function _addAction(address target, bytes memory calldata_) internal {
    _addAction(target, 0, calldata_);
  }

  function getTargets() external view returns(address[] memory) {
    return targets;
  }

  function getValues() external view returns(uint256[] memory) {
    return values;
  }

  function getCalldatas() external view returns(bytes[] memory) {
    return calldatas;
  }
}