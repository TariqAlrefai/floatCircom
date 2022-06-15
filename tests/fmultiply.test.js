
const wasm_tester = require("circom_tester").wasm;
const c_tester = require("circom_tester").c;

async function tester(){

    const circuit = await wasm_tester("../circuits/fmultiply.circom");
    const w = await circuit.calculateWitness({f1: 1075838976, f2: 1075838976});
    await circuit.checkConstraints(w);
    console.log(w);
}


tester().
then(()=>console.log("OK")).
catch(e=>console.log(e));

