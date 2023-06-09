#!/bin/bash

# exit when any command fails
set -e

# geth --datadir data --networkid 8 --allow-insecure-unlock --http --http.api personal,eth,net,web3 console


geth --http --http.corsdomain="package://6fd22d6fe5549ad4c4d8fd3ca0b7816b.mod" --http.api web3,eth,debug,personal,net --vmdebug --datadir data --dev console