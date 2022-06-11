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
    var counter=0;
    component ands[n];
    var holder;
    

    for(j=n-1; j>=0; j--){ // 31 >> 0
        ands[j] = MultiAND(n-j);
        // ands[j].in[0] <== intin.out[n-j-1];
        ands[j].in[0] <== intin.out[j];

        for(i=n-1; i>j; i--){ // 31 >> j+1
            ands[j].in[1+n-i-1] <== 1 - intin.out[i]; // Invert input, because I need the not of bits here
        }

        intout.in[j] <== ands[j].out;
    }

    // holder <== intout.out;
    var exp = intout.out;
    if(exp == 1){
        holder = 0;
    }
    if(exp == 2){
        holder = 1;
    }
    if(exp == 4){
        holder = 2;
    }
    if(exp == 8){
        holder = 3;
    }
    if(exp == 16){
        holder = 4;
    }
    if(exp == 32){
        holder = 5;
    }
    if(exp == 64){
        holder = 6;
    }
    if(exp == 128){
        holder = 7;
    }
    if(exp == 256){
        holder = 8;
    }
    if(exp == 512){
        holder = 9;
    }
    if(exp == 1024){
        holder = 10;
    }
    if(exp == 2048){
        holder = 11;
    }
    if(exp == 4096){
        holder = 12;
    }
    if(exp == 8192){
        holder = 13;
    }
    if(exp == 16384){
        holder = 14;
    }
    if(exp == 32768){
        holder = 15;
    }
    if(exp == 65536){
        holder = 16;
    }
    if(exp == 131072){
        holder = 17;
    }
    if(exp == 262144){
        holder = 18;
    }
    if(exp == 524288){
        holder = 19;
    }
    if(exp == 1048576){
        holder = 20;
    }
    if(exp == 2097152){
        holder = 21;
    }
    if(exp == 4194304){
        holder = 22;
    }
    if(exp == 8388608){
        holder = 23;
    }
    if(exp == 16777216){
        holder = 24;
    }
    if(exp == 33554432){
        holder = 25;
    }
    if(exp == 67108864){
        holder = 26;
    }
    if(exp == 134217728){
        holder = 27;
    }
    if(exp == 268435456){
        holder = 28;
    }
    if(exp == 536870912){
        holder = 29;
    }
    if(exp == 1073741824){
        holder = 30;
    }
    if(exp == 2147483648){
        holder = 31;
    }

    o <-- holder;
    
    
}

template i2f(n){
    signal input in;
    signal input test;
    signal output out;

    component p = pe(n);
    p.integer <== in;
    p.o === test; // Test output is correct, Exponent part should be ready here
    
    component exp = Num2Bits(8);
    exp.in <== p.o+127;

    var i;
/////////
    component mantissa = Num2Bits(23);
    var shift = 21-p.o;
    var shifted = in << shift;
    mantissa.in <-- shifted;
    
    

////////
    component f = Bits2Num(n);
    f.in[31] <== 0;

    for(i=0; i<8; i++){
        f.in[23+i] <== exp.out[i];
    }
    
    for(i=22; i>=0; i--){
        f.in[i] <== mantissa.out[i];
    }

    out <== f.out;
    log(out);
}

component main = i2f(32);
