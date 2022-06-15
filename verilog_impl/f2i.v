
/* verilator lint_off UNUSED */
module f2i(
    input  [31:0] i_float,
    output [15:0] o_integer
);

    wire [7:0]  exponent;         // Exponent part in floating point number
    wire [7:0]  correct_exponent; // Correcting exponent, so it is zero when it is 127
    wire [22:0] mantissa;         // Mantissa part of floating point number
    wire [22:0] shifted_mantissa; // Shift mantissa so it can be used in oring
    wire [15:0] oring_mantissa;   // down size mantissa so it can be ored with output

    assign exponent         = i_float[30:23];
    assign correct_exponent = exponent - 8'd127;
    assign mantissa         = {i_float[22:0]};
    assign shifted_mantissa = mantissa >> (16-correct_exponent);
    assign oring_mantissa   = shifted_mantissa[22:7];
    assign o_integer        = |exponent ?  16'd1<<correct_exponent | oring_mantissa: 16'h0;

endmodule