`timescale 1ns/1ps

module tb_merge;

    reg small_n_mode;

    reg [63:0] f0_re, f0_im;
    reg [63:0] f1_re, f1_im;
    reg [63:0] gm_re, gm_im;

    wire [63:0] out0_re, out0_im;
    wire [63:0] out1_re, out1_im;

    // Golden Directed vectors
    reg [63:0] in0_mem     [0:255];
    reg [63:0] in1_mem     [0:255];
    reg [63:0] expected_mem [0:511];

    // GM coefficients
    reg [63:0] gm_table [0:2047];

    integer logn, n, hn, qn;
    integer case_id, u, gm_idx;
    integer i, fd, rc;
    integer total, fail;

    real gm_value;

    reg [1023:0] filename;

    // Device Under Test
    merge dut (
        .small_n_mode (small_n_mode),

        .f0_re        (f0_re),
        .f0_im        (f0_im),

        .f1_re        (f1_re),
        .f1_im        (f1_im),

        .gm_re        (gm_re),
        .gm_im        (gm_im),

        .out0_re      (out0_re),
        .out0_im      (out0_im),

        .out1_re      (out1_re),
        .out1_im      (out1_im)
    );

    // Compare one FP64 value bit-by-bit
    task check_word;
        input [63:0] actual;
        input [63:0] expected;
        input integer ln;
        input integer index;

        begin
            total = total + 1;

            if (actual !== expected) begin
                fail = fail + 1;

                $display(
                    "[FAIL] logn=%0d index=%0d expected=%h actual=%h",
                    ln, index, expected, actual
                );
            end
        end
    endtask

    initial begin

        total = 0;
        fail  = 0;

        small_n_mode = 0;

        f0_re = 0;
        f0_im = 0;
        f1_re = 0;
        f1_im = 0;

        gm_re = 0;
        gm_im = 0;

        /*
         * Load GM coefficients
         */

        fd = $fopen(
            "vectors/split_merge/gm_decimal.txt", "r"
        );

        if (fd == 0) begin
            $display("[ERROR] Cannot open GM file");
            $finish;
        end

        for (i = 0; i < 2048; i = i + 1) begin

            rc = $fscanf(fd, "%f", gm_value);

            if (rc != 1) begin
                $display("[ERROR] Invalid GM entry %0d", i);
                $finish;
            end

            gm_table[i] = $realtobits(gm_value);
        end

        $fclose(fd);

        /*
         * Run 9 Golden Directed cases
         */

        for (logn = 1; logn <= 9; logn = logn + 1) begin

            case_id = logn - 1;

            n  = 1 << logn;
            hn = n >> 1;
            qn = hn >> 1;

            // Load input f0
            $sformat(
                filename,
                "golden/unit/split_merge/directed/merge/case_%03d/in0.memh",
                case_id
            );

            $readmemh(filename, in0_mem);

            // Load input f1
            $sformat(
                filename,
                "golden/unit/split_merge/directed/merge/case_%03d/in1.memh",
                case_id
            );

            $readmemh(filename, in1_mem);

            // Load expected output
            $sformat(
                filename,
                "golden/unit/split_merge/directed/merge/case_%03d/expected.memh",
                case_id
            );

            $readmemh(filename, expected_mem);

            /*
             * Special case: logn = 1
             */

            if (logn == 1) begin

                small_n_mode = 1;

                f0_re = in0_mem[0];
                f1_re = in1_mem[0];

                f0_im = 0;
                f1_im = 0;

                #10;

                check_word(
                    out0_re, expected_mem[0], logn, 0
                );

                check_word(
                    out1_re, expected_mem[hn], logn, hn
                );

            end else begin

                /*
                 * Normal Merge
                 */

                small_n_mode = 0;

                for (u = 0; u < qn; u = u + 1) begin

                    // Complex f0
                    f0_re = in0_mem[u];
                    f0_im = in0_mem[u + qn];

                    // Complex f1
                    f1_re = in1_mem[u];
                    f1_im = in1_mem[u + qn];

                    // GM coefficient
                    gm_idx = 2 * (u + hn);

                    gm_re = gm_table[gm_idx];
                    gm_im = gm_table[gm_idx + 1];

                    #10;

                    // First complex output
                    check_word(
                        out0_re,
                        expected_mem[2*u],
                        logn, 2*u
                    );

                    check_word(
                        out0_im,
                        expected_mem[2*u + hn],
                        logn, 2*u + hn
                    );

                    // Second complex output
                    check_word(
                        out1_re,
                        expected_mem[2*u + 1],
                        logn, 2*u + 1
                    );

                    check_word(
                        out1_im,
                        expected_mem[2*u + 1 + hn],
                        logn, 2*u + 1 + hn
                    );
                end
            end

            $display("[DONE] logn=%0d", logn);
        end

        /*
         * Final report
         */

        $display("================================");
        $display("MERGE DIRECTED TEST");
        $display("TOTAL = %0d", total);
        $display("PASS  = %0d", total - fail);
        $display("FAIL  = %0d", fail);
        $display("================================");

        if (fail == 0)
            $display("MERGE DIRECTED : PASS");
        else
            $display("MERGE DIRECTED : FAIL");

        $finish;
    end

endmodule
