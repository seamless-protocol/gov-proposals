// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import {SeamlessGovProposal, SeamlessAddressBook} from "../../helpers/SeamlessGovProposal.sol";
import {IERC20} from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Proposal is SeamlessGovProposal {
  constructor() {
    _makeProposal();
  }

  function _makeProposal() internal virtual override {

    address transferTo = 0xaAaAaAaaAaAaAaaAaAAAAAAAAaaaAaAaAaaAaaAa;
    uint256 amount1 = 100 ether;
    uint256 amount2 = 200 ether;

    _addAction(
      SeamlessAddressBook.SEAM,
      abi.encodeWithSelector(
        IERC20.transfer.selector, 
        transferTo, 
        amount1
      )
    );

    _addAction(
      SeamlessAddressBook.SEAM,
      abi.encodeWithSelector(
        IERC20.transfer.selector, 
        transferTo, 
        amount2
      )
    );
  }
}