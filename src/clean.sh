#!/bin/bash

# exit when any command fails
set -e
# set working directory
pwd
cd Circom
rm proof.json
rm public.json
rm withdraw.r1cs
rm -rf tau
rm -rf withdraw_js
rm -rf zkey
cd ..
cd contracts
rm verifier.sol