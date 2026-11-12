/*
 * square.v
 * Sequential square module - higher Fmax version
 *
 * Idea:
 * - Avoid one-cycle multiplier.
 * - Avoid one-cycle 64-bit adder.
 * - Split each accumulation into two smaller additions:
 *     cycle 1: add lower WIDTH bits
 *     cycle 2: add upper WIDTH bits with carry
 *
 * Latency:
 * - about 2*WIDTH cycles
 */

`timescale 1ns/1ps

module square #(
    parameter WIDTH = 32
)(
    input clk,
    input rst_n,
    input start,

    input signed [WIDTH-1:0] a,

    output reg done,
    output reg busy,
    output reg [2*WIDTH-1:0] square_out
);

localparam OUT_WIDTH = 2 * WIDTH;

localparam S_IDLE    = 2'd0;
localparam S_ADD_LOW = 2'd1;
localparam S_ADD_HI  = 2'd2;

reg [1:0] state;

reg [WIDTH-1:0]     multiplier;
reg [OUT_WIDTH-1:0] multiplicand;
reg [OUT_WIDTH-1:0] acc;

reg [7:0] count;

reg [WIDTH-1:0] low_sum_reg;
reg             carry_reg;

wire [WIDTH-1:0] a_unsigned;
wire [WIDTH-1:0] a_abs;

wire [WIDTH-1:0] addend_low;
wire [WIDTH-1:0] addend_hi;

wire [WIDTH:0] low_sum;
wire [WIDTH:0] hi_sum;

/*
 * Convert signed input to unsigned magnitude.
 * Because a^2 = |a| * |a|
 */
assign a_unsigned = a[WIDTH-1:0];

assign a_abs = a[WIDTH-1] ? (~a_unsigned + {{(WIDTH-1){1'b0}}, 1'b1})
                          :  a_unsigned;

/*
 * Current addend.
 * If multiplier[0] = 1, add multiplicand.
 * Else add 0.
 */
assign addend_low = multiplier[0] ? multiplicand[WIDTH-1:0]
                                  : {WIDTH{1'b0}};

assign addend_hi  = multiplier[0] ? multiplicand[OUT_WIDTH-1:WIDTH]
                                  : {WIDTH{1'b0}};

/*
 * Split adder:
 * low_sum is WIDTH-bit addition + carry out.
 * hi_sum is WIDTH-bit addition + carry in.
 */
assign low_sum = {1'b0, acc[WIDTH-1:0]} + {1'b0, addend_low};

assign hi_sum  = {1'b0, acc[OUT_WIDTH-1:WIDTH]} +
                 {1'b0, addend_hi} +
                 {{WIDTH{1'b0}}, carry_reg};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state        <= S_IDLE;
        multiplier   <= {WIDTH{1'b0}};
        multiplicand <= {OUT_WIDTH{1'b0}};
        acc          <= {OUT_WIDTH{1'b0}};
        count        <= 8'd0;
        low_sum_reg  <= {WIDTH{1'b0}};
        carry_reg    <= 1'b0;
        square_out   <= {OUT_WIDTH{1'b0}};
        done         <= 1'b0;
        busy         <= 1'b0;
    end else begin
        done <= 1'b0;

        case (state)

            S_IDLE: begin
                if (start && !busy) begin
                    multiplier   <= a_abs;
                    multiplicand <= {{WIDTH{1'b0}}, a_abs};
                    acc          <= {OUT_WIDTH{1'b0}};
                    count        <= 8'd0;
                    low_sum_reg  <= {WIDTH{1'b0}};
                    carry_reg    <= 1'b0;
                    busy         <= 1'b1;
                    state        <= S_ADD_LOW;
                end
            end

            /*
             * Cycle 1:
             * add lower WIDTH bits.
             */
            S_ADD_LOW: begin
                low_sum_reg <= low_sum[WIDTH-1:0];
                carry_reg   <= low_sum[WIDTH];
                state       <= S_ADD_HI;
            end

            /*
             * Cycle 2:
             * add upper WIDTH bits with carry.
             */
            S_ADD_HI: begin
                acc <= {hi_sum[WIDTH-1:0], low_sum_reg};

                if (count == WIDTH-1) begin
                    square_out <= {hi_sum[WIDTH-1:0], low_sum_reg};
                    busy       <= 1'b0;
                    done       <= 1'b1;
                    state      <= S_IDLE;
                end else begin
                    multiplier   <= multiplier >> 1;
                    multiplicand <= multiplicand << 1;
                    count        <= count + 1'b1;
                    state        <= S_ADD_LOW;
                end
            end

            default: begin
                state <= S_IDLE;
            end

        endcase
    end
end

endmodule
