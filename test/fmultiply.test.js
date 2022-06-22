
const wasm_tester = require("circom_tester").wasm;
const c_tester = require("circom_tester").c;
const assert = require("assert");

const {Float32Bytes2Number, Number2Float32Bytes, f32Mul} = require("../src/float-circom.js");
// const Number2Float32Bytes = require("../src/floatCircom.js");
// import {Number2Float32Bytes, Float32Bytes2Number} from "../src/float-circom.mjs";

async function tester(){

    describe("Test Multiplicatoin", async ()=>{
       
        it("10.5*11.25", async ()=>{
            let p1 = 10.5;
            let p2 = 11.25;

            const circuit = await wasm_tester("./circuits/fmultiply.circom");
            const w = await circuit.calculateWitness({
                f1: Number2Float32Bytes(p2), 
                f2: Number2Float32Bytes(p1)
            });

            await circuit.checkConstraints(w);
            const output = w[1];
                        
            const rate = f32Mul(p1,p2)/Float32Bytes2Number(output);
            assert.ok(rate > 0.999 && rate < 1.001);
        })

        it("0.031*0.00456", async ()=>{
            let p1 = 0.031;
            let p2 = 0.00456;

            const circuit = await wasm_tester("./circuits/fmultiply.circom");
            const w = await circuit.calculateWitness({
                f1: Number2Float32Bytes(p2), 
                f2: Number2Float32Bytes(p1)
            });

            await circuit.checkConstraints(w);
            const output = w[1];
                        
            const rate = f32Mul(p1,p2)/Float32Bytes2Number(output);
            assert.ok(rate > 0.999 && rate < 1.001);
        })

        it("8546857.235*0.00145", async ()=>{
            let p1 = 8546857.235;
            let p2 = 0.00145;

            const circuit = await wasm_tester("./circuits/fmultiply.circom");
            const w = await circuit.calculateWitness({
                f1: Number2Float32Bytes(p2), 
                f2: Number2Float32Bytes(p1)
            });

            await circuit.checkConstraints(w);
            const output = w[1];
                        
            const rate = f32Mul(p1,p2)/Float32Bytes2Number(output);
            assert.ok(rate > 0.999 && rate < 1.001);
        })

        it("-152.3*23.23", async ()=>{
            let p1 = -152.3;
            let p2 = 23.23;

            const circuit = await wasm_tester("./circuits/fmultiply.circom");
            const w = await circuit.calculateWitness({
                f1: Number2Float32Bytes(p2), 
                f2: Number2Float32Bytes(p1)
            });

            await circuit.checkConstraints(w);
            const output = w[1];
                        
            const rate = f32Mul(p1,p2)/Float32Bytes2Number(output);
            assert.ok(rate > 0.999 && rate < 1.001);
        })

        it("-9.6*-1.5", async ()=>{
            let p1 = -9.6;
            let p2 = -1.5;

            const circuit = await wasm_tester("./circuits/fmultiply.circom");
            const w = await circuit.calculateWitness({
                f1: Number2Float32Bytes(p2), 
                f2: Number2Float32Bytes(p1)
            });

            await circuit.checkConstraints(w);
            const output = w[1];
                        
            const rate = f32Mul(p1,p2)/Float32Bytes2Number(output);
            assert.ok(rate > 0.999 && rate < 1.001);
        })
    })

    describe("Test Addition", async() =>{
        it("0.3+0.12", async ()=>{
            let p1 = 0.3;
            let p2 = 0.12;

            const circuit = await wasm_tester("./circuits/fadd.circom");
            const w = await circuit.calculateWitness({
                f1: Number2Float32Bytes(p2), 
                f2: Number2Float32Bytes(p1)
            });
            await circuit.checkConstraints(w);
            
            const output = w[1];

            const c = (new DataView(new ArrayBuffer(8)));
            c.setBigInt64(0, output);

            assert.ok(Math.abs(p1+p2-c.getFloat32(4)) < 0.01);
        })
    })
    
    

    
}


tester().
then(()=>console.log("OK")).
catch(e=>console.log(e));

