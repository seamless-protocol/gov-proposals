## Seamless governance proposals

This repo contains scripts and tools for making and testing proposals for the Seamless governance.

## Usage

To create new proposal run:
```shell
make create-proposal name=PROPOSAL_NAME
```

It will create a folder `PROPOSAL_NAME` inside of the `proposals` folder with the template proposal files:
- `Proposal.sol` containing the proposal payload. Implement here the `_makeProposal` by adding `_addAction` calls with the desired actions of the proposal.
- `description.md` - Change this file by adding the proposal description in the markdown format.
- `TestProposal.t.sol` - Implement tests inside this file. Function `_passProposal` from the `GovTestHelper` can be used to queue up and execute the proposal.
- `DeployProposal.s.sol` is a script which is run on the proposal deployment. By default it doesn't need to be changed.

Run proposal tests with the command:
```shell
make test-proposal name=PROPOSAL_NAME
```

Deploy the proposal onchain with the command:
```shell
make deploy-proposal name=PROPOSAL_NAME
```

Deploy the proposal on tenderly with the command:
```shell
make deploy-proposal-tenderly name=PROPOSAL_NAME
```

Run the simulation of voting and execution on tenderly with the command:
```shell
make tenderly-simulateVotingAndExecution name=PROPOSAL_NAME
```