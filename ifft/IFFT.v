`timescale 1ns/1ps
// Original IFFT order U=8..1; migrated to ifft_stage_fp64.
module IFFT #(
  parameter FLOAT_PRECISION=64, parameter logn=8,
  // Set 0 to reproduce the previously tested unnormalized IFFT.
  parameter NORMALIZE=1
) (
  input clk, rst_n, in_valid,
  input [FLOAT_PRECISION-1:0] fi_re, fi_im,
  input [FLOAT_PRECISION-1:0] s_re_1, s_im_1,
  input [FLOAT_PRECISION-1:0] s_re_2, s_im_2,
  input [FLOAT_PRECISION-1:0] s_re_3, s_im_3,
  input [FLOAT_PRECISION-1:0] s_re_4, s_im_4,
  input [FLOAT_PRECISION-1:0] s_re_5, s_im_5,
  input [FLOAT_PRECISION-1:0] s_re_6, s_im_6,
  input [FLOAT_PRECISION-1:0] s_re_7, s_im_7,
  input [FLOAT_PRECISION-1:0] s_re_8, s_im_8,
  output reg out_valid,
  output wire [logn:0] tw_idx_1,
  output wire [logn:0] tw_idx_2,
  output wire [logn:0] tw_idx_3,
  output wire [logn:0] tw_idx_4,
  output wire [logn:0] tw_idx_5,
  output wire [logn:0] tw_idx_6,
  output wire [logn:0] tw_idx_7,
  output wire [logn:0] tw_idx_8,
  output reg [FLOAT_PRECISION-1:0] fo_re, fo_im
);
  reg in_valid_reg;
  reg [FLOAT_PRECISION-1:0] fi_re_reg, fi_im_reg;
  reg [FLOAT_PRECISION-1:0] s_re_1_reg, s_im_1_reg;
  reg [FLOAT_PRECISION-1:0] s_re_2_reg, s_im_2_reg;
  reg [FLOAT_PRECISION-1:0] s_re_3_reg, s_im_3_reg;
  reg [FLOAT_PRECISION-1:0] s_re_4_reg, s_im_4_reg;
  reg [FLOAT_PRECISION-1:0] s_re_5_reg, s_im_5_reg;
  reg [FLOAT_PRECISION-1:0] s_re_6_reg, s_im_6_reg;
  reg [FLOAT_PRECISION-1:0] s_re_7_reg, s_im_7_reg;
  reg [FLOAT_PRECISION-1:0] s_re_8_reg, s_im_8_reg;
  wire valid_12;
  wire [FLOAT_PRECISION-1:0] f_re_12, f_im_12;
  wire valid_23;
  wire [FLOAT_PRECISION-1:0] f_re_23, f_im_23;
  wire valid_34;
  wire [FLOAT_PRECISION-1:0] f_re_34, f_im_34;
  wire valid_45;
  wire [FLOAT_PRECISION-1:0] f_re_45, f_im_45;
  wire valid_56;
  wire [FLOAT_PRECISION-1:0] f_re_56, f_im_56;
  wire valid_67;
  wire [FLOAT_PRECISION-1:0] f_re_67, f_im_67;
  wire valid_78;
  wire [FLOAT_PRECISION-1:0] f_re_78, f_im_78;
  wire next_out_valid;
  wire [FLOAT_PRECISION-1:0] next_fo_re, next_fo_im;
  wire [FLOAT_PRECISION-1:0] scaled_fo_re, scaled_fo_im;
  generate if (NORMALIZE != 0) begin: g_normalize
    ifft_normalize_fp64 #(.logn(logn)) u_normalize (
      .in_re(next_fo_re), .in_im(next_fo_im),
      .out_re(scaled_fo_re), .out_im(scaled_fo_im)
    );
  end else begin: g_no_normalize
    assign scaled_fo_re = next_fo_re;
    assign scaled_fo_im = next_fo_im;
  end endgenerate
  ifft_stage_fp64 #(.FLOAT_PRECISION(FLOAT_PRECISION), .logn(logn), .U(8)) u_stage_1 (
    .clk(clk), .rst_n(rst_n), .in_valid(in_valid_reg),
    .di_re(fi_re_reg), .di_im(fi_im_reg),
    .s_re(s_re_1_reg), .s_im(s_im_1_reg),
    .tw_idx(tw_idx_1), .out_valid(valid_12),
    .do_re(f_re_12), .do_im(f_im_12)
  );
  ifft_stage_fp64 #(.FLOAT_PRECISION(FLOAT_PRECISION), .logn(logn), .U(7)) u_stage_2 (
    .clk(clk), .rst_n(rst_n), .in_valid(valid_12),
    .di_re(f_re_12), .di_im(f_im_12),
    .s_re(s_re_2_reg), .s_im(s_im_2_reg),
    .tw_idx(tw_idx_2), .out_valid(valid_23),
    .do_re(f_re_23), .do_im(f_im_23)
  );
  ifft_stage_fp64 #(.FLOAT_PRECISION(FLOAT_PRECISION), .logn(logn), .U(6)) u_stage_3 (
    .clk(clk), .rst_n(rst_n), .in_valid(valid_23),
    .di_re(f_re_23), .di_im(f_im_23),
    .s_re(s_re_3_reg), .s_im(s_im_3_reg),
    .tw_idx(tw_idx_3), .out_valid(valid_34),
    .do_re(f_re_34), .do_im(f_im_34)
  );
  ifft_stage_fp64 #(.FLOAT_PRECISION(FLOAT_PRECISION), .logn(logn), .U(5)) u_stage_4 (
    .clk(clk), .rst_n(rst_n), .in_valid(valid_34),
    .di_re(f_re_34), .di_im(f_im_34),
    .s_re(s_re_4_reg), .s_im(s_im_4_reg),
    .tw_idx(tw_idx_4), .out_valid(valid_45),
    .do_re(f_re_45), .do_im(f_im_45)
  );
  ifft_stage_fp64 #(.FLOAT_PRECISION(FLOAT_PRECISION), .logn(logn), .U(4)) u_stage_5 (
    .clk(clk), .rst_n(rst_n), .in_valid(valid_45),
    .di_re(f_re_45), .di_im(f_im_45),
    .s_re(s_re_5_reg), .s_im(s_im_5_reg),
    .tw_idx(tw_idx_5), .out_valid(valid_56),
    .do_re(f_re_56), .do_im(f_im_56)
  );
  ifft_stage_fp64 #(.FLOAT_PRECISION(FLOAT_PRECISION), .logn(logn), .U(3)) u_stage_6 (
    .clk(clk), .rst_n(rst_n), .in_valid(valid_56),
    .di_re(f_re_56), .di_im(f_im_56),
    .s_re(s_re_6_reg), .s_im(s_im_6_reg),
    .tw_idx(tw_idx_6), .out_valid(valid_67),
    .do_re(f_re_67), .do_im(f_im_67)
  );
  ifft_stage_fp64 #(.FLOAT_PRECISION(FLOAT_PRECISION), .logn(logn), .U(2)) u_stage_7 (
    .clk(clk), .rst_n(rst_n), .in_valid(valid_67),
    .di_re(f_re_67), .di_im(f_im_67),
    .s_re(s_re_7_reg), .s_im(s_im_7_reg),
    .tw_idx(tw_idx_7), .out_valid(valid_78),
    .do_re(f_re_78), .do_im(f_im_78)
  );
  ifft_stage_fp64 #(.FLOAT_PRECISION(FLOAT_PRECISION), .logn(logn), .U(1)) u_stage_8 (
    .clk(clk), .rst_n(rst_n), .in_valid(valid_78),
    .di_re(f_re_78), .di_im(f_im_78),
    .s_re(s_re_8_reg), .s_im(s_im_8_reg),
    .tw_idx(tw_idx_8), .out_valid(next_out_valid),
    .do_re(next_fo_re), .do_im(next_fo_im)
  );
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      in_valid_reg <= 0; fi_re_reg <= 0; fi_im_reg <= 0;
      out_valid <= 0; fo_re <= 0; fo_im <= 0;
      s_re_1_reg <= 0; s_im_1_reg <= 0;
      s_re_2_reg <= 0; s_im_2_reg <= 0;
      s_re_3_reg <= 0; s_im_3_reg <= 0;
      s_re_4_reg <= 0; s_im_4_reg <= 0;
      s_re_5_reg <= 0; s_im_5_reg <= 0;
      s_re_6_reg <= 0; s_im_6_reg <= 0;
      s_re_7_reg <= 0; s_im_7_reg <= 0;
      s_re_8_reg <= 0; s_im_8_reg <= 0;
    end else begin
      in_valid_reg <= in_valid; fi_re_reg <= fi_re; fi_im_reg <= fi_im;
      out_valid <= next_out_valid;
      fo_re <= scaled_fo_re; fo_im <= scaled_fo_im;
      s_re_1_reg <= s_re_1;
      s_im_1_reg <= s_im_1 ^ 64'h8000000000000000;
      s_re_2_reg <= s_re_2;
      s_im_2_reg <= s_im_2 ^ 64'h8000000000000000;
      s_re_3_reg <= s_re_3;
      s_im_3_reg <= s_im_3 ^ 64'h8000000000000000;
      s_re_4_reg <= s_re_4;
      s_im_4_reg <= s_im_4 ^ 64'h8000000000000000;
      s_re_5_reg <= s_re_5;
      s_im_5_reg <= s_im_5 ^ 64'h8000000000000000;
      s_re_6_reg <= s_re_6;
      s_im_6_reg <= s_im_6 ^ 64'h8000000000000000;
      s_re_7_reg <= s_re_7;
      s_im_7_reg <= s_im_7 ^ 64'h8000000000000000;
      s_re_8_reg <= s_re_8;
      s_im_8_reg <= s_im_8 ^ 64'h8000000000000000;
    end
  end
endmodule
