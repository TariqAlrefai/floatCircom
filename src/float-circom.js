const wasm_tester = require("circom_tester").wasm;
const c_tester = require("circom_tester").c;
const assert = require("assert");

function Number2Float32Bytes(n){
    const dv = (new DataView(new ArrayBuffer(4)));
    dv.setFloat32(0, n);
    return dv.getUint32(0);
}

function Number2Float64Bytes(n){
    const dv = (new DataView(new ArrayBuffer(8)));
    dv.setFloat64(0, n);
    return dv.getBigUint64(0);
}

function Float32Bytes2Number(n){
    const c = (new DataView(new ArrayBuffer(8)));
    c.setBigInt64(0, n);
    return c.getFloat32(4);
}

function Float64Bytes2Number(n){
    const c = (new DataView(new ArrayBuffer(8)));
    c.setBigInt64(0, n);
    return c.getFloat64(0);
}

module.exports = {
    Number2Float32Bytes, 
    Number2Float64Bytes, 
    Float32Bytes2Number, 
    Float64Bytes2Number
};
