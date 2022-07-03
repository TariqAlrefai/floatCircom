pragma circom 2.0.3;

include "../node_modules/circomlib/circuits/mux1.circom";
include "../node_modules/circomlib/circuits/comparators.circom";

template leftShift(max) {
    signal input n;
    signal input shift;
    signal output o;
    
    assert(shift<=max);

    component eqs[max];
    component muxs[max];

    eqs[0] = GreaterThan(8);
    eqs[0].in[0] <== shift;
    eqs[0].in[1] <== 0;

    muxs[0] = Mux1();
    muxs[0].c[0] <== n;
    muxs[0].c[1] <== n*2;
    muxs[0].s <== eqs[0].out;
    for(var i=1; i<max; i++){

        eqs[i] = GreaterThan(8);
        eqs[i].in[0] <== shift;
        eqs[i].in[1] <== i;

        muxs[i] = Mux1();
        muxs[i].c[0] <== muxs[i-1].out;
        muxs[i].c[1] <== muxs[i-1].out * 2;
        muxs[i].s <== eqs[i].out;
    }

    o <== muxs[max-1].out;

    // log(10944121435919637611123202872628637544274182200208017171849102093287904247809); // 2 Invers in prime space 'p'
}

// component main = leftShift(2);

// INPUT = {
//     "n": "1",
//     "shift": "1"
// } 