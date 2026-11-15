`timescale 1ns/1ps
// Falcon FFT-domain SPLIT/MERGE on one pair of complex values.
// Data: raw IEEE-754 binary64 (not Q fixed point).
// mode_merge: 0=SPLIT, 1=MERGE.
// base_case: logn==1; handles two real scalars without twiddle.
// Combinational arithmetic, intended as FUNCTIONAL BASELINE.
// No RAM addressing or FPU pipeline control is included here.
module falcon_split_merge_pair (
    input  wire        mode_merge,
    input  wire        base_case,
    input  wire [63:0] a_re, a_im, b_re, b_im,
    input  wire [63:0] tw_re, tw_im,
    output wire [63:0] out0_re, out0_im, out1_re, out1_im
);
    localparam [63:0] FP_HALF = 64'h3fe0000000000000;
    localparam [63:0] FP_ZERO = 64'h0000000000000000;

    wire [63:0] sum_re, sum_im, diff_re, diff_im;
    falcon_fp64_add u_sum_re (.a(a_re), .b(b_re), .z(sum_re));
    falcon_fp64_add u_sum_im (.a(a_im), .b(b_im), .z(sum_im));
    falcon_fp64_sub u_diff_re(.a(a_re), .b(b_re), .z(diff_re));
    falcon_fp64_sub u_diff_im(.a(a_im), .b(b_im), .z(diff_im));

    // SPLIT: ((a-b)*conj(w))/2 ; MERGE: b*w
    wire [63:0] x_re = mode_merge ? b_re : diff_re;
    wire [63:0] x_im = mode_merge ? b_im : diff_im;
    wire [63:0] w_im = mode_merge ? tw_im : {~tw_im[63], tw_im[62:0]};
    wire [63:0] mul_rr, mul_ii, mul_ri, mul_ir, p_re, p_im;
    falcon_fp64_mul u_mul_rr(.a(x_re), .b(tw_re), .z(mul_rr));
    falcon_fp64_mul u_mul_ii(.a(x_im), .b(w_im),  .z(mul_ii));
    falcon_fp64_mul u_mul_ri(.a(x_re), .b(w_im),  .z(mul_ri));
    falcon_fp64_mul u_mul_ir(.a(x_im), .b(tw_re),.z(mul_ir));
    falcon_fp64_sub u_p_re(.a(mul_rr), .b(mul_ii), .z(p_re));
    falcon_fp64_add u_p_im(.a(mul_ri), .b(mul_ir), .z(p_im));

    // SPLIT path
    wire [63:0] split0_re, split0_im, split1_re, split1_im;
    falcon_fp64_mul u_half_0re(.a(sum_re), .b(FP_HALF), .z(split0_re));
    falcon_fp64_mul u_half_0im(.a(sum_im), .b(FP_HALF), .z(split0_im));
    falcon_fp64_mul u_half_1re(.a(p_re), .b(FP_HALF), .z(split1_re));
    falcon_fp64_mul u_half_1im(.a(p_im), .b(FP_HALF), .z(split1_im));

    // MERGE path
    wire [63:0] merge0_re, merge0_im, merge1_re, merge1_im;
    falcon_fp64_add u_merge_0re(.a(a_re), .b(p_re), .z(merge0_re));
    falcon_fp64_add u_merge_0im(.a(a_im), .b(p_im), .z(merge0_im));
    falcon_fp64_sub u_merge_1re(.a(a_re), .b(p_re), .z(merge1_re));
    falcon_fp64_sub u_merge_1im(.a(a_im), .b(p_im), .z(merge1_im));

    // logn==1: SPLIT f[0],f[1] -> f0[0],f1[0];
    //           MERGE f0[0],f1[0] -> f[0],f[1].
    assign out0_re = base_case ? a_re  : (mode_merge ? merge0_re : split0_re);
    assign out0_im = base_case ? FP_ZERO : (mode_merge ? merge0_im : split0_im);
    assign out1_re = base_case ? (mode_merge ? b_re : a_im)
                               : (mode_merge ? merge1_re : split1_re);
    assign out1_im = base_case ? FP_ZERO : (mode_merge ? merge1_im : split1_im);
endmodule
