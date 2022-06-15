
include "../node_modules/circomlib/circuits/bitify.circom";
include "../node_modules/circomlib/circuits/mux1.circom";

template fmultiply(){
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

    // Extract Exponent
    var i;
    component f1exp = Bits2Num(8);
    for(i=0; i<8; i++){
        f1exp.in[i] <== f1b.out[23+i];
    }

    component f2exp = Bits2Num(8);
    for(i=0; i<8; i++){
        f2exp.in[i] <== f2b.out[23+i];
    }

    // Extract Mantissa
    component f1mant = Bits2Num(24);
    f1mant.in[23] <== 1;
    for(i=0; i<23; i++){
        f1mant.in[i] <== f2b.out[i];
    }

    component f2mant = Bits2Num(24);
    f2mant.in[23] <== 1;
    for(i=0; i<23; i++){
        f2mant.in[i] <== f2b.out[i];
    }

    // Multiply exponents part;
    signal oexp;
    oexp <== f1exp.out + f2exp.out - 127;

    // Multiply mantissas
    signal mant;
    mant <== f1mant.out * f2mant.out;
    // log(f1mant.out);
    // log(f2mant.out);
    // log(mant);
    component bits = Num2Bits(48);

    bits.in <== mant;

    component of = Bits2Num(32);
    var last = bits.out[47];
    var base=22;
    // if(last == 1){
    //     base = 22;
    // }
    // else{
    //     base = 21;
    // }
    signal b[23];
    for(i=0;i<23;i++){
        b[i] <== bits.out[23+i];
    }

    signal c[23];
    for(i=0;i<23;i++){
        c[i] <== bits.out[24+i];
    }

    component B = Bits2Num(23);
    for(i=0;i<23;i++){
        B.in[i] <== b[i];
    }

    component C = Bits2Num(23);
    for(i=0;i<23;i++){
        C.in[i] <== c[i];
    }

    component mux = Mux1();
    mux.c[0] <== B.out;
    mux.c[1] <== C.out;
    mux.s <== bits.out[47];
    
    // Combine both parts
    component foe = Num2Bits(8);
    component fom = Num2Bits(23);
    component f   = Bits2Num(32);

    fom.in <== mux.out;
    foe.in <== oexp;
    f.in[31] <== 0;
    for(i=0; i<8; i++){
        f.in[23+i] <== foe.out[i];
    }  
    for(i=0; i<23; i++){
        f.in[i] <== fom.out[i];
    }  
    
    fo <== f.out;
    log(fo);
}

component main = fmultiply();