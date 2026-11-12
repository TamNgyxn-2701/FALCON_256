`timescale 1ns/1ps

module tb_int2fpr_trace;

    parameter NUM_CASES = 11957;

    reg  [63:0] a;
    wire [63:0] y;
    wire [7:0]  status;

    reg [63:0] input_mem    [0:NUM_CASES-1];
    reg [63:0] expected_mem [0:NUM_CASES-1];

    integer i;
    integer pass_count;
    integer fail_count;
    integer fail_printed;

    int2fpr dut (
        .a      (a),
        .y      (y),
        .status (status)
    );

    initial begin

        $readmemh(
            "golden/unit/convert/trace/int2fpr_in.memh",
            input_mem
        );

        $readmemh(
            "golden/unit/convert/trace/int2fpr_out.memh",
            expected_mem
        );

        pass_count   = 0;
        fail_count   = 0;
        fail_printed = 0;

        a = 64'd0;

        #10;

        for (i = 0; i < NUM_CASES; i = i + 1) begin

            a = input_mem[i];

            #1;

            if (y === expected_mem[i]) begin
                pass_count = pass_count + 1;
            end
            else begin
                fail_count = fail_count + 1;

                if (fail_printed < 20) begin
                    $display(
                        "[FAIL] case=%0d int=%016h rtl=%016h golden=%016h status=%02h",
                        i, a, y, expected_mem[i], status
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
        $display("INT2FPR TRACE TEST");
        $display("TOTAL = %0d", NUM_CASES);
        $display("PASS  = %0d", pass_count);
        $display("FAIL  = %0d", fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("INT2FPR TRACE : PASS");
        else
            $display("INT2FPR TRACE : FAIL");

        $finish;
    end

endmodule
