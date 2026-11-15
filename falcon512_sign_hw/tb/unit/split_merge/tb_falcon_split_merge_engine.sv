`timescale 1ns/1ps

module tb_falcon_split_merge_engine;

    // =========================================
    // SIGNALS
    // =========================================

    reg clk, rst_n, start, mode_merge;
    reg [3:0] logn;
    wire busy, done;

    wire rd_req;
    wire [1:0] rd_bank;
    wire [8:0] rd_addr;
    reg rd_valid;
    reg [63:0] rd_data;

    wire wr_valid;
    wire [1:0] wr_bank;
    wire [8:0] wr_addr;
    wire [63:0] wr_data;
    reg wr_ready;

    wire [8:0] tw_idx;
    wire [63:0] tw_re, tw_im;

    // 4 memory banks, each 512 x 64-bit
    reg [63:0] ram [0:2047];

    // Twiddle ROM
    reg [63:0] gm [0:2047];

    // Golden vectors
    reg [63:0] split_input [0:511];
    reg [63:0] split_exp0 [0:255];
    reg [63:0] split_exp1 [0:255];

    reg [63:0] merge_in0 [0:255];
    reg [63:0] merge_in1 [0:255];
    reg [63:0] merge_exp [0:511];

    integer errors, checks, reads, writes;
    integer cid, n, hn, i, cycles;

    string filename;

    // =========================================
    // DUT
    // =========================================

    falcon_split_merge_engine dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),

        .mode_merge(mode_merge),
        .logn(logn),

        .busy(busy),
        .done(done),

        .rd_req(rd_req),
        .rd_bank(rd_bank),
        .rd_addr(rd_addr),
        .rd_valid(rd_valid),
        .rd_data(rd_data),

        .wr_valid(wr_valid),
        .wr_bank(wr_bank),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_ready(wr_ready),

        .tw_idx(tw_idx),
        .tw_re(tw_re),
        .tw_im(tw_im)
    );

    // =========================================
    // TWIDDLE ROM
    // =========================================

    assign tw_re = gm[{tw_idx, 1'b0}];
    assign tw_im = gm[{tw_idx, 1'b1}];

    // =========================================
    // CLOCK: PERIOD = 10ns
    // =========================================

    always #5 clk = ~clk;

    // =========================================
    // MEMORY MODEL
    //
    // Bank 0: address 0    - 511
    // Bank 1: address 512  - 1023
    // Bank 2: address 1024 - 1535
    // Bank 3: address 1536 - 2047
    //
    // Registered read response
    // Always-ready write port
    // =========================================

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin
            rd_valid <= 1'b0;
            rd_data <= 64'd0;
            reads <= 0;
            writes <= 0;
        end
        else begin

            rd_valid <= rd_req;

            if (rd_req) begin
                rd_data <= ram[{rd_bank, rd_addr}];
                reads <= reads + 1;
            end

            if (wr_valid && wr_ready) begin
                ram[{wr_bank, wr_addr}] <= wr_data;
                writes <= writes + 1;
            end

        end
    end

    // =========================================
    // COMPARE OUTPUT WITH GOLDEN
    // =========================================

    task automatic check_word;

        input [63:0] actual, expected;
        input integer operation, case_id, address;

        begin
            checks = checks + 1;

            if (actual !== expected) begin
                errors = errors + 1;

                if (errors <= 20)
                    $display(
                        "MISMATCH op=%0d case=%0d addr=%0d got=%016h expected=%016h",
                        operation, case_id, address,
                        actual, expected
                    );
            end
        end

    endtask

    // =========================================
    // START ENGINE AND WAIT FOR DONE
    // =========================================

    task automatic execute_engine;

        input integer operation, ln, expected_words;

        begin

            @(negedge clk);

            reads = 0;
            writes = 0;

            mode_merge = (operation != 0);
            logn = ln;
            start = 1'b1;

            @(negedge clk);
            start = 1'b0;

            cycles = 0;

            while ((done !== 1'b1) &&
                   (cycles < 7000)) begin

                @(negedge clk);
                cycles = cycles + 1;

            end

            if (done !== 1'b1) begin
                $display(
                    "TIMEOUT: operation=%0d logn=%0d",
                    operation, ln
                );

                errors = errors + 1;
                $finish;
            end

            if ((reads != expected_words) ||
                (writes != expected_words)) begin

                errors = errors + 1;

                $display(
                    "TRANSFER ERROR: operation=%0d logn=%0d reads=%0d writes=%0d expected=%0d",
                    operation, ln,
                    reads, writes, expected_words
                );
            end

        end

    endtask

    // =========================================
    // MAIN TEST
    // =========================================

    initial begin

        clk = 1'b0;
        rst_n = 1'b0;
        start = 1'b0;
        mode_merge = 1'b0;
        logn = 4'd1;

        rd_valid = 1'b0;
        rd_data = 64'd0;
        wr_ready = 1'b1;

        errors = 0;
        checks = 0;
        reads = 0;
        writes = 0;

        $readmemh("tb/unit/split_merge/gm_tab.memh", gm);

        // Enable VCD with +DUMP
        if ($test$plusargs("DUMP")) begin
            $dumpfile("build/split_merge_engine.vcd");
            $dumpvars(0, dut);
        end

        repeat (3) @(negedge clk);
        rst_n = 1'b1;

        // =====================================
        // TEST ALL N = 2, 4, 8, ... 512
        // =====================================

        for (cid = 0; cid < 9; cid = cid + 1) begin

            n = 1 << (cid + 1);
            hn = n >> 1;

            // =================================
            // TEST SPLIT
            // =================================

            filename = $sformatf(
                "golden/unit/split_merge/directed/split/case_%03d/input.memh",
                cid
            );
            $readmemh(filename, split_input);

            filename = $sformatf(
                "golden/unit/split_merge/directed/split/case_%03d/out0.memh",
                cid
            );
            $readmemh(filename, split_exp0);

            filename = $sformatf(
                "golden/unit/split_merge/directed/split/case_%03d/out1.memh",
                cid
            );
            $readmemh(filename, split_exp1);

            // Load input into bank 0
            for (i = 0; i < n; i = i + 1)
                ram[i] = split_input[i];

            // Clear output banks
            for (i = 0; i < hn; i = i + 1) begin
                ram[1024 + i] = 64'hDEADBEEFDEADBEEF;
                ram[1536 + i] = 64'hDEADBEEFDEADBEEF;
            end

            // Run Split
            execute_engine(0, cid + 1, n);

            // Compare Split results
            for (i = 0; i < hn; i = i + 1) begin

                check_word(
                    ram[1024 + i],
                    split_exp0[i],
                    0, cid, i
                );

                check_word(
                    ram[1536 + i],
                    split_exp1[i],
                    0, cid, i
                );

            end

            // =================================
            // TEST MERGE
            // =================================

            filename = $sformatf(
                "golden/unit/split_merge/directed/merge/case_%03d/in0.memh",
                cid
            );
            $readmemh(filename, merge_in0);

            filename = $sformatf(
                "golden/unit/split_merge/directed/merge/case_%03d/in1.memh",
                cid
            );
            $readmemh(filename, merge_in1);

            filename = $sformatf(
                "golden/unit/split_merge/directed/merge/case_%03d/expected.memh",
                cid
            );
            $readmemh(filename, merge_exp);

            // Load input banks
            for (i = 0; i < hn; i = i + 1) begin
                ram[i] = merge_in0[i];
                ram[512 + i] = merge_in1[i];
            end

            // Clear output bank
            for (i = 0; i < n; i = i + 1)
                ram[1024 + i] =
                    64'hDEADBEEFDEADBEEF;

            // Run Merge
            execute_engine(1, cid + 1, n);

            // Compare Merge results
            for (i = 0; i < n; i = i + 1) begin

                check_word(
                    ram[1024 + i],
                    merge_exp[i],
                    1, cid, i
                );

            end

            $display(
                "Completed logn=%0d N=%0d errors=%0d",
                cid + 1, n, errors
            );

        end

        // =====================================
        // FINAL REPORT
        // =====================================

        $display(
            "TOTAL: checks=%0d errors=%0d",
            checks, errors
        );

        if (errors == 0)
            $display(
                "TEST PASS: Split/Merge Engine golden comparison"
            );
        else
            $display(
                "TEST FAIL: Split/Merge Engine golden comparison"
            );

        $finish;

    end

endmodule


