# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

.PHONY: test clean

create-proposal :; cp -R ./proposals/.template ./proposals/${name}
test-proposal   :; forge test --match-path proposals/${name}/TestProposal.t.sol --fork-url base -vvvv
deploy-proposal	:; forge script proposals/${name}/DeployProposal.s.sol ./proposals/${name}/description.md --sig "run(string)" --force --rpc-url base --chain base --slow --broadcast --verify --delay 5 -vvvv
deploy-proposal-tenderly :; forge script proposals/${name}/DeployProposal.s.sol ./proposals/${name}/description.md --sig "run(string)" --force --rpc-url tenderly --slow --broadcast -vvvv --verify --verifier-url ${TENDERLY_FORK_VERIFIER_URL} --etherscan-api-key ${TENDERLY_ACCESS_KEY}