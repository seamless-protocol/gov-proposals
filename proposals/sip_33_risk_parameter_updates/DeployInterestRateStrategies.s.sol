// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import { Script, console } from "forge-std/Script.sol";
import { Proposal } from "./Proposal.sol";
import { IGovernor } from "@openzeppelin/contracts/governance/IGovernor.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";
import { WadRayMath } from
    "@aave/contracts/protocol/libraries/math/WadRayMath.sol";
import { IPoolAddressesProvider } from
    "@aave/contracts/interfaces/IPoolAddressesProvider.sol";
import { DefaultReserveInterestRateStrategy } from
    "@aave/contracts/protocol/pool/DefaultReserveInterestRateStrategy.sol";

contract DeployInterestRateStrategies is Script {
    function setUp() public { }

    function run() public {
        address deployerAddress = vm.envAddress("DEPLOYER_ADDRESS");
        vm.startBroadcast(deployerAddress);

        DefaultReserveInterestRateStrategy interestStrategyDAI = new DefaultReserveInterestRateStrategy(
            IPoolAddressesProvider(SeamlessAddressBook.POOL_ADDRESSES_PROVIDER),
            _bpsToRay(90_00),
            0,
            _bpsToRay(5_50),
            _bpsToRay(75_00),
            0,
            0,
            0,
            0,
            0
        );
        console.log("interestStrategyDAI: ", address(interestStrategyDAI));

        DefaultReserveInterestRateStrategy interestStrategyUSDC = new DefaultReserveInterestRateStrategy(
            IPoolAddressesProvider(SeamlessAddressBook.POOL_ADDRESSES_PROVIDER),
            _bpsToRay(90_00),
            0,
            _bpsToRay(8_00),
            _bpsToRay(75_00),
            0,
            0,
            0,
            0,
            0
        );
        console.log("interestStrategyUSDC: ", address(interestStrategyUSDC));

        DefaultReserveInterestRateStrategy interestStrategyWETH = new DefaultReserveInterestRateStrategy(
            IPoolAddressesProvider(SeamlessAddressBook.POOL_ADDRESSES_PROVIDER),
            _bpsToRay(90_00),
            0,
            _bpsToRay(2_50),
            _bpsToRay(80_00),
            0,
            0,
            0,
            0,
            0
        );
        console.log("interestStrategyWETH: ", address(interestStrategyWETH));

        vm.stopBroadcast();
    }

    function _bpsToRay(uint256 amount) internal pure returns (uint256) {
        return (amount * WadRayMath.RAY) / 10_000;
    }
}
