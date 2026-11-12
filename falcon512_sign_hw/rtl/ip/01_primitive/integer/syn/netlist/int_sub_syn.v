
module int_sub_DW01_sub_0 ( A, B, CI, DIFF, CO );
  input [32:0] A;
  input [32:0] B;
  output [32:0] DIFF;
  input CI;
  output CO;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16,
         n17, n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30,
         n31, n32, n33;
  wire   [33:0] carry;

  FADDX1 U2_1 ( .A(A[1]), .B(n32), .CI(carry[1]), .CO(carry[2]), .S(DIFF[1])
         );
  XOR3X1 U2_32 ( .IN1(A[32]), .IN2(n2), .IN3(carry[32]), .Q(DIFF[32]) );
  FADDX1 U2_31 ( .A(A[31]), .B(n2), .CI(carry[31]), .CO(carry[32]), .S(
        DIFF[31]) );
  FADDX1 U2_30 ( .A(A[30]), .B(n3), .CI(carry[30]), .CO(carry[31]), .S(
        DIFF[30]) );
  FADDX1 U2_29 ( .A(A[29]), .B(n4), .CI(carry[29]), .CO(carry[30]), .S(
        DIFF[29]) );
  FADDX1 U2_28 ( .A(A[28]), .B(n5), .CI(carry[28]), .CO(carry[29]), .S(
        DIFF[28]) );
  FADDX1 U2_27 ( .A(A[27]), .B(n6), .CI(carry[27]), .CO(carry[28]), .S(
        DIFF[27]) );
  FADDX1 U2_26 ( .A(A[26]), .B(n7), .CI(carry[26]), .CO(carry[27]), .S(
        DIFF[26]) );
  FADDX1 U2_25 ( .A(A[25]), .B(n8), .CI(carry[25]), .CO(carry[26]), .S(
        DIFF[25]) );
  FADDX1 U2_24 ( .A(A[24]), .B(n9), .CI(carry[24]), .CO(carry[25]), .S(
        DIFF[24]) );
  FADDX1 U2_23 ( .A(A[23]), .B(n10), .CI(carry[23]), .CO(carry[24]), .S(
        DIFF[23]) );
  FADDX1 U2_22 ( .A(A[22]), .B(n11), .CI(carry[22]), .CO(carry[23]), .S(
        DIFF[22]) );
  FADDX1 U2_21 ( .A(A[21]), .B(n12), .CI(carry[21]), .CO(carry[22]), .S(
        DIFF[21]) );
  FADDX1 U2_20 ( .A(A[20]), .B(n13), .CI(carry[20]), .CO(carry[21]), .S(
        DIFF[20]) );
  FADDX1 U2_19 ( .A(A[19]), .B(n14), .CI(carry[19]), .CO(carry[20]), .S(
        DIFF[19]) );
  FADDX1 U2_18 ( .A(A[18]), .B(n15), .CI(carry[18]), .CO(carry[19]), .S(
        DIFF[18]) );
  FADDX1 U2_17 ( .A(A[17]), .B(n16), .CI(carry[17]), .CO(carry[18]), .S(
        DIFF[17]) );
  FADDX1 U2_16 ( .A(A[16]), .B(n17), .CI(carry[16]), .CO(carry[17]), .S(
        DIFF[16]) );
  FADDX1 U2_15 ( .A(A[15]), .B(n18), .CI(carry[15]), .CO(carry[16]), .S(
        DIFF[15]) );
  FADDX1 U2_14 ( .A(A[14]), .B(n19), .CI(carry[14]), .CO(carry[15]), .S(
        DIFF[14]) );
  FADDX1 U2_13 ( .A(A[13]), .B(n20), .CI(carry[13]), .CO(carry[14]), .S(
        DIFF[13]) );
  FADDX1 U2_12 ( .A(A[12]), .B(n21), .CI(carry[12]), .CO(carry[13]), .S(
        DIFF[12]) );
  FADDX1 U2_11 ( .A(A[11]), .B(n22), .CI(carry[11]), .CO(carry[12]), .S(
        DIFF[11]) );
  FADDX1 U2_10 ( .A(A[10]), .B(n23), .CI(carry[10]), .CO(carry[11]), .S(
        DIFF[10]) );
  FADDX1 U2_9 ( .A(A[9]), .B(n24), .CI(carry[9]), .CO(carry[10]), .S(DIFF[9])
         );
  FADDX1 U2_8 ( .A(A[8]), .B(n25), .CI(carry[8]), .CO(carry[9]), .S(DIFF[8])
         );
  FADDX1 U2_7 ( .A(A[7]), .B(n26), .CI(carry[7]), .CO(carry[8]), .S(DIFF[7])
         );
  FADDX1 U2_6 ( .A(A[6]), .B(n27), .CI(carry[6]), .CO(carry[7]), .S(DIFF[6])
         );
  FADDX1 U2_5 ( .A(A[5]), .B(n28), .CI(carry[5]), .CO(carry[6]), .S(DIFF[5])
         );
  FADDX1 U2_4 ( .A(A[4]), .B(n29), .CI(carry[4]), .CO(carry[5]), .S(DIFF[4])
         );
  FADDX1 U2_3 ( .A(A[3]), .B(n30), .CI(carry[3]), .CO(carry[4]), .S(DIFF[3])
         );
  FADDX1 U2_2 ( .A(A[2]), .B(n31), .CI(carry[2]), .CO(carry[3]), .S(DIFF[2])
         );
  XOR2X1 U1 ( .IN1(n1), .IN2(n33), .Q(DIFF[0]) );
  INVX0 U2 ( .IN(B[2]), .QN(n31) );
  INVX0 U3 ( .IN(B[3]), .QN(n30) );
  INVX0 U4 ( .IN(B[4]), .QN(n29) );
  INVX0 U5 ( .IN(B[5]), .QN(n28) );
  INVX0 U6 ( .IN(B[6]), .QN(n27) );
  INVX0 U7 ( .IN(B[7]), .QN(n26) );
  INVX0 U8 ( .IN(B[8]), .QN(n25) );
  INVX0 U9 ( .IN(B[9]), .QN(n24) );
  INVX0 U10 ( .IN(B[10]), .QN(n23) );
  INVX0 U11 ( .IN(B[11]), .QN(n22) );
  INVX0 U12 ( .IN(B[12]), .QN(n21) );
  INVX0 U13 ( .IN(B[13]), .QN(n20) );
  INVX0 U14 ( .IN(B[14]), .QN(n19) );
  INVX0 U15 ( .IN(B[15]), .QN(n18) );
  INVX0 U16 ( .IN(B[16]), .QN(n17) );
  INVX0 U17 ( .IN(B[17]), .QN(n16) );
  INVX0 U18 ( .IN(B[18]), .QN(n15) );
  INVX0 U19 ( .IN(B[19]), .QN(n14) );
  INVX0 U20 ( .IN(B[20]), .QN(n13) );
  INVX0 U21 ( .IN(B[21]), .QN(n12) );
  INVX0 U22 ( .IN(B[22]), .QN(n11) );
  INVX0 U23 ( .IN(B[23]), .QN(n10) );
  INVX0 U24 ( .IN(B[24]), .QN(n9) );
  INVX0 U25 ( .IN(B[25]), .QN(n8) );
  INVX0 U26 ( .IN(B[26]), .QN(n7) );
  INVX0 U27 ( .IN(B[27]), .QN(n6) );
  INVX0 U28 ( .IN(B[28]), .QN(n5) );
  INVX0 U29 ( .IN(B[29]), .QN(n4) );
  INVX0 U30 ( .IN(B[30]), .QN(n3) );
  INVX0 U31 ( .IN(B[1]), .QN(n32) );
  NAND2X0 U32 ( .IN1(B[0]), .IN2(n1), .QN(carry[1]) );
  INVX0 U33 ( .IN(B[0]), .QN(n33) );
  INVX0 U34 ( .IN(A[0]), .QN(n1) );
  INVX0 U35 ( .IN(B[32]), .QN(n2) );
endmodule


module int_sub ( a, b, diff );
  input [31:0] a;
  input [31:0] b;
  output [32:0] diff;


  int_sub_DW01_sub_0 sub_16 ( .A({a[31], a}), .B({b[31], b}), .CI(1'b0), 
        .DIFF(diff) );
endmodule

