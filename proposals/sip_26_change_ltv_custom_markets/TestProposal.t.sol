// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {Proposal} from "./Proposal.sol";
import {GovTestHelper} from "../../helpers/GovTestHelper.sol";
import {IPoolDataProvider} from "@aave/contracts/interfaces/IPoolDataProvider.sol";
import {SeamlessAddressBook} from "../../helpers/SeamlessAddressBook.sol";

contract TestProposal is Test, GovTestHelper {
    Proposal public proposal;

    function setUp() public {
      proposal = new Proposal();
    }

    function test_checkLTV_LT_LB_afterPassingProposal() public {
      _passProposal(proposal);

      IPoolDataProvider poolDataProvider = IPoolDataProvider(SeamlessAddressBook.POOL_DATA_PROVIDER);

      (, uint256 rwstETH_LTV, uint256 rwstETH_LT, uint256 rwstETH_LB,,,,,,) 
        = poolDataProvider.getReserveConfigurationData(SeamlessAddressBook.SEAMLESS_RESERVED_WSTETH);

      assertEq(rwstETH_LTV, 9000);
      assertEq(rwstETH_LT, 9300);
      assertEq(rwstETH_LB, 10500);

      (, uint256 rWETH_LTV, uint256 rWETH_LT, uint256 rWETH_LB,,,,,,) 
        = poolDataProvider.getReserveConfigurationData(SeamlessAddressBook.SEAMLESS_RESERVED_WETH);

      assertEq(rWETH_LTV, 9000);
      assertEq(rWETH_LT, 9300);
      assertEq(rWETH_LB, 10500);
    }
}
