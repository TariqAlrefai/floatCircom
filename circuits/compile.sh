
circom ./fmultiply.circom --r1cs --sym --wasm
cd fmultiply_js
node generate_witness.js fmultiply.wasm ../inputm.json witness.wtns
cd ..