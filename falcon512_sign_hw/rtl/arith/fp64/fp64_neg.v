`timescale 1ns/1ps

module fp64_neg (
    input  [63:0] a,
    output [63:0] y
);

    assign y = {~a[63], a[62:0]};

endmodule
