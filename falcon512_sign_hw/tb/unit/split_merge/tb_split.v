`timescale 1ns/1ps

module tb_split;

    reg small_n_mode;

    reg [63:0] copy_f0, copy_f1;
    reg [63:0] a_re, a_im;
    reg [63:0] b_re, b_im;
    reg [63:0] gm_re, gm_im;

    wire [63:0] f0_re, f0_im;
    wire [63:0] f1_re, f1_im;

    reg [63:0] input_mem [0:511];
    reg [63:0] out0_mem  [0:255];
    reg [63:0] out1_mem  [0:255];
    reg [63:0] gm_table  [0:2047];

    integer logn, n, hn, qn;
    integer case_id, u, gm_idx;
    integer i, fd, rc;
    integer total, fail;

    real gm_value;

    reg [1023:0] filename;

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
        copy_f0 = 0;
        copy_f1 = 0;

        a_re = 0;
        a_im = 0;
        b_re = 0;
        b_im = 0;
        gm_re = 0;
        gm_im = 0;

        // Load GM coefficients from Falcon reference.
        fd = $fopen("vectors/split_merge/gm_decimal.txt", "r");

        if (fd == 0) begin
            $display("[ERROR] Cannot open GM coefficients");
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

        // Golden directed cases: case_000 to case_008.
        for (logn = 1; logn <= 9; logn = logn + 1) begin

            case_id = logn - 1;

            n  = 1 << logn;
            hn = n >> 1;
            qn = hn >> 1;

            $sformat(
                filename,
                "golden/unit/split_merge/directed/split/case_%03d/input.memh",
                case_id
            );
            $readmemh(filename, input_mem);

            $sformat(
                filename,
                "golden/unit/split_merge/directed/split/case_%03d/out0.memh",
                case_id
            );
            $readmemh(filename, out0_mem);

            $sformat(
                filename,
                "golden/unit/split_merge/directed/split/case_%03d/out1.memh",
                case_id
            );
            $readmemh(filename, out1_mem);

            if (logn == 1) begin

                // Golden: f0[0] = f[0], f1[0] = f[1].
                small_n_mode = 1;

                copy_f0 = input_mem[0];
                copy_f1 = input_mem[1];

                #10;

                check_word(f0_re, out0_mem[0], logn, 0);
                check_word(f1_re, out1_mem[0], logn, 1);

            end else begin

                small_n_mode = 0;

                for (u = 0; u < qn; u = u + 1) begin

                    a_re = input_mem[2*u];
                    a_im = input_mem[2*u + hn];

                    b_re = input_mem[2*u + 1];
                    b_im = input_mem[2*u + 1 + hn];

                    gm_idx = 2 * (u + hn);

                    gm_re = gm_table[gm_idx];
                    gm_im = gm_table[gm_idx + 1];

                    #10;

                    check_word(f0_re, out0_mem[u],      logn, u);
                    check_word(f0_im, out0_mem[u + qn], logn, u + qn);

                    check_word(f1_re, out1_mem[u],      logn, u);
                    check_word(f1_im, out1_mem[u + qn], logn, u + qn);
                end
            end

            $display("[DONE] logn=%0d", logn);
        end

        $display("================================");
        $display("SPLIT DIRECTED TEST");
        $display("TOTAL = %0d", total);
        $display("PASS  = %0d", total - fail);
        $display("FAIL  = %0d", fail);
        $display("================================");

        if (fail == 0)
            $display("SPLIT DIRECTED : PASS");
        else
            $display("SPLIT DIRECTED : FAIL");

        $finish;
    end

endmodule

