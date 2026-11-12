`timescale 1ns/1ps

module int2fpr (
    input  [63:0] a,
    output [63:0] y,
    output [7:0]  status
);

    wire [2:0] rnd;

    assign rnd = 3'b000;

    DW_fp_i2flt #(
        52,     // sig_width
        11,     // exp_width
        64,     // isize
        1       // isign: signed
    ) u_dw_fp_i2flt (
        .a      (a),
        .rnd    (rnd),
        .z      (y),
        .status (status)
    );

endmodule
