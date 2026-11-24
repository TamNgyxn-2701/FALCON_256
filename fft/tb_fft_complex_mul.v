`timescale 1ns/1ps
module tb_fft_complex_mul;
    reg clk = 1'b0;
    always #5 clk = ~clk;
    reg rst_n=1'b0, in_valid=1'b0;
    reg [63:0] a_re, a_im, b_re, b_im;
    wire [63:0] d_re, d_im;
    wire mult_valid;
    wire [7:0] status;
    fft_complex_mul dut (
        .clk(clk), .rst_n(rst_n), .in_valid(in_valid),
        .a_re(a_re), .a_im(a_im), .b_re(b_re), .b_im(b_im),
        .mult_valid(mult_valid), .d_re(d_re), .d_im(d_im), .status(status)
    );
    initial begin
        // (1+2i)*(3+4i)=(-5+10i)
        a_re=64'h3ff0000000000000; a_im=64'h4000000000000000;
        b_re=64'h4008000000000000; b_im=64'h4010000000000000;
        repeat (2) @(negedge clk);
        rst_n=1'b1;
        in_valid=1'b1;
        @(posedge clk); #1;
        if(mult_valid!==1'b1 || d_re!==64'hc014000000000000 ||
           d_im!==64'h4024000000000000) begin
            $display("FAIL: valid=%b re=%h im=%h",mult_valid,d_re,d_im);
            $fatal(1);
        end
        @(negedge clk); in_valid=1'b0;
        @(posedge clk); #1;
        if(mult_valid!==1'b0) $fatal(1,"FAIL: valid deassert");
        $display("PASS: fft_complex_mul simple exact test");
        $finish;
    end
endmodule
