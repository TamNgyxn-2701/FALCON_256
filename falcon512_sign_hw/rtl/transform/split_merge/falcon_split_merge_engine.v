
`timescale 1ns/1ps

// Falcon-512 Split/Merge Engine
// Sequential controller for polynomial operations
//
// Read banks:
//   0 = input polynomial 0
//   1 = input polynomial 1
//
// Write banks:
//   2 = output polynomial 0
//   3 = output polynomial 1
//
// Requires falcon_split_merge_pair.v
//
// FP64 pair unit is combinational.
// Memory read uses request/valid handshake.
// Memory write uses valid/ready handshake.

module falcon_split_merge_engine (
    input wire clk,
    input wire rst_n,
    input wire start,

    input wire mode_merge,
    input wire [3:0] logn,

    output wire busy,
    output wire done,

    // Memory read interface
    output wire rd_req,
    output reg [1:0] rd_bank,
    output reg [8:0] rd_addr,
    input wire rd_valid,
    input wire [63:0] rd_data,

    // Memory write interface
    output wire wr_valid,
    output reg [1:0] wr_bank,
    output reg [8:0] wr_addr,
    output reg [63:0] wr_data,
    input wire wr_ready,

    // Twiddle ROM interface
    output wire [8:0] tw_idx,
    input wire [63:0] tw_re,
    input wire [63:0] tw_im
);

    // =====================================
    // FSM STATES
    // =====================================

    localparam S_IDLE      = 3'd0;
    localparam S_READ_REQ  = 3'd1;
    localparam S_READ_WAIT = 3'd2;
    localparam S_CAPTURE   = 3'd3;
    localparam S_WRITE     = 3'd4;
    localparam S_DONE      = 3'd5;

    reg [2:0] state;

    // =====================================
    // CONTROL REGISTERS
    // =====================================

    reg mode_r;
    reg base_r;

    reg [8:0] half_n;
    reg [8:0] quarter_n;
    reg [8:0] pair_idx;

    reg [1:0] read_slot;
    reg [1:0] write_slot;

    // =====================================
    // FP64 INPUT REGISTERS
    // =====================================

    reg [63:0] a_re;
    reg [63:0] a_im;
    reg [63:0] b_re;
    reg [63:0] b_im;

    // =====================================
    // PAIR UNIT OUTPUTS
    // =====================================

    wire [63:0] pair0_re;
    wire [63:0] pair0_im;
    wire [63:0] pair1_re;
    wire [63:0] pair1_im;

    falcon_split_merge_pair u_pair (
        .mode_merge(mode_r),
        .base_case(base_r),

        .a_re(a_re),
        .a_im(a_im),
        .b_re(b_re),
        .b_im(b_im),

        .tw_re(tw_re),
        .tw_im(tw_im),

        .out0_re(pair0_re),
        .out0_im(pair0_im),
        .out1_re(pair1_re),
        .out1_im(pair1_im)
    );

    // Captured results
    reg [63:0] result0_re;
    reg [63:0] result0_im;
    reg [63:0] result1_re;
    reg [63:0] result1_im;

    // =====================================
    // STATUS SIGNALS
    // =====================================

    assign busy = (state != S_IDLE) &&
                  (state != S_DONE);

    assign done = (state == S_DONE);

    assign rd_req = (state == S_READ_REQ);

    assign wr_valid = (state == S_WRITE);

    // Falcon twiddle index
    assign tw_idx = pair_idx + half_n;

    // =====================================
    // READ ADDRESS GENERATOR
    // =====================================

    always @(*) begin
        rd_bank = 2'd0;
        rd_addr = 9'd0;

        if (base_r) begin
            // N = 2
            case (read_slot)
                2'd0: begin
                    rd_bank = 2'd0;
                    rd_addr = 9'd0;
                end

                2'd1: begin
                    rd_bank = mode_r ? 2'd1 : 2'd0;
                    rd_addr = mode_r ? 9'd0 : 9'd1;
                end
            endcase
        end
        else if (mode_r == 1'b0) begin
            // SPLIT: read polynomial f
            case (read_slot)
                2'd0: rd_addr = 2 * pair_idx;
                2'd1: rd_addr = 2 * pair_idx + half_n;
                2'd2: rd_addr = 2 * pair_idx + 1;
                2'd3: rd_addr = 2 * pair_idx + half_n + 1;
            endcase
        end
        else begin
            // MERGE: read f0 and f1
            case (read_slot)
                2'd0: begin
                    rd_bank = 2'd0;
                    rd_addr = pair_idx;
                end

                2'd1: begin
                    rd_bank = 2'd0;
                    rd_addr = pair_idx + quarter_n;
                end

                2'd2: begin
                    rd_bank = 2'd1;
                    rd_addr = pair_idx;
                end

                2'd3: begin
                    rd_bank = 2'd1;
                    rd_addr = pair_idx + quarter_n;
                end
            endcase
        end
    end

    // =====================================
    // WRITE ADDRESS AND DATA GENERATOR
    // =====================================

    always @(*) begin
        wr_bank = 2'd2;
        wr_addr = 9'd0;
        wr_data = 64'd0;

        if (base_r) begin
            case (write_slot)
                2'd0: begin
                    wr_bank = 2'd2;
                    wr_addr = 9'd0;
                    wr_data = result0_re;
                end

                2'd1: begin
                    wr_bank = mode_r ? 2'd2 : 2'd3;
                    wr_addr = mode_r ? 9'd1 : 9'd0;
                    wr_data = result1_re;
                end
            endcase
        end
        else if (mode_r == 1'b0) begin
            // SPLIT
            case (write_slot)
                2'd0: begin
                    wr_bank = 2'd2;
                    wr_addr = pair_idx;
                    wr_data = result0_re;
                end

                2'd1: begin
                    wr_bank = 2'd2;
                    wr_addr = pair_idx + quarter_n;
                    wr_data = result0_im;
                end

                2'd2: begin
                    wr_bank = 2'd3;
                    wr_addr = pair_idx;
                    wr_data = result1_re;
                end

                2'd3: begin
                    wr_bank = 2'd3;
                    wr_addr = pair_idx + quarter_n;
                    wr_data = result1_im;
                end
            endcase
        end
        else begin
            // MERGE
            case (write_slot)
                2'd0: begin
                    wr_addr = 2 * pair_idx;
                    wr_data = result0_re;
                end

                2'd1: begin
                    wr_addr = 2 * pair_idx + half_n;
                    wr_data = result0_im;
                end

                2'd2: begin
                    wr_addr = 2 * pair_idx + 1;
                    wr_data = result1_re;
                end

                2'd3: begin
                    wr_addr = 2 * pair_idx + half_n + 1;
                    wr_data = result1_im;
                end
            endcase
        end
    end

    // =====================================
    // MAIN CONTROLLER FSM
    // =====================================

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= S_IDLE;

            mode_r <= 1'b0;
            base_r <= 1'b0;

            half_n <= 0;
            quarter_n <= 0;
            pair_idx <= 0;

            read_slot <= 0;
            write_slot <= 0;

            a_re <= 0;
            a_im <= 0;
            b_re <= 0;
            b_im <= 0;

            result0_re <= 0;
            result0_im <= 0;
            result1_re <= 0;
            result1_im <= 0;
        end
        else begin
            case (state)

                S_IDLE: begin
                    if (start &&
                        logn >= 4'd1 &&
                        logn <= 4'd9) begin

                        mode_r <= mode_merge;
                        base_r <= (logn == 4'd1);

                        half_n <= 9'd1 << (logn - 1);

                        if (logn == 4'd1)
                            quarter_n <= 9'd0;
                        else
                            quarter_n <= 9'd1 << (logn - 2);

                        pair_idx <= 0;
                        read_slot <= 0;

                        a_re <= 0;
                        a_im <= 0;
                        b_re <= 0;
                        b_im <= 0;

                        state <= S_READ_REQ;
                    end
                end

                S_READ_REQ: begin
                    state <= S_READ_WAIT;
                end

                S_READ_WAIT: begin
                    if (rd_valid) begin
                        case (read_slot)
                            2'd0:
                                a_re <= rd_data;

                            2'd1: begin
                                if (base_r && mode_r)
                                    b_re <= rd_data;
                                else
                                    a_im <= rd_data;
                            end

                            2'd2:
                                b_re <= rd_data;

                            2'd3:
                                b_im <= rd_data;
                        endcase

                        if ((base_r && read_slot == 2'd1) ||
                            (!base_r && read_slot == 2'd3)) begin
                            state <= S_CAPTURE;
                        end
                        else begin
                            read_slot <= read_slot + 1'b1;
                            state <= S_READ_REQ;
                        end
                    end
                end

                S_CAPTURE: begin
                    result0_re <= pair0_re;
                    result0_im <= pair0_im;
                    result1_re <= pair1_re;
                    result1_im <= pair1_im;

                    write_slot <= 0;
                    state <= S_WRITE;
                end

                S_WRITE: begin
                    if (wr_ready) begin
                        if ((base_r && write_slot == 2'd1) ||
                            (!base_r && write_slot == 2'd3)) begin

                            if (base_r ||
                                pair_idx == quarter_n - 1'b1) begin
                                state <= S_DONE;
                            end
                            else begin
                                pair_idx <= pair_idx + 1'b1;
                                read_slot <= 0;
                                state <= S_READ_REQ;
                            end
                        end
                        else begin
                            write_slot <= write_slot + 1'b1;
                        end
                    end
                end

                S_DONE: begin
                    state <= S_IDLE;
                end

                default: begin
                    state <= S_IDLE;
                end
            endcase
        end
    end

endmodule

