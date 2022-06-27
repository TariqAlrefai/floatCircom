import React from "react";
import reactDom from "react-dom";
import App from "./src/App"

const {
    Float32Bytes2Number, 
    Float64Bytes2Number, 
    Number2Float32Bytes, 
    Number2Float64Bytes 
} = require("./lib/float-circom");


module.exports = {
    Float32Bytes2Number, 
    Float64Bytes2Number, 
    Number2Float32Bytes, 
    Number2Float64Bytes 
};

reactDom.render(<App />, document.getElementById("root"));