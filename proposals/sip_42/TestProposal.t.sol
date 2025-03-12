// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.25;

import { GovTestHelper } from "../../helpers/GovTestHelper.sol";
import { Proposal } from "./Proposal.sol";
import { ERC1967Utils } from
    "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { IERC4626 } from "@openzeppelin/contracts/interfaces/IERC4626.sol";
import { IVotes } from "@openzeppelin/contracts/governance/utils/IVotes.sol";
import { IGovernor } from "@openzeppelin/contracts/governance/IGovernor.sol";
import { SeamlessAddressBook } from "../../helpers/SeamlessAddressBook.sol";

interface ISeamGovernorV2 {
    function tokens() external view returns (address[] memory);
}

contract TestProposal is GovTestHelper {
    Proposal public proposal;

    function setUp() public {
        vm.rollFork(27510935);
        proposal = new Proposal();
    }

    function test_governorV2ImplementationAddressChanged_afterPassingProposal()
        public
    {
        address longGovernorImplementationBefore =
            _getImplementationAddress(SeamlessAddressBook.GOVERNOR_LONG);
        address shortGovernorImplementationBefore =
            _getImplementationAddress(SeamlessAddressBook.GOVERNOR_SHORT);

        _passProposalLongGov(proposal);

        address longGovernorImplementationAfter =
            _getImplementationAddress(SeamlessAddressBook.GOVERNOR_LONG);
        address shortGovernorImplementationAfter =
            _getImplementationAddress(SeamlessAddressBook.GOVERNOR_SHORT);

        assertNotEq(
            longGovernorImplementationBefore, longGovernorImplementationAfter
        );
        assertNotEq(
            shortGovernorImplementationBefore, shortGovernorImplementationAfter
        );
        assertEq(
            longGovernorImplementationAfter,
            SeamlessAddressBook.SEAM_GOVERNOR_V2_IMPLEMENTATION
        );
        assertEq(
            shortGovernorImplementationAfter,
            SeamlessAddressBook.SEAM_GOVERNOR_V2_IMPLEMENTATION
        );
    }

    function test_tokensAreCorrectlySet_afterPassingProposal() public {
        // Pass the proposal to upgrade the governors
        _passProposalLongGov(proposal);

        // Check that the tokens function returns the correct addresses
        address[] memory longGovTokens =
            ISeamGovernorV2(payable(SeamlessAddressBook.GOVERNOR_LONG)).tokens();
        address[] memory shortGovTokens = ISeamGovernorV2(
            payable(SeamlessAddressBook.GOVERNOR_SHORT)
        ).tokens();

        // Both governors should have exactly three tokens
        assertEq(longGovTokens.length, 3);
        assertEq(shortGovTokens.length, 3);

        // The first token should be SEAM
        assertEq(longGovTokens[0], SeamlessAddressBook.SEAM);
        assertEq(shortGovTokens[0], SeamlessAddressBook.SEAM);

        // The second token should be escrowed SEAM
        assertEq(longGovTokens[1], SeamlessAddressBook.ESSEAM);
        assertEq(shortGovTokens[1], SeamlessAddressBook.ESSEAM);

        // The third token should be stkSEAM
        assertEq(longGovTokens[2], SeamlessAddressBook.stkSEAM);
        assertEq(shortGovTokens[2], SeamlessAddressBook.stkSEAM);
    }

    function test_stkSeamDelegationIsCounted_afterPassingProposal() public {
        IERC20 seam = IERC20(SeamlessAddressBook.SEAM);
        address stkSeam = SeamlessAddressBook.stkSEAM;
        IGovernor longGov = IGovernor(SeamlessAddressBook.GOVERNOR_LONG);
        IGovernor shortGov = IGovernor(SeamlessAddressBook.GOVERNOR_SHORT);

        // Create a test user
        address testUser = makeAddr("testUser");

        // Use deal to give SEAM to the test user
        uint256 seamAmount = 100 ether;
        deal(address(seam), testUser, seamAmount);

        // Stake and delegate SEAM before passing the proposal
        vm.startPrank(testUser);
        seam.approve(stkSeam, seamAmount);
        IERC4626(stkSeam).deposit(seamAmount, testUser);
        IVotes(stkSeam).delegate(testUser);
        vm.stopPrank();

        // Warp forward to ensure delegation is active
        vm.warp(block.timestamp + 1);

        // Get the voting power before passing the proposal
        uint256 longGovVotingPowerBefore =
            longGov.getVotes(testUser, block.timestamp - 1);
        uint256 shortGovVotingPowerBefore =
            shortGov.getVotes(testUser, block.timestamp - 1);

        // Verify that stkSEAM is not counted before the upgrade
        assertEq(longGovVotingPowerBefore, 0);
        assertEq(shortGovVotingPowerBefore, 0);

        // Pass the proposal to upgrade the governors
        _passProposalLongGov(proposal);

        // Get the voting power after passing the proposal
        uint256 longGovVotingPowerAfter =
            longGov.getVotes(testUser, block.timestamp - 1);
        uint256 shortGovVotingPowerAfter =
            shortGov.getVotes(testUser, block.timestamp - 1);

        // Get the user's stkSEAM balance
        uint256 stkSeamBalance = IERC4626(stkSeam).balanceOf(testUser);

        // Check that the voting power matches the staked amount
        assertEq(longGovVotingPowerAfter, stkSeamBalance);
        assertEq(shortGovVotingPowerAfter, stkSeamBalance);
    }

    function _getImplementationAddress(address proxy)
        internal
        view
        returns (address)
    {
        bytes32 implementationAddress =
            vm.load(proxy, ERC1967Utils.IMPLEMENTATION_SLOT);
        return address(uint160(uint256(implementationAddress)));
    }
}
