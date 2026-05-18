-include .env

build:
	forge build

test:
	forge test

snapshot:
	forge snapshot

anvil:
	anvil


deploy-anvil:
	forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --private-key $(ANVIL_PRIVATE_KEY) --broadcast

fund:
	forge script script/Interactions.s.sol:FundFundMe --rpc-url http://127.0.0.1:8545 --private-key $(ANVIL_PRIVATE_KEY) --broadcast

withdraw:
	forge script script/Interactions.s.sol:WithdrawFundMe --rpc-url http://127.0.0.1:8545 --private-key $(ANVIL_PRIVATE_KEY) --broadcast