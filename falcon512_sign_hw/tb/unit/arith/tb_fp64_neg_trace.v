`timescale 1ns/1ps

module tb_fp64_neg_trace;

    parameter NUM_CASES = 14079;

    reg  [63:0] a;
    wire [63:0] y;

    reg [63:0] a_mem [0:NUM_CASES-1];
    reg [63:0] y_mem [0:NUM_CASES-1];

    integer i;
    integer pass_count;
    integer fail_count;
    integer fail_printed;

    fp64_neg dut (
        .a (a),
        .y (y)
    );

    initial begin

        $readmemh(
            "golden/unit/fp64/trace/neg_a.memh",
            a_mem
        );

        $readmemh(
            "golden/unit/fp64/trace/neg_y.memh",
            y_mem
        );

        pass_count   = 0;
        fail_count   = 0;
        fail_printed = 0;

        a = 64'd0;

        #10;

        for (i = 0; i < NUM_CASES; i = i + 1) begin

            a = a_mem[i];

            #1;

            if (y === y_mem[i]) begin
                pass_count = pass_count + 1;
            end
            else begin
                fail_count = fail_count + 1;

                if (fail_printed < 20) begin
                    $display(
                        "[FAIL] case=%0d a=%016h rtl=%016h golden=%016h",
                        i, a, y, y_mem[i]
                    );

                    fail_printed = fail_printed + 1;
                end
            end

            if ((i % 2000) == 0) begin
                $display(
                    "[PROGRESS] case=%0d pass=%0d fail=%0d",
                    i, pass_count, fail_count
                );
            end
        end

        $display("");
        $display("========================================");
        $display("FP64 NEG TRACE TEST");
        $display("TOTAL = %0d", NUM_CASES);
        $display("PASS  = %0d", pass_count);
        $display("FAIL  = %0d", fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("FP64 NEG TRACE : PASS");
        else
            $display("FP64 NEG TRACE : FAIL");

        $finish;
    end

endmodule
