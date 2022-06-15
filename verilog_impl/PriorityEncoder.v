


module PriorityEncoder(
    input [15:0] datain,
    output [3:0] dataout,
    output zero
);

    assign dataout = datain[15] ? 4'hf:
                     datain[14] ? 4'he:
                     datain[13] ? 4'hd:
                     datain[12] ? 4'hc:
                     datain[11] ? 4'hb:
                     datain[10] ? 4'ha:
                     datain[09] ? 4'h9:
                     datain[08] ? 4'h8:
                     datain[07] ? 4'h7:
                     datain[06] ? 4'h6:
                     datain[05] ? 4'h5:
                     datain[04] ? 4'h4:
                     datain[03] ? 4'h3:
                     datain[02] ? 4'h2:
                     datain[01] ? 4'h1:
                     datain[00] ? 4'h0: 
                                  4'h0;
    
    assign zero = ~(|datain);


endmodule