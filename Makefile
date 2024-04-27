-include .env

test-dollar:
	forge test --mt testMiniDollar -vvvv --fork-url $(SEPOLIA_RPC_URL)