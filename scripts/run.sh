#!/bin/bash

if [ $# -ne 1 ] 
then 
    echo "More then argument exists"
    exit 1
fi

cd "circuits/$1/$1_js"

node generate_witness.js "$1.wasm" ../input.json ../witness.wtns
