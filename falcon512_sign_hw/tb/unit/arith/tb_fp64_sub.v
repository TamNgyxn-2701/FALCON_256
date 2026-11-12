`timescale 1ns/1ps

module tb_fp64_sub;

    parameter NUM_CASES = 32;

    reg  [63:0] a;
    reg  [63:0] b;
    wire [63:0] y;
    wire [7:0]  status;

    reg [63:0] a_mem [0:NUM_CASES-1];
    reg [63:0] b_mem [0:NUM_CASES-1];
    reg [63:0] y_mem [0:NUM_CASES-1];

    integer i;
    integer pass_count;
    integer fail_count;

    fp64_sub dut (
        .a      (a),
        .b      (b),
        .y      (y),
        .status (status)
    );

    initial begin

        $readmemh(
            "golden/unit/fp64/directed/sub_a.memh",
            a_mem
        );

        $readmemh(
            "golden/unit/fp64/directed/sub_b.memh",
            b_mem
        );

        $readmemh(
            "golden/unit/fp64/directed/sub_y.memh",
            y_mem
        );

        pass_count = 0;
        fail_count = 0;

        a = 64'd0;
        b = 64'd0;

        #10;

        for (i = 0; i < NUM_CASES; i = i + 1) begin

            a = a_mem[i];
            b = b_mem[i];

            #10;

            if (y === y_mem[i]) begin
                $display(
                    "[PASS] case=%0d a=%016h b=%016h y=%016h",
                    i, a, b, y
                );

                pass_count = pass_count + 1;
            end
            else begin
                $display(
                    "[FAIL] case=%0d a=%016h b=%016h rtl=%016h golden=%016h status=%02h",
                    i, a, b, y, y_mem[i], status
                );

                fail_count = fail_count + 1;
            end
        end

        $display("");
        $display("========================================");
        $display("FP64 SUB DIRECTED TEST");
        $display("PASS = %0d", pass_count);
        $display("FAIL = %0d", fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("FP64 SUB DIRECTED : PASS");
        else
            $display("FP64 SUB DIRECTED : FAIL");

        $finish;
    end

endmodule

