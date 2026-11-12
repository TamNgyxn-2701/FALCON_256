`timescale 1ns/1ps

module fp64_sub (
    input  [63:0] a,
    input  [63:0] b,
    output [63:0] y,
    output [7:0]  status
);

    wire [2:0] rnd;

    assign rnd = 3'b000;

    DW_fp_addsub #(
        52,
        11,
        0
    ) u_dw_fp_sub (
        .a      (a),
        .b      (b),
        .rnd    (rnd),
        .op     (1'b1),
        .z      (y),
        .status (status)
    );

endmodule
