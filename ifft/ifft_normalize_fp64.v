`timescale 1ns/1ps
// Normalizes one complex FP64 sample after all Falcon IFFT stages.
// For 256 complex samples (logn=8), scale = 1/256 = 2^-8.
// Combinational: the existing IFFT output register captures the result.
module ifft_normalize_fp64 #(
    parameter logn = 8
)(
    input  [63:0] in_re, in_im,
    output [63:0] out_re, out_im
);
    localparam [63:0] SCALE_FP64 = (64'd1023 - logn) << 52;
    wire [7:0] st_re, st_im;

    fp64_mul u_normalize_re (
        .a(in_re), .b(SCALE_FP64),
        .y(out_re), .status(st_re)
    );
    fp64_mul u_normalize_im (
        .a(in_im), .b(SCALE_FP64),
        .y(out_im), .status(st_im)
    );
endmodule
