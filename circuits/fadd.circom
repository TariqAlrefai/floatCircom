pragma circom 2.0.4;

include "../node_modules/circomlib/circuits/mux1.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

template fadd(){
    signal input f1;
    signal input f2;
    signal output fo;


    // Decode numbers
    component f1b = Num2Bits(32);
    f1b.in <== f1;

    component f2b = Num2Bits(32);
    f2b.in <== f2;

    // Extract Sign
    signal f1s <== f1b.out[31];
    signal f2s <== f2b.out[31];

    // Extract Exponent, calculate ANDs & ORs of each
    var i;
    component f1exp  = Bits2Num(8);
    for(i=0; i<8; i++){
        f1exp.in[i]  <== f1b.out[23+i];
    }

    component f2exp  = Bits2Num(8);
    for(i=0; i<8; i++){
        f2exp.in[i]  <== f2b.out[23+i];
    }

    // Extract Mantissa
    component f1mant = Bits2Num(24);
    f1mant.in[23] <== 1;
    for(i=0; i<23; i++){
        f1mant.in[i] <== f1b.out[i];
    }

    component f2mant = Bits2Num(24);
    f2mant.in[23] <== 1;
    for(i=0; i<23; i++){
        f2mant.in[i] <== f2b.out[i];
    }

    component less = LessThan(8);
    less.in[0] <== f1exp.out;
    less.in[1] <== f2exp.out;

    component eq   = IsEqual(8);
    eq.in[0] <== f1exp.out;
    eq.in[1] <== f2exp.out;

    component mmux = MultiMux1(1);
    mmux.in[0][0] <== f1exp;
    mmux.in[0][1] <== f2exp;
    mmux.s <== less.out;
    signal greate = mmux.out[0];
    signal smalle = mmux.out[1];

    signal diff = greate - smalle;

    component mantissaSelector1 = Mux1();
    mantissaSelector1.in[0] <== f1mant.out;
    mantissaSelector1.in[0] <== f1mant.out;

    component mantissaSelector2 = Mux1();



    
}