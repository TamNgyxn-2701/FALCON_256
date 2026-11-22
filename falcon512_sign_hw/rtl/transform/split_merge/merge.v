`timescale 1ns/1ps

module merge (
    input         small_n_mode,

    // First complex input: f0
    input  [63:0] f0_re,
    input  [63:0] f0_im,

    // Second complex input: f1
    input  [63:0] f1_re,
    input  [63:0] f1_im,

    // GM coefficient
    input  [63:0] gm_re,
    input  [63:0] gm_im,

    // Merge outputs
    output [63:0] out0_re,
    output [63:0] out0_im,

    output [63:0] out1_re,
    output [63:0] out1_im
);

    /*
     * Normal Merge:
     *
     * T    = f1 * GM
     * Out0 = f0 + T
     * Out1 = f0 - T
     *
     * Reuse BFU in FFT mode (mode = 0).
     */

    wire [63:0] bfu_out0_re;
    wire [63:0] bfu_out0_im;

    wire [63:0] bfu_out1_re;
    wire [63:0] bfu_out1_im;

    bfu u_merge_bfu (
        .mode    (1'b0),

        .x_re    (f0_re),
        .x_im    (f0_im),

        .y_re    (f1_re),
        .y_im    (f1_im),

        .w_re    (gm_re),
        .w_im    (gm_im),

        .out0_re (bfu_out0_re),
        .out0_im (bfu_out0_im),

        .out1_re (bfu_out1_re),
        .out1_im (bfu_out1_im)
    );

    /*
     * Special case: logn = 1
     *
     * f[0] = f0[0]
     * f[1] = f1[0]
     */

    assign out0_re = small_n_mode ? f0_re : bfu_out0_re;
    assign out0_im = small_n_mode ? 64'b0 : bfu_out0_im;

    assign out1_re = small_n_mode ? f1_re : bfu_out1_re;
    assign out1_im = small_n_mode ? 64'b0 : bfu_out1_im;

endmodule
