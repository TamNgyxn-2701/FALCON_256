`timescale 1ns/1ps

module complex_mul (
    input  [63:0] a_re,
    input  [63:0] a_im,
    input  [63:0] b_re,
    input  [63:0] b_im,

    output [63:0] y_re,
    output [63:0] y_im
);

    wire [63:0] mul_rr;
    wire [63:0] mul_ii;
    wire [63:0] mul_ri;
    wire [63:0] mul_ir;

    wire [7:0] status_mul_rr;
    wire [7:0] status_mul_ii;
    wire [7:0] status_mul_ri;
    wire [7:0] status_mul_ir;
    wire [7:0] status_re;
    wire [7:0] status_im;

    /*
     * Falcon FPC_MUL:
     *
     * y_re = a_re*b_re - a_im*b_im
     * y_im = a_re*b_im + a_im*b_re
     */

    fp64_mul u_mul_rr (
        .a      (a_re),
        .b      (b_re),
        .y      (mul_rr),
        .status (status_mul_rr)
    );

    fp64_mul u_mul_ii (
        .a      (a_im),
        .b      (b_im),
        .y      (mul_ii),
        .status (status_mul_ii)
    );

    fp64_mul u_mul_ri (
        .a      (a_re),
        .b      (b_im),
        .y      (mul_ri),
        .status (status_mul_ri)
    );

    fp64_mul u_mul_ir (
        .a      (a_im),
        .b      (b_re),
        .y      (mul_ir),
        .status (status_mul_ir)
    );

    fp64_sub u_sub_re (
        .a      (mul_rr),
        .b      (mul_ii),
        .y      (y_re),
        .status (status_re)
    );

    fp64_add u_add_im (
        .a      (mul_ri),
        .b      (mul_ir),
        .y      (y_im),
        .status (status_im)
    );

endmodule
