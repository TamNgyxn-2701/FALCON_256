`timescale 1ns/1ps

module fp64_mul (
    input  [63:0] a,
    input  [63:0] b,
    output [63:0] y,
    output [7:0]  status
);

    wire [2:0] rnd;

    assign rnd = 3'b000;

    DW_fp_mult #(
        52,
        11,
        0
    ) u_dw_fp_mult (
        .a      (a),
        .b      (b),
        .rnd    (rnd),
        .z      (y),
        .status (status)
    );

endmodule
