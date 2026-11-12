`timescale 1ns/1ps

module fp64_sqrt (
    input  [63:0] a,
    output [63:0] y,
    output [7:0]  status
);

    wire [2:0] rnd;

    assign rnd = 3'b000;

    DW_fp_sqrt #(
        52,
        11,
        0
    ) u_dw_fp_sqrt (
        .a      (a),
        .rnd    (rnd),
        .z      (y),
        .status (status)
    );

endmodule
