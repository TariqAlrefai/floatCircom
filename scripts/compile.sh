#!/bin/bash
echo "Args: $#"

if [ $# -ne 1 ] 
then 
    echo "More then argument exists"
    exit 1
fi
cd circuits
mkdir -p $1
cd $1
circom "../$1.circom" --r1cs --sym --wasm
cd ../..