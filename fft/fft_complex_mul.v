`timescale 1ns/1ps
// Complex FP64 multiplication with the same one-cycle product register
// placement as the original FPC_MUL. Computation (a_re+j*a_im)*(b_re+j*b_im).
// DW_fp_mult/ DW_fp_add are combinational in the supplied FP64 wrappers.
module fft_complex_mul (
    input wire clk,
    input wire rst_n,
    input wire in_valid,
    input wire [63:0] a_re, a_im,
    input wire [63:0] b_re, b_im,
    output reg mult_valid,
    output wire [63:0] d_re, d_im,
    output wire [7:0] status
);
    wire [63:0] pp_rr, pp_ii, pp_ri, pp_ir;
    reg  [63:0] rr_q, ii_q, ri_q, ir_q;
    wire [63:0] neg_ii;
    wire [7:0] st_rr, st_ii, st_ri, st_ir, st_re, st_im;
    reg [7:0] mul_status_q;

    fp64_mul mul_rr (.a(a_re), .b(b_re), .y(pp_rr), .status(st_rr));
    fp64_mul mul_ii (.a(a_im), .b(b_im), .y(pp_ii), .status(st_ii));
    fp64_mul mul_ri (.a(a_re), .b(b_im), .y(pp_ri), .status(st_ri));
    fp64_mul mul_ir (.a(a_im), .b(b_re), .y(pp_ir), .status(st_ir));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rr_q <= 64'b0;
            ii_q <= 64'b0;
            ri_q <= 64'b0;
            ir_q <= 64'b0;
            mul_status_q <= 8'b0;
            mult_valid <= 1'b0;
        end else begin
            // Unconditional data update matches legacy FPC_MUL.
            rr_q <= pp_rr;
            ii_q <= pp_ii;
            ri_q <= pp_ri;
            ir_q <= pp_ir;
            mul_status_q <= st_rr | st_ii | st_ri | st_ir;
            mult_valid <= in_valid;
        end
    end
    fp64_neg negate_ii (.a(ii_q), .y(neg_ii));
    fp64_add add_re (.a(rr_q), .b(neg_ii), .y(d_re), .status(st_re));
    fp64_add add_im (.a(ri_q), .b(ir_q), .y(d_im), .status(st_im));
    assign status = mul_status_q | st_re | st_im;
endmodule
