// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {MerkleAirdrop} from "src/MerkleAirdrop.sol";

contract ClaimAirdrop is Script {
    error ClaimAirdrop__InvalidSignatureLength();

    address CLAIMING_ADDRESS = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266; // Default anvil first address
    uint256 CLAIMING_AMOUNT = 25 * 1e18;
    bytes32 proofOne = 0xd1445c931158119b00449ffcac3c947d028c0c359c34a6646d95962b3b55c6ad;
    bytes32 proofTwo = 0xe5ebd1e1b5a5478a944ecab36a9a954ac3b6b8216875f6524caa7a1d87096576;
    bytes32[] public proof = [proofOne, proofTwo];
    bytes private SIGNATURE =
        hex"e6daba7e95f9099d91a9302ad015d956e1798978b0632a0eb8798d5e13f7f734407ba27caaded62631223d997180924ead95c3d5fe8e7953ba8658b91e115e051b";

    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("MerkleAirdrop", block.chainid);
        claimAirdrop(mostRecentDeployed);
    }

    function claimAirdrop(address airdrop) public {
        // cast call 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512 "getMessageHash(address, uint256)" 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 25000000000000000000 --rpc-url http://127.0.0.1:8545
        // then take output and do
        // cast wallet sign --no-hash 0xd1e38ade95fa170a86b8c4fc36c18f66eb68ceee7169613c773a647325e82d42 --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
        // then take output without the 0x part and here it is:
        // e6daba7e95f9099d91a9302ad015d956e1798978b0632a0eb8798d5e13f7f734407ba27caaded62631223d997180924ead95c3d5fe8e7953ba8658b91e115e051b
        (uint8 v, bytes32 r, bytes32 s) = splitSignature(SIGNATURE);

        vm.startBroadcast();
        MerkleAirdrop(airdrop).claim(CLAIMING_ADDRESS, CLAIMING_AMOUNT, proof, v, r, s);
        vm.stopBroadcast();
    }

    function splitSignature(bytes memory sig) public pure returns (uint8 v, bytes32 r, bytes32 s) {
        if (sig.length != 65) revert ClaimAirdrop__InvalidSignatureLength();

        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}
