
/* verilator lint_off UNUSED */ 

module FloatMul(
    input  [31:0] A,
    input  [31:0] B,
    output [31:0] O,
    output overflow, nan
);

    wire Asign;
    wire Bsign;
    wire [7:0] Aexp;
    wire [7:0] Bexp;
    wire [22:0] Amantissa;
    wire [22:0] Bmantissa;
    wire sign;
    wire [8:0] exp;
    wire [23:0] AmodMantissa;
    wire [23:0] BmodMantissa;
    wire [47:0] mantissa_full;
    wire [47:0] mantissa_full_shifted;
    wire [22:0] mantissa;
    wire normalized;

    // Splitters
    assign Asign     = A[31];
    assign Bsign     = B[31];
    assign Aexp      = A[30:23];
    assign Bexp      = B[30:23];
    assign Amantissa = A[22:0];
    assign Bmantissa = B[22:0];

    // Sgin
    assign sign = Asign ^ Bsign;

    // Exponent Part
    assign exp = &Aexp|&Bexp ?  9'h0ff : (|Aexp)&(|Bexp) ?  {1'b0,Aexp} + {1'b0,Bexp} - 9'd127 + {8'd0, normalized} : 9'h000;

    // Multiplication
    assign AmodMantissa = |Aexp ? {1'b1, Amantissa} : {1'b0, Amantissa};
    assign BmodMantissa = |Bexp ? {1'b1, Bmantissa} : {1'b0, Bmantissa};
    assign mantissa_full = AmodMantissa * BmodMantissa;
    assign normalized = mantissa_full[47];
    assign mantissa_full_shifted = normalized ? mantissa_full : mantissa_full << 1;
    assign mantissa = exp == 9'h000 ? 23'h0 : mantissa_full_shifted[46:24];

    // Errors
    assign overflow = exp[8];
    assign nan      = (&Aexp & |Amantissa) | (&Bexp & |Bmantissa);

    // Final Value
    assign O = {sign, exp[7:0], mantissa};

    always @(*) begin
        // $display("MantissaA,MantissaB,MantissaR,normalized:%x,%x,%x,%x", AmodMantissa, BmodMantissa, mantissa_full, mantissa_full[47]);
        // $display("ExpA,ExpB,Exp:%x,%x,%x", Aexp, Bexp, exp);
    end

endmodule