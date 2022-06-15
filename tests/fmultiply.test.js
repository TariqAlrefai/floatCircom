
const wasm_tester = require("circom_tester").wasm;
const c_tester = require("circom_tester").c;

async function tester(){

    const a = (new DataView(new ArrayBuffer(4)));
    a.setFloat32(0, 2.5);

    const b = (new DataView(new ArrayBuffer(4)));
    b.setFloat32(0, 2.5);

    const circuit = await wasm_tester("../circuits/fmultiply.circom");
    console.log(a.getUint32(0));
    const w = await circuit.calculateWitness({f1: a.getUint32(0), f2: b.getUint32(0)});
    await circuit.checkConstraints(w);
    const result = w[0];
    const output = w[1];
    const in1 = w[2];
    const in2 = w[3];

    const c = (new DataView(new ArrayBuffer(8)));
    c.setBigInt64(0, output);
    console.log(c);
    console.log(c.getFloat32(4));

    
}


tester().
then(()=>console.log("OK")).
catch(e=>console.log(e));

