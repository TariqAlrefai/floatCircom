/*
    This moduel convert any 32-bit integer to floating point number
*/

pragma circom 2.0.4;

include "../node_modules/circomlib/circuits/bitify.circom";
include "./logic.circom";
// include "../node_modules/circomlib/circuits/gates.circom";

template i2f(n){
    signal input in;   // input integer
    // signal input test; // test input, should be removed in production
    signal output out; // floating point number

    // Get the integr exponent
    component p = pe(n);
    p.integer <== in;
    // p.o === test; // Test output is correct, Exponent part should be ready here
    
    component exp = Num2Bits(8);
    exp.in <== p.o+127; // correct exponent form

    // Set mantissa part of the floating point number
    var i;
    component mantissa = Num2Bits(23);
    var shift = 23-p.o;
    var shifted = in << shift;
    mantissa.in <-- shifted & 0x7fffff;
    

    // combine both parts along with sing part (sign always positive right now)
    component f = Bits2Num(n);
    f.in[31] <== 0;

    for(i=0; i<8; i++){
        f.in[23+i] <== exp.out[i];
    }
    
    for(i=22; i>=0; i--){
        f.in[i] <== mantissa.out[i];
    }

    out <== f.out;
}

// component main = i2f(32);
