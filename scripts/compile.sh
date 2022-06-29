#!/bin/bash
echo "Args: $#"

# if [ $# -ne 1 ] 
# then 
#     echo "More then argument exists"
#     exit 1
# fi

cd circuits

for f in "$@"
do
    mkdir -p "$f"
    cd "$f"
    circom "../test_circuits/$f.circom" --r1cs --sym --wasm
    cd ..
done

cd ..
