
module accumulator_DW01_add_0 ( A, B, CI, SUM, CO );
  input [63:0] A;
  input [63:0] B;
  output [63:0] SUM;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32;
  wire   [63:1] carry;

  FADDX1 U1_30 ( .A(A[30]), .B(B[30]), .CI(carry[30]), .CO(carry[31]), .S(
        SUM[30]) );
  FADDX1 U1_29 ( .A(A[29]), .B(B[29]), .CI(carry[29]), .CO(carry[30]), .S(
        SUM[29]) );
  FADDX1 U1_28 ( .A(A[28]), .B(B[28]), .CI(carry[28]), .CO(carry[29]), .S(
        SUM[28]) );
  FADDX1 U1_27 ( .A(A[27]), .B(B[27]), .CI(carry[27]), .CO(carry[28]), .S(
        SUM[27]) );
  FADDX1 U1_26 ( .A(A[26]), .B(B[26]), .CI(carry[26]), .CO(carry[27]), .S(
        SUM[26]) );
  FADDX1 U1_25 ( .A(A[25]), .B(B[25]), .CI(carry[25]), .CO(carry[26]), .S(
        SUM[25]) );
  FADDX1 U1_24 ( .A(A[24]), .B(B[24]), .CI(carry[24]), .CO(carry[25]), .S(
        SUM[24]) );
  FADDX1 U1_23 ( .A(A[23]), .B(B[23]), .CI(carry[23]), .CO(carry[24]), .S(
        SUM[23]) );
  FADDX1 U1_22 ( .A(A[22]), .B(B[22]), .CI(carry[22]), .CO(carry[23]), .S(
        SUM[22]) );
  FADDX1 U1_21 ( .A(A[21]), .B(B[21]), .CI(carry[21]), .CO(carry[22]), .S(
        SUM[21]) );
  FADDX1 U1_20 ( .A(A[20]), .B(B[20]), .CI(carry[20]), .CO(carry[21]), .S(
        SUM[20]) );
  FADDX1 U1_19 ( .A(A[19]), .B(B[19]), .CI(carry[19]), .CO(carry[20]), .S(
        SUM[19]) );
  FADDX1 U1_18 ( .A(A[18]), .B(B[18]), .CI(carry[18]), .CO(carry[19]), .S(
        SUM[18]) );
  FADDX1 U1_17 ( .A(A[17]), .B(B[17]), .CI(carry[17]), .CO(carry[18]), .S(
        SUM[17]) );
  FADDX1 U1_16 ( .A(A[16]), .B(B[16]), .CI(carry[16]), .CO(carry[17]), .S(
        SUM[16]) );
  FADDX1 U1_15 ( .A(A[15]), .B(B[15]), .CI(carry[15]), .CO(carry[16]), .S(
        SUM[15]) );
  FADDX1 U1_14 ( .A(A[14]), .B(B[14]), .CI(carry[14]), .CO(carry[15]), .S(
        SUM[14]) );
  FADDX1 U1_13 ( .A(A[13]), .B(B[13]), .CI(carry[13]), .CO(carry[14]), .S(
        SUM[13]) );
  FADDX1 U1_12 ( .A(A[12]), .B(B[12]), .CI(carry[12]), .CO(carry[13]), .S(
        SUM[12]) );
  FADDX1 U1_11 ( .A(A[11]), .B(B[11]), .CI(carry[11]), .CO(carry[12]), .S(
        SUM[11]) );
  FADDX1 U1_10 ( .A(A[10]), .B(B[10]), .CI(carry[10]), .CO(carry[11]), .S(
        SUM[10]) );
  FADDX1 U1_9 ( .A(A[9]), .B(B[9]), .CI(carry[9]), .CO(carry[10]), .S(SUM[9])
         );
  FADDX1 U1_8 ( .A(A[8]), .B(B[8]), .CI(carry[8]), .CO(carry[9]), .S(SUM[8])
         );
  FADDX1 U1_7 ( .A(A[7]), .B(B[7]), .CI(carry[7]), .CO(carry[8]), .S(SUM[7])
         );
  FADDX1 U1_6 ( .A(A[6]), .B(B[6]), .CI(carry[6]), .CO(carry[7]), .S(SUM[6])
         );
  FADDX1 U1_5 ( .A(A[5]), .B(B[5]), .CI(carry[5]), .CO(carry[6]), .S(SUM[5])
         );
  FADDX1 U1_4 ( .A(A[4]), .B(B[4]), .CI(carry[4]), .CO(carry[5]), .S(SUM[4])
         );
  FADDX1 U1_3 ( .A(A[3]), .B(B[3]), .CI(carry[3]), .CO(carry[4]), .S(SUM[3])
         );
  FADDX1 U1_2 ( .A(A[2]), .B(B[2]), .CI(carry[2]), .CO(carry[3]), .S(SUM[2])
         );
  FADDX1 U1_31 ( .A(A[31]), .B(B[31]), .CI(carry[31]), .CO(carry[32]), .S(
        SUM[31]) );
  FADDX1 U1_1 ( .A(A[1]), .B(B[1]), .CI(n1), .CO(carry[2]), .S(SUM[1]) );
  AND2X1 U1 ( .IN1(B[0]), .IN2(A[0]), .Q(n1) );
  XOR2X1 U2 ( .IN1(n31), .IN2(A[62]), .Q(SUM[62]) );
  XOR2X1 U3 ( .IN1(n29), .IN2(A[60]), .Q(SUM[60]) );
  XOR2X1 U4 ( .IN1(n28), .IN2(A[59]), .Q(SUM[59]) );
  XOR2X1 U5 ( .IN1(n26), .IN2(A[57]), .Q(SUM[57]) );
  XOR2X1 U6 ( .IN1(n25), .IN2(A[56]), .Q(SUM[56]) );
  XOR2X1 U7 ( .IN1(n23), .IN2(A[54]), .Q(SUM[54]) );
  XOR2X1 U8 ( .IN1(n22), .IN2(A[53]), .Q(SUM[53]) );
  XOR2X1 U9 ( .IN1(n20), .IN2(A[51]), .Q(SUM[51]) );
  XOR2X1 U10 ( .IN1(n19), .IN2(A[50]), .Q(SUM[50]) );
  XOR2X1 U11 ( .IN1(n30), .IN2(A[61]), .Q(SUM[61]) );
  XOR2X1 U12 ( .IN1(n27), .IN2(A[58]), .Q(SUM[58]) );
  XOR2X1 U13 ( .IN1(n24), .IN2(A[55]), .Q(SUM[55]) );
  XOR2X1 U14 ( .IN1(n21), .IN2(A[52]), .Q(SUM[52]) );
  XOR2X1 U15 ( .IN1(n18), .IN2(A[49]), .Q(SUM[49]) );
  AND2X1 U16 ( .IN1(carry[32]), .IN2(A[32]), .Q(n2) );
  AND2X1 U17 ( .IN1(n2), .IN2(A[33]), .Q(n3) );
  AND2X1 U18 ( .IN1(n3), .IN2(A[34]), .Q(n4) );
  AND2X1 U19 ( .IN1(n4), .IN2(A[35]), .Q(n5) );
  AND2X1 U20 ( .IN1(n5), .IN2(A[36]), .Q(n6) );
  AND2X1 U21 ( .IN1(n6), .IN2(A[37]), .Q(n7) );
  AND2X1 U22 ( .IN1(n7), .IN2(A[38]), .Q(n8) );
  AND2X1 U23 ( .IN1(n8), .IN2(A[39]), .Q(n9) );
  AND2X1 U24 ( .IN1(n9), .IN2(A[40]), .Q(n10) );
  AND2X1 U25 ( .IN1(n10), .IN2(A[41]), .Q(n11) );
  AND2X1 U26 ( .IN1(n11), .IN2(A[42]), .Q(n12) );
  AND2X1 U27 ( .IN1(n12), .IN2(A[43]), .Q(n13) );
  AND2X1 U28 ( .IN1(n13), .IN2(A[44]), .Q(n14) );
  AND2X1 U29 ( .IN1(n14), .IN2(A[45]), .Q(n15) );
  AND2X1 U30 ( .IN1(n15), .IN2(A[46]), .Q(n16) );
  AND2X1 U31 ( .IN1(n16), .IN2(A[47]), .Q(n17) );
  AND2X1 U32 ( .IN1(n17), .IN2(A[48]), .Q(n18) );
  AND2X1 U33 ( .IN1(n18), .IN2(A[49]), .Q(n19) );
  AND2X1 U34 ( .IN1(n19), .IN2(A[50]), .Q(n20) );
  AND2X1 U35 ( .IN1(n20), .IN2(A[51]), .Q(n21) );
  AND2X1 U36 ( .IN1(n21), .IN2(A[52]), .Q(n22) );
  AND2X1 U37 ( .IN1(n22), .IN2(A[53]), .Q(n23) );
  AND2X1 U38 ( .IN1(n23), .IN2(A[54]), .Q(n24) );
  AND2X1 U39 ( .IN1(n24), .IN2(A[55]), .Q(n25) );
  AND2X1 U40 ( .IN1(n25), .IN2(A[56]), .Q(n26) );
  AND2X1 U41 ( .IN1(n26), .IN2(A[57]), .Q(n27) );
  AND2X1 U42 ( .IN1(n27), .IN2(A[58]), .Q(n28) );
  AND2X1 U43 ( .IN1(n28), .IN2(A[59]), .Q(n29) );
  AND2X1 U44 ( .IN1(n29), .IN2(A[60]), .Q(n30) );
  AND2X1 U45 ( .IN1(n30), .IN2(A[61]), .Q(n31) );
  XNOR2X1 U46 ( .IN1(n32), .IN2(A[63]), .Q(SUM[63]) );
  NAND2X0 U47 ( .IN1(n31), .IN2(A[62]), .QN(n32) );
  XOR2X1 U48 ( .IN1(n17), .IN2(A[48]), .Q(SUM[48]) );
  XOR2X1 U49 ( .IN1(n16), .IN2(A[47]), .Q(SUM[47]) );
  XOR2X1 U50 ( .IN1(n14), .IN2(A[45]), .Q(SUM[45]) );
  XOR2X1 U51 ( .IN1(n13), .IN2(A[44]), .Q(SUM[44]) );
  XOR2X1 U52 ( .IN1(n11), .IN2(A[42]), .Q(SUM[42]) );
  XOR2X1 U53 ( .IN1(n10), .IN2(A[41]), .Q(SUM[41]) );
  XOR2X1 U54 ( .IN1(n8), .IN2(A[39]), .Q(SUM[39]) );
  XOR2X1 U55 ( .IN1(n7), .IN2(A[38]), .Q(SUM[38]) );
  XOR2X1 U56 ( .IN1(n5), .IN2(A[36]), .Q(SUM[36]) );
  XOR2X1 U57 ( .IN1(n4), .IN2(A[35]), .Q(SUM[35]) );
  XOR2X1 U58 ( .IN1(n2), .IN2(A[33]), .Q(SUM[33]) );
  XOR2X1 U59 ( .IN1(carry[32]), .IN2(A[32]), .Q(SUM[32]) );
  XOR2X1 U60 ( .IN1(n15), .IN2(A[46]), .Q(SUM[46]) );
  XOR2X1 U61 ( .IN1(n12), .IN2(A[43]), .Q(SUM[43]) );
  XOR2X1 U62 ( .IN1(n9), .IN2(A[40]), .Q(SUM[40]) );
  XOR2X1 U63 ( .IN1(n6), .IN2(A[37]), .Q(SUM[37]) );
  XOR2X1 U64 ( .IN1(n3), .IN2(A[34]), .Q(SUM[34]) );
  XOR2X1 U65 ( .IN1(B[0]), .IN2(A[0]), .Q(SUM[0]) );
endmodule


module accumulator ( clk, rst_n, ena, clear, in_valid, data_in, acc_out, 
        out_valid );
  input [31:0] data_in;
  output [63:0] acc_out;
  input clk, rst_n, ena, clear, in_valid;
  output out_valid;
  wire   N6, N7, N8, N9, N10, N11, N12, N13, N14, N15, N16, N17, N18, N19, N20,
         N21, N22, N23, N24, N25, N26, N27, N28, N29, N30, N31, N32, N33, N34,
         N35, N36, N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47, N48,
         N49, N50, N51, N52, N53, N54, N55, N56, N57, N58, N59, N60, N61, N62,
         N63, N64, N65, N66, N67, N68, N69, n68, n69, n70, n71, n72, n73, n74,
         n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87, n88,
         n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100, n101,
         n102, n103, n104, n105, n106, n107, n108, n109, n110, n111, n112,
         n113, n114, n115, n116, n117, n118, n119, n120, n121, n122, n123,
         n124, n125, n126, n127, n128, n129, n130, n131, n132, n133, n134,
         n135, n136, n202, n203, n204, n205;

  accumulator_DW01_add_0 add_34 ( .A(acc_out), .B({1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 
        1'b0, 1'b0, 1'b0, 1'b0, data_in}), .CI(1'b0), .SUM({N69, N68, N67, N66, 
        N65, N64, N63, N62, N61, N60, N59, N58, N57, N56, N55, N54, N53, N52, 
        N51, N50, N49, N48, N47, N46, N45, N44, N43, N42, N41, N40, N39, N38, 
        N37, N36, N35, N34, N33, N32, N31, N30, N29, N28, N27, N26, N25, N24, 
        N23, N22, N21, N20, N19, N18, N17, N16, N15, N14, N13, N12, N11, N10, 
        N9, N8, N7, N6}) );
  DFFARX1 out_valid_reg ( .D(n136), .CLK(clk), .RSTB(rst_n), .Q(out_valid) );
  DFFARX1 \acc_out_reg[63]  ( .D(n72), .CLK(clk), .RSTB(rst_n), .Q(acc_out[63]) );
  DFFARX1 \acc_out_reg[38]  ( .D(n97), .CLK(clk), .RSTB(rst_n), .Q(acc_out[38]) );
  DFFARX1 \acc_out_reg[39]  ( .D(n96), .CLK(clk), .RSTB(rst_n), .Q(acc_out[39]) );
  DFFARX1 \acc_out_reg[40]  ( .D(n95), .CLK(clk), .RSTB(rst_n), .Q(acc_out[40]) );
  DFFARX1 \acc_out_reg[41]  ( .D(n94), .CLK(clk), .RSTB(rst_n), .Q(acc_out[41]) );
  DFFARX1 \acc_out_reg[42]  ( .D(n93), .CLK(clk), .RSTB(rst_n), .Q(acc_out[42]) );
  DFFARX1 \acc_out_reg[43]  ( .D(n92), .CLK(clk), .RSTB(rst_n), .Q(acc_out[43]) );
  DFFARX1 \acc_out_reg[44]  ( .D(n91), .CLK(clk), .RSTB(rst_n), .Q(acc_out[44]) );
  DFFARX1 \acc_out_reg[45]  ( .D(n90), .CLK(clk), .RSTB(rst_n), .Q(acc_out[45]) );
  DFFARX1 \acc_out_reg[46]  ( .D(n89), .CLK(clk), .RSTB(rst_n), .Q(acc_out[46]) );
  DFFARX1 \acc_out_reg[47]  ( .D(n88), .CLK(clk), .RSTB(rst_n), .Q(acc_out[47]) );
  DFFARX1 \acc_out_reg[48]  ( .D(n87), .CLK(clk), .RSTB(rst_n), .Q(acc_out[48]) );
  DFFARX1 \acc_out_reg[49]  ( .D(n86), .CLK(clk), .RSTB(rst_n), .Q(acc_out[49]) );
  DFFARX1 \acc_out_reg[50]  ( .D(n85), .CLK(clk), .RSTB(rst_n), .Q(acc_out[50]) );
  DFFARX1 \acc_out_reg[51]  ( .D(n84), .CLK(clk), .RSTB(rst_n), .Q(acc_out[51]) );
  DFFARX1 \acc_out_reg[52]  ( .D(n83), .CLK(clk), .RSTB(rst_n), .Q(acc_out[52]) );
  DFFARX1 \acc_out_reg[53]  ( .D(n82), .CLK(clk), .RSTB(rst_n), .Q(acc_out[53]) );
  DFFARX1 \acc_out_reg[54]  ( .D(n81), .CLK(clk), .RSTB(rst_n), .Q(acc_out[54]) );
  DFFARX1 \acc_out_reg[55]  ( .D(n80), .CLK(clk), .RSTB(rst_n), .Q(acc_out[55]) );
  DFFARX1 \acc_out_reg[56]  ( .D(n79), .CLK(clk), .RSTB(rst_n), .Q(acc_out[56]) );
  DFFARX1 \acc_out_reg[57]  ( .D(n78), .CLK(clk), .RSTB(rst_n), .Q(acc_out[57]) );
  DFFARX1 \acc_out_reg[58]  ( .D(n77), .CLK(clk), .RSTB(rst_n), .Q(acc_out[58]) );
  DFFARX1 \acc_out_reg[59]  ( .D(n76), .CLK(clk), .RSTB(rst_n), .Q(acc_out[59]) );
  DFFARX1 \acc_out_reg[60]  ( .D(n75), .CLK(clk), .RSTB(rst_n), .Q(acc_out[60]) );
  DFFARX1 \acc_out_reg[61]  ( .D(n74), .CLK(clk), .RSTB(rst_n), .Q(acc_out[61]) );
  DFFARX1 \acc_out_reg[62]  ( .D(n73), .CLK(clk), .RSTB(rst_n), .Q(acc_out[62]) );
  DFFARX1 \acc_out_reg[27]  ( .D(n108), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[27]) );
  DFFARX1 \acc_out_reg[28]  ( .D(n107), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[28]) );
  DFFARX1 \acc_out_reg[29]  ( .D(n106), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[29]) );
  DFFARX1 \acc_out_reg[30]  ( .D(n105), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[30]) );
  DFFARX1 \acc_out_reg[31]  ( .D(n104), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[31]) );
  DFFARX1 \acc_out_reg[32]  ( .D(n103), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[32]) );
  DFFARX1 \acc_out_reg[33]  ( .D(n102), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[33]) );
  DFFARX1 \acc_out_reg[34]  ( .D(n101), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[34]) );
  DFFARX1 \acc_out_reg[35]  ( .D(n100), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[35]) );
  DFFARX1 \acc_out_reg[36]  ( .D(n99), .CLK(clk), .RSTB(rst_n), .Q(acc_out[36]) );
  DFFARX1 \acc_out_reg[37]  ( .D(n98), .CLK(clk), .RSTB(rst_n), .Q(acc_out[37]) );
  DFFARX1 \acc_out_reg[19]  ( .D(n116), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[19]) );
  DFFARX1 \acc_out_reg[20]  ( .D(n115), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[20]) );
  DFFARX1 \acc_out_reg[21]  ( .D(n114), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[21]) );
  DFFARX1 \acc_out_reg[22]  ( .D(n113), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[22]) );
  DFFARX1 \acc_out_reg[23]  ( .D(n112), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[23]) );
  DFFARX1 \acc_out_reg[24]  ( .D(n111), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[24]) );
  DFFARX1 \acc_out_reg[25]  ( .D(n110), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[25]) );
  DFFARX1 \acc_out_reg[26]  ( .D(n109), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[26]) );
  DFFARX1 \acc_out_reg[10]  ( .D(n125), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[10]) );
  DFFARX1 \acc_out_reg[11]  ( .D(n124), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[11]) );
  DFFARX1 \acc_out_reg[12]  ( .D(n123), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[12]) );
  DFFARX1 \acc_out_reg[13]  ( .D(n122), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[13]) );
  DFFARX1 \acc_out_reg[14]  ( .D(n121), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[14]) );
  DFFARX1 \acc_out_reg[15]  ( .D(n120), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[15]) );
  DFFARX1 \acc_out_reg[16]  ( .D(n119), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[16]) );
  DFFARX1 \acc_out_reg[17]  ( .D(n118), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[17]) );
  DFFARX1 \acc_out_reg[18]  ( .D(n117), .CLK(clk), .RSTB(rst_n), .Q(
        acc_out[18]) );
  DFFARX1 \acc_out_reg[2]  ( .D(n133), .CLK(clk), .RSTB(rst_n), .Q(acc_out[2])
         );
  DFFARX1 \acc_out_reg[3]  ( .D(n132), .CLK(clk), .RSTB(rst_n), .Q(acc_out[3])
         );
  DFFARX1 \acc_out_reg[4]  ( .D(n131), .CLK(clk), .RSTB(rst_n), .Q(acc_out[4])
         );
  DFFARX1 \acc_out_reg[5]  ( .D(n130), .CLK(clk), .RSTB(rst_n), .Q(acc_out[5])
         );
  DFFARX1 \acc_out_reg[6]  ( .D(n129), .CLK(clk), .RSTB(rst_n), .Q(acc_out[6])
         );
  DFFARX1 \acc_out_reg[7]  ( .D(n128), .CLK(clk), .RSTB(rst_n), .Q(acc_out[7])
         );
  DFFARX1 \acc_out_reg[8]  ( .D(n127), .CLK(clk), .RSTB(rst_n), .Q(acc_out[8])
         );
  DFFARX1 \acc_out_reg[9]  ( .D(n126), .CLK(clk), .RSTB(rst_n), .Q(acc_out[9])
         );
  DFFARX1 \acc_out_reg[1]  ( .D(n134), .CLK(clk), .RSTB(rst_n), .Q(acc_out[1])
         );
  DFFARX1 \acc_out_reg[0]  ( .D(n135), .CLK(clk), .RSTB(rst_n), .Q(acc_out[0])
         );
  AO22X1 U73 ( .IN1(acc_out[63]), .IN2(n202), .IN3(N69), .IN4(n204), .Q(n72)
         );
  ISOLANDX1 U74 ( .D(n70), .ISO(n203), .Q(n204) );
  ISOLANDX1 U75 ( .D(n70), .ISO(n68), .Q(n69) );
  ISOLANDX1 U76 ( .D(n70), .ISO(n203), .Q(n205) );
  AO22X1 U77 ( .IN1(acc_out[62]), .IN2(n68), .IN3(N68), .IN4(n69), .Q(n73) );
  AO22X1 U78 ( .IN1(acc_out[60]), .IN2(n202), .IN3(N66), .IN4(n204), .Q(n75)
         );
  AO22X1 U79 ( .IN1(acc_out[59]), .IN2(n68), .IN3(N65), .IN4(n69), .Q(n76) );
  AO22X1 U80 ( .IN1(acc_out[57]), .IN2(n202), .IN3(N63), .IN4(n204), .Q(n78)
         );
  AO22X1 U81 ( .IN1(acc_out[56]), .IN2(n68), .IN3(N62), .IN4(n69), .Q(n79) );
  AO22X1 U82 ( .IN1(acc_out[54]), .IN2(n202), .IN3(N60), .IN4(n204), .Q(n81)
         );
  AO22X1 U83 ( .IN1(acc_out[53]), .IN2(n68), .IN3(N59), .IN4(n69), .Q(n82) );
  AO22X1 U84 ( .IN1(acc_out[51]), .IN2(n202), .IN3(N57), .IN4(n204), .Q(n84)
         );
  AO22X1 U85 ( .IN1(acc_out[50]), .IN2(n68), .IN3(N56), .IN4(n69), .Q(n85) );
  AO22X1 U86 ( .IN1(acc_out[61]), .IN2(n203), .IN3(N67), .IN4(n205), .Q(n74)
         );
  AO22X1 U87 ( .IN1(acc_out[58]), .IN2(n203), .IN3(N64), .IN4(n205), .Q(n77)
         );
  AO22X1 U88 ( .IN1(acc_out[55]), .IN2(n203), .IN3(N61), .IN4(n205), .Q(n80)
         );
  AO22X1 U89 ( .IN1(acc_out[52]), .IN2(n203), .IN3(N58), .IN4(n205), .Q(n83)
         );
  AO22X1 U90 ( .IN1(acc_out[49]), .IN2(n203), .IN3(N55), .IN4(n205), .Q(n86)
         );
  AO22X1 U91 ( .IN1(acc_out[48]), .IN2(n202), .IN3(N54), .IN4(n204), .Q(n87)
         );
  AO22X1 U92 ( .IN1(acc_out[47]), .IN2(n68), .IN3(N53), .IN4(n69), .Q(n88) );
  AO22X1 U93 ( .IN1(acc_out[45]), .IN2(n202), .IN3(N51), .IN4(n204), .Q(n90)
         );
  AO22X1 U94 ( .IN1(acc_out[44]), .IN2(n68), .IN3(N50), .IN4(n69), .Q(n91) );
  AO22X1 U95 ( .IN1(acc_out[42]), .IN2(n202), .IN3(N48), .IN4(n204), .Q(n93)
         );
  AO22X1 U96 ( .IN1(acc_out[41]), .IN2(n68), .IN3(N47), .IN4(n69), .Q(n94) );
  AO22X1 U97 ( .IN1(acc_out[39]), .IN2(n202), .IN3(N45), .IN4(n204), .Q(n96)
         );
  AO22X1 U98 ( .IN1(acc_out[38]), .IN2(n68), .IN3(N44), .IN4(n69), .Q(n97) );
  AO22X1 U99 ( .IN1(acc_out[36]), .IN2(n202), .IN3(N42), .IN4(n204), .Q(n99)
         );
  AO22X1 U100 ( .IN1(acc_out[35]), .IN2(n68), .IN3(N41), .IN4(n69), .Q(n100)
         );
  AO22X1 U101 ( .IN1(acc_out[33]), .IN2(n202), .IN3(N39), .IN4(n204), .Q(n102)
         );
  AO22X1 U102 ( .IN1(acc_out[32]), .IN2(n68), .IN3(N38), .IN4(n69), .Q(n103)
         );
  AO22X1 U103 ( .IN1(acc_out[46]), .IN2(n203), .IN3(N52), .IN4(n205), .Q(n89)
         );
  AO22X1 U104 ( .IN1(acc_out[43]), .IN2(n203), .IN3(N49), .IN4(n205), .Q(n92)
         );
  AO22X1 U105 ( .IN1(acc_out[40]), .IN2(n203), .IN3(N46), .IN4(n205), .Q(n95)
         );
  AO22X1 U106 ( .IN1(acc_out[37]), .IN2(n203), .IN3(N43), .IN4(n205), .Q(n98)
         );
  AO22X1 U107 ( .IN1(acc_out[34]), .IN2(n203), .IN3(N40), .IN4(n205), .Q(n101)
         );
  AO22X1 U108 ( .IN1(acc_out[31]), .IN2(n203), .IN3(N37), .IN4(n205), .Q(n104)
         );
  AO22X1 U109 ( .IN1(acc_out[30]), .IN2(n202), .IN3(N36), .IN4(n204), .Q(n105)
         );
  AO22X1 U110 ( .IN1(acc_out[29]), .IN2(n68), .IN3(N35), .IN4(n69), .Q(n106)
         );
  AO22X1 U111 ( .IN1(acc_out[27]), .IN2(n202), .IN3(N33), .IN4(n204), .Q(n108)
         );
  AO22X1 U112 ( .IN1(acc_out[26]), .IN2(n68), .IN3(N32), .IN4(n69), .Q(n109)
         );
  AO22X1 U113 ( .IN1(acc_out[24]), .IN2(n202), .IN3(N30), .IN4(n204), .Q(n111)
         );
  AO22X1 U114 ( .IN1(acc_out[23]), .IN2(n68), .IN3(N29), .IN4(n69), .Q(n112)
         );
  AO22X1 U115 ( .IN1(acc_out[28]), .IN2(n203), .IN3(N34), .IN4(n205), .Q(n107)
         );
  AO22X1 U116 ( .IN1(acc_out[25]), .IN2(n203), .IN3(N31), .IN4(n205), .Q(n110)
         );
  AO22X1 U117 ( .IN1(acc_out[22]), .IN2(n203), .IN3(N28), .IN4(n205), .Q(n113)
         );
  AO22X1 U118 ( .IN1(acc_out[21]), .IN2(n202), .IN3(N27), .IN4(n204), .Q(n114)
         );
  AO22X1 U119 ( .IN1(acc_out[20]), .IN2(n68), .IN3(N26), .IN4(n69), .Q(n115)
         );
  AO22X1 U120 ( .IN1(acc_out[18]), .IN2(n202), .IN3(N24), .IN4(n204), .Q(n117)
         );
  AO22X1 U121 ( .IN1(acc_out[17]), .IN2(n68), .IN3(N23), .IN4(n69), .Q(n118)
         );
  AO22X1 U122 ( .IN1(acc_out[15]), .IN2(n202), .IN3(N21), .IN4(n204), .Q(n120)
         );
  AO22X1 U123 ( .IN1(acc_out[14]), .IN2(n68), .IN3(N20), .IN4(n69), .Q(n121)
         );
  AO22X1 U124 ( .IN1(acc_out[19]), .IN2(n203), .IN3(N25), .IN4(n205), .Q(n116)
         );
  AO22X1 U125 ( .IN1(acc_out[16]), .IN2(n203), .IN3(N22), .IN4(n205), .Q(n119)
         );
  AO22X1 U126 ( .IN1(acc_out[12]), .IN2(n202), .IN3(N18), .IN4(n204), .Q(n123)
         );
  AO22X1 U127 ( .IN1(acc_out[11]), .IN2(n68), .IN3(N17), .IN4(n69), .Q(n124)
         );
  AO22X1 U128 ( .IN1(acc_out[9]), .IN2(n202), .IN3(N15), .IN4(n204), .Q(n126)
         );
  AO22X1 U129 ( .IN1(acc_out[8]), .IN2(n68), .IN3(N14), .IN4(n69), .Q(n127) );
  AO22X1 U130 ( .IN1(acc_out[6]), .IN2(n202), .IN3(N12), .IN4(n204), .Q(n129)
         );
  AO22X1 U131 ( .IN1(acc_out[13]), .IN2(n203), .IN3(N19), .IN4(n205), .Q(n122)
         );
  AO22X1 U132 ( .IN1(acc_out[10]), .IN2(n203), .IN3(N16), .IN4(n205), .Q(n125)
         );
  AO22X1 U133 ( .IN1(acc_out[7]), .IN2(n203), .IN3(N13), .IN4(n205), .Q(n128)
         );
  AOI21X1 U134 ( .IN1(in_valid), .IN2(n70), .IN3(clear), .QN(n203) );
  AOI21X1 U135 ( .IN1(in_valid), .IN2(n70), .IN3(clear), .QN(n202) );
  AOI21X1 U136 ( .IN1(in_valid), .IN2(n70), .IN3(clear), .QN(n68) );
  AO22X1 U137 ( .IN1(acc_out[5]), .IN2(n68), .IN3(N11), .IN4(n69), .Q(n130) );
  AO22X1 U138 ( .IN1(acc_out[3]), .IN2(n202), .IN3(N9), .IN4(n204), .Q(n132)
         );
  AO22X1 U139 ( .IN1(acc_out[2]), .IN2(n68), .IN3(N8), .IN4(n69), .Q(n133) );
  AO22X1 U140 ( .IN1(acc_out[0]), .IN2(n202), .IN3(N6), .IN4(n204), .Q(n135)
         );
  AO22X1 U141 ( .IN1(acc_out[4]), .IN2(n203), .IN3(N10), .IN4(n205), .Q(n131)
         );
  AO22X1 U142 ( .IN1(acc_out[1]), .IN2(n203), .IN3(N7), .IN4(n205), .Q(n134)
         );
  AO22X1 U143 ( .IN1(in_valid), .IN2(n70), .IN3(n71), .IN4(out_valid), .Q(n136) );
  NOR2X0 U144 ( .IN1(clear), .IN2(n70), .QN(n71) );
  ISOLANDX1 U145 ( .D(ena), .ISO(clear), .Q(n70) );
endmodule

