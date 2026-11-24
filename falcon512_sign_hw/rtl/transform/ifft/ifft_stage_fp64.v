`timescale 1ns/1ps
// Migrated from original IFFT RADIX2 stage: DIF butterfly, then FP64 multiply.
// FPC_MUL is replaced by fft_complex_mul (one registered multiply stage).
module ifft_stage_fp64 #(
    parameter FLOAT_PRECISION=64, parameter logn=8, parameter U=1
)(
    input clk, rst_n, in_valid,
    input [FLOAT_PRECISION-1:0] di_re, di_im, s_re, s_im,
    output wire out_valid,
    output wire [logn:0] tw_idx,
    output wire [FLOAT_PRECISION-1:0] do_re, do_im
);
    localparam N = (1 << logn);
    localparam M = (1 << U);
    localparam HT = N / M;
    localparam T = HT << 1;
    localparam CNT_MAX = N + HT + 1;
    localparam I1_WIDTH = (U < 2) ? 1 : U;

    reg state_reg, state;
    reg [logn:0] cnt_reg, cnt;
    reg [FLOAT_PRECISION-1:0] di_re_reg, di_im_reg;
    reg [FLOAT_PRECISION-1:0] mult_di_re_reg, mult_di_im_reg;
    reg i_valid, mult_in_valid;

    wire stall = (cnt_reg < N-1) && !in_valid;
    wire delay_ena = !stall;
    wire delay_mux = (cnt_reg == 0) ? 1'b0 : ((cnt_reg / HT) % 2);
    wire output_mux = (cnt_reg < HT-1) ? 1'b0 : ((cnt_reg / HT) % 2 == 0);
    wire [I1_WIDTH-1:0] i1 = cnt_reg / T - 1;
    wire tw_mask = (state == 1'b1) && (cnt_reg >= T) && ((cnt_reg % T) < HT);
    assign tw_idx = tw_mask ? M+i1 : 0;

    wire [FLOAT_PRECISION-1:0] butterfly_X_re, butterfly_X_im;
    wire [FLOAT_PRECISION-1:0] butterfly_Y_re, butterfly_Y_im;
    wire [FLOAT_PRECISION-1:0] delay_do_re, delay_do_im;
    wire [FLOAT_PRECISION-1:0] delay_di_re, delay_di_im;
    wire [FLOAT_PRECISION-1:0] mult_di_re, mult_di_im;
    wire o_valid;

    fft_butterfly u_butterfly (
        .x_re(delay_do_re), .x_im(delay_do_im),
        .y_re(di_re_reg), .y_im(di_im_reg),
        .X_re(butterfly_X_re), .X_im(butterfly_X_im),
        .Y_re(butterfly_Y_re), .Y_im(butterfly_Y_im), .status()
    );
    assign delay_di_re = delay_mux ? butterfly_Y_re : di_re_reg;
    assign delay_di_im = delay_mux ? butterfly_Y_im : di_im_reg;
    DELAY_BUFFER #(.FLOAT_PRECISION(FLOAT_PRECISION), .DEPTH(HT)) u_delay (
        .clk(clk), .rst_n(rst_n), .ena(delay_ena), .i_valid(i_valid),
        .di_re(delay_di_re), .di_im(delay_di_im),
        .o_valid(o_valid), .do_re(delay_do_re), .do_im(delay_do_im)
    );

    assign mult_di_re = output_mux ? delay_do_re : butterfly_X_re;
    assign mult_di_im = output_mux ? delay_do_im : butterfly_X_im;
    fft_complex_mul u_mul (
        .clk(clk), .rst_n(rst_n), .in_valid(mult_in_valid),
        .a_re(mult_di_re_reg), .a_im(mult_di_im_reg),
        .b_re(s_re), .b_im(s_im),
        .mult_valid(out_valid), .d_re(do_re), .d_im(do_im), .status()
    );

    always @* begin
        state = state_reg;
        if (!state_reg && in_valid) state = 1'b1;
        else if (state_reg && cnt_reg == CNT_MAX) state = 1'b0;
        cnt = 0;
        if (state_reg) begin
            if (cnt_reg >= N-1 || in_valid) cnt = cnt_reg+1'b1;
            else cnt = cnt_reg;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state_reg <= 0; cnt_reg <= 0;
            i_valid <= 0; mult_in_valid <= 0;
            di_re_reg <= 0; di_im_reg <= 0;
            mult_di_re_reg <= 0; mult_di_im_reg <= 0;
        end else begin
            state_reg <= state; cnt_reg <= cnt;
            mult_di_re_reg <= mult_di_re;
            mult_di_im_reg <= mult_di_im;
            if (!stall) begin
                i_valid <= in_valid;
                di_re_reg <= di_re;
                di_im_reg <= di_im;
            end
            mult_in_valid <= o_valid;
        end
    end
endmodule
