#!/bin/bash

# exit when any command fails
set -e
# set working directory
pwd
cd Circom
# compile circuit
circom withdraw.circom --r1cs --wasm

echo "finish compile"

#computing witness
cd withdraw_js
node generate_witness.js withdraw.wasm ../input.json witness.wtns

echo "finish computing witness"

cd ..

# powers of tau
mkdir tau && mkdir zkey && cd tau
snarkjs powersoftau new bn128 12 pot12_0000.ptau -v
snarkjs powersoftau contribute  pot12_0000.ptau pot12_0001.ptau --name="Contribution" -e="text"
snarkjs powersoftau prepare phase2 pot12_0001.ptau pot12_final.ptau -v
snarkjs groth16 setup ../withdraw.r1cs pot12_final.ptau ../zkey/withdraw_0000.zkey

snarkjs zkey contribute ../zkey/withdraw_0000.zkey ../zkey/withdraw_0001.zkey --name="Name" -v -e="text"
snarkjs zkey export verificationkey ../zkey/withdraw_0001.zkey verification_key.json
# export to solidity
# snarkjs zkey export solidityverifier ../zkey/withdraw_0001.zkey ../../contracts/Verifier.sol

# generate proof
cd ..
snarkjs groth16 prove zkey/withdraw_0001.zkey withdraw_js/witness.wtns proof.json public.json

# verify proof
snarkjs groth16 verify tau/verification_key.json public.json proof.json

# generate verifier.sol
snarkjs zkey export solidityverifier zkey/withdraw_0001.zkey ../contracts/verifier.sol

