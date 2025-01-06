-include .env

.PHONY: all test deploy

build:
	forge build

test:
	forge test

install:
	forge install dmfxyz/murky@v0.1.0 --no-commit
	forge install Cyfrin/foundry-devops@0.2.3 --no-commit
	forge install OpenZeppelin/openzeppelin-contracts@v5.1.0 --no-commit

deploy-local:
	@forge script script/DeployMerkleAirdrop.s.sol:DeployMerkleAirdrop --rpc-url $(LOCAL_RPC_URL) --account $(LOCAL_ACCOUNT) --broadcast -vv

claim-local:
	@forge script script/Interact.s.sol:ClaimAirdrop --rpc-url $(LOCAL_RPC_URL) --account $(LOCAL_GAS_PAYER_ACCOUNT) --broadcast -vv