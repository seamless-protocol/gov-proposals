// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

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
import { CLSynchronicityPriceAdapterPegToBase } from
    "@aave/cl-synchronicity-price-adapter/contracts/CLSynchronicityPriceAdapterPegToBase.sol";

contract DeployDependencies is Script {
    address constant ETH_USD_CHAINLINK_AGGREGATOR =
        0x71041dddad3595F9CEd3DcCFBe3D1F4b0a16Bb70;
    address constant weETH_ETH_CHAINLINK_AGGREGATOR =
        0xFC1415403EbB0c693f9a7844b92aD2Ff24775C65; // This is a market rate oracle not an exchange rate since we don't want to peg eETH to ETH 1:1

    function setUp() public { }

    function run() public {
        address deployerAddress = vm.envAddress("DEPLOYER_ADDRESS");

        vm.startBroadcast(deployerAddress);

        DefaultReserveInterestRateStrategy interestStrategyweETH = new DefaultReserveInterestRateStrategy(
            IPoolAddressesProvider(SeamlessAddressBook.POOL_ADDRESSES_PROVIDER),
            _bpsToRay(45_00),
            0,
            _bpsToRay(7_00),
            _bpsToRay(75_00),
            0,
            0,
            0,
            0,
            0
        );

        console.log("interestStrategyweETH: ", address(interestStrategyweETH));

        CLSynchronicityPriceAdapterPegToBase weETHPriceOracleAdapter = new CLSynchronicityPriceAdapterPegToBase(
            ETH_USD_CHAINLINK_AGGREGATOR,
            weETH_ETH_CHAINLINK_AGGREGATOR,
            8,
            "weETH/ETH/USD"
        );

        console.log(
            "weETHPriceOracleAdapter: ", address(weETHPriceOracleAdapter)
        );

        vm.stopBroadcast();
    }

    function _bpsToRay(uint256 amount) internal pure returns (uint256) {
        return (amount * WadRayMath.RAY) / 10_000;
    }
}
