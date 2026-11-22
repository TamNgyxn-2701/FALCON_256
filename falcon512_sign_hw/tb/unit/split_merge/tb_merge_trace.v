`timescale 1ns/1ps

module tb_merge_trace;

    reg small_n_mode;

    reg [63:0] f0_re, f0_im;
    reg [63:0] f1_re, f1_im;
    reg [63:0] gm_re, gm_im;

    wire [63:0] out0_re, out0_im;
    wire [63:0] out1_re, out1_im;

    // Golden Trace data
    reg [63:0] in0_mem     [0:4607];
    reg [63:0] in1_mem     [0:4607];
    reg [63:0] expected_mem [0:9215];

    // GM coefficients
    reg [63:0] gm_table [0:2047];

    integer fd, rc, fields;
    integer i, u, gm_idx;

    integer call_id, logn, n, hn, qn;
    integer input_offset, output_offset;

    integer total, fail, call_count;

    real gm_value;
    reg [2047:0] csv_line;

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

    // Compare one FP64 value
    task check_word;
        input [63:0] actual;
        input [63:0] expected;
        input integer call_number;
        input integer index;

        begin
            total = total + 1;

            if (actual !== expected) begin
                fail = fail + 1;

                if (fail <= 20) begin
                    $display(
                        "[FAIL] call=%0d index=%0d expected=%h actual=%h",
                        call_number, index, expected, actual
                    );
                end
            end
        end
    endtask

    initial begin

        total      = 0;
        fail       = 0;
        call_count = 0;

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
         * Load Golden Trace vectors
         */

        $readmemh(
            "golden/unit/split_merge/trace/merge/in0.memh",
            in0_mem
        );

        $readmemh(
            "golden/unit/split_merge/trace/merge/in1.memh",
            in1_mem
        );

        $readmemh(
            "golden/unit/split_merge/trace/merge/expected.memh",
            expected_mem
        );

        /*
         * Read calls.csv
         */

        fd = $fopen(
            "golden/unit/split_merge/trace/merge/calls.csv",
            "r"
        );

        if (fd == 0) begin
            $display("[ERROR] Cannot open calls.csv");
            $finish;
        end

        // Skip CSV header
        rc = $fgets(csv_line, fd);

        while (!$feof(fd)) begin

            rc = $fgets(csv_line, fd);

            if (rc > 0) begin

                fields = $sscanf(
                    csv_line,
                    "%d,%d,%d,%d,%d",
                    call_id,
                    logn,
                    n,
                    input_offset,
                    output_offset
                );

                if (fields == 5) begin

                    hn = n >> 1;
                    qn = hn >> 1;

                    /*
                     * Special case: logn = 1
                     */

                    if (logn == 1) begin

                        small_n_mode = 1;

                        f0_re = in0_mem[input_offset];
                        f1_re = in1_mem[input_offset];

                        f0_im = 0;
                        f1_im = 0;

                        #10;

                        check_word(
                            out0_re,
                            expected_mem[output_offset],
                            call_id, 0
                        );

                        check_word(
                            out1_re,
                            expected_mem[output_offset + hn],
                            call_id, hn
                        );

                    end else begin

                        /*
                         * Normal Merge
                         */

                        small_n_mode = 0;

                        for (u = 0; u < qn; u = u + 1) begin

                            // Complex f0
                            f0_re = in0_mem[input_offset + u];
                            f0_im = in0_mem[input_offset + u + qn];

                            // Complex f1
                            f1_re = in1_mem[input_offset + u];
                            f1_im = in1_mem[input_offset + u + qn];

                            // GM coefficient
                            gm_idx = 2 * (u + hn);

                            gm_re = gm_table[gm_idx];
                            gm_im = gm_table[gm_idx + 1];

                            #10;

                            check_word(
                                out0_re,
                                expected_mem[output_offset + 2*u],
                                call_id, 2*u
                            );

                            check_word(
                                out0_im,
                                expected_mem[output_offset + 2*u + hn],
                                call_id, 2*u + hn
                            );

                            check_word(
                                out1_re,
                                expected_mem[output_offset + 2*u + 1],
                                call_id, 2*u + 1
                            );

                            check_word(
                                out1_im,
                                expected_mem[output_offset + 2*u + 1 + hn],
                                call_id, 2*u + 1 + hn
                            );

                        end
                    end

                    call_count = call_count + 1;

                    if ((call_count % 250) == 0) begin
                        $display(
                            "[PROGRESS] calls=%0d fail=%0d",
                            call_count, fail
                        );
                    end

                end else begin
                    $display("[ERROR] Invalid CSV record");
                    fail = fail + 1;
                end
            end
        end

        $fclose(fd);

        /*
         * Check trace counts
         */

        if (call_count != 1022) begin
            $display(
                "[ERROR] Expected 1022 calls, found %0d",
                call_count
            );
            fail = fail + 1;
        end

        if (total != 9216) begin
            $display(
                "[ERROR] Expected 9216 comparisons, found %0d",
                total
            );
            fail = fail + 1;
        end

        /*
         * Final report
         */

        $display("================================");
        $display("MERGE TRACE TEST");
        $display("CALLS = %0d", call_count);
        $display("TOTAL = %0d", total);
        $display("FAIL  = %0d", fail);
        $display("================================");

        if (fail == 0)
            $display("MERGE TRACE : PASS");
        else
            $display("MERGE TRACE : FAIL");

        $finish;
    end

endmodule
