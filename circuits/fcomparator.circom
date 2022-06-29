pragma circom 2.0.4;

include "./logic.circom";
include "../node_modules/circomlib/circuits/mux1.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
<<<<<<< HEAD
=======
include "./fadd.circom";
>>>>>>> 568644e7ab36ea39762fb359210e2f763c0fc777

// A < B
template lessThanF(e,m){
    signal input f1;
    signal input f2;
    signal output r;

    component decode1 = Decode(e,m);
    decode1.f <== f1;

    component decode2 = Decode(e,m);
    decode2.f <== f2;

<<<<<<< HEAD
    component Eless = LessThan(e);
    Eless.in[0] <== decode1.exponent;
    Eless.in[1] <== decode2.exponent;

=======
>>>>>>> 568644e7ab36ea39762fb359210e2f763c0fc777
    component Eeq = IsEqual();
    Eeq.in[0] <== decode1.exponent;
    Eeq.in[1] <== decode2.exponent;

<<<<<<< HEAD
    component Mless = LessThan(m);
    Mless.in[0] <== decode1.mantissa;
    Mless.in[1] <== decode2.mantissa;
    
=======
    component Eless = LessThan(e);
    Eless.in[0] <== decode1.exponent;
    Eless.in[1] <== decode2.exponent;

    component Mless = LessThan(m);
    Mless.in[0] <== decode1.mantissa;
    Mless.in[1] <== decode2.mantissa;

>>>>>>> 568644e7ab36ea39762fb359210e2f763c0fc777
    component mux1 = Mux1();
    mux1.c[0] <== Eless.out;
    mux1.c[1] <== Mless.out;
    mux1.s <== Eeq.out;
<<<<<<< HEAD

=======
>>>>>>> 568644e7ab36ea39762fb359210e2f763c0fc777
    r <== mux1.out;
}
component main = lessThenF(8,23);



// !(A < B+1)
<<<<<<< HEAD
// template greaterThenF(e,m){
    
// }

// template inRange(e,m){
    
// }

// template isEqualF(e,m){

// }
=======
template greaterThanF(e,m){
    signal input f1;
    signal input f2;
    signal output r;

    component add = fadd();
    signal float_one <== 0xf3800000;
    add.f1 <== float_one;
    add.f2 <== f2;

    component less = lessThanF(e,m);
    less.f1 <== f1;
    less.f2 <== add.fo;

    r <== 1-less.r;
}
>>>>>>> 568644e7ab36ea39762fb359210e2f763c0fc777




