`timescale 1ns/1ps

module fpr2int (
    input  [63:0] a,
    output [63:0] y,
    output [7:0]  status
);

    wire [2:0] rnd;

    // round-to-nearest, ties-to-even
    assign rnd = 3'b000;

    DW_fp_flt2i #(
        52,     // sig_width
        11,     // exp_width
        64,     // isize
        0       // ieee_compliance
    ) u_dw_fp_flt2i (
        .a      (a),
        .rnd    (rnd),
        .z      (y),
        .status (status)
    );

endmodule

