`timescale 1ns/1ps

module fp64_add (
    input  [63:0] a,
    input  [63:0] b,
    output [63:0] y,
    output [7:0]  status
);

    wire [2:0] rnd;

    // Falcon Golden uses normal IEEE-754 double precision.
    // Round-to-nearest mode.
    assign rnd = 3'b000;

    DW_fp_add #(
        52,     // sig_width
        11,     // exp_width
        0       // ieee_compliance
    ) u_dw_fp_add (
        .a      (a),
        .b      (b),
        .rnd    (rnd),
        .z      (y),
        .status (status)
    );

endmodule
