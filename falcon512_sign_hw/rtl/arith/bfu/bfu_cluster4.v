`timescale 1ns/1ps

module bfu_cluster4 (
    input         mode,

    input  [255:0] x_re,
    input  [255:0] x_im,

    input  [255:0] y_re,
    input  [255:0] y_im,

    input  [255:0] w_re,
    input  [255:0] w_im,

    output [255:0] out0_re,
    output [255:0] out0_im,

    output [255:0] out1_re,
    output [255:0] out1_im
);

    /*
     * 4 BFUs in parallel.
     *
     * Lane mapping:
     *
     * lane 0 = [ 63:  0]
     * lane 1 = [127: 64]
     * lane 2 = [191:128]
     * lane 3 = [255:192]
     */

    bfu u_bfu0 (
        .mode    (mode),

        .x_re    (x_re[63:0]),
        .x_im    (x_im[63:0]),

        .y_re    (y_re[63:0]),
        .y_im    (y_im[63:0]),

        .w_re    (w_re[63:0]),
        .w_im    (w_im[63:0]),

        .out0_re (out0_re[63:0]),
        .out0_im (out0_im[63:0]),

        .out1_re (out1_re[63:0]),
        .out1_im (out1_im[63:0])
    );

    bfu u_bfu1 (
        .mode    (mode),

        .x_re    (x_re[127:64]),
        .x_im    (x_im[127:64]),

        .y_re    (y_re[127:64]),
        .y_im    (y_im[127:64]),

        .w_re    (w_re[127:64]),
        .w_im    (w_im[127:64]),

        .out0_re (out0_re[127:64]),
        .out0_im (out0_im[127:64]),

        .out1_re (out1_re[127:64]),
        .out1_im (out1_im[127:64])
    );

    bfu u_bfu2 (
        .mode    (mode),

        .x_re    (x_re[191:128]),
        .x_im    (x_im[191:128]),

        .y_re    (y_re[191:128]),
        .y_im    (y_im[191:128]),

        .w_re    (w_re[191:128]),
        .w_im    (w_im[191:128]),

        .out0_re (out0_re[191:128]),
        .out0_im (out0_im[191:128]),

        .out1_re (out1_re[191:128]),
        .out1_im (out1_im[191:128])
    );

    bfu u_bfu3 (
        .mode    (mode),

        .x_re    (x_re[255:192]),
        .x_im    (x_im[255:192]),

        .y_re    (y_re[255:192]),
        .y_im    (y_im[255:192]),

        .w_re    (w_re[255:192]),
        .w_im    (w_im[255:192]),

        .out0_re (out0_re[255:192]),
        .out0_im (out0_im[255:192]),

        .out1_re (out1_re[255:192]),
        .out1_im (out1_im[255:192])
    );

endmodule
