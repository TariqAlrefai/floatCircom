pragma circom 2.0.4;

include "../node_modules/circomlib/circuits/mux1.circom";
include "../node_modules/circomlib/circuits/comparators.circom";
// include "../node_modules/circomlib/bitify.circom";

template rightShift(max) {
    signal input n;
    signal input shift;
    signal output o;
    
    assert(shift<=max);
    assert(n>>shift>0);

    component eqs[max];
    component muxs[max];
    component oddmux[max];
    component n2b[max];

    n2b[0] = Num2Bits(32);
    n2b[0].in <== n;

    oddmux[0] = Mux1();
    oddmux[0].c[0] <== n;
    oddmux[0].c[1] <== n-1;
    oddmux[0].s <== n2b[0].out[0];

    eqs[0] = GreaterThan(8);
    eqs[0].in[0] <== shift;
    eqs[0].in[1] <== 0;

    muxs[0] = Mux1();
    muxs[0].c[0] <== n;
    muxs[0].c[1] <== oddmux[0].out * 10944121435919637611123202872628637544274182200208017171849102093287904247809;
    // muxs[0].c[1] <-- oddmux[0].out/2;
    // muxs[0].c[1] * 2 === oddmux[0].out;
    muxs[0].s <== eqs[0].out;
    for(var i=1; i<max; i++){

        n2b[i] = Num2Bits(32);
        log(muxs[i-1].out);
        n2b[i].in <== muxs[i-1].out;

        oddmux[i] = Mux1();
        oddmux[i].c[0] <== muxs[i-1].out;
        oddmux[i].c[1] <== muxs[i-1].out-1;
        oddmux[i].s <== n2b[i].out[0];

        eqs[i] = GreaterThan(8);
        eqs[i].in[0] <== shift;
        eqs[i].in[1] <== i;

        muxs[i] = Mux1();
        muxs[i].c[0] <== oddmux[i].out;
        muxs[i].c[1] <== oddmux[i].out * 10944121435919637611123202872628637544274182200208017171849102093287904247809;
        // muxs[i].c[1] <-- oddmux[i].out/2;
        // muxs[i].c[1] * 2 === oddmux[i].out;
        muxs[i].s <== eqs[i].out;
    }

    o <== muxs[max-1].out;

    // log(10944121435919637611123202872628637544274182200208017171849102093287904247809); // 2 Invers in prime space 'p'
}

// component main = rightShift(20);

/* INPUT = {
    "n": "27",
    "shift": "3"
} */