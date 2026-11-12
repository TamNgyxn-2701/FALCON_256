`timescale 1ns/1ps

module tb_bfu_ifft;

    parameter NUM_CASES = 32;

    reg mode;

    reg [63:0] x_re;
    reg [63:0] x_im;
    reg [63:0] y_re;
    reg [63:0] y_im;
    reg [63:0] w_re;
    reg [63:0] w_im;

    wire [63:0] out0_re;
    wire [63:0] out0_im;
    wire [63:0] out1_re;
    wire [63:0] out1_im;

    reg [63:0] mem_x_re    [0:NUM_CASES-1];
    reg [63:0] mem_x_im    [0:NUM_CASES-1];
    reg [63:0] mem_y_re    [0:NUM_CASES-1];
    reg [63:0] mem_y_im    [0:NUM_CASES-1];
    reg [63:0] mem_w_re    [0:NUM_CASES-1];
    reg [63:0] mem_w_im    [0:NUM_CASES-1];

    reg [63:0] exp_out0_re [0:NUM_CASES-1];
    reg [63:0] exp_out0_im [0:NUM_CASES-1];
    reg [63:0] exp_out1_re [0:NUM_CASES-1];
    reg [63:0] exp_out1_im [0:NUM_CASES-1];

    integer i;
    integer pass_count;
    integer fail_count;

    bfu dut (
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

    initial begin

        $readmemh(
            "golden/unit/bfu/directed/ifft/x_re.memh",
            mem_x_re
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/x_im.memh",
            mem_x_im
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/y_re.memh",
            mem_y_re
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/y_im.memh",
            mem_y_im
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/w_re.memh",
            mem_w_re
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/w_im.memh",
            mem_w_im
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/out0_re.memh",
            exp_out0_re
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/out0_im.memh",
            exp_out0_im
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/out1_re.memh",
            exp_out1_re
        );

        $readmemh(
            "golden/unit/bfu/directed/ifft/out1_im.memh",
            exp_out1_im
        );

        /*
         * mode = 1 -> IFFT
         *
         * O0 = X + Y
         * D  = X - Y
         * O1 = D * W
         */
        mode = 1'b1;

        x_re = 64'd0;
        x_im = 64'd0;
        y_re = 64'd0;
        y_im = 64'd0;
        w_re = 64'd0;
        w_im = 64'd0;

        pass_count = 0;
        fail_count = 0;

        #10;

        for (i = 0; i < NUM_CASES; i = i + 1) begin

            x_re = mem_x_re[i];
            x_im = mem_x_im[i];

            y_re = mem_y_re[i];
            y_im = mem_y_im[i];

            w_re = mem_w_re[i];
            w_im = mem_w_im[i];

            #10;

            if ((out0_re === exp_out0_re[i]) &&
                (out0_im === exp_out0_im[i]) &&
                (out1_re === exp_out1_re[i]) &&
                (out1_im === exp_out1_im[i])) begin

                pass_count = pass_count + 1;

                $display(
                    "[PASS] case=%0d",
                    i
                );

            end
            else begin

                fail_count = fail_count + 1;

                $display("");
                $display("========================================");
                $display("[FAIL] case=%0d", i);

                $display(
                    "OUT0_RE rtl=%016h golden=%016h",
                    out0_re,
                    exp_out0_re[i]
                );

                $display(
                    "OUT0_IM rtl=%016h golden=%016h",
                    out0_im,
                    exp_out0_im[i]
                );

                $display(
                    "OUT1_RE rtl=%016h golden=%016h",
                    out1_re,
                    exp_out1_re[i]
                );

                $display(
                    "OUT1_IM rtl=%016h golden=%016h",
                    out1_im,
                    exp_out1_im[i]
                );

                $display("========================================");
            end
        end

        $display("");
        $display("========================================");
        $display("BFU IFFT DIRECTED TEST");
        $display("TOTAL = %0d", NUM_CASES);
        $display("PASS  = %0d", pass_count);
        $display("FAIL  = %0d", fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("BFU IFFT DIRECTED : PASS");
        else
            $display("BFU IFFT DIRECTED : FAIL");

        $finish;
    end

endmodule
