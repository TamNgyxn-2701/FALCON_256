// FALCONver2 complex add/sub butterfly.
// Replaces legacy FPC_ADD/FPC_SUB with the new fp64_add + fp64_neg.
// This module does NOT multiply by twiddle; the FFT stage must do that.
// Combinational, as is the existing fp64_add based on DW_fp_add.
module fft_butterfly (
    input  wire [63:0] x_re,
    input  wire [63:0] x_im,
    input  wire [63:0] y_re,
    input  wire [63:0] y_im,
    output wire [63:0] X_re,
    output wire [63:0] X_im,
    output wire [63:0] Y_re,
    output wire [63:0] Y_im,
    output wire [7:0]  status
);
    wire [63:0] neg_y_re, neg_y_im;
    wire [7:0] st_add_re, st_add_im, st_sub_re, st_sub_im;

    fp64_neg u_neg_re (.a(y_re), .y(neg_y_re));
    fp64_neg u_neg_im (.a(y_im), .y(neg_y_im));

    fp64_add u_add_re (.a(x_re), .b(y_re), .y(X_re), .status(st_add_re));
    fp64_add u_add_im (.a(x_im), .b(y_im), .y(X_im), .status(st_add_im));
    fp64_add u_sub_re (.a(x_re), .b(neg_y_re), .y(Y_re), .status(st_sub_re));
    fp64_add u_sub_im (.a(x_im), .b(neg_y_im), .y(Y_im), .status(st_sub_im));

    assign status = st_add_re | st_add_im | st_sub_re | st_sub_im;
endmodule
