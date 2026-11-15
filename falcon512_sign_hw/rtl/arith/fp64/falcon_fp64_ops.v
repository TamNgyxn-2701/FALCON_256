`timescale 1ns/1ps
// FP64 IEEE-754 bit patterns. SIM_FP is simulation-only.
// Without SIM_FP, DesignWare floating-point IP is instantiated.
module falcon_fp64_add(input [63:0] a, b, output [63:0] z);
`ifdef SIM_FP
    reg [63:0] z_sim;
    real ar, br;
    always @* begin
        ar = $bitstoreal(a);
        br = $bitstoreal(b);
        z_sim = $realtobits(ar + br);
    end
    assign z = z_sim;
`else
    wire [7:0] status;
    DW_fp_add #(.sig_width(52), .exp_width(11), .ieee_compliance(1))
      u_add(.a(a), .b(b), .rnd(3'b000), .z(z), .status(status));
`endif
endmodule

module falcon_fp64_mul(input [63:0] a, b, output [63:0] z);
`ifdef SIM_FP
    reg [63:0] z_sim;
    real ar, br;
    always @* begin
        ar = $bitstoreal(a);
        br = $bitstoreal(b);
        z_sim = $realtobits(ar * br);
    end
    assign z = z_sim;
`else
    wire [7:0] status;
    DW_fp_mult #(.sig_width(52), .exp_width(11), .ieee_compliance(1))
      u_mult(.a(a), .b(b), .rnd(3'b000), .z(z), .status(status));
`endif
endmodule

module falcon_fp64_sub(input [63:0] a, b, output [63:0] z);
    wire [63:0] neg_b = {~b[63], b[62:0]};
    falcon_fp64_add u_add(.a(a), .b(neg_b), .z(z));
endmodule
