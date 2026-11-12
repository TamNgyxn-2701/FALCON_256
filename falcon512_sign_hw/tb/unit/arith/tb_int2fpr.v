`timescale 1ns/1ps

module tb_int2fpr;

    parameter NUM_CASES = 32;

    reg  [63:0] a;
    wire [63:0] y;
    wire [7:0]  status;

    reg [63:0] input_mem    [0:NUM_CASES-1];
    reg [63:0] expected_mem [0:NUM_CASES-1];

    integer i;
    integer pass_count;
    integer fail_count;

    int2fpr dut (
        .a      (a),
        .y      (y),
        .status (status)
    );

    initial begin

        $readmemh(
            "golden/unit/convert/int2fpr/input.memh",
            input_mem
        );

        $readmemh(
            "golden/unit/convert/int2fpr/expected.memh",
            expected_mem
        );

        pass_count = 0;
        fail_count = 0;

        a = 64'd0;

        #10;

        for (i = 0; i < NUM_CASES; i = i + 1) begin

            a = input_mem[i];

            #10;

            if (y === expected_mem[i]) begin
                $display(
                    "[PASS] case=%0d int=%016h fpr=%016h",
                    i, a, y
                );

                pass_count = pass_count + 1;
            end
            else begin
                $display(
                    "[FAIL] case=%0d int=%016h rtl=%016h golden=%016h status=%02h",
                    i, a, y, expected_mem[i], status
                );

                fail_count = fail_count + 1;
            end
        end

        $display("");
        $display("========================================");
        $display("INT2FPR DIRECTED TEST");
        $display("PASS = %0d", pass_count);
        $display("FAIL = %0d", fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("INT2FPR DIRECTED : PASS");
        else
            $display("INT2FPR DIRECTED : FAIL");

        $finish;
    end

endmodule
