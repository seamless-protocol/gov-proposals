// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

interface ISeamlessGovProposal {
  function getTargets() external view returns(address[] memory);

  function getValues() external view returns(uint256[] memory);

  function getCalldatas() external view returns(bytes[] memory);
}