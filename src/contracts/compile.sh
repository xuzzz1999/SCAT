#!/bin/bash

# exit when any command fails
set -e
# set working directory
pwd
solcjs --bin mimc.sol  merkleTree.sol verifier.sol mix.sol -o bin
solcjs --abi mimc.sol  merkleTree.sol verifier.sol mix.sol -o abi

