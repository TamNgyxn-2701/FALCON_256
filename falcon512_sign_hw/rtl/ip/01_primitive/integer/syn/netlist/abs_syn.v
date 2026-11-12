
module abs_DW01_inc_0 ( A, SUM );
  input [31:0] A;
  output [31:0] SUM;

  wire   [31:2] carry;

  HADDX1 U1_1_30 ( .A0(A[30]), .B0(carry[30]), .C1(carry[31]), .SO(SUM[30]) );
  HADDX1 U1_1_29 ( .A0(A[29]), .B0(carry[29]), .C1(carry[30]), .SO(SUM[29]) );
  HADDX1 U1_1_28 ( .A0(A[28]), .B0(carry[28]), .C1(carry[29]), .SO(SUM[28]) );
  HADDX1 U1_1_27 ( .A0(A[27]), .B0(carry[27]), .C1(carry[28]), .SO(SUM[27]) );
  HADDX1 U1_1_26 ( .A0(A[26]), .B0(carry[26]), .C1(carry[27]), .SO(SUM[26]) );
  HADDX1 U1_1_25 ( .A0(A[25]), .B0(carry[25]), .C1(carry[26]), .SO(SUM[25]) );
  HADDX1 U1_1_24 ( .A0(A[24]), .B0(carry[24]), .C1(carry[25]), .SO(SUM[24]) );
  HADDX1 U1_1_23 ( .A0(A[23]), .B0(carry[23]), .C1(carry[24]), .SO(SUM[23]) );
  HADDX1 U1_1_22 ( .A0(A[22]), .B0(carry[22]), .C1(carry[23]), .SO(SUM[22]) );
  HADDX1 U1_1_21 ( .A0(A[21]), .B0(carry[21]), .C1(carry[22]), .SO(SUM[21]) );
  HADDX1 U1_1_20 ( .A0(A[20]), .B0(carry[20]), .C1(carry[21]), .SO(SUM[20]) );
  HADDX1 U1_1_19 ( .A0(A[19]), .B0(carry[19]), .C1(carry[20]), .SO(SUM[19]) );
  HADDX1 U1_1_18 ( .A0(A[18]), .B0(carry[18]), .C1(carry[19]), .SO(SUM[18]) );
  HADDX1 U1_1_17 ( .A0(A[17]), .B0(carry[17]), .C1(carry[18]), .SO(SUM[17]) );
  HADDX1 U1_1_16 ( .A0(A[16]), .B0(carry[16]), .C1(carry[17]), .SO(SUM[16]) );
  HADDX1 U1_1_15 ( .A0(A[15]), .B0(carry[15]), .C1(carry[16]), .SO(SUM[15]) );
  HADDX1 U1_1_14 ( .A0(A[14]), .B0(carry[14]), .C1(carry[15]), .SO(SUM[14]) );
  HADDX1 U1_1_13 ( .A0(A[13]), .B0(carry[13]), .C1(carry[14]), .SO(SUM[13]) );
  HADDX1 U1_1_12 ( .A0(A[12]), .B0(carry[12]), .C1(carry[13]), .SO(SUM[12]) );
  HADDX1 U1_1_11 ( .A0(A[11]), .B0(carry[11]), .C1(carry[12]), .SO(SUM[11]) );
  HADDX1 U1_1_10 ( .A0(A[10]), .B0(carry[10]), .C1(carry[11]), .SO(SUM[10]) );
  HADDX1 U1_1_9 ( .A0(A[9]), .B0(carry[9]), .C1(carry[10]), .SO(SUM[9]) );
  HADDX1 U1_1_8 ( .A0(A[8]), .B0(carry[8]), .C1(carry[9]), .SO(SUM[8]) );
  HADDX1 U1_1_7 ( .A0(A[7]), .B0(carry[7]), .C1(carry[8]), .SO(SUM[7]) );
  HADDX1 U1_1_6 ( .A0(A[6]), .B0(carry[6]), .C1(carry[7]), .SO(SUM[6]) );
  HADDX1 U1_1_5 ( .A0(A[5]), .B0(carry[5]), .C1(carry[6]), .SO(SUM[5]) );
  HADDX1 U1_1_4 ( .A0(A[4]), .B0(carry[4]), .C1(carry[5]), .SO(SUM[4]) );
  HADDX1 U1_1_3 ( .A0(A[3]), .B0(carry[3]), .C1(carry[4]), .SO(SUM[3]) );
  HADDX1 U1_1_2 ( .A0(A[2]), .B0(carry[2]), .C1(carry[3]), .SO(SUM[2]) );
  HADDX1 U1_1_1 ( .A0(A[1]), .B0(A[0]), .C1(carry[2]), .SO(SUM[1]) );
  INVX0 U1 ( .IN(A[0]), .QN(SUM[0]) );
  XOR2X1 U2 ( .IN1(carry[31]), .IN2(A[31]), .Q(SUM[31]) );
endmodule


module abs ( a, abs_out );
  input [31:0] a;
  output [31:0] abs_out;
  wire   N34, N35, N36, N37, N38, N39, N40, N41, N42, N43, N44, N45, N46, N47,
         N48, N49, N50, N51, N52, N53, N54, N55, N56, N57, N58, N59, N60, N61,
         N62, N63, N64, N65, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42,
         n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56,
         n57, n58, n59, n60, n61, n62, n63, n64;

  abs_DW01_inc_0 add_15 ( .A({n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, 
        n43, n44, n45, n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, 
        n57, n58, n59, n60, n61, n62, n63, n64}), .SUM({N65, N64, N63, N62, 
        N61, N60, N59, N58, N57, N56, N55, N54, N53, N52, N51, N50, N49, N48, 
        N47, N46, N45, N44, N43, N42, N41, N40, N39, N38, N37, N36, N35, N34})
         );
  ISOLANDX1 U66 ( .D(N65), .ISO(n33), .Q(abs_out[31]) );
  AO22X1 U67 ( .IN1(a[23]), .IN2(n33), .IN3(N57), .IN4(a[31]), .Q(abs_out[23])
         );
  AO22X1 U68 ( .IN1(a[24]), .IN2(n33), .IN3(N58), .IN4(a[31]), .Q(abs_out[24])
         );
  AO22X1 U69 ( .IN1(a[25]), .IN2(n33), .IN3(N59), .IN4(a[31]), .Q(abs_out[25])
         );
  AO22X1 U70 ( .IN1(a[26]), .IN2(n33), .IN3(N60), .IN4(a[31]), .Q(abs_out[26])
         );
  AO22X1 U71 ( .IN1(a[27]), .IN2(n33), .IN3(N61), .IN4(a[31]), .Q(abs_out[27])
         );
  AO22X1 U72 ( .IN1(a[28]), .IN2(n33), .IN3(N62), .IN4(a[31]), .Q(abs_out[28])
         );
  AO22X1 U73 ( .IN1(a[29]), .IN2(n33), .IN3(N63), .IN4(a[31]), .Q(abs_out[29])
         );
  AO22X1 U74 ( .IN1(a[30]), .IN2(n33), .IN3(N64), .IN4(a[31]), .Q(abs_out[30])
         );
  INVX0 U75 ( .IN(a[1]), .QN(n63) );
  INVX0 U76 ( .IN(a[2]), .QN(n62) );
  INVX0 U77 ( .IN(a[3]), .QN(n61) );
  INVX0 U78 ( .IN(a[4]), .QN(n60) );
  INVX0 U79 ( .IN(a[5]), .QN(n59) );
  INVX0 U80 ( .IN(a[6]), .QN(n58) );
  INVX0 U81 ( .IN(a[7]), .QN(n57) );
  INVX0 U82 ( .IN(a[8]), .QN(n56) );
  INVX0 U83 ( .IN(a[9]), .QN(n55) );
  INVX0 U84 ( .IN(a[10]), .QN(n54) );
  INVX0 U85 ( .IN(a[11]), .QN(n53) );
  INVX0 U86 ( .IN(a[12]), .QN(n52) );
  INVX0 U87 ( .IN(a[13]), .QN(n51) );
  INVX0 U88 ( .IN(a[14]), .QN(n50) );
  INVX0 U89 ( .IN(a[15]), .QN(n49) );
  INVX0 U90 ( .IN(a[16]), .QN(n48) );
  INVX0 U91 ( .IN(a[17]), .QN(n47) );
  INVX0 U92 ( .IN(a[18]), .QN(n46) );
  INVX0 U93 ( .IN(a[19]), .QN(n45) );
  INVX0 U94 ( .IN(a[20]), .QN(n44) );
  INVX0 U95 ( .IN(a[21]), .QN(n43) );
  INVX0 U96 ( .IN(a[22]), .QN(n42) );
  INVX0 U97 ( .IN(a[23]), .QN(n41) );
  INVX0 U98 ( .IN(a[24]), .QN(n40) );
  INVX0 U99 ( .IN(a[25]), .QN(n39) );
  INVX0 U100 ( .IN(a[26]), .QN(n38) );
  INVX0 U101 ( .IN(a[27]), .QN(n37) );
  INVX0 U102 ( .IN(a[28]), .QN(n36) );
  INVX0 U103 ( .IN(a[29]), .QN(n35) );
  INVX0 U104 ( .IN(a[30]), .QN(n34) );
  INVX0 U105 ( .IN(a[0]), .QN(n64) );
  AO22X1 U106 ( .IN1(a[15]), .IN2(n33), .IN3(N49), .IN4(a[31]), .Q(abs_out[15]) );
  AO22X1 U107 ( .IN1(a[16]), .IN2(n33), .IN3(N50), .IN4(a[31]), .Q(abs_out[16]) );
  AO22X1 U108 ( .IN1(a[17]), .IN2(n33), .IN3(N51), .IN4(a[31]), .Q(abs_out[17]) );
  AO22X1 U109 ( .IN1(a[18]), .IN2(n33), .IN3(N52), .IN4(a[31]), .Q(abs_out[18]) );
  AO22X1 U110 ( .IN1(a[19]), .IN2(n33), .IN3(N53), .IN4(a[31]), .Q(abs_out[19]) );
  AO22X1 U111 ( .IN1(a[20]), .IN2(n33), .IN3(N54), .IN4(a[31]), .Q(abs_out[20]) );
  AO22X1 U112 ( .IN1(a[21]), .IN2(n33), .IN3(N55), .IN4(a[31]), .Q(abs_out[21]) );
  AO22X1 U113 ( .IN1(a[22]), .IN2(n33), .IN3(N56), .IN4(a[31]), .Q(abs_out[22]) );
  AO22X1 U114 ( .IN1(a[7]), .IN2(n33), .IN3(N41), .IN4(a[31]), .Q(abs_out[7])
         );
  AO22X1 U115 ( .IN1(a[8]), .IN2(n33), .IN3(N42), .IN4(a[31]), .Q(abs_out[8])
         );
  AO22X1 U116 ( .IN1(a[9]), .IN2(n33), .IN3(N43), .IN4(a[31]), .Q(abs_out[9])
         );
  AO22X1 U117 ( .IN1(a[10]), .IN2(n33), .IN3(N44), .IN4(a[31]), .Q(abs_out[10]) );
  AO22X1 U118 ( .IN1(a[11]), .IN2(n33), .IN3(N45), .IN4(a[31]), .Q(abs_out[11]) );
  AO22X1 U119 ( .IN1(a[12]), .IN2(n33), .IN3(N46), .IN4(a[31]), .Q(abs_out[12]) );
  AO22X1 U120 ( .IN1(a[13]), .IN2(n33), .IN3(N47), .IN4(a[31]), .Q(abs_out[13]) );
  AO22X1 U121 ( .IN1(a[14]), .IN2(n33), .IN3(N48), .IN4(a[31]), .Q(abs_out[14]) );
  AO22X1 U122 ( .IN1(a[0]), .IN2(n33), .IN3(N34), .IN4(a[31]), .Q(abs_out[0])
         );
  AO22X1 U123 ( .IN1(a[1]), .IN2(n33), .IN3(N35), .IN4(a[31]), .Q(abs_out[1])
         );
  AO22X1 U124 ( .IN1(a[2]), .IN2(n33), .IN3(N36), .IN4(a[31]), .Q(abs_out[2])
         );
  AO22X1 U125 ( .IN1(a[3]), .IN2(n33), .IN3(N37), .IN4(a[31]), .Q(abs_out[3])
         );
  AO22X1 U126 ( .IN1(a[4]), .IN2(n33), .IN3(N38), .IN4(a[31]), .Q(abs_out[4])
         );
  AO22X1 U127 ( .IN1(a[5]), .IN2(n33), .IN3(N39), .IN4(a[31]), .Q(abs_out[5])
         );
  AO22X1 U128 ( .IN1(a[6]), .IN2(n33), .IN3(N40), .IN4(a[31]), .Q(abs_out[6])
         );
  INVX0 U129 ( .IN(a[31]), .QN(n33) );
endmodule

