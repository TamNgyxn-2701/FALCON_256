`timescale 1ns/1ps

module tb_split_trace;

    reg small_n_mode;
    reg [63:0] copy_f0, copy_f1;
    reg [63:0] a_re, a_im;
    reg [63:0] b_re, b_im;
    reg [63:0] gm_re, gm_im;

    wire [63:0] f0_re, f0_im;
    wire [63:0] f1_re, f1_im;

    // Golden Trace data
    reg [63:0] input_mem [0:18431];
    reg [63:0] out0_mem  [0:9215];
    reg [63:0] out1_mem  [0:9215];

    // GM coefficients
    reg [63:0] gm_table [0:2047];

    integer fd, rc, fields;
    integer i, u, gm_idx;
    integer call_id, logn, n, hn, qn;
    integer input_offset, output_offset;

    integer total, fail, call_count;

    real gm_value;
    reg [2047:0] csv_line;

    split dut (
        .small_n_mode (small_n_mode),
        .copy_f0      (copy_f0),
        .copy_f1      (copy_f1),

        .a_re         (a_re),
        .a_im         (a_im),
        .b_re         (b_re),
        .b_im         (b_im),

        .gm_re        (gm_re),
        .gm_im        (gm_im),

        .f0_re        (f0_re),
        .f0_im        (f0_im),
        .f1_re        (f1_re),
        .f1_im        (f1_im)
    );

    task check_word;
        input [63:0] actual;
        input [63:0] expected;
        input integer call_number;
        input integer output_number;
        input integer index;
        begin
            total = total + 1;

            if (actual !== expected) begin
                fail = fail + 1;

                if (fail <= 20) begin
                    $display(
                        "[FAIL] call=%0d out=%0d index=%0d expected=%h actual=%h",
                        call_number,
                        output_number,
                        index,
                        expected,
                        actual
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
        copy_f0 = 0;
        copy_f1 = 0;

        a_re = 0;
        a_im = 0;
        b_re = 0;
        b_im = 0;
        gm_re = 0;
        gm_im = 0;

        // Load GM coefficients
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
                $display("[ERROR] GM entry %0d", i);
                $finish;
            end

            gm_table[i] = $realtobits(gm_value);
        end

        $fclose(fd);

        // Load Golden Trace vectors
        $readmemh(
            "golden/unit/split_merge/trace/split/input.memh",
            input_mem
        );

        $readmemh(
            "golden/unit/split_merge/trace/split/out0.memh",
            out0_mem
        );

        $readmemh(
            "golden/unit/split_merge/trace/split/out1.memh",
            out1_mem
        );

        // Read information about each Split call
        fd = $fopen(
            "golden/unit/split_merge/trace/split/calls.csv",
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

                    if (logn == 1) begin

                        small_n_mode = 1;

                        copy_f0 = input_mem[input_offset];
                        copy_f1 = input_mem[input_offset + hn];

                        #10;

                        check_word(
                            f0_re,
                            out0_mem[output_offset],
                            call_id, 0, 0
                        );

                        check_word(
                            f1_re,
                            out1_mem[output_offset],
                            call_id, 1, 0
                        );

                    end else begin

                        small_n_mode = 0;

                        for (u = 0; u < qn; u = u + 1) begin

                            a_re = input_mem[input_offset + 2*u];
                            a_im = input_mem[input_offset + hn + 2*u];

                            b_re = input_mem[input_offset + 2*u + 1];
                            b_im = input_mem[input_offset + hn + 2*u + 1];

                            gm_idx = 2 * (u + hn);

                            gm_re = gm_table[gm_idx];
                            gm_im = gm_table[gm_idx + 1];

                            #10;

                            check_word(
                                f0_re,
                                out0_mem[output_offset + u],
                                call_id, 0, u
                            );

                            check_word(
                                f0_im,
                                out0_mem[output_offset + u + qn],
                                call_id, 0, u + qn
                            );

                            check_word(
                                f1_re,
                                out1_mem[output_offset + u],
                                call_id, 1, u
                            );

                            check_word(
                                f1_im,
                                out1_mem[output_offset + u + qn],
                                call_id, 1, u + qn
                            );
                        end
                    end

                    call_count = call_count + 1;

                    if ((call_count % 500) == 0)
                        $display(
                            "[PROGRESS] calls=%0d fail=%0d",
                            call_count, fail
                        );

                end else begin
                    $display("[ERROR] Invalid CSV record");
                    fail = fail + 1;
                end
            end
        end

        $fclose(fd);

        if (call_count != 2044) begin
            $display(
                "[ERROR] Expected 2044 calls, found %0d",
                call_count
            );
            fail = fail + 1;
        end

        if (total != 18432) begin
            $display(
                "[ERROR] Expected 18432 comparisons, found %0d",
                total
            );
            fail = fail + 1;
        end

        $display("================================");
        $display("SPLIT TRACE TEST");
        $display("CALLS = %0d", call_count);
        $display("TOTAL = %0d", total);
        $display("FAIL  = %0d", fail);
        $display("================================");

        if (fail == 0)
            $display("SPLIT TRACE : PASS");
        else
            $display("SPLIT TRACE : FAIL");

        $finish;
    end

endmodule
