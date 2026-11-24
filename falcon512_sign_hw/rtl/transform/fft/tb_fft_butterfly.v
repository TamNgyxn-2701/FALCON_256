`timescale 1ns/1ps
module tb_fft_butterfly;
    reg [63:0] x_re,x_im,y_re,y_im;
    wire [63:0] X_re,X_im,Y_re,Y_im;
    wire [7:0] status;
    integer errors;

    fft_butterfly dut (.x_re(x_re),.x_im(x_im),.y_re(y_re),.y_im(y_im),
                       .X_re(X_re),.X_im(X_im),.Y_re(Y_re),.Y_im(Y_im),.status(status));
    initial begin
        errors=0;
        // x = 3 + 4i; y = 1 + 2i
        x_re=64'h4008000000000000; x_im=64'h4010000000000000;
        y_re=64'h3ff0000000000000; y_im=64'h4000000000000000;
        #10;
        if (X_re !== 64'h4010000000000000 || // 4
            X_im !== 64'h4018000000000000 || // 6
            Y_re !== 64'h4000000000000000 || // 2
            Y_im !== 64'h4000000000000000) begin // 2
            $display("FAIL fft_butterfly X=(%h,%h) Y=(%h,%h)", X_re,X_im,Y_re,Y_im);
            errors=errors+1;
        end
        if(errors==0) $display("PASS fft_butterfly basic arithmetic");
        $finish;
    end
endmodule
