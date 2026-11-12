`timescale 1ns/1ps

module tb_bfu_fft_trace;

    parameter NUM_CASES = 9216;

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
    integer fail_printed;

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
            "golden/unit/bfu/trace/fft/x_re.memh",
            mem_x_re
        );

        $readmemh(
            "golden/unit/bfu/trace/fft/x_im.memh",
            mem_x_im
        );

        $readmemh(
            "golden/unit/bfu/trace/fft/y_re.memh",
            mem_y_re
        );

        $readmemh(
            "golden/unit/bfu/trace/fft/y_im.memh",
            mem_y_im
        );

        $readmemh(
            "golden/unit/bfu/trace/fft/w_re.memh",
            mem_w_re
        );

        $readmemh(
            "golden/unit/bfu/trace/fft/w_im.memh",
            mem_w_im
        );

        $readmemh(
            "golden/unit/bfu/trace/fft/out0_re.memh",
            exp_out0_re
        );

        $readmemh(
            "golden/unit/bfu/trace/fft/out0_im.memh",
            exp_out0_im
        );

        $readmemh(
            "golden/unit/bfu/trace/fft/out1_re.memh",
            exp_out1_re
        );

        $readmemh(
            "golden/unit/bfu/trace/fft/out1_im.memh",
            exp_out1_im
        );

        /*
         * FFT mode:
         *
         * T  = Y * W
         * O0 = X + T
         * O1 = X - T
         */
        mode = 1'b0;

        x_re = 64'd0;
        x_im = 64'd0;
        y_re = 64'd0;
        y_im = 64'd0;
        w_re = 64'd0;
        w_im = 64'd0;

        pass_count   = 0;
        fail_count   = 0;
        fail_printed = 0;

        #10;

        for (i = 0; i < NUM_CASES; i = i + 1) begin

            x_re = mem_x_re[i];
            x_im = mem_x_im[i];

            y_re = mem_y_re[i];
            y_im = mem_y_im[i];

            w_re = mem_w_re[i];
            w_im = mem_w_im[i];

            #1;

            if ((out0_re === exp_out0_re[i]) &&
                (out0_im === exp_out0_im[i]) &&
                (out1_re === exp_out1_re[i]) &&
                (out1_im === exp_out1_im[i])) begin

                pass_count = pass_count + 1;

            end
            else begin

                fail_count = fail_count + 1;

                if (fail_printed < 20) begin

                    $display("");
                    $display("========================================");
                    $display("[FAIL] case=%0d", i);

                    $display(
                        "X   = %016h + j%016h",
                        x_re, x_im
                    );

                    $display(
                        "Y   = %016h + j%016h",
                        y_re, y_im
                    );

                    $display(
                        "W   = %016h + j%016h",
                        w_re, w_im
                    );

                    $display(
                        "O0_RE rtl=%016h golden=%016h",
                        out0_re, exp_out0_re[i]
                    );

                    $display(
                        "O0_IM rtl=%016h golden=%016h",
                        out0_im, exp_out0_im[i]
                    );

                    $display(
                        "O1_RE rtl=%016h golden=%016h",
                        out1_re, exp_out1_re[i]
                    );

                    $display(
                        "O1_IM rtl=%016h golden=%016h",
                        out1_im, exp_out1_im[i]
                    );

                    $display("========================================");

                    fail_printed = fail_printed + 1;
                end
            end

            if ((i % 1000) == 0) begin
                $display(
                    "[PROGRESS] case=%0d pass=%0d fail=%0d",
                    i, pass_count, fail_count
                );
            end
        end

        $display("");
        $display("========================================");
        $display("BFU FFT TRACE TEST");
        $display("TOTAL = %0d", NUM_CASES);
        $display("PASS  = %0d", pass_count);
        $display("FAIL  = %0d", fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("BFU FFT TRACE : PASS");
        else
            $display("BFU FFT TRACE : FAIL");

        $finish;
    end

endmodule
