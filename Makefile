# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

.PHONY: test clean

create-proposal :; cp -R ./proposals/.template ./proposals/${name}
test-proposal   :; forge test --match-path proposals/${name}/TestProposal.t.sol --fork-url base -vvvv
deploy-proposal	:; forge script proposals/${name}/DeployProposal.s.sol ./proposals/${name}/description.md --sig "run(string)" --force --rpc-url base --chain base --slow --account ${PROPOSER_ACCOUNT_NAME} --broadcast --verify --delay 5 -vvvv
deploy-proposal-tenderly :; forge script proposals/${name}/DeployProposal.s.sol ./proposals/${name}/description.md --sig "run(string)" --force --rpc-url tenderly --slow --account ${PROPOSER_ACCOUNT_NAME} --broadcast -vvvv --verify --verifier-url ${TENDERLY_FORK_VERIFIER_URL} --etherscan-api-key ${TENDERLY_ACCESS_KEY}

test-all				:; forge test --fork-url base

deploy-sip29-interest-rate-strategies :; forge script proposals/sip_29_listing_cbBTC_and_EURC/DeployInterestRateStrategies.s.sol --force --rpc-url base --chain base --slow --account ${DEPLOYER_ACCOUNT_NAME} --broadcast --verify --delay 5 -vvvv