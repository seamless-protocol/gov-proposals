# include .env file and export its env vars
# (-include to ignore error if it does not exist)
-include .env

.PHONY: test clean

create-proposal :; cp -R ./proposals/.template ./proposals/${name}
test-proposal   :; forge test --match-path proposals/${name}/TestProposal.t.sol --fork-url base -vvvv
deploy-proposal	:; forge script proposals/${name}/DeployProposal.s.sol ./proposals/${name}/description.md --sig "run(string)" --force --rpc-url base --chain base --slow --account ${PROPOSER_ACCOUNT_NAME} --broadcast --verify --delay 5 -vvvv
deploy-proposal-tenderly :; forge script proposals/${name}/DeployProposal.s.sol ./proposals/${name}/description.md --sig "run(string)" --force --rpc-url tenderly --slow --account ${PROPOSER_ACCOUNT_NAME} --broadcast -vvvv --verify --verifier-url ${TENDERLY_FORK_VERIFIER_URL} --etherscan-api-key ${TENDERLY_ACCESS_KEY}

test-all				:; forge test --fork-url base

# Tendely simulation
# Make sure the proposer address has enough delegated voting power to propose and meet quorum. Mint and delegate tokens on the fork
tenderly-setupProposer						:; forge script proposals/${name}/TenderlySimulation.s.sol --sig "setupProposer()" --rpc-url tenderly --slow --broadcast -vvvv --verify --verifier-url ${TENDERLY_FORK_VERIFIER_URL} --etherscan-api-key ${TENDERLY_ACCESS_KEY}	
tenderly-createProposal						:; forge script proposals/${name}/TenderlySimulation.s.sol ./proposals/${name}/description.md --sig "createProposal(string)" --rpc-url tenderly --slow --broadcast -vvvv --verify --verifier-url ${TENDERLY_FORK_VERIFIER_URL} --etherscan-api-key ${TENDERLY_ACCESS_KEY}
tenderly-increaseTimeVotingDelay  :; forge script proposals/${name}/TenderlySimulation.s.sol --sig "increaseTimeVotingDelay()" --rpc-url tenderly --slow --broadcast -vvvv --verify --verifier-url ${TENDERLY_FORK_VERIFIER_URL} --etherscan-api-key ${TENDERLY_ACCESS_KEY}	
tenderly-castVote 							  :; forge script proposals/${name}/TenderlySimulation.s.sol ./proposals/${name}/description.md --sig "castVote(string)" --rpc-url tenderly --slow --broadcast -vvvv --verify --verifier-url ${TENDERLY_FORK_VERIFIER_URL} --etherscan-api-key ${TENDERLY_ACCESS_KEY}	
tenderly-increaseTimeVotingPeriod :; forge script proposals/${name}/TenderlySimulation.s.sol --sig "increaseTimeVotingPeriod()" --rpc-url tenderly --slow --broadcast -vvvv --verify --verifier-url ${TENDERLY_FORK_VERIFIER_URL} --etherscan-api-key ${TENDERLY_ACCESS_KEY}	
tenderly-queueProposal						:; forge script proposals/${name}/TenderlySimulation.s.sol ./proposals/${name}/description.md --sig "queueProposal(string)" --rpc-url tenderly --slow --broadcast -vvvv --verify --verifier-url ${TENDERLY_FORK_VERIFIER_URL} --etherscan-api-key ${TENDERLY_ACCESS_KEY}	
tenderly-setTimeToProposalEta			:; forge script proposals/${name}/TenderlySimulation.s.sol ./proposals/${name}/description.md --sig "setTimeToProposalEta(string)" --rpc-url tenderly --slow --broadcast -vvvv --verify --verifier-url ${TENDERLY_FORK_VERIFIER_URL} --etherscan-api-key ${TENDERLY_ACCESS_KEY}	
tenderly-executeProposal					:; forge script proposals/${name}/TenderlySimulation.s.sol ./proposals/${name}/description.md --sig "executeProposal(string)" --rpc-url tenderly --slow --broadcast -vvvv --verify --verifier-url ${TENDERLY_FORK_VERIFIER_URL} --etherscan-api-key ${TENDERLY_ACCESS_KEY}	
tenderly-simulateVotingAndExecution :
	make tenderly-setupProposer name=${name}
	make tenderly-createProposal name=${name}
	make tenderly-increaseTimeVotingDelay name=${name}
	make tenderly-castVote name=${name}
	make tenderly-increaseTimeVotingPeriod name=${name}
	make tenderly-queueProposal name=${name}
	make tenderly-setTimeToProposalEta name=${name}
	make tenderly-executeProposal	name=${name}


deploy-sip29-interest-rate-strategies :; forge script proposals/sip_29_listing_cbBTC_and_EURC/DeployInterestRateStrategies.s.sol --force --rpc-url base --chain base --slow --account ${DEPLOYER_ACCOUNT_NAME} --broadcast --verify --delay 5 -vvvv
deploy-sip33-interest-rate-strategies :; forge script proposals/sip_33_risk_parameter_updates/DeployInterestRateStrategies.s.sol --force --rpc-url base --chain base --slow --account ${DEPLOYER_ACCOUNT_NAME} --broadcast --verify --delay 5 -vvvv
deploy-sip36-dependencies :; forge script proposals/sip_36_listing_weETH/DeployDependencies.s.sol --force --rpc-url base --chain base --slow --account ${DEPLOYER_ACCOUNT_NAME} --broadcast --verify --delay 5 -vvvv
