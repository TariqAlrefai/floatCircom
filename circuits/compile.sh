
circom ./i2f.circom --r1cs --sym --wasm
cd i2f_js
node generate_witness.js i2f.wasm ../input.json witness.wtns
cd ..