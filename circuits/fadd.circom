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

    component eq   = IsEqual();
    eq.in[0] <== f1exp.out;
    eq.in[1] <== f2exp.out;

    component mmux = MultiMux1(2);
    mmux.c[0][0] <== f1exp.out;
    mmux.c[0][1] <== f2exp.out;
    mmux.c[1][0] <== f2exp.out;
    mmux.c[1][1] <== f1exp.out;
    mmux.s <== less.out;
    signal greate <== mmux.out[0];
    signal smalle <== mmux.out[1];

    signal diff <== greate - smalle;

    component mantissaSelector1 = Mux1();
    mantissaSelector1.c[0] <== f1mant.out;
    mantissaSelector1.c[1] <-- f1mant.out>>diff;
    mantissaSelector1.s <== less.out;
    
    signal m1 <== mantissaSelector1.out;

    component mantissaSelector2 = Mux1();
    mantissaSelector2.c[0] <== f2mant.out;
    mantissaSelector2.c[1] <-- f2mant.out>>diff;
    mantissaSelector2.s <== 1-less.out;
    signal m2 <== mantissaSelector2.out;

    component sameSign = IsEqual();
    sameSign.in[0] <== f1s;
    sameSign.in[1] <== f2s;
    component singSelector = Mux1();
    singSelector.c[0] <== m1+m2;
    component greaterMantissaSelector = Mux1();
    greaterMantissaSelector.c[0] <== m1-m2;
    greaterMantissaSelector.c[1] <== m2-m1;
    greaterMantissaSelector.s <== less.out;
    singSelector.c[1] <== m1-m2;
    singSelector.s <== 1-less.out;
    signal fm <== singSelector.out;

    component fm2bits = Num2Bits(25);
    fm2bits.in <== fm;

    signal m;
    component mant_mux = Mux1();
    mant_mux.c[0] <== fm;
    mant_mux.c[1] <-- fm>>1;
    mant_mux.s <== fm2bits.out[24];
    m <== mant_mux.out;

    signal e;
    component exp_mux = Mux1();
    exp_mux.c[0] <== greate;
    exp_mux.c[1] <== greate+1;
    exp_mux.s <== fm2bits.out[24];
    e <== exp_mux.out;

    component mbits = Num2Bits(24);
    mbits.in <== m;

    component ebits = Num2Bits(8);
    ebits.in <== e;

    component full = Bits2Num(32);
    // var i;
    for(i=0;i<23;i++){
        full.in[i] <== mbits.out[i];
    }
    for(i=0; i<8; i++){
        full.in[i+23] <== ebits.out[i];
    }
    full.in[31] <== f1s;

    fo <== full.out;
}

component main = fadd();

/*
     5 +  2 =  7
    -5 + -2 = -7
    -5 +  2 = -3
     5 + -2 =  3

*/