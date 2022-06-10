pragma circom 2.0.4;

include "../circomlib/circuits/bitify.circom";
include "../circomlib/circuits/gates.circom";

template pe(n){
    signal input integer;
    signal output o;

    component intin = Num2Bits(n);
    component intout= Bits2Num(n);

    intin.in <== integer;
    var i;
    var j;
    var counter=1;
    component ands[n];

    for(j=n-1; j>=0; j--){ // 31 >> 0
        ands[j] = MultiAND(n-j);
        // ands[j].in[0] <== intin.out[n-j-1];
        ands[j].in[0] <== intin.out[j];

        for(i=n-1; i>j; i--){ // 31 >> j+1
            ands[j].in[1+n-i-1] <== 1 - intin.out[i]; // Invert input, because I need the not of bits here
        }

        intout.in[j] <== ands[j].out;
    }

    o <== intout.out;
}

template i2f(){
    signal input in;
    component p = pe(32);

    p.integer <== in;
    p.o === 64;
}

component main = i2f();
