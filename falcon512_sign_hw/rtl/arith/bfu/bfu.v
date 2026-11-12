`timescale 1ns/1ps

module bfu (
    input         mode,

    input  [63:0] x_re,
    input  [63:0] x_im,

    input  [63:0] y_re,
    input  [63:0] y_im,

    input  [63:0] w_re,
    input  [63:0] w_im,

    output [63:0] out0_re,
    output [63:0] out0_im,

    output [63:0] out1_re,
    output [63:0] out1_im
);

    /*
     * mode = 0 : FFT
     *
     * T  = Y * W
     * O0 = X + T
     * O1 = X - T
     *
     * mode = 1 : IFFT
     *
     * O0 = X + Y
     * D  = X - Y
     * O1 = D * W
     */

    wire [63:0] fft_t_re;
    wire [63:0] fft_t_im;

    wire [63:0] fft_o0_re;
    wire [63:0] fft_o0_im;
    wire [63:0] fft_o1_re;
    wire [63:0] fft_o1_im;

    wire [63:0] ifft_sum_re;
    wire [63:0] ifft_sum_im;

    wire [63:0] ifft_diff_re;
    wire [63:0] ifft_diff_im;

    wire [63:0] ifft_mul_re;
    wire [63:0] ifft_mul_im;

    wire [7:0] unused_status_0;
    wire [7:0] unused_status_1;
    wire [7:0] unused_status_2;
    wire [7:0] unused_status_3;
    wire [7:0] unused_status_4;
    wire [7:0] unused_status_5;
    wire [7:0] unused_status_6;
    wire [7:0] unused_status_7;

    /*
     * ==========================================================
     * FFT path
     * ==========================================================
     */

    complex_mul u_fft_complex_mul (
        .a_re (y_re),
        .a_im (y_im),
        .b_re (w_re),
        .b_im (w_im),
        .y_re (fft_t_re),
        .y_im (fft_t_im)
    );

    fp64_add u_fft_add_re (
        .a      (x_re),
        .b      (fft_t_re),
        .y      (fft_o0_re),
        .status (unused_status_0)
    );

    fp64_add u_fft_add_im (
        .a      (x_im),
        .b      (fft_t_im),
        .y      (fft_o0_im),
        .status (unused_status_1)
    );

    fp64_sub u_fft_sub_re (
        .a      (x_re),
        .b      (fft_t_re),
        .y      (fft_o1_re),
        .status (unused_status_2)
    );

    fp64_sub u_fft_sub_im (
        .a      (x_im),
        .b      (fft_t_im),
        .y      (fft_o1_im),
        .status (unused_status_3)
    );

    /*
     * ==========================================================
     * IFFT path
     * ==========================================================
     */

    fp64_add u_ifft_add_re (
        .a      (x_re),
        .b      (y_re),
        .y      (ifft_sum_re),
        .status (unused_status_4)
    );

    fp64_add u_ifft_add_im (
        .a      (x_im),
        .b      (y_im),
        .y      (ifft_sum_im),
        .status (unused_status_5)
    );

    fp64_sub u_ifft_sub_re (
        .a      (x_re),
        .b      (y_re),
        .y      (ifft_diff_re),
        .status (unused_status_6)
    );

    fp64_sub u_ifft_sub_im (
        .a      (x_im),
        .b      (y_im),
        .y      (ifft_diff_im),
        .status (unused_status_7)
    );

    complex_mul u_ifft_complex_mul (
        .a_re (ifft_diff_re),
        .a_im (ifft_diff_im),
        .b_re (w_re),
        .b_im (w_im),
        .y_re (ifft_mul_re),
        .y_im (ifft_mul_im)
    );

    /*
     * Select FFT / IFFT result.
     */

    assign out0_re = (mode == 1'b0) ? fft_o0_re : ifft_sum_re;
    assign out0_im = (mode == 1'b0) ? fft_o0_im : ifft_sum_im;

    assign out1_re = (mode == 1'b0) ? fft_o1_re : ifft_mul_re;
    assign out1_im = (mode == 1'b0) ? fft_o1_im : ifft_mul_im;

endmodule
