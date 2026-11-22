
`timescale 1ns/1ps

module split (
    // Special case: logn = 1
    input         small_n_mode,
    input  [63:0] copy_f0,
    input  [63:0] copy_f1,

    // Complex input A
    input  [63:0] a_re,
    input  [63:0] a_im,

    // Complex input B
    input  [63:0] b_re,
    input  [63:0] b_im,

    // GM coefficient
    input  [63:0] gm_re,
    input  [63:0] gm_im,

    // Split outputs
    output [63:0] f0_re,
    output [63:0] f0_im,
    output [63:0] f1_re,
    output [63:0] f1_im
);

    // IEEE-754 binary64 representation of 0.5
    localparam [63:0] HALF = 64'h3FE0000000000000;

    // GM conjugate
    wire [63:0] gm_conj_im;

    // BFU outputs
    wire [63:0] bfu_out0_re;
    wire [63:0] bfu_out0_im;
    wire [63:0] bfu_out1_re;
    wire [63:0] bfu_out1_im;

    // Half operation results
    wire [63:0] half_f0_re;
    wire [63:0] half_f0_im;
    wire [63:0] half_f1_re;
    wire [63:0] half_f1_im;

    // Unused FP64 status signals
    wire [7:0] status_f0_re;
    wire [7:0] status_f0_im;
    wire [7:0] status_f1_re;
    wire [7:0] status_f1_im;

    // Negate GM imaginary component
    fp64_neg u_gm_neg (
        .a (gm_im),
        .y (gm_conj_im)
    );

    // Reuse BFU in IFFT mode
    bfu u_split_bfu (
        .mode  (1'b1),

        .x_re  (a_re),
        .x_im  (a_im),

        .y_re  (b_re),
        .y_im  (b_im),

        .w_re  (gm_re),
        .w_im  (gm_conj_im),

        .out0_re (bfu_out0_re),
        .out0_im (bfu_out0_im),

        .out1_re (bfu_out1_re),
        .out1_im (bfu_out1_im)
    );

    // f0 = (A + B) / 2
    fp64_mul u_half_f0_re (
        .a      (bfu_out0_re),
        .b      (HALF),
        .y      (half_f0_re),
        .status (status_f0_re)
    );

    fp64_mul u_half_f0_im (
        .a      (bfu_out0_im),
        .b      (HALF),
        .y      (half_f0_im),
        .status (status_f0_im)
    );

    // f1 = (A - B) * conjugate(GM) / 2
    fp64_mul u_half_f1_re (
        .a      (bfu_out1_re),
        .b      (HALF),
        .y      (half_f1_re),
        .status (status_f1_re)
    );

    fp64_mul u_half_f1_im (
        .a      (bfu_out1_im),
        .b      (HALF),
        .y      (half_f1_im),
        .status (status_f1_im)
    );

    // Normal operation / logn = 1 bypass
    assign f0_re = small_n_mode ? copy_f0 : half_f0_re;
    assign f0_im = small_n_mode ? 64'b0 : half_f0_im;

    assign f1_re = small_n_mode ? copy_f1 : half_f1_re;
    assign f1_im = small_n_mode ? 64'b0 : half_f1_im;

endmodule

