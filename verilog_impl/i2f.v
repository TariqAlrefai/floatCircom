
`ifdef VERILATOR
    `include "../src/PriorityEncoder.v"
`endif

module i2f(
    input  [15:0] i_number,
    output [31:0] f_number
);

    wire [3:0] location;
    wire zero;
    wire [7:0] exponent;
    wire [22:0] mantissa;

    PriorityEncoder penc(i_number,location, zero);

    assign exponent = 8'h7f + {4'h0, location};
    assign mantissa = {i_number << (16-location), 7'h0};

    // Floating Number creation
    //                             Sign(+)|2e(exponent)|1.mantissa
    assign f_number = zero ? 32'h0 : {1'h0,   exponent,   mantissa};

endmodule