pragma circom 2.0.4;

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
    // component xor = XOR();
    // xor.a <== f1s;
    // xor.b <== f2s;
    // signal s <== xor.out;

    // Extract Exponent, calculate ANDs & ORs of each
    var i;
    // component f1eAnd = MultiAND(8);
    // component f1eOr  = MultiOR(8);
    component f1exp  = Bits2Num(8);
    for(i=0; i<8; i++){
        // f1eAnd.in[i] <== f1b.out[23+i];
        // f1eOr.in[i]  <== f1b.out[23+i];
        f1exp.in[i]  <== f1b.out[23+i];
    }

    // component f2eAnd = MultiAND(8);
    // component f2eOr  = MultiOR(8);
    component f2exp  = Bits2Num(8);
    for(i=0; i<8; i++){
        // f2eAnd.in[i] <== f1b.out[23+i];
        // f2eOr.in[i]  <== f1b.out[23+i];
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

    
}