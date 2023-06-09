#!/bin/bash

# exit when any command fails
set -e
# set working directory
pwd
cd test
# compile circuit
circom test.circom --r1cs --wasm

echo "finish compile"

#computing witness
cd test_js
node generate_witness.js test.wasm ../input.json witness.wtns

echo "finish computing witness"

cd ..

# powers of tau
mkdir tau && mkdir zkey && cd tau
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
snarkjs powersoftau contribute  pot12_0000.ptau pot12_0001.ptau --name="Contribution" -e="text"
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
snarkjs groth16 setup ../test.r1cs pot12_final.ptau ../zkey/test_0000.zkey

snarkjs zkey contribute ../zkey/test_0000.zkey ../zkey/test_0001.zkey --name="Name" -v -e="text"
snarkjs zkey export verificationkey ../zkey/test_0001.zkey verification_key.json
# export to solidity
# snarkjs zkey export solidityverifier ../zkey/test_0001.zkey ../../contracts/Verifier.sol

# generate proof
cd ..
echo "generate proof"
snarkjs groth16 prove zkey/test_0001.zkey test_js/witness.wtns proof.json public.json

# verify proof
echo "verify proof"
snarkjs groth16 verify tau/verification_key.json public.json proof.json

