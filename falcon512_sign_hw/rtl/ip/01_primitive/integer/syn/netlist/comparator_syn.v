
module comparator_DW01_cmp6_0 ( A, B, TC, LT, GT, EQ, LE, GE, NE );
  input [63:0] A;
  input [63:0] B;
  input TC;
  output LT, GT, EQ, LE, GE, NE;
  wire   n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17,
         n18, n19, n20, n21, n22, n23, n24, n25, n26, n27, n28, n29, n30, n31,
         n32, n33, n34, n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45,
         n46, n47, n48, n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59,
         n60, n61, n62, n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n73,
         n74, n75, n76, n77, n78, n79, n80, n81, n82, n83, n84, n85, n86, n87,
         n88, n89, n90, n91, n92, n93, n94, n95, n96, n97, n98, n99, n100,
         n101, n102, n103, n104, n105, n106, n107, n108, n109, n110, n111,
         n112, n113, n114, n115, n116, n117, n118, n119, n120, n121, n122,
         n123, n124, n125, n126, n127, n128, n129, n130, n131, n132, n133,
         n134, n135, n136, n137, n138, n139, n140, n141, n142, n143, n144,
         n145, n146, n147, n148, n149, n150, n151, n152, n153, n154, n155,
         n156, n157, n158, n159, n160, n161, n162, n163, n164, n165, n166,
         n167, n168, n169, n170, n171, n172, n173, n174, n175, n176, n177,
         n178, n179, n180, n181, n182, n183, n184, n185, n186, n187, n188,
         n189, n190, n191, n192, n193, n194, n195, n196, n197, n198, n199,
         n200, n201, n202, n203, n204, n205, n206, n207, n208, n209, n210,
         n211, n212, n213, n214, n215, n216, n217, n218, n219, n220, n221,
         n222, n223, n224, n225, n226, n227, n228, n229, n230, n231, n232,
         n233, n234, n235, n236, n237, n238, n239, n240, n241, n242, n243,
         n244, n245, n246, n247, n248, n249, n250, n251, n252, n253, n254,
         n255, n256, n257, n258, n259, n260, n261, n262, n263, n264, n265,
         n266, n267, n268, n269, n270, n271, n272, n273, n274, n275, n276,
         n277, n278, n279, n280, n281, n282, n283, n284, n285, n286, n287,
         n288, n289, n290, n291, n292, n293, n294, n295, n296, n297, n298,
         n299, n300, n301, n302, n303, n304, n305, n306, n307, n308, n309,
         n310, n311, n312, n313, n314, n315, n316, n317, n318, n319, n320,
         n321, n322, n323, n324, n325, n326, n327, n328, n329, n330, n331,
         n332, n333, n334, n335, n336, n337, n338, n339, n340, n341, n342,
         n343, n344, n345, n346, n347, n348, n349, n350;

  INVX0 U1 ( .IN(n350), .QN(n36) );
  INVX0 U2 ( .IN(GE), .QN(LT) );
  INVX0 U3 ( .IN(GT), .QN(LE) );
  INVX0 U4 ( .IN(A[62]), .QN(n4) );
  INVX0 U5 ( .IN(B[0]), .QN(n69) );
  INVX0 U6 ( .IN(B[62]), .QN(n37) );
  INVX0 U7 ( .IN(A[1]), .QN(n35) );
  INVX0 U8 ( .IN(A[2]), .QN(n34) );
  INVX0 U9 ( .IN(B[3]), .QN(n67) );
  INVX0 U10 ( .IN(A[4]), .QN(n33) );
  INVX0 U11 ( .IN(A[6]), .QN(n32) );
  INVX0 U12 ( .IN(B[5]), .QN(n66) );
  INVX0 U13 ( .IN(B[7]), .QN(n65) );
  INVX0 U14 ( .IN(A[8]), .QN(n31) );
  INVX0 U15 ( .IN(A[10]), .QN(n30) );
  INVX0 U16 ( .IN(B[9]), .QN(n64) );
  INVX0 U17 ( .IN(B[11]), .QN(n63) );
  INVX0 U18 ( .IN(A[12]), .QN(n29) );
  INVX0 U19 ( .IN(A[14]), .QN(n28) );
  INVX0 U20 ( .IN(B[13]), .QN(n62) );
  INVX0 U21 ( .IN(B[15]), .QN(n61) );
  INVX0 U22 ( .IN(A[16]), .QN(n27) );
  INVX0 U23 ( .IN(A[18]), .QN(n26) );
  INVX0 U24 ( .IN(B[17]), .QN(n60) );
  INVX0 U25 ( .IN(B[19]), .QN(n59) );
  INVX0 U26 ( .IN(A[20]), .QN(n25) );
  INVX0 U27 ( .IN(A[22]), .QN(n24) );
  INVX0 U28 ( .IN(B[21]), .QN(n58) );
  INVX0 U29 ( .IN(A[24]), .QN(n23) );
  INVX0 U30 ( .IN(B[1]), .QN(n68) );
  INVX0 U31 ( .IN(B[23]), .QN(n57) );
  INVX0 U32 ( .IN(A[26]), .QN(n22) );
  INVX0 U33 ( .IN(B[25]), .QN(n56) );
  INVX0 U34 ( .IN(B[27]), .QN(n55) );
  INVX0 U35 ( .IN(A[28]), .QN(n21) );
  INVX0 U36 ( .IN(A[30]), .QN(n20) );
  INVX0 U37 ( .IN(B[29]), .QN(n54) );
  INVX0 U38 ( .IN(B[31]), .QN(n53) );
  INVX0 U39 ( .IN(A[32]), .QN(n19) );
  INVX0 U40 ( .IN(A[34]), .QN(n18) );
  INVX0 U41 ( .IN(B[33]), .QN(n52) );
  INVX0 U42 ( .IN(B[35]), .QN(n51) );
  INVX0 U43 ( .IN(A[36]), .QN(n17) );
  INVX0 U44 ( .IN(A[38]), .QN(n16) );
  INVX0 U45 ( .IN(B[37]), .QN(n50) );
  INVX0 U46 ( .IN(B[39]), .QN(n49) );
  INVX0 U47 ( .IN(A[40]), .QN(n15) );
  INVX0 U48 ( .IN(A[42]), .QN(n14) );
  INVX0 U49 ( .IN(B[41]), .QN(n48) );
  INVX0 U50 ( .IN(B[43]), .QN(n47) );
  INVX0 U51 ( .IN(A[44]), .QN(n13) );
  INVX0 U52 ( .IN(A[46]), .QN(n12) );
  INVX0 U53 ( .IN(B[45]), .QN(n46) );
  INVX0 U54 ( .IN(B[47]), .QN(n45) );
  INVX0 U55 ( .IN(A[48]), .QN(n11) );
  INVX0 U56 ( .IN(A[50]), .QN(n10) );
  INVX0 U57 ( .IN(B[49]), .QN(n44) );
  INVX0 U58 ( .IN(B[51]), .QN(n43) );
  INVX0 U59 ( .IN(A[52]), .QN(n9) );
  INVX0 U60 ( .IN(A[54]), .QN(n8) );
  INVX0 U61 ( .IN(B[53]), .QN(n42) );
  INVX0 U62 ( .IN(B[55]), .QN(n41) );
  INVX0 U63 ( .IN(A[56]), .QN(n7) );
  INVX0 U64 ( .IN(A[58]), .QN(n6) );
  INVX0 U65 ( .IN(B[57]), .QN(n40) );
  INVX0 U66 ( .IN(B[59]), .QN(n39) );
  INVX0 U67 ( .IN(A[60]), .QN(n5) );
  INVX0 U68 ( .IN(B[61]), .QN(n38) );
  INVX0 U69 ( .IN(A[63]), .QN(n3) );
  NOR2X0 U70 ( .IN1(LT), .IN2(GT), .QN(EQ) );
  AO21X1 U71 ( .IN1(n70), .IN2(n71), .IN3(n72), .Q(GT) );
  OAI22X1 U72 ( .IN1(B[62]), .IN2(n4), .IN3(n73), .IN4(n74), .QN(n71) );
  NAND2X0 U73 ( .IN1(n75), .IN2(n76), .QN(n74) );
  NAND3X0 U74 ( .IN1(n77), .IN2(n78), .IN3(n79), .QN(n75) );
  NAND3X0 U75 ( .IN1(n80), .IN2(n81), .IN3(n82), .QN(n79) );
  NAND3X0 U76 ( .IN1(n83), .IN2(n84), .IN3(n85), .QN(n80) );
  NAND3X0 U77 ( .IN1(n86), .IN2(n87), .IN3(n88), .QN(n85) );
  NAND3X0 U78 ( .IN1(n89), .IN2(n90), .IN3(n91), .QN(n86) );
  NAND3X0 U79 ( .IN1(n92), .IN2(n93), .IN3(n94), .QN(n91) );
  NAND3X0 U80 ( .IN1(n95), .IN2(n96), .IN3(n97), .QN(n92) );
  NAND3X0 U81 ( .IN1(n98), .IN2(n99), .IN3(n100), .QN(n97) );
  NAND3X0 U82 ( .IN1(n101), .IN2(n102), .IN3(n103), .QN(n98) );
  NAND3X0 U83 ( .IN1(n104), .IN2(n105), .IN3(n106), .QN(n103) );
  NAND3X0 U84 ( .IN1(n107), .IN2(n108), .IN3(n109), .QN(n104) );
  NAND3X0 U85 ( .IN1(n110), .IN2(n111), .IN3(n112), .QN(n109) );
  NAND3X0 U86 ( .IN1(n113), .IN2(n114), .IN3(n115), .QN(n110) );
  NAND3X0 U87 ( .IN1(n116), .IN2(n117), .IN3(n118), .QN(n115) );
  NAND3X0 U88 ( .IN1(n119), .IN2(n120), .IN3(n121), .QN(n116) );
  NAND3X0 U89 ( .IN1(n122), .IN2(n123), .IN3(n124), .QN(n121) );
  NAND3X0 U90 ( .IN1(n125), .IN2(n126), .IN3(n127), .QN(n122) );
  NAND3X0 U91 ( .IN1(n128), .IN2(n129), .IN3(n130), .QN(n127) );
  NAND3X0 U92 ( .IN1(n131), .IN2(n132), .IN3(n133), .QN(n128) );
  NAND3X0 U93 ( .IN1(n134), .IN2(n135), .IN3(n136), .QN(n133) );
  NAND3X0 U94 ( .IN1(n137), .IN2(n138), .IN3(n139), .QN(n134) );
  NAND3X0 U95 ( .IN1(n140), .IN2(n141), .IN3(n142), .QN(n139) );
  NAND3X0 U96 ( .IN1(n143), .IN2(n144), .IN3(n145), .QN(n140) );
  NAND3X0 U97 ( .IN1(n146), .IN2(n147), .IN3(n148), .QN(n145) );
  NAND3X0 U98 ( .IN1(n149), .IN2(n150), .IN3(n151), .QN(n146) );
  NAND3X0 U99 ( .IN1(n152), .IN2(n153), .IN3(n154), .QN(n151) );
  NAND3X0 U100 ( .IN1(n155), .IN2(n156), .IN3(n157), .QN(n152) );
  NAND3X0 U101 ( .IN1(n158), .IN2(n159), .IN3(n160), .QN(n157) );
  NAND3X0 U102 ( .IN1(n161), .IN2(n162), .IN3(n163), .QN(n158) );
  NAND3X0 U103 ( .IN1(n164), .IN2(n165), .IN3(n166), .QN(n163) );
  NAND3X0 U104 ( .IN1(n167), .IN2(n168), .IN3(n169), .QN(n164) );
  NAND3X0 U105 ( .IN1(n170), .IN2(n171), .IN3(n172), .QN(n169) );
  NAND3X0 U106 ( .IN1(n173), .IN2(n174), .IN3(n175), .QN(n170) );
  NAND3X0 U107 ( .IN1(n176), .IN2(n177), .IN3(n178), .QN(n175) );
  NAND3X0 U108 ( .IN1(n179), .IN2(n180), .IN3(n181), .QN(n176) );
  NAND3X0 U109 ( .IN1(n182), .IN2(n183), .IN3(n184), .QN(n181) );
  NAND3X0 U110 ( .IN1(n185), .IN2(n186), .IN3(n187), .QN(n182) );
  NAND3X0 U111 ( .IN1(n188), .IN2(n189), .IN3(n190), .QN(n187) );
  NAND3X0 U112 ( .IN1(n191), .IN2(n192), .IN3(n193), .QN(n188) );
  NAND3X0 U113 ( .IN1(n194), .IN2(n195), .IN3(n196), .QN(n193) );
  NAND3X0 U114 ( .IN1(n197), .IN2(n198), .IN3(n199), .QN(n194) );
  NAND3X0 U115 ( .IN1(n200), .IN2(n201), .IN3(n202), .QN(n199) );
  NAND3X0 U116 ( .IN1(n203), .IN2(n204), .IN3(n205), .QN(n200) );
  NAND3X0 U117 ( .IN1(n206), .IN2(n207), .IN3(n208), .QN(n205) );
  NAND3X0 U118 ( .IN1(n209), .IN2(n210), .IN3(n211), .QN(n206) );
  NAND3X0 U119 ( .IN1(n212), .IN2(n213), .IN3(n214), .QN(n211) );
  NAND3X0 U120 ( .IN1(n215), .IN2(n216), .IN3(n217), .QN(n212) );
  NAND3X0 U121 ( .IN1(n218), .IN2(n219), .IN3(n220), .QN(n217) );
  NAND3X0 U122 ( .IN1(n221), .IN2(n222), .IN3(n223), .QN(n218) );
  NAND3X0 U123 ( .IN1(n224), .IN2(n225), .IN3(n226), .QN(n223) );
  NAND3X0 U124 ( .IN1(n227), .IN2(n228), .IN3(n229), .QN(n224) );
  NAND3X0 U125 ( .IN1(n230), .IN2(n231), .IN3(n232), .QN(n229) );
  NAND3X0 U126 ( .IN1(n233), .IN2(n234), .IN3(n235), .QN(n230) );
  NAND3X0 U127 ( .IN1(n236), .IN2(n237), .IN3(n238), .QN(n235) );
  NAND3X0 U128 ( .IN1(n239), .IN2(n240), .IN3(n241), .QN(n236) );
  NAND3X0 U129 ( .IN1(n242), .IN2(n243), .IN3(n244), .QN(n241) );
  NAND3X0 U130 ( .IN1(n245), .IN2(n246), .IN3(n247), .QN(n242) );
  NAND3X0 U131 ( .IN1(n248), .IN2(n249), .IN3(n250), .QN(n247) );
  NAND3X0 U132 ( .IN1(n251), .IN2(n252), .IN3(n253), .QN(n248) );
  AO221X1 U133 ( .IN1(B[1]), .IN2(n254), .IN3(n255), .IN4(n35), .IN5(n256), 
        .Q(n253) );
  OR2X1 U134 ( .IN1(n255), .IN2(n35), .Q(n254) );
  NAND2X0 U135 ( .IN1(A[0]), .IN2(n69), .QN(n255) );
  OA21X1 U136 ( .IN1(n72), .IN2(n257), .IN3(n70), .Q(GE) );
  NAND2X0 U137 ( .IN1(B[63]), .IN2(n3), .QN(n70) );
  OA22X1 U138 ( .IN1(A[62]), .IN2(n37), .IN3(n73), .IN4(n258), .Q(n257) );
  NAND2X0 U139 ( .IN1(n259), .IN2(n77), .QN(n258) );
  NAND2X0 U140 ( .IN1(A[61]), .IN2(n38), .QN(n77) );
  NAND3X0 U141 ( .IN1(n260), .IN2(n261), .IN3(n76), .QN(n259) );
  OR2X1 U142 ( .IN1(n38), .IN2(A[61]), .Q(n76) );
  NAND3X0 U143 ( .IN1(n262), .IN2(n83), .IN3(n82), .QN(n260) );
  AND2X1 U144 ( .IN1(n78), .IN2(n261), .Q(n82) );
  NAND2X0 U145 ( .IN1(B[60]), .IN2(n5), .QN(n261) );
  OR2X1 U146 ( .IN1(n5), .IN2(B[60]), .Q(n78) );
  NAND2X0 U147 ( .IN1(A[59]), .IN2(n39), .QN(n83) );
  NAND3X0 U148 ( .IN1(n263), .IN2(n264), .IN3(n81), .QN(n262) );
  OR2X1 U149 ( .IN1(n39), .IN2(A[59]), .Q(n81) );
  NAND3X0 U150 ( .IN1(n265), .IN2(n89), .IN3(n88), .QN(n263) );
  AND2X1 U151 ( .IN1(n84), .IN2(n264), .Q(n88) );
  NAND2X0 U152 ( .IN1(B[58]), .IN2(n6), .QN(n264) );
  OR2X1 U153 ( .IN1(n6), .IN2(B[58]), .Q(n84) );
  NAND2X0 U154 ( .IN1(A[57]), .IN2(n40), .QN(n89) );
  NAND3X0 U155 ( .IN1(n266), .IN2(n267), .IN3(n87), .QN(n265) );
  OR2X1 U156 ( .IN1(n40), .IN2(A[57]), .Q(n87) );
  NAND3X0 U157 ( .IN1(n268), .IN2(n95), .IN3(n94), .QN(n266) );
  AND2X1 U158 ( .IN1(n90), .IN2(n267), .Q(n94) );
  NAND2X0 U159 ( .IN1(B[56]), .IN2(n7), .QN(n267) );
  OR2X1 U160 ( .IN1(n7), .IN2(B[56]), .Q(n90) );
  NAND2X0 U161 ( .IN1(A[55]), .IN2(n41), .QN(n95) );
  NAND3X0 U162 ( .IN1(n269), .IN2(n270), .IN3(n93), .QN(n268) );
  OR2X1 U163 ( .IN1(n41), .IN2(A[55]), .Q(n93) );
  NAND3X0 U164 ( .IN1(n271), .IN2(n101), .IN3(n100), .QN(n269) );
  AND2X1 U165 ( .IN1(n96), .IN2(n270), .Q(n100) );
  NAND2X0 U166 ( .IN1(B[54]), .IN2(n8), .QN(n270) );
  OR2X1 U167 ( .IN1(n8), .IN2(B[54]), .Q(n96) );
  NAND2X0 U168 ( .IN1(A[53]), .IN2(n42), .QN(n101) );
  NAND3X0 U169 ( .IN1(n272), .IN2(n273), .IN3(n99), .QN(n271) );
  OR2X1 U170 ( .IN1(n42), .IN2(A[53]), .Q(n99) );
  NAND3X0 U171 ( .IN1(n274), .IN2(n107), .IN3(n106), .QN(n272) );
  AND2X1 U172 ( .IN1(n102), .IN2(n273), .Q(n106) );
  NAND2X0 U173 ( .IN1(B[52]), .IN2(n9), .QN(n273) );
  OR2X1 U174 ( .IN1(n9), .IN2(B[52]), .Q(n102) );
  NAND2X0 U175 ( .IN1(A[51]), .IN2(n43), .QN(n107) );
  NAND3X0 U176 ( .IN1(n275), .IN2(n276), .IN3(n105), .QN(n274) );
  OR2X1 U177 ( .IN1(n43), .IN2(A[51]), .Q(n105) );
  NAND3X0 U178 ( .IN1(n277), .IN2(n113), .IN3(n112), .QN(n275) );
  AND2X1 U179 ( .IN1(n108), .IN2(n276), .Q(n112) );
  NAND2X0 U180 ( .IN1(B[50]), .IN2(n10), .QN(n276) );
  OR2X1 U181 ( .IN1(n10), .IN2(B[50]), .Q(n108) );
  NAND2X0 U182 ( .IN1(A[49]), .IN2(n44), .QN(n113) );
  NAND3X0 U183 ( .IN1(n278), .IN2(n279), .IN3(n111), .QN(n277) );
  OR2X1 U184 ( .IN1(n44), .IN2(A[49]), .Q(n111) );
  NAND3X0 U185 ( .IN1(n280), .IN2(n119), .IN3(n118), .QN(n278) );
  AND2X1 U186 ( .IN1(n114), .IN2(n279), .Q(n118) );
  NAND2X0 U187 ( .IN1(B[48]), .IN2(n11), .QN(n279) );
  OR2X1 U188 ( .IN1(n11), .IN2(B[48]), .Q(n114) );
  NAND2X0 U189 ( .IN1(A[47]), .IN2(n45), .QN(n119) );
  NAND3X0 U190 ( .IN1(n281), .IN2(n282), .IN3(n117), .QN(n280) );
  OR2X1 U191 ( .IN1(n45), .IN2(A[47]), .Q(n117) );
  NAND3X0 U192 ( .IN1(n283), .IN2(n125), .IN3(n124), .QN(n281) );
  AND2X1 U193 ( .IN1(n120), .IN2(n282), .Q(n124) );
  NAND2X0 U194 ( .IN1(B[46]), .IN2(n12), .QN(n282) );
  OR2X1 U195 ( .IN1(n12), .IN2(B[46]), .Q(n120) );
  NAND2X0 U196 ( .IN1(A[45]), .IN2(n46), .QN(n125) );
  NAND3X0 U197 ( .IN1(n284), .IN2(n285), .IN3(n123), .QN(n283) );
  OR2X1 U198 ( .IN1(n46), .IN2(A[45]), .Q(n123) );
  NAND3X0 U199 ( .IN1(n286), .IN2(n131), .IN3(n130), .QN(n284) );
  AND2X1 U200 ( .IN1(n126), .IN2(n285), .Q(n130) );
  NAND2X0 U201 ( .IN1(B[44]), .IN2(n13), .QN(n285) );
  OR2X1 U202 ( .IN1(n13), .IN2(B[44]), .Q(n126) );
  NAND2X0 U203 ( .IN1(A[43]), .IN2(n47), .QN(n131) );
  NAND3X0 U204 ( .IN1(n287), .IN2(n288), .IN3(n129), .QN(n286) );
  OR2X1 U205 ( .IN1(n47), .IN2(A[43]), .Q(n129) );
  NAND3X0 U206 ( .IN1(n289), .IN2(n137), .IN3(n136), .QN(n287) );
  AND2X1 U207 ( .IN1(n132), .IN2(n288), .Q(n136) );
  NAND2X0 U208 ( .IN1(B[42]), .IN2(n14), .QN(n288) );
  OR2X1 U209 ( .IN1(n14), .IN2(B[42]), .Q(n132) );
  NAND2X0 U210 ( .IN1(A[41]), .IN2(n48), .QN(n137) );
  NAND3X0 U211 ( .IN1(n290), .IN2(n291), .IN3(n135), .QN(n289) );
  OR2X1 U212 ( .IN1(n48), .IN2(A[41]), .Q(n135) );
  NAND3X0 U213 ( .IN1(n292), .IN2(n143), .IN3(n142), .QN(n290) );
  AND2X1 U214 ( .IN1(n138), .IN2(n291), .Q(n142) );
  NAND2X0 U215 ( .IN1(B[40]), .IN2(n15), .QN(n291) );
  OR2X1 U216 ( .IN1(n15), .IN2(B[40]), .Q(n138) );
  NAND2X0 U217 ( .IN1(A[39]), .IN2(n49), .QN(n143) );
  NAND3X0 U218 ( .IN1(n293), .IN2(n294), .IN3(n141), .QN(n292) );
  OR2X1 U219 ( .IN1(n49), .IN2(A[39]), .Q(n141) );
  NAND3X0 U220 ( .IN1(n295), .IN2(n149), .IN3(n148), .QN(n293) );
  AND2X1 U221 ( .IN1(n144), .IN2(n294), .Q(n148) );
  NAND2X0 U222 ( .IN1(B[38]), .IN2(n16), .QN(n294) );
  OR2X1 U223 ( .IN1(n16), .IN2(B[38]), .Q(n144) );
  NAND2X0 U224 ( .IN1(A[37]), .IN2(n50), .QN(n149) );
  NAND3X0 U225 ( .IN1(n296), .IN2(n297), .IN3(n147), .QN(n295) );
  OR2X1 U226 ( .IN1(n50), .IN2(A[37]), .Q(n147) );
  NAND3X0 U227 ( .IN1(n298), .IN2(n155), .IN3(n154), .QN(n296) );
  AND2X1 U228 ( .IN1(n150), .IN2(n297), .Q(n154) );
  NAND2X0 U229 ( .IN1(B[36]), .IN2(n17), .QN(n297) );
  OR2X1 U230 ( .IN1(n17), .IN2(B[36]), .Q(n150) );
  NAND2X0 U231 ( .IN1(A[35]), .IN2(n51), .QN(n155) );
  NAND3X0 U232 ( .IN1(n299), .IN2(n300), .IN3(n153), .QN(n298) );
  OR2X1 U233 ( .IN1(n51), .IN2(A[35]), .Q(n153) );
  NAND3X0 U234 ( .IN1(n301), .IN2(n161), .IN3(n160), .QN(n299) );
  AND2X1 U235 ( .IN1(n156), .IN2(n300), .Q(n160) );
  NAND2X0 U236 ( .IN1(B[34]), .IN2(n18), .QN(n300) );
  OR2X1 U237 ( .IN1(n18), .IN2(B[34]), .Q(n156) );
  NAND2X0 U238 ( .IN1(A[33]), .IN2(n52), .QN(n161) );
  NAND3X0 U239 ( .IN1(n302), .IN2(n303), .IN3(n159), .QN(n301) );
  OR2X1 U240 ( .IN1(n52), .IN2(A[33]), .Q(n159) );
  NAND3X0 U241 ( .IN1(n304), .IN2(n167), .IN3(n166), .QN(n302) );
  AND2X1 U242 ( .IN1(n162), .IN2(n303), .Q(n166) );
  NAND2X0 U243 ( .IN1(B[32]), .IN2(n19), .QN(n303) );
  OR2X1 U244 ( .IN1(n19), .IN2(B[32]), .Q(n162) );
  NAND2X0 U245 ( .IN1(A[31]), .IN2(n53), .QN(n167) );
  NAND3X0 U246 ( .IN1(n305), .IN2(n306), .IN3(n165), .QN(n304) );
  OR2X1 U247 ( .IN1(n53), .IN2(A[31]), .Q(n165) );
  NAND3X0 U248 ( .IN1(n307), .IN2(n173), .IN3(n172), .QN(n305) );
  AND2X1 U249 ( .IN1(n168), .IN2(n306), .Q(n172) );
  NAND2X0 U250 ( .IN1(B[30]), .IN2(n20), .QN(n306) );
  OR2X1 U251 ( .IN1(n20), .IN2(B[30]), .Q(n168) );
  NAND2X0 U252 ( .IN1(A[29]), .IN2(n54), .QN(n173) );
  NAND3X0 U253 ( .IN1(n308), .IN2(n309), .IN3(n171), .QN(n307) );
  OR2X1 U254 ( .IN1(n54), .IN2(A[29]), .Q(n171) );
  NAND3X0 U255 ( .IN1(n310), .IN2(n179), .IN3(n178), .QN(n308) );
  AND2X1 U256 ( .IN1(n174), .IN2(n309), .Q(n178) );
  NAND2X0 U257 ( .IN1(B[28]), .IN2(n21), .QN(n309) );
  OR2X1 U258 ( .IN1(n21), .IN2(B[28]), .Q(n174) );
  NAND2X0 U259 ( .IN1(A[27]), .IN2(n55), .QN(n179) );
  NAND3X0 U260 ( .IN1(n311), .IN2(n312), .IN3(n177), .QN(n310) );
  OR2X1 U261 ( .IN1(n55), .IN2(A[27]), .Q(n177) );
  NAND3X0 U262 ( .IN1(n313), .IN2(n185), .IN3(n184), .QN(n311) );
  AND2X1 U263 ( .IN1(n180), .IN2(n312), .Q(n184) );
  NAND2X0 U264 ( .IN1(B[26]), .IN2(n22), .QN(n312) );
  OR2X1 U265 ( .IN1(n22), .IN2(B[26]), .Q(n180) );
  NAND2X0 U266 ( .IN1(A[25]), .IN2(n56), .QN(n185) );
  NAND3X0 U267 ( .IN1(n314), .IN2(n315), .IN3(n183), .QN(n313) );
  OR2X1 U268 ( .IN1(n56), .IN2(A[25]), .Q(n183) );
  NAND3X0 U269 ( .IN1(n316), .IN2(n191), .IN3(n190), .QN(n314) );
  AND2X1 U270 ( .IN1(n186), .IN2(n315), .Q(n190) );
  NAND2X0 U271 ( .IN1(B[24]), .IN2(n23), .QN(n315) );
  OR2X1 U272 ( .IN1(n23), .IN2(B[24]), .Q(n186) );
  NAND2X0 U273 ( .IN1(A[23]), .IN2(n57), .QN(n191) );
  NAND3X0 U274 ( .IN1(n317), .IN2(n318), .IN3(n189), .QN(n316) );
  OR2X1 U275 ( .IN1(n57), .IN2(A[23]), .Q(n189) );
  NAND3X0 U276 ( .IN1(n319), .IN2(n197), .IN3(n196), .QN(n317) );
  AND2X1 U277 ( .IN1(n192), .IN2(n318), .Q(n196) );
  NAND2X0 U278 ( .IN1(B[22]), .IN2(n24), .QN(n318) );
  OR2X1 U279 ( .IN1(n24), .IN2(B[22]), .Q(n192) );
  NAND2X0 U280 ( .IN1(A[21]), .IN2(n58), .QN(n197) );
  NAND3X0 U281 ( .IN1(n320), .IN2(n321), .IN3(n195), .QN(n319) );
  OR2X1 U282 ( .IN1(n58), .IN2(A[21]), .Q(n195) );
  NAND3X0 U283 ( .IN1(n322), .IN2(n203), .IN3(n202), .QN(n320) );
  AND2X1 U284 ( .IN1(n198), .IN2(n321), .Q(n202) );
  NAND2X0 U285 ( .IN1(B[20]), .IN2(n25), .QN(n321) );
  OR2X1 U286 ( .IN1(n25), .IN2(B[20]), .Q(n198) );
  NAND2X0 U287 ( .IN1(A[19]), .IN2(n59), .QN(n203) );
  NAND3X0 U288 ( .IN1(n323), .IN2(n324), .IN3(n201), .QN(n322) );
  OR2X1 U289 ( .IN1(n59), .IN2(A[19]), .Q(n201) );
  NAND3X0 U290 ( .IN1(n325), .IN2(n209), .IN3(n208), .QN(n323) );
  AND2X1 U291 ( .IN1(n204), .IN2(n324), .Q(n208) );
  NAND2X0 U292 ( .IN1(B[18]), .IN2(n26), .QN(n324) );
  OR2X1 U293 ( .IN1(n26), .IN2(B[18]), .Q(n204) );
  NAND2X0 U294 ( .IN1(A[17]), .IN2(n60), .QN(n209) );
  NAND3X0 U295 ( .IN1(n326), .IN2(n327), .IN3(n207), .QN(n325) );
  OR2X1 U296 ( .IN1(n60), .IN2(A[17]), .Q(n207) );
  NAND3X0 U297 ( .IN1(n328), .IN2(n215), .IN3(n214), .QN(n326) );
  AND2X1 U298 ( .IN1(n210), .IN2(n327), .Q(n214) );
  NAND2X0 U299 ( .IN1(B[16]), .IN2(n27), .QN(n327) );
  OR2X1 U300 ( .IN1(n27), .IN2(B[16]), .Q(n210) );
  NAND2X0 U301 ( .IN1(A[15]), .IN2(n61), .QN(n215) );
  NAND3X0 U302 ( .IN1(n329), .IN2(n330), .IN3(n213), .QN(n328) );
  OR2X1 U303 ( .IN1(n61), .IN2(A[15]), .Q(n213) );
  NAND3X0 U304 ( .IN1(n331), .IN2(n221), .IN3(n220), .QN(n329) );
  AND2X1 U305 ( .IN1(n216), .IN2(n330), .Q(n220) );
  NAND2X0 U306 ( .IN1(B[14]), .IN2(n28), .QN(n330) );
  OR2X1 U307 ( .IN1(n28), .IN2(B[14]), .Q(n216) );
  NAND2X0 U308 ( .IN1(A[13]), .IN2(n62), .QN(n221) );
  NAND3X0 U309 ( .IN1(n332), .IN2(n333), .IN3(n219), .QN(n331) );
  OR2X1 U310 ( .IN1(n62), .IN2(A[13]), .Q(n219) );
  NAND3X0 U311 ( .IN1(n334), .IN2(n227), .IN3(n226), .QN(n332) );
  AND2X1 U312 ( .IN1(n222), .IN2(n333), .Q(n226) );
  NAND2X0 U313 ( .IN1(B[12]), .IN2(n29), .QN(n333) );
  OR2X1 U314 ( .IN1(n29), .IN2(B[12]), .Q(n222) );
  NAND2X0 U315 ( .IN1(A[11]), .IN2(n63), .QN(n227) );
  NAND3X0 U316 ( .IN1(n335), .IN2(n336), .IN3(n225), .QN(n334) );
  OR2X1 U317 ( .IN1(n63), .IN2(A[11]), .Q(n225) );
  NAND3X0 U318 ( .IN1(n337), .IN2(n233), .IN3(n232), .QN(n335) );
  AND2X1 U319 ( .IN1(n228), .IN2(n336), .Q(n232) );
  NAND2X0 U320 ( .IN1(B[10]), .IN2(n30), .QN(n336) );
  OR2X1 U321 ( .IN1(n30), .IN2(B[10]), .Q(n228) );
  NAND2X0 U322 ( .IN1(A[9]), .IN2(n64), .QN(n233) );
  NAND3X0 U323 ( .IN1(n338), .IN2(n339), .IN3(n231), .QN(n337) );
  OR2X1 U324 ( .IN1(n64), .IN2(A[9]), .Q(n231) );
  NAND3X0 U325 ( .IN1(n340), .IN2(n239), .IN3(n238), .QN(n338) );
  AND2X1 U326 ( .IN1(n234), .IN2(n339), .Q(n238) );
  NAND2X0 U327 ( .IN1(B[8]), .IN2(n31), .QN(n339) );
  OR2X1 U328 ( .IN1(n31), .IN2(B[8]), .Q(n234) );
  NAND2X0 U329 ( .IN1(A[7]), .IN2(n65), .QN(n239) );
  NAND3X0 U330 ( .IN1(n341), .IN2(n342), .IN3(n237), .QN(n340) );
  OR2X1 U331 ( .IN1(n65), .IN2(A[7]), .Q(n237) );
  NAND3X0 U332 ( .IN1(n343), .IN2(n245), .IN3(n244), .QN(n341) );
  AND2X1 U333 ( .IN1(n240), .IN2(n342), .Q(n244) );
  NAND2X0 U334 ( .IN1(B[6]), .IN2(n32), .QN(n342) );
  OR2X1 U335 ( .IN1(n32), .IN2(B[6]), .Q(n240) );
  NAND2X0 U336 ( .IN1(A[5]), .IN2(n66), .QN(n245) );
  NAND3X0 U337 ( .IN1(n344), .IN2(n345), .IN3(n243), .QN(n343) );
  OR2X1 U338 ( .IN1(n66), .IN2(A[5]), .Q(n243) );
  NAND3X0 U339 ( .IN1(n346), .IN2(n251), .IN3(n250), .QN(n344) );
  AND2X1 U340 ( .IN1(n246), .IN2(n345), .Q(n250) );
  NAND2X0 U341 ( .IN1(B[4]), .IN2(n33), .QN(n345) );
  OR2X1 U342 ( .IN1(n33), .IN2(B[4]), .Q(n246) );
  NAND2X0 U343 ( .IN1(A[3]), .IN2(n67), .QN(n251) );
  NAND3X0 U344 ( .IN1(n347), .IN2(n348), .IN3(n249), .QN(n346) );
  OR2X1 U345 ( .IN1(n67), .IN2(A[3]), .Q(n249) );
  AO221X1 U346 ( .IN1(n349), .IN2(n68), .IN3(A[1]), .IN4(n36), .IN5(n256), .Q(
        n347) );
  NAND2X0 U347 ( .IN1(n252), .IN2(n348), .QN(n256) );
  NAND2X0 U348 ( .IN1(B[2]), .IN2(n34), .QN(n348) );
  OR2X1 U349 ( .IN1(n34), .IN2(B[2]), .Q(n252) );
  NAND2X0 U350 ( .IN1(n350), .IN2(n35), .QN(n349) );
  NOR2X0 U351 ( .IN1(n69), .IN2(A[0]), .QN(n350) );
  XOR2X1 U352 ( .IN1(A[62]), .IN2(B[62]), .Q(n73) );
  NOR2X0 U353 ( .IN1(n3), .IN2(B[63]), .QN(n72) );
endmodule


module comparator ( a, b, lt, le, eq, ge, gt );
  input [63:0] a;
  input [63:0] b;
  output lt, le, eq, ge, gt;


  comparator_DW01_cmp6_0 r54 ( .A(a), .B(b), .TC(1'b0), .LT(lt), .GT(gt), .EQ(
        eq), .LE(le), .GE(ge) );
endmodule

