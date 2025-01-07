## About

This repository explores how we can create an airdrop of our token to a list of whitelisted addresses. To identify which addresses are allowed to claim airdrop, I am using Merkle tree, so that there is no need to store an array or mapping of addresses on-chain. Instead it is provable that the address belongs to the tree and for the `MerkleAirdrop` smart contract I only need to store the Merkle tree root. In this project I've also explored how ECDSA works, EIP712, and how it is possible to sign a message by an address to allow then other address to use this signature to claim the airdrop on behalf of the first address.

## Learnings

1) Learned about best practices on how to do airdrops.
2) Learned what Merkle trees are and how we can use them to quickly identify whether account is eligible for airdrop without the need to store a full list of accounts in array or mapping.
3) Learned about ECDSA (Elliptic Curve Digital Signature Algorithm), the signature components `v, r, s`, EIP712, and how someone can provide their signature to allow other entity to perform an action on their behalf.

## Using this repository

1) Run `git clone https://github.com/accurec/CyfrinUpdraftCourseSignaturesAndAirdrop.git`.
2) Run `make install` to install dependencies.
3) Run `make build` to build the project.
4) Use `GenerateInput` script to create json data that will be used in `MakeMerkle` script. In `GenerateInput` file there are 4 whitelisted addresses that are considered to be able to claim airdrop.
5) Use `MakeMerkle` script to generate the Merkle tree structure for the input data that then can be used in the `MerkleAirdrop` contract.
6) In tests and deployment script for the `MerkleAirdrop` contract we are using the root that has been produced by the `MakeMerkle` script, which is `0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4`.
7) In tests we are setting up the new `user` address, which corresponds to the actual address of `0x6CA6d1e2D5347Bfab1d91e883F1915560e09129D`, which we have included in the input/output Merkle files. The corresponding proofs are provided in the test, as well: `0x0fd7c981d39bece61f7499702bf59b3114a90e66b51ba2c53abdf7b62986c00a`, `0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576`.
8) In the `Interact` script we are using proofs for the claiming address `0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266`, which is also included in the whitelist. We've obtained the signature for the message in the following way:
   
First, run:
```
cast call MERKLE_AIRDROP_CONTRACT_ADDRESS "getMessageHash(address, uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 25000000000000000000 --rpc-url http://127.0.0.1:8545
```

Then run the following command using the output of the message hash that got produced in the previous step:
```
cast wallet sign --no-hash MESSAGE_HASH_FROM_STEP_ONE --private-key PRIVATE_KEY_OF_THE_ADDRESS_0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266
```

After that we get the signature that we can use in our `Interact` script by putting what we got from the previous step without the `0x` part, which looks like this;
```
bytes private SIGNATURE = hex"e6daba7e95f9099d91a9302ad015d956e1798978b0632a0eb8798d5e13f7f734407ba27caaded62631223d997180924ead95c3d5fe8e7953ba8658b91e115e051b";
```

Using the above signature we can then do `make claim-local` which would effectively run the transaction using one address that is using the signature of the other address to allow them to claim airdrop on their behalf (pay for their fees - the airdrop is still going to be received by the address that provided the signature).
9) Lastly, we can verify that the signer address received the airdrop and not the one that sent `claim` transaction by running the following:
```
cast call AIRDROP_TOKEN_ADDRESS "balanceOf(address)" SIGNER_ADDRESS
```

## TODO list

1) Write more tests :).
2) In `MerkleAirdrop` contract instead of using `ECDSA.tryRecover` with `v, r, s` parameters, can simplify to use `ECDSA.recover` (`function recover(bytes32 hash, bytes memory signature)`) so that can pass the signature directly without the need to split the signature to do `claim`.