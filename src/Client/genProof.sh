#!/bin/bash

# exit when any command fails
set -e
# set working directory
pwd

cd proofbase

node generate_witness.js withdraw.wasm input.json witness.wtns
snarkjs groth16 prove withdraw_0001.zkey witness.wtns ../proofs/proof.json ../proofs/public.json
cd ../proofs

snarkjs generatecall >> mixInput.txt

