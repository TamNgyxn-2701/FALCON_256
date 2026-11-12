`timescale 1ns/1ps

module tb_bfu_cluster4;

    parameter NUM_CASES = 32;

    reg mode;

    reg [255:0] x_re;
    reg [255:0] x_im;

    reg [255:0] y_re;
    reg [255:0] y_im;

    reg [255:0] w_re;
    reg [255:0] w_im;

    wire [255:0] out0_re;
    wire [255:0] out0_im;

    wire [255:0] out1_re;
    wire [255:0] out1_im;


    // ============================================================
    // FFT GOLDEN
    // ============================================================

    reg [63:0] fft_x_re [0:NUM_CASES-1];
    reg [63:0] fft_x_im [0:NUM_CASES-1];

    reg [63:0] fft_y_re [0:NUM_CASES-1];
    reg [63:0] fft_y_im [0:NUM_CASES-1];

    reg [63:0] fft_w_re [0:NUM_CASES-1];
    reg [63:0] fft_w_im [0:NUM_CASES-1];

    reg [63:0] fft_o0_re [0:NUM_CASES-1];
    reg [63:0] fft_o0_im [0:NUM_CASES-1];

    reg [63:0] fft_o1_re [0:NUM_CASES-1];
    reg [63:0] fft_o1_im [0:NUM_CASES-1];


    // ============================================================
    // IFFT GOLDEN
    // ============================================================

    reg [63:0] ifft_x_re [0:NUM_CASES-1];
    reg [63:0] ifft_x_im [0:NUM_CASES-1];

    reg [63:0] ifft_y_re [0:NUM_CASES-1];
    reg [63:0] ifft_y_im [0:NUM_CASES-1];

    reg [63:0] ifft_w_re [0:NUM_CASES-1];
    reg [63:0] ifft_w_im [0:NUM_CASES-1];

    reg [63:0] ifft_o0_re [0:NUM_CASES-1];
    reg [63:0] ifft_o0_im [0:NUM_CASES-1];

    reg [63:0] ifft_o1_re [0:NUM_CASES-1];
    reg [63:0] ifft_o1_im [0:NUM_CASES-1];


    integer batch;
    integer base;

    integer fft_pass;
    integer fft_fail;

    integer ifft_pass;
    integer ifft_fail;


    // ============================================================
    // DUT
    // ============================================================

    bfu_cluster4 dut (
        .mode    (mode),

        .x_re    (x_re),
        .x_im    (x_im),

        .y_re    (y_re),
        .y_im    (y_im),

        .w_re    (w_re),
        .w_im    (w_im),

        .out0_re (out0_re),
        .out0_im (out0_im),

        .out1_re (out1_re),
        .out1_im (out1_im)
    );


    // ============================================================
    // CHECK ONE BFU LANE
    // ============================================================

    task check_lane;

        input integer index;

        input [63:0] rtl_o0_re;
        input [63:0] rtl_o0_im;
        input [63:0] rtl_o1_re;
        input [63:0] rtl_o1_im;

        input [63:0] exp_o0_re;
        input [63:0] exp_o0_im;
        input [63:0] exp_o1_re;
        input [63:0] exp_o1_im;

        begin

            if ((rtl_o0_re === exp_o0_re) &&
                (rtl_o0_im === exp_o0_im) &&
                (rtl_o1_re === exp_o1_re) &&
                (rtl_o1_im === exp_o1_im)) begin

                if (mode == 1'b0) begin
                    fft_pass = fft_pass + 1;
                end
                else begin
                    ifft_pass = ifft_pass + 1;
                end

            end
            else begin

                if (mode == 1'b0) begin
                    fft_fail = fft_fail + 1;
                end
                else begin
                    ifft_fail = ifft_fail + 1;
                end

                $display("");
                $display("========================================");
                $display(
                    "[FAIL] mode=%0d case=%0d",
                    mode,
                    index
                );

                $display(
                    "O0_RE rtl=%016h golden=%016h",
                    rtl_o0_re,
                    exp_o0_re
                );

                $display(
                    "O0_IM rtl=%016h golden=%016h",
                    rtl_o0_im,
                    exp_o0_im
                );

                $display(
                    "O1_RE rtl=%016h golden=%016h",
                    rtl_o1_re,
                    exp_o1_re
                );

                $display(
                    "O1_IM rtl=%016h golden=%016h",
                    rtl_o1_im,
                    exp_o1_im
                );

                $display("========================================");

            end
        end

    endtask


    // ============================================================
    // MAIN TEST
    // ============================================================

    initial begin

        // ========================================================
        // LOAD FFT GOLDEN
        // ========================================================

        $readmemh(
            "golden/unit/bfu/directed/fft/x_re.memh",
            fft_x_re
        );

        $readmemh(
            "golden/unit/bfu/directed/fft/x_im.memh",
            fft_x_im
        );

        $readmemh(
            "golden/unit/bfu/directed/fft/y_re.memh",
            fft_y_re
        );

        $readmemh(
            "golden/unit/bfu/directed/fft/y_im.memh",
            fft_y_im
        );

        $readmemh(
            "golden/unit/bfu/directed/fft/w_re.memh",
            fft_w_re
        );

        $readmemh(
            "golden/unit/bfu/directed/fft/w_im.memh",
            fft_w_im
        );

        $readmemh(
            "golden/unit/bfu/directed/fft/out0_re.memh",
            fft_o0_re
        );

        $readmemh(
            "golden/unit/bfu/directed/fft/out0_im.memh",
            fft_o0_im
        );

        $readmemh(
            "golden/unit/bfu/directed/fft/out1_re.memh",
            fft_o1_re
        );

        $readmemh(
            "golden/unit/bfu/directed/fft/out1_im.memh",
            fft_o1_im
        );


        // ========================================================
        // LOAD IFFT GOLDEN
        // ========================================================

        $readmemh(
            "golden/unit/bfu/directed/ifft/x_re.memh",
            ifft_x_re
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/x_im.memh",
            ifft_x_im
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/y_re.memh",
            ifft_y_re
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/y_im.memh",
            ifft_y_im
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/w_re.memh",
            ifft_w_re
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/w_im.memh",
            ifft_w_im
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/out0_re.memh",
            ifft_o0_re
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/out0_im.memh",
            ifft_o0_im
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/out1_re.memh",
            ifft_o1_re
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/out1_im.memh",
            ifft_o1_im
        );


        // ========================================================
        // INITIALIZE
        // ========================================================

        fft_pass  = 0;
        fft_fail  = 0;

        ifft_pass = 0;
        ifft_fail = 0;

        mode = 1'b0;

        x_re = 256'd0;
        x_im = 256'd0;

        y_re = 256'd0;
        y_im = 256'd0;

        w_re = 256'd0;
        w_im = 256'd0;

        #10;


        // ========================================================
        // FFT TEST
        //
        // 32 cases / 4 BFUs = 8 batches
        // ========================================================

        $display("");
        $display("========================================");
        $display("START 4-BFU FFT TEST");
        $display("========================================");

        mode = 1'b0;

        for (batch = 0; batch < 8; batch = batch + 1) begin

            base = batch * 4;

            // lane 3,2,1,0 packed from MSB -> LSB

            x_re = {
                fft_x_re[base+3],
                fft_x_re[base+2],
                fft_x_re[base+1],
                fft_x_re[base+0]
            };

            x_im = {
                fft_x_im[base+3],
                fft_x_im[base+2],
                fft_x_im[base+1],
                fft_x_im[base+0]
            };

            y_re = {
                fft_y_re[base+3],
                fft_y_re[base+2],
                fft_y_re[base+1],
                fft_y_re[base+0]
            };

            y_im = {
                fft_y_im[base+3],
                fft_y_im[base+2],
                fft_y_im[base+1],
                fft_y_im[base+0]
            };

            w_re = {
                fft_w_re[base+3],
                fft_w_re[base+2],
                fft_w_re[base+1],
                fft_w_re[base+0]
            };

            w_im = {
                fft_w_im[base+3],
                fft_w_im[base+2],
                fft_w_im[base+1],
                fft_w_im[base+0]
            };

            #10;


            // lane 0
            check_lane(
                base+0,

                out0_re[63:0],
                out0_im[63:0],

                out1_re[63:0],
                out1_im[63:0],

                fft_o0_re[base+0],
                fft_o0_im[base+0],

                fft_o1_re[base+0],
                fft_o1_im[base+0]
            );


            // lane 1
            check_lane(
                base+1,

                out0_re[127:64],
                out0_im[127:64],

                out1_re[127:64],
                out1_im[127:64],

                fft_o0_re[base+1],
                fft_o0_im[base+1],

                fft_o1_re[base+1],
                fft_o1_im[base+1]
            );


            // lane 2
            check_lane(
                base+2,

                out0_re[191:128],
                out0_im[191:128],

                out1_re[191:128],
                out1_im[191:128],

                fft_o0_re[base+2],
                fft_o0_im[base+2],

                fft_o1_re[base+2],
                fft_o1_im[base+2]
            );


            // lane 3
            check_lane(
                base+3,

                out0_re[255:192],
                out0_im[255:192],

                out1_re[255:192],
                out1_im[255:192],

                fft_o0_re[base+3],
                fft_o0_im[base+3],

                fft_o1_re[base+3],
                fft_o1_im[base+3]
            );

        end


        // ========================================================
        // IFFT TEST
        // ========================================================

        $display("");
        $display("========================================");
        $display("START 4-BFU IFFT TEST");
        $display("========================================");

        mode = 1'b1;

        for (batch = 0; batch < 8; batch = batch + 1) begin

            base = batch * 4;


            x_re = {
                ifft_x_re[base+3],
                ifft_x_re[base+2],
                ifft_x_re[base+1],
                ifft_x_re[base+0]
            };

            x_im = {
                ifft_x_im[base+3],
                ifft_x_im[base+2],
                ifft_x_im[base+1],
                ifft_x_im[base+0]
            };

            y_re = {
                ifft_y_re[base+3],
                ifft_y_re[base+2],
                ifft_y_re[base+1],
                ifft_y_re[base+0]
            };

            y_im = {
                ifft_y_im[base+3],
                ifft_y_im[base+2],
                ifft_y_im[base+1],
                ifft_y_im[base+0]
            };

            w_re = {
                ifft_w_re[base+3],
                ifft_w_re[base+2],
                ifft_w_re[base+1],
                ifft_w_re[base+0]
            };

            w_im = {
                ifft_w_im[base+3],
                ifft_w_im[base+2],
                ifft_w_im[base+1],
                ifft_w_im[base+0]
            };

            #10;


            // lane 0
            check_lane(
                base+0,

                out0_re[63:0],
                out0_im[63:0],

                out1_re[63:0],
                out1_im[63:0],

                ifft_o0_re[base+0],
                ifft_o0_im[base+0],

                ifft_o1_re[base+0],
                ifft_o1_im[base+0]
            );


            // lane 1
            check_lane(
                base+1,

                out0_re[127:64],
                out0_im[127:64],

                out1_re[127:64],
                out1_im[127:64],

                ifft_o0_re[base+1],
                ifft_o0_im[base+1],

                ifft_o1_re[base+1],
                ifft_o1_im[base+1]
            );


            // lane 2
            check_lane(
                base+2,

                out0_re[191:128],
                out0_im[191:128],

                out1_re[191:128],
                out1_im[191:128],

                ifft_o0_re[base+2],
                ifft_o0_im[base+2],

                ifft_o1_re[base+2],
                ifft_o1_im[base+2]
            );


            // lane 3
            check_lane(
                base+3,

                out0_re[255:192],
                out0_im[255:192],

                out1_re[255:192],
                out1_im[255:192],

                ifft_o0_re[base+3],
                ifft_o0_im[base+3],

                ifft_o1_re[base+3],
                ifft_o1_im[base+3]
            );

        end


        // ========================================================
        // FINAL RESULT
        // ========================================================

        $display("");
        $display("========================================");
        $display("4-BFU CLUSTER TEST");

        $display(
            "FFT  PASS = %0d / 32",
            fft_pass
        );

        $display(
            "FFT  FAIL = %0d",
            fft_fail
        );

        $display(
            "IFFT PASS = %0d / 32",
            ifft_pass
        );

        $display(
            "IFFT FAIL = %0d",
            ifft_fail
        );

        $display("========================================");

        if ((fft_fail  == 0) &&
            (ifft_fail == 0) &&
            (fft_pass  == 32) &&
            (ifft_pass == 32)) begin

            $display("4-BFU CLUSTER : PASS");

        end
        else begin

            $display("4-BFU CLUSTER : FAIL");

        end

        $finish;

    end

endmodule
