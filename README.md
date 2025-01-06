## About

This repository explores how we can create an airdrop of our token to a list of whitelisted addresses. To identify which addresses are allowed to claim airdrop, I am using Merkle tree, so that there is no need to store an array or mapping of addresses on-chain. Instead it is provable that the address belongs to the tree and for the `MerkleAirdrop` smart contract I only need to store the Merkle tree root. In this project I've also explored how ECDSA works, EIP712, and how it is possible to sign a message by an address to allow then other address to use this signature to claim the airdrop on behalf of the first address.

## Learnings

1) Learned about best practices on how to do airdrops.
2) Learned what Merkle trees are and how we can use them to quickly identify whether account is eligible for airdrop without the need to store a full list of accounts in array or mapping.
3) Learned about ECDSA (Elliptic Curve Digital Signature Algorithm), the signature components `v, r, s`, EIP712, and how someone can provide their signature to allow other entity to perform an action on their behalf.

## Using this repository



## TODO list

1) Write more tests :).
2) In `MerkleAirdrop` contract instead of using `ECDSA.tryRecover` with `v, r, s` parameters, can simplify to use `ECDSA.recover` (`function recover(bytes32 hash, bytes memory signature)`) so that can pass the signature directly without the need to split the signature to do `claim`.