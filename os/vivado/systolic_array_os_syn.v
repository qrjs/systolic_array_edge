// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2024.2 (lin64) Build 5239630 Fri Nov 08 22:34:34 MST 2024
// Date        : Fri Jan 30 20:10:30 2026
// Host        : curry-GTR-Pro running 64-bit Ubuntu 24.04.3 LTS
// Command     : write_verilog -force ./vivado/systolic_array_os_syn.v
// Design      : systolic_array_os_4x4
// Purpose     : This is a Verilog netlist of the current design or from a specific cell of the design. The output is an
//               IEEE 1364-2001 compliant Verilog HDL file that contains netlist information obtained from the input
//               design files.
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module os_pe
   (Q,
    computing_reg_0,
    input_valid_reg,
    input_out_valid_mesh_0,
    input_valid_reg11_out,
    E,
    D,
    \input_out_reg_reg[15]_0 ,
    B,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    input_valid_IBUF,
    flush_IBUF,
    input_in_IBUF,
    accumulator_clr_IBUF,
    computing_reg_1,
    \weight_out_reg_reg[15]_0 ,
    \weight_out_reg_reg[15]_1 );
  output [31:0]Q;
  output computing_reg_0;
  output input_valid_reg;
  output input_out_valid_mesh_0;
  output input_valid_reg11_out;
  output [0:0]E;
  output [15:0]D;
  output [15:0]\input_out_reg_reg[15]_0 ;
  input [15:0]B;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input [0:0]input_valid_IBUF;
  input flush_IBUF;
  input [15:0]input_in_IBUF;
  input accumulator_clr_IBUF;
  input computing_reg_1;
  input [0:0]\weight_out_reg_reg[15]_0 ;
  input [15:0]\weight_out_reg_reg[15]_1 ;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1_n_0 ;
  wire \accumulator[10]_i_1_n_0 ;
  wire \accumulator[11]_i_1_n_0 ;
  wire \accumulator[12]_i_1_n_0 ;
  wire \accumulator[13]_i_1_n_0 ;
  wire \accumulator[14]_i_1_n_0 ;
  wire \accumulator[15]_i_1_n_0 ;
  wire \accumulator[16]_i_1_n_0 ;
  wire \accumulator[17]_i_1_n_0 ;
  wire \accumulator[18]_i_1_n_0 ;
  wire \accumulator[19]_i_1_n_0 ;
  wire \accumulator[1]_i_1_n_0 ;
  wire \accumulator[20]_i_1_n_0 ;
  wire \accumulator[21]_i_1_n_0 ;
  wire \accumulator[22]_i_1_n_0 ;
  wire \accumulator[23]_i_1_n_0 ;
  wire \accumulator[24]_i_1_n_0 ;
  wire \accumulator[25]_i_1_n_0 ;
  wire \accumulator[26]_i_1_n_0 ;
  wire \accumulator[27]_i_1_n_0 ;
  wire \accumulator[28]_i_1_n_0 ;
  wire \accumulator[29]_i_1_n_0 ;
  wire \accumulator[2]_i_1_n_0 ;
  wire \accumulator[30]_i_1_n_0 ;
  wire \accumulator[31]_i_1_n_0 ;
  wire \accumulator[31]_i_2_n_0 ;
  wire \accumulator[3]_i_1_n_0 ;
  wire \accumulator[4]_i_1_n_0 ;
  wire \accumulator[5]_i_1_n_0 ;
  wire \accumulator[6]_i_1_n_0 ;
  wire \accumulator[7]_i_1_n_0 ;
  wire \accumulator[8]_i_1_n_0 ;
  wire \accumulator[9]_i_1_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_1;
  wire flush_IBUF;
  wire [15:0]input_in_IBUF;
  wire [15:0]input_out_mesh_0;
  wire \input_out_reg[0]_i_1_n_0 ;
  wire \input_out_reg[10]_i_1_n_0 ;
  wire \input_out_reg[11]_i_1_n_0 ;
  wire \input_out_reg[12]_i_1_n_0 ;
  wire \input_out_reg[13]_i_1_n_0 ;
  wire \input_out_reg[14]_i_1_n_0 ;
  wire \input_out_reg[15]_i_1_n_0 ;
  wire \input_out_reg[15]_i_2_n_0 ;
  wire \input_out_reg[1]_i_1_n_0 ;
  wire \input_out_reg[2]_i_1_n_0 ;
  wire \input_out_reg[3]_i_1_n_0 ;
  wire \input_out_reg[4]_i_1_n_0 ;
  wire \input_out_reg[5]_i_1_n_0 ;
  wire \input_out_reg[6]_i_1_n_0 ;
  wire \input_out_reg[7]_i_1_n_0 ;
  wire \input_out_reg[8]_i_1_n_0 ;
  wire \input_out_reg[9]_i_1_n_0 ;
  wire [15:0]\input_out_reg_reg[15]_0 ;
  wire input_out_valid_mesh_0;
  wire input_out_valid_reg;
  wire \input_reg[0]_i_1_n_0 ;
  wire \input_reg[10]_i_1_n_0 ;
  wire \input_reg[11]_i_1_n_0 ;
  wire \input_reg[12]_i_1_n_0 ;
  wire \input_reg[13]_i_1_n_0 ;
  wire \input_reg[14]_i_1_n_0 ;
  wire \input_reg[15]_i_1_n_0 ;
  wire \input_reg[15]_i_2_n_0 ;
  wire \input_reg[1]_i_1_n_0 ;
  wire \input_reg[2]_i_1_n_0 ;
  wire \input_reg[3]_i_1_n_0 ;
  wire \input_reg[4]_i_1_n_0 ;
  wire \input_reg[5]_i_1_n_0 ;
  wire \input_reg[6]_i_1_n_0 ;
  wire \input_reg[7]_i_1_n_0 ;
  wire \input_reg[8]_i_1_n_0 ;
  wire \input_reg[9]_i_1_n_0 ;
  wire [15:0]input_reg__0;
  wire [0:0]input_valid_IBUF;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_0;
  wire [31:0]signed_mac_result__0;
  wire [15:0]weight_out_mesh_0;
  wire [0:0]\weight_out_reg_reg[15]_0 ;
  wire [15:0]\weight_out_reg_reg[15]_1 ;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(\accumulator[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[0]_i_1 
       (.I0(input_reg__0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[10]_i_1 
       (.I0(input_reg__0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[11]_i_1 
       (.I0(input_reg__0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[12]_i_1 
       (.I0(input_reg__0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg[12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[13]_i_1 
       (.I0(input_reg__0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[14]_i_1 
       (.I0(input_reg__0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg[14]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \input_out_reg[15]_i_1 
       (.I0(flush_IBUF),
        .I1(input_valid_reg),
        .O(\input_out_reg[15]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[15]_i_2 
       (.I0(input_reg__0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg[15]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[1]_i_1 
       (.I0(input_reg__0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[2]_i_1 
       (.I0(input_reg__0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[3]_i_1 
       (.I0(input_reg__0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[4]_i_1 
       (.I0(input_reg__0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[5]_i_1 
       (.I0(input_reg__0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[6]_i_1 
       (.I0(input_reg__0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[7]_i_1 
       (.I0(input_reg__0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[8]_i_1 
       (.I0(input_reg__0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[9]_i_1 
       (.I0(input_reg__0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg[9]_i_1_n_0 ));
  FDCE \input_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[0]_i_1_n_0 ),
        .Q(input_out_mesh_0[0]));
  FDCE \input_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[10]_i_1_n_0 ),
        .Q(input_out_mesh_0[10]));
  FDCE \input_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[11]_i_1_n_0 ),
        .Q(input_out_mesh_0[11]));
  FDCE \input_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[12]_i_1_n_0 ),
        .Q(input_out_mesh_0[12]));
  FDCE \input_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[13]_i_1_n_0 ),
        .Q(input_out_mesh_0[13]));
  FDCE \input_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[14]_i_1_n_0 ),
        .Q(input_out_mesh_0[14]));
  FDCE \input_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[15]_i_2_n_0 ),
        .Q(input_out_mesh_0[15]));
  FDCE \input_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[1]_i_1_n_0 ),
        .Q(input_out_mesh_0[1]));
  FDCE \input_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[2]_i_1_n_0 ),
        .Q(input_out_mesh_0[2]));
  FDCE \input_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[3]_i_1_n_0 ),
        .Q(input_out_mesh_0[3]));
  FDCE \input_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[4]_i_1_n_0 ),
        .Q(input_out_mesh_0[4]));
  FDCE \input_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[5]_i_1_n_0 ),
        .Q(input_out_mesh_0[5]));
  FDCE \input_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[6]_i_1_n_0 ),
        .Q(input_out_mesh_0[6]));
  FDCE \input_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[7]_i_1_n_0 ),
        .Q(input_out_mesh_0[7]));
  FDCE \input_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[8]_i_1_n_0 ),
        .Q(input_out_mesh_0[8]));
  FDCE \input_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[9]_i_1_n_0 ),
        .Q(input_out_mesh_0[9]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1
       (.I0(input_valid_reg),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_mesh_0));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1 
       (.I0(input_in_IBUF[0]),
        .I1(flush_IBUF),
        .O(\input_reg[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__3 
       (.I0(input_out_mesh_0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1 
       (.I0(input_in_IBUF[10]),
        .I1(flush_IBUF),
        .O(\input_reg[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__3 
       (.I0(input_out_mesh_0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [10]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1 
       (.I0(input_in_IBUF[11]),
        .I1(flush_IBUF),
        .O(\input_reg[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__3 
       (.I0(input_out_mesh_0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [11]));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1 
       (.I0(input_in_IBUF[12]),
        .I1(flush_IBUF),
        .O(\input_reg[12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__3 
       (.I0(input_out_mesh_0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [12]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1 
       (.I0(input_in_IBUF[13]),
        .I1(flush_IBUF),
        .O(\input_reg[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__3 
       (.I0(input_out_mesh_0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [13]));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1 
       (.I0(input_in_IBUF[14]),
        .I1(flush_IBUF),
        .O(\input_reg[14]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__3 
       (.I0(input_out_mesh_0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [14]));
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1 
       (.I0(flush_IBUF),
        .I1(input_valid_IBUF),
        .O(\input_reg[15]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__3 
       (.I0(flush_IBUF),
        .I1(input_out_valid_mesh_0),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2 
       (.I0(input_in_IBUF[15]),
        .I1(flush_IBUF),
        .O(\input_reg[15]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__3 
       (.I0(input_out_mesh_0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [15]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1 
       (.I0(input_in_IBUF[1]),
        .I1(flush_IBUF),
        .O(\input_reg[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__3 
       (.I0(input_out_mesh_0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [1]));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1 
       (.I0(input_in_IBUF[2]),
        .I1(flush_IBUF),
        .O(\input_reg[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__3 
       (.I0(input_out_mesh_0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [2]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1 
       (.I0(input_in_IBUF[3]),
        .I1(flush_IBUF),
        .O(\input_reg[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__3 
       (.I0(input_out_mesh_0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [3]));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1 
       (.I0(input_in_IBUF[4]),
        .I1(flush_IBUF),
        .O(\input_reg[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__3 
       (.I0(input_out_mesh_0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [4]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1 
       (.I0(input_in_IBUF[5]),
        .I1(flush_IBUF),
        .O(\input_reg[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__3 
       (.I0(input_out_mesh_0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [5]));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1 
       (.I0(input_in_IBUF[6]),
        .I1(flush_IBUF),
        .O(\input_reg[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__3 
       (.I0(input_out_mesh_0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [6]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1 
       (.I0(input_in_IBUF[7]),
        .I1(flush_IBUF),
        .O(\input_reg[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__3 
       (.I0(input_out_mesh_0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [7]));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1 
       (.I0(input_in_IBUF[8]),
        .I1(flush_IBUF),
        .O(\input_reg[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__3 
       (.I0(input_out_mesh_0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [8]));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1 
       (.I0(input_in_IBUF[9]),
        .I1(flush_IBUF),
        .O(\input_reg[9]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__3 
       (.I0(input_out_mesh_0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [9]));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[0]_i_1_n_0 ),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[10]_i_1_n_0 ),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[11]_i_1_n_0 ),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[12]_i_1_n_0 ),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[13]_i_1_n_0 ),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[14]_i_1_n_0 ),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[15]_i_2_n_0 ),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[1]_i_1_n_0 ),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[2]_i_1_n_0 ),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[3]_i_1_n_0 ),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[4]_i_1_n_0 ),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[5]_i_1_n_0 ),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[6]_i_1_n_0 ),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[7]_i_1_n_0 ),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[8]_i_1_n_0 ),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[9]_i_1_n_0 ),
        .Q(input_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1
       (.I0(input_valid_IBUF),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out_0));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__3
       (.I0(input_out_valid_mesh_0),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out_0),
        .Q(input_valid_reg));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
  FDCE \weight_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [0]),
        .Q(weight_out_mesh_0[0]));
  FDCE \weight_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [10]),
        .Q(weight_out_mesh_0[10]));
  FDCE \weight_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [11]),
        .Q(weight_out_mesh_0[11]));
  FDCE \weight_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [12]),
        .Q(weight_out_mesh_0[12]));
  FDCE \weight_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [13]),
        .Q(weight_out_mesh_0[13]));
  FDCE \weight_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [14]),
        .Q(weight_out_mesh_0[14]));
  FDCE \weight_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [15]),
        .Q(weight_out_mesh_0[15]));
  FDCE \weight_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [1]),
        .Q(weight_out_mesh_0[1]));
  FDCE \weight_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [2]),
        .Q(weight_out_mesh_0[2]));
  FDCE \weight_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [3]),
        .Q(weight_out_mesh_0[3]));
  FDCE \weight_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [4]),
        .Q(weight_out_mesh_0[4]));
  FDCE \weight_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [5]),
        .Q(weight_out_mesh_0[5]));
  FDCE \weight_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [6]),
        .Q(weight_out_mesh_0[6]));
  FDCE \weight_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [7]),
        .Q(weight_out_mesh_0[7]));
  FDCE \weight_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [8]),
        .Q(weight_out_mesh_0[8]));
  FDCE \weight_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg_reg[15]_1 [9]),
        .Q(weight_out_mesh_0[9]));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[0]_i_1__0 
       (.I0(weight_out_mesh_0[0]),
        .I1(flush_IBUF),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[10]_i_1__0 
       (.I0(weight_out_mesh_0[10]),
        .I1(flush_IBUF),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[11]_i_1__0 
       (.I0(weight_out_mesh_0[11]),
        .I1(flush_IBUF),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[12]_i_1__0 
       (.I0(weight_out_mesh_0[12]),
        .I1(flush_IBUF),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[13]_i_1__0 
       (.I0(weight_out_mesh_0[13]),
        .I1(flush_IBUF),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[14]_i_1__0 
       (.I0(weight_out_mesh_0[14]),
        .I1(flush_IBUF),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[15]_i_2 
       (.I0(weight_out_mesh_0[15]),
        .I1(flush_IBUF),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[1]_i_1__0 
       (.I0(weight_out_mesh_0[1]),
        .I1(flush_IBUF),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[2]_i_1__0 
       (.I0(weight_out_mesh_0[2]),
        .I1(flush_IBUF),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[3]_i_1__0 
       (.I0(weight_out_mesh_0[3]),
        .I1(flush_IBUF),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[4]_i_1__0 
       (.I0(weight_out_mesh_0[4]),
        .I1(flush_IBUF),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[5]_i_1__0 
       (.I0(weight_out_mesh_0[5]),
        .I1(flush_IBUF),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[6]_i_1__0 
       (.I0(weight_out_mesh_0[6]),
        .I1(flush_IBUF),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[7]_i_1__0 
       (.I0(weight_out_mesh_0[7]),
        .I1(flush_IBUF),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[8]_i_1__0 
       (.I0(weight_out_mesh_0[8]),
        .I1(flush_IBUF),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[9]_i_1__0 
       (.I0(weight_out_mesh_0[9]),
        .I1(flush_IBUF),
        .O(D[9]));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_0
   (Q,
    input_valid_reg11_out,
    E,
    input_out_valid_reg_reg_0,
    D,
    \input_out_reg_reg[15]_0 ,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    input_valid_IBUF,
    flush_IBUF,
    array_busy_reg_i_6,
    input_in_IBUF,
    accumulator_clr_IBUF,
    computing_reg_0,
    \weight_reg_reg[0]_0 ,
    \weight_reg_reg[15]_0 ,
    \weight_out_reg_reg[0]_0 );
  output [31:0]Q;
  output input_valid_reg11_out;
  output [0:0]E;
  output input_out_valid_reg_reg_0;
  output [15:0]D;
  output [15:0]\input_out_reg_reg[15]_0 ;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input [0:0]input_valid_IBUF;
  input flush_IBUF;
  input array_busy_reg_i_6;
  input [15:0]input_in_IBUF;
  input accumulator_clr_IBUF;
  input computing_reg_0;
  input \weight_reg_reg[0]_0 ;
  input [15:0]\weight_reg_reg[15]_0 ;
  input \weight_out_reg_reg[0]_0 ;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__0_n_0 ;
  wire \accumulator[10]_i_1__0_n_0 ;
  wire \accumulator[11]_i_1__0_n_0 ;
  wire \accumulator[12]_i_1__0_n_0 ;
  wire \accumulator[13]_i_1__0_n_0 ;
  wire \accumulator[14]_i_1__0_n_0 ;
  wire \accumulator[15]_i_1__0_n_0 ;
  wire \accumulator[16]_i_1__0_n_0 ;
  wire \accumulator[17]_i_1__0_n_0 ;
  wire \accumulator[18]_i_1__0_n_0 ;
  wire \accumulator[19]_i_1__0_n_0 ;
  wire \accumulator[1]_i_1__0_n_0 ;
  wire \accumulator[20]_i_1__0_n_0 ;
  wire \accumulator[21]_i_1__0_n_0 ;
  wire \accumulator[22]_i_1__0_n_0 ;
  wire \accumulator[23]_i_1__0_n_0 ;
  wire \accumulator[24]_i_1__0_n_0 ;
  wire \accumulator[25]_i_1__0_n_0 ;
  wire \accumulator[26]_i_1__0_n_0 ;
  wire \accumulator[27]_i_1__0_n_0 ;
  wire \accumulator[28]_i_1__0_n_0 ;
  wire \accumulator[29]_i_1__0_n_0 ;
  wire \accumulator[2]_i_1__0_n_0 ;
  wire \accumulator[30]_i_1__0_n_0 ;
  wire \accumulator[31]_i_1__0_n_0 ;
  wire \accumulator[31]_i_2__0_n_0 ;
  wire \accumulator[3]_i_1__0_n_0 ;
  wire \accumulator[4]_i_1__0_n_0 ;
  wire \accumulator[5]_i_1__0_n_0 ;
  wire \accumulator[6]_i_1__0_n_0 ;
  wire \accumulator[7]_i_1__0_n_0 ;
  wire \accumulator[8]_i_1__0_n_0 ;
  wire \accumulator[9]_i_1__0_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire array_busy_reg_i_6;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_n_0;
  wire flush_IBUF;
  wire [15:0]input_in_IBUF;
  wire [15:0]input_out_mesh_16;
  wire \input_out_reg[0]_i_1__0_n_0 ;
  wire \input_out_reg[10]_i_1__0_n_0 ;
  wire \input_out_reg[11]_i_1__0_n_0 ;
  wire \input_out_reg[12]_i_1__0_n_0 ;
  wire \input_out_reg[13]_i_1__0_n_0 ;
  wire \input_out_reg[14]_i_1__0_n_0 ;
  wire \input_out_reg[15]_i_1__0_n_0 ;
  wire \input_out_reg[15]_i_2__0_n_0 ;
  wire \input_out_reg[1]_i_1__0_n_0 ;
  wire \input_out_reg[2]_i_1__0_n_0 ;
  wire \input_out_reg[3]_i_1__0_n_0 ;
  wire \input_out_reg[4]_i_1__0_n_0 ;
  wire \input_out_reg[5]_i_1__0_n_0 ;
  wire \input_out_reg[6]_i_1__0_n_0 ;
  wire \input_out_reg[7]_i_1__0_n_0 ;
  wire \input_out_reg[8]_i_1__0_n_0 ;
  wire \input_out_reg[9]_i_1__0_n_0 ;
  wire [15:0]\input_out_reg_reg[15]_0 ;
  wire input_out_valid_mesh_1;
  wire input_out_valid_reg;
  wire input_out_valid_reg_reg_0;
  wire \input_reg[0]_i_1__0_n_0 ;
  wire \input_reg[10]_i_1__0_n_0 ;
  wire \input_reg[11]_i_1__0_n_0 ;
  wire \input_reg[12]_i_1__0_n_0 ;
  wire \input_reg[13]_i_1__0_n_0 ;
  wire \input_reg[14]_i_1__0_n_0 ;
  wire \input_reg[15]_i_1__0_n_0 ;
  wire \input_reg[15]_i_2__0_n_0 ;
  wire \input_reg[1]_i_1__0_n_0 ;
  wire \input_reg[2]_i_1__0_n_0 ;
  wire \input_reg[3]_i_1__0_n_0 ;
  wire \input_reg[4]_i_1__0_n_0 ;
  wire \input_reg[5]_i_1__0_n_0 ;
  wire \input_reg[6]_i_1__0_n_0 ;
  wire \input_reg[7]_i_1__0_n_0 ;
  wire \input_reg[8]_i_1__0_n_0 ;
  wire \input_reg[9]_i_1__0_n_0 ;
  wire [15:0]input_reg__0;
  wire [0:0]input_valid_IBUF;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_0;
  wire [31:0]signed_mac_result__0;
  wire [15:0]weight_out_mesh_16;
  wire \weight_out_reg[0]_i_1__0_n_0 ;
  wire \weight_out_reg[10]_i_1_n_0 ;
  wire \weight_out_reg[11]_i_1_n_0 ;
  wire \weight_out_reg[12]_i_1_n_0 ;
  wire \weight_out_reg[13]_i_1_n_0 ;
  wire \weight_out_reg[14]_i_1_n_0 ;
  wire \weight_out_reg[15]_i_2_n_0 ;
  wire \weight_out_reg[1]_i_1_n_0 ;
  wire \weight_out_reg[2]_i_1_n_0 ;
  wire \weight_out_reg[3]_i_1_n_0 ;
  wire \weight_out_reg[4]_i_1_n_0 ;
  wire \weight_out_reg[5]_i_1_n_0 ;
  wire \weight_out_reg[6]_i_1_n_0 ;
  wire \weight_out_reg[7]_i_1_n_0 ;
  wire \weight_out_reg[8]_i_1_n_0 ;
  wire \weight_out_reg[9]_i_1_n_0 ;
  wire \weight_out_reg_reg[0]_0 ;
  wire [15:0]weight_reg__0;
  wire \weight_reg_reg[0]_0 ;
  wire [15:0]\weight_reg_reg[15]_0 ;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__0_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_0),
        .O(\accumulator[31]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__0 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__0_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__0_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__0_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__0_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__0_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__0_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__0_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__0_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__0_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__0_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__0_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__0_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__0_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__0_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__0_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__0_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__0_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__0_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__0_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__0_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__0_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__0_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__0_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__0_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__0_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__0_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__0_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__0_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__0_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__0_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__0_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__0_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__0_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_23
       (.I0(input_out_valid_mesh_1),
        .I1(input_valid_reg),
        .I2(computing_reg_n_0),
        .I3(array_busy_reg_i_6),
        .O(input_out_valid_reg_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__0
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_0),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[0]_i_1__0 
       (.I0(input_reg__0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[10]_i_1__0 
       (.I0(input_reg__0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg[10]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair79" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[11]_i_1__0 
       (.I0(input_reg__0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg[11]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[12]_i_1__0 
       (.I0(input_reg__0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg[12]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair78" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[13]_i_1__0 
       (.I0(input_reg__0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg[13]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[14]_i_1__0 
       (.I0(input_reg__0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg[14]_i_1__0_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \input_out_reg[15]_i_1__0 
       (.I0(flush_IBUF),
        .I1(input_valid_reg),
        .O(\input_out_reg[15]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair77" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[15]_i_2__0 
       (.I0(input_reg__0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg[15]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair84" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[1]_i_1__0 
       (.I0(input_reg__0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[2]_i_1__0 
       (.I0(input_reg__0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg[2]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair83" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[3]_i_1__0 
       (.I0(input_reg__0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg[3]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[4]_i_1__0 
       (.I0(input_reg__0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg[4]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair82" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[5]_i_1__0 
       (.I0(input_reg__0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg[5]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[6]_i_1__0 
       (.I0(input_reg__0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg[6]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair81" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[7]_i_1__0 
       (.I0(input_reg__0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg[7]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[8]_i_1__0 
       (.I0(input_reg__0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg[8]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair80" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[9]_i_1__0 
       (.I0(input_reg__0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg[9]_i_1__0_n_0 ));
  FDCE \input_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[0]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[0]));
  FDCE \input_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[10]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[10]));
  FDCE \input_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[11]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[11]));
  FDCE \input_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[12]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[12]));
  FDCE \input_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[13]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[13]));
  FDCE \input_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[14]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[14]));
  FDCE \input_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[15]_i_2__0_n_0 ),
        .Q(input_out_mesh_16[15]));
  FDCE \input_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[1]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[1]));
  FDCE \input_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[2]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[2]));
  FDCE \input_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[3]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[3]));
  FDCE \input_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[4]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[4]));
  FDCE \input_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[5]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[5]));
  FDCE \input_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[6]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[6]));
  FDCE \input_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[7]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[7]));
  FDCE \input_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[8]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[8]));
  FDCE \input_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[9]_i_1__0_n_0 ),
        .Q(input_out_mesh_16[9]));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__0
       (.I0(input_valid_reg),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_mesh_1));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__0 
       (.I0(input_in_IBUF[0]),
        .I1(flush_IBUF),
        .O(\input_reg[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__4 
       (.I0(input_out_mesh_16[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__0 
       (.I0(input_in_IBUF[10]),
        .I1(flush_IBUF),
        .O(\input_reg[10]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__4 
       (.I0(input_out_mesh_16[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [10]));
  (* SOFT_HLUTNM = "soft_lutpair71" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__0 
       (.I0(input_in_IBUF[11]),
        .I1(flush_IBUF),
        .O(\input_reg[11]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair103" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__4 
       (.I0(input_out_mesh_16[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [11]));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__0 
       (.I0(input_in_IBUF[12]),
        .I1(flush_IBUF),
        .O(\input_reg[12]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__4 
       (.I0(input_out_mesh_16[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [12]));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__0 
       (.I0(input_in_IBUF[13]),
        .I1(flush_IBUF),
        .O(\input_reg[13]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair102" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__4 
       (.I0(input_out_mesh_16[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [13]));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__0 
       (.I0(input_in_IBUF[14]),
        .I1(flush_IBUF),
        .O(\input_reg[14]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__4 
       (.I0(input_out_mesh_16[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [14]));
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__0 
       (.I0(flush_IBUF),
        .I1(input_valid_IBUF),
        .O(\input_reg[15]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__4 
       (.I0(flush_IBUF),
        .I1(input_out_valid_mesh_1),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__0 
       (.I0(input_in_IBUF[15]),
        .I1(flush_IBUF),
        .O(\input_reg[15]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair101" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__4 
       (.I0(input_out_mesh_16[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [15]));
  (* SOFT_HLUTNM = "soft_lutpair76" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__0 
       (.I0(input_in_IBUF[1]),
        .I1(flush_IBUF),
        .O(\input_reg[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair108" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__4 
       (.I0(input_out_mesh_16[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [1]));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__0 
       (.I0(input_in_IBUF[2]),
        .I1(flush_IBUF),
        .O(\input_reg[2]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__4 
       (.I0(input_out_mesh_16[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [2]));
  (* SOFT_HLUTNM = "soft_lutpair75" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__0 
       (.I0(input_in_IBUF[3]),
        .I1(flush_IBUF),
        .O(\input_reg[3]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair107" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__4 
       (.I0(input_out_mesh_16[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [3]));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__0 
       (.I0(input_in_IBUF[4]),
        .I1(flush_IBUF),
        .O(\input_reg[4]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__4 
       (.I0(input_out_mesh_16[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [4]));
  (* SOFT_HLUTNM = "soft_lutpair74" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__0 
       (.I0(input_in_IBUF[5]),
        .I1(flush_IBUF),
        .O(\input_reg[5]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair106" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__4 
       (.I0(input_out_mesh_16[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [5]));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__0 
       (.I0(input_in_IBUF[6]),
        .I1(flush_IBUF),
        .O(\input_reg[6]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__4 
       (.I0(input_out_mesh_16[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [6]));
  (* SOFT_HLUTNM = "soft_lutpair73" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__0 
       (.I0(input_in_IBUF[7]),
        .I1(flush_IBUF),
        .O(\input_reg[7]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair105" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__4 
       (.I0(input_out_mesh_16[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [7]));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__0 
       (.I0(input_in_IBUF[8]),
        .I1(flush_IBUF),
        .O(\input_reg[8]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__4 
       (.I0(input_out_mesh_16[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [8]));
  (* SOFT_HLUTNM = "soft_lutpair72" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__0 
       (.I0(input_in_IBUF[9]),
        .I1(flush_IBUF),
        .O(\input_reg[9]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair104" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__4 
       (.I0(input_out_mesh_16[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [9]));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[0]_i_1__0_n_0 ),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[10]_i_1__0_n_0 ),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[11]_i_1__0_n_0 ),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[12]_i_1__0_n_0 ),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[13]_i_1__0_n_0 ),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[14]_i_1__0_n_0 ),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[15]_i_2__0_n_0 ),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[1]_i_1__0_n_0 ),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[2]_i_1__0_n_0 ),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[3]_i_1__0_n_0 ),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[4]_i_1__0_n_0 ),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[5]_i_1__0_n_0 ),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[6]_i_1__0_n_0 ),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[7]_i_1__0_n_0 ),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[8]_i_1__0_n_0 ),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__0_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[9]_i_1__0_n_0 ),
        .Q(input_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__0
       (.I0(input_valid_IBUF),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out_0));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__4
       (.I0(input_out_valid_mesh_1),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out_0),
        .Q(input_valid_reg));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,weight_reg__0}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[0]_i_1__0 
       (.I0(weight_reg__0[0]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[10]_i_1 
       (.I0(weight_reg__0[10]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair87" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[11]_i_1 
       (.I0(weight_reg__0[11]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[12]_i_1 
       (.I0(weight_reg__0[12]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair86" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[13]_i_1 
       (.I0(weight_reg__0[13]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[14]_i_1 
       (.I0(weight_reg__0[14]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[14]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair85" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[15]_i_2 
       (.I0(weight_reg__0[15]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[15]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair92" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[1]_i_1 
       (.I0(weight_reg__0[1]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[2]_i_1 
       (.I0(weight_reg__0[2]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair91" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[3]_i_1 
       (.I0(weight_reg__0[3]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[4]_i_1 
       (.I0(weight_reg__0[4]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair90" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[5]_i_1 
       (.I0(weight_reg__0[5]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[6]_i_1 
       (.I0(weight_reg__0[6]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair89" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[7]_i_1 
       (.I0(weight_reg__0[7]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[8]_i_1 
       (.I0(weight_reg__0[8]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair88" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[9]_i_1 
       (.I0(weight_reg__0[9]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[9]_i_1_n_0 ));
  FDCE \weight_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[0]_i_1__0_n_0 ),
        .Q(weight_out_mesh_16[0]));
  FDCE \weight_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[10]_i_1_n_0 ),
        .Q(weight_out_mesh_16[10]));
  FDCE \weight_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[11]_i_1_n_0 ),
        .Q(weight_out_mesh_16[11]));
  FDCE \weight_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[12]_i_1_n_0 ),
        .Q(weight_out_mesh_16[12]));
  FDCE \weight_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[13]_i_1_n_0 ),
        .Q(weight_out_mesh_16[13]));
  FDCE \weight_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[14]_i_1_n_0 ),
        .Q(weight_out_mesh_16[14]));
  FDCE \weight_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[15]_i_2_n_0 ),
        .Q(weight_out_mesh_16[15]));
  FDCE \weight_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[1]_i_1_n_0 ),
        .Q(weight_out_mesh_16[1]));
  FDCE \weight_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[2]_i_1_n_0 ),
        .Q(weight_out_mesh_16[2]));
  FDCE \weight_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[3]_i_1_n_0 ),
        .Q(weight_out_mesh_16[3]));
  FDCE \weight_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[4]_i_1_n_0 ),
        .Q(weight_out_mesh_16[4]));
  FDCE \weight_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[5]_i_1_n_0 ),
        .Q(weight_out_mesh_16[5]));
  FDCE \weight_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[6]_i_1_n_0 ),
        .Q(weight_out_mesh_16[6]));
  FDCE \weight_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[7]_i_1_n_0 ),
        .Q(weight_out_mesh_16[7]));
  FDCE \weight_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[8]_i_1_n_0 ),
        .Q(weight_out_mesh_16[8]));
  FDCE \weight_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[9]_i_1_n_0 ),
        .Q(weight_out_mesh_16[9]));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[0]_i_1__1 
       (.I0(weight_out_mesh_16[0]),
        .I1(flush_IBUF),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[10]_i_1__1 
       (.I0(weight_out_mesh_16[10]),
        .I1(flush_IBUF),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair95" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[11]_i_1__1 
       (.I0(weight_out_mesh_16[11]),
        .I1(flush_IBUF),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[12]_i_1__1 
       (.I0(weight_out_mesh_16[12]),
        .I1(flush_IBUF),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair94" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[13]_i_1__1 
       (.I0(weight_out_mesh_16[13]),
        .I1(flush_IBUF),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[14]_i_1__1 
       (.I0(weight_out_mesh_16[14]),
        .I1(flush_IBUF),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair93" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[15]_i_2__0 
       (.I0(weight_out_mesh_16[15]),
        .I1(flush_IBUF),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair100" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[1]_i_1__1 
       (.I0(weight_out_mesh_16[1]),
        .I1(flush_IBUF),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[2]_i_1__1 
       (.I0(weight_out_mesh_16[2]),
        .I1(flush_IBUF),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair99" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[3]_i_1__1 
       (.I0(weight_out_mesh_16[3]),
        .I1(flush_IBUF),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[4]_i_1__1 
       (.I0(weight_out_mesh_16[4]),
        .I1(flush_IBUF),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair98" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[5]_i_1__1 
       (.I0(weight_out_mesh_16[5]),
        .I1(flush_IBUF),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[6]_i_1__1 
       (.I0(weight_out_mesh_16[6]),
        .I1(flush_IBUF),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair97" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[7]_i_1__1 
       (.I0(weight_out_mesh_16[7]),
        .I1(flush_IBUF),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[8]_i_1__1 
       (.I0(weight_out_mesh_16[8]),
        .I1(flush_IBUF),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair96" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[9]_i_1__1 
       (.I0(weight_out_mesh_16[9]),
        .I1(flush_IBUF),
        .O(D[9]));
  FDCE \weight_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [0]),
        .Q(weight_reg__0[0]));
  FDCE \weight_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [10]),
        .Q(weight_reg__0[10]));
  FDCE \weight_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [11]),
        .Q(weight_reg__0[11]));
  FDCE \weight_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [12]),
        .Q(weight_reg__0[12]));
  FDCE \weight_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [13]),
        .Q(weight_reg__0[13]));
  FDCE \weight_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [14]),
        .Q(weight_reg__0[14]));
  FDCE \weight_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [15]),
        .Q(weight_reg__0[15]));
  FDCE \weight_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [1]),
        .Q(weight_reg__0[1]));
  FDCE \weight_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [2]),
        .Q(weight_reg__0[2]));
  FDCE \weight_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [3]),
        .Q(weight_reg__0[3]));
  FDCE \weight_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [4]),
        .Q(weight_reg__0[4]));
  FDCE \weight_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [5]),
        .Q(weight_reg__0[5]));
  FDCE \weight_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [6]),
        .Q(weight_reg__0[6]));
  FDCE \weight_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [7]),
        .Q(weight_reg__0[7]));
  FDCE \weight_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [8]),
        .Q(weight_reg__0[8]));
  FDCE \weight_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [9]),
        .Q(weight_reg__0[9]));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_1
   (Q,
    rst_n,
    input_valid_reg,
    input_out_valid_mesh_2,
    input_valid_reg11_out,
    E,
    computing_reg_0,
    D,
    \input_out_reg_reg[15]_0 ,
    clk_IBUF_BUFG,
    input_valid_IBUF,
    flush_IBUF,
    array_busy_reg_i_3,
    array_busy_reg_i_3_0,
    weight_out_valid_mesh_13,
    input_in_IBUF,
    rst_n_IBUF,
    accumulator_clr_IBUF,
    computing_reg_1,
    \weight_reg_reg[0]_0 ,
    \weight_reg_reg[15]_0 ,
    \weight_out_reg_reg[0]_0 );
  output [31:0]Q;
  output rst_n;
  output input_valid_reg;
  output input_out_valid_mesh_2;
  output input_valid_reg11_out;
  output [0:0]E;
  output computing_reg_0;
  output [15:0]D;
  output [15:0]\input_out_reg_reg[15]_0 ;
  input clk_IBUF_BUFG;
  input [0:0]input_valid_IBUF;
  input flush_IBUF;
  input array_busy_reg_i_3;
  input array_busy_reg_i_3_0;
  input weight_out_valid_mesh_13;
  input [15:0]input_in_IBUF;
  input rst_n_IBUF;
  input accumulator_clr_IBUF;
  input computing_reg_1;
  input \weight_reg_reg[0]_0 ;
  input [15:0]\weight_reg_reg[15]_0 ;
  input \weight_out_reg_reg[0]_0 ;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__1_n_0 ;
  wire \accumulator[10]_i_1__1_n_0 ;
  wire \accumulator[11]_i_1__1_n_0 ;
  wire \accumulator[12]_i_1__1_n_0 ;
  wire \accumulator[13]_i_1__1_n_0 ;
  wire \accumulator[14]_i_1__1_n_0 ;
  wire \accumulator[15]_i_1__1_n_0 ;
  wire \accumulator[16]_i_1__1_n_0 ;
  wire \accumulator[17]_i_1__1_n_0 ;
  wire \accumulator[18]_i_1__1_n_0 ;
  wire \accumulator[19]_i_1__1_n_0 ;
  wire \accumulator[1]_i_1__1_n_0 ;
  wire \accumulator[20]_i_1__1_n_0 ;
  wire \accumulator[21]_i_1__1_n_0 ;
  wire \accumulator[22]_i_1__1_n_0 ;
  wire \accumulator[23]_i_1__1_n_0 ;
  wire \accumulator[24]_i_1__1_n_0 ;
  wire \accumulator[25]_i_1__1_n_0 ;
  wire \accumulator[26]_i_1__1_n_0 ;
  wire \accumulator[27]_i_1__1_n_0 ;
  wire \accumulator[28]_i_1__1_n_0 ;
  wire \accumulator[29]_i_1__1_n_0 ;
  wire \accumulator[2]_i_1__1_n_0 ;
  wire \accumulator[30]_i_1__1_n_0 ;
  wire \accumulator[31]_i_1__1_n_0 ;
  wire \accumulator[31]_i_2__1_n_0 ;
  wire \accumulator[3]_i_1__1_n_0 ;
  wire \accumulator[4]_i_1__1_n_0 ;
  wire \accumulator[5]_i_1__1_n_0 ;
  wire \accumulator[6]_i_1__1_n_0 ;
  wire \accumulator[7]_i_1__1_n_0 ;
  wire \accumulator[8]_i_1__1_n_0 ;
  wire \accumulator[9]_i_1__1_n_0 ;
  wire accumulator_clr_IBUF;
  wire accumulator_valid_reg4_out;
  wire array_busy_reg_i_3;
  wire array_busy_reg_i_3_0;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_1;
  wire computing_reg_n_0;
  wire flush_IBUF;
  wire [15:0]input_in_IBUF;
  wire [15:0]input_out_mesh_32;
  wire \input_out_reg[0]_i_1__1_n_0 ;
  wire \input_out_reg[10]_i_1__1_n_0 ;
  wire \input_out_reg[11]_i_1__1_n_0 ;
  wire \input_out_reg[12]_i_1__1_n_0 ;
  wire \input_out_reg[13]_i_1__1_n_0 ;
  wire \input_out_reg[14]_i_1__1_n_0 ;
  wire \input_out_reg[15]_i_1__1_n_0 ;
  wire \input_out_reg[15]_i_2__1_n_0 ;
  wire \input_out_reg[1]_i_1__1_n_0 ;
  wire \input_out_reg[2]_i_1__1_n_0 ;
  wire \input_out_reg[3]_i_1__1_n_0 ;
  wire \input_out_reg[4]_i_1__1_n_0 ;
  wire \input_out_reg[5]_i_1__1_n_0 ;
  wire \input_out_reg[6]_i_1__1_n_0 ;
  wire \input_out_reg[7]_i_1__1_n_0 ;
  wire \input_out_reg[8]_i_1__1_n_0 ;
  wire \input_out_reg[9]_i_1__1_n_0 ;
  wire [15:0]\input_out_reg_reg[15]_0 ;
  wire input_out_valid_mesh_2;
  wire input_out_valid_reg;
  wire \input_reg[0]_i_1__1_n_0 ;
  wire \input_reg[10]_i_1__1_n_0 ;
  wire \input_reg[11]_i_1__1_n_0 ;
  wire \input_reg[12]_i_1__1_n_0 ;
  wire \input_reg[13]_i_1__1_n_0 ;
  wire \input_reg[14]_i_1__1_n_0 ;
  wire \input_reg[15]_i_1__1_n_0 ;
  wire \input_reg[15]_i_2__1_n_0 ;
  wire \input_reg[1]_i_1__1_n_0 ;
  wire \input_reg[2]_i_1__1_n_0 ;
  wire \input_reg[3]_i_1__1_n_0 ;
  wire \input_reg[4]_i_1__1_n_0 ;
  wire \input_reg[5]_i_1__1_n_0 ;
  wire \input_reg[6]_i_1__1_n_0 ;
  wire \input_reg[7]_i_1__1_n_0 ;
  wire \input_reg[8]_i_1__1_n_0 ;
  wire \input_reg[9]_i_1__1_n_0 ;
  wire [15:0]input_reg__0;
  wire [0:0]input_valid_IBUF;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_0;
  wire rst_n;
  wire rst_n_IBUF;
  wire [31:0]signed_mac_result__0;
  wire [15:0]weight_out_mesh_32;
  wire \weight_out_reg[0]_i_1__1_n_0 ;
  wire \weight_out_reg[10]_i_1__0_n_0 ;
  wire \weight_out_reg[11]_i_1__0_n_0 ;
  wire \weight_out_reg[12]_i_1__0_n_0 ;
  wire \weight_out_reg[13]_i_1__0_n_0 ;
  wire \weight_out_reg[14]_i_1__0_n_0 ;
  wire \weight_out_reg[15]_i_2__0_n_0 ;
  wire \weight_out_reg[1]_i_1__0_n_0 ;
  wire \weight_out_reg[2]_i_1__0_n_0 ;
  wire \weight_out_reg[3]_i_1__0_n_0 ;
  wire \weight_out_reg[4]_i_1__0_n_0 ;
  wire \weight_out_reg[5]_i_1__0_n_0 ;
  wire \weight_out_reg[6]_i_1__0_n_0 ;
  wire \weight_out_reg[7]_i_1__0_n_0 ;
  wire \weight_out_reg[8]_i_1__0_n_0 ;
  wire \weight_out_reg[9]_i_1__0_n_0 ;
  wire \weight_out_reg_reg[0]_0 ;
  wire weight_out_valid_mesh_13;
  wire [15:0]weight_reg__0;
  wire \weight_reg_reg[0]_0 ;
  wire [15:0]\weight_reg_reg[15]_0 ;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair125" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair120" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair119" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair119" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair118" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair118" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair117" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair117" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair116" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair124" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair115" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair114" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair113" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair112" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair111" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair124" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair110" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__1_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(\accumulator[31]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair123" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair123" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair122" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair122" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair121" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair121" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair120" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__1 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__1_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[0]_i_1__1_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[10]_i_1__1_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[11]_i_1__1_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[12]_i_1__1_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[13]_i_1__1_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[14]_i_1__1_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[15]_i_1__1_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[16]_i_1__1_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[17]_i_1__1_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[18]_i_1__1_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[19]_i_1__1_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[1]_i_1__1_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[20]_i_1__1_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[21]_i_1__1_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[22]_i_1__1_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[23]_i_1__1_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[24]_i_1__1_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[25]_i_1__1_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[26]_i_1__1_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[27]_i_1__1_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[28]_i_1__1_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[29]_i_1__1_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[2]_i_1__1_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[30]_i_1__1_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[31]_i_2__1_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[3]_i_1__1_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[4]_i_1__1_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[5]_i_1__1_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[6]_i_1__1_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[7]_i_1__1_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[8]_i_1__1_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\accumulator[9]_i_1__1_n_0 ),
        .Q(Q[9]));
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_12
       (.I0(computing_reg_n_0),
        .I1(array_busy_reg_i_3),
        .I2(array_busy_reg_i_3_0),
        .I3(weight_out_valid_mesh_13),
        .O(computing_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair109" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__1
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair143" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[0]_i_1__1 
       (.I0(input_reg__0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg[0]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair138" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[10]_i_1__1 
       (.I0(input_reg__0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg[10]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair138" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[11]_i_1__1 
       (.I0(input_reg__0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg[11]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair137" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[12]_i_1__1 
       (.I0(input_reg__0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg[12]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair137" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[13]_i_1__1 
       (.I0(input_reg__0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg[13]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair136" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[14]_i_1__1 
       (.I0(input_reg__0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg[14]_i_1__1_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \input_out_reg[15]_i_1__1 
       (.I0(flush_IBUF),
        .I1(input_valid_reg),
        .O(\input_out_reg[15]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair136" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[15]_i_2__1 
       (.I0(input_reg__0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg[15]_i_2__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair143" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[1]_i_1__1 
       (.I0(input_reg__0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg[1]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair142" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[2]_i_1__1 
       (.I0(input_reg__0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg[2]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair142" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[3]_i_1__1 
       (.I0(input_reg__0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg[3]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair141" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[4]_i_1__1 
       (.I0(input_reg__0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg[4]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair141" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[5]_i_1__1 
       (.I0(input_reg__0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg[5]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair140" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[6]_i_1__1 
       (.I0(input_reg__0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg[6]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair140" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[7]_i_1__1 
       (.I0(input_reg__0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg[7]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair139" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[8]_i_1__1 
       (.I0(input_reg__0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg[8]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair139" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[9]_i_1__1 
       (.I0(input_reg__0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg[9]_i_1__1_n_0 ));
  FDCE \input_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[0]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[0]));
  FDCE \input_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[10]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[10]));
  FDCE \input_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[11]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[11]));
  FDCE \input_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[12]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[12]));
  FDCE \input_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[13]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[13]));
  FDCE \input_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[14]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[14]));
  FDCE \input_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[15]_i_2__1_n_0 ),
        .Q(input_out_mesh_32[15]));
  FDCE \input_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[1]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[1]));
  FDCE \input_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[2]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[2]));
  FDCE \input_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[3]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[3]));
  FDCE \input_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[4]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[4]));
  FDCE \input_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[5]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[5]));
  FDCE \input_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[6]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[6]));
  FDCE \input_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[7]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[7]));
  FDCE \input_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[8]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[8]));
  FDCE \input_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_out_reg[9]_i_1__1_n_0 ),
        .Q(input_out_mesh_32[9]));
  (* SOFT_HLUTNM = "soft_lutpair126" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__1
       (.I0(input_valid_reg),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(rst_n),
        .D(input_out_valid_reg),
        .Q(input_out_valid_mesh_2));
  (* SOFT_HLUTNM = "soft_lutpair135" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__1 
       (.I0(input_in_IBUF[0]),
        .I1(flush_IBUF),
        .O(\input_reg[0]_i_1__1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__5 
       (.I0(input_out_mesh_32[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair130" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__1 
       (.I0(input_in_IBUF[10]),
        .I1(flush_IBUF),
        .O(\input_reg[10]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair162" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__5 
       (.I0(input_out_mesh_32[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [10]));
  (* SOFT_HLUTNM = "soft_lutpair129" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__1 
       (.I0(input_in_IBUF[11]),
        .I1(flush_IBUF),
        .O(\input_reg[11]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair161" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__5 
       (.I0(input_out_mesh_32[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [11]));
  (* SOFT_HLUTNM = "soft_lutpair129" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__1 
       (.I0(input_in_IBUF[12]),
        .I1(flush_IBUF),
        .O(\input_reg[12]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair161" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__5 
       (.I0(input_out_mesh_32[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [12]));
  (* SOFT_HLUTNM = "soft_lutpair128" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__1 
       (.I0(input_in_IBUF[13]),
        .I1(flush_IBUF),
        .O(\input_reg[13]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair160" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__5 
       (.I0(input_out_mesh_32[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [13]));
  (* SOFT_HLUTNM = "soft_lutpair128" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__1 
       (.I0(input_in_IBUF[14]),
        .I1(flush_IBUF),
        .O(\input_reg[14]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair160" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__5 
       (.I0(input_out_mesh_32[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [14]));
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__1 
       (.I0(flush_IBUF),
        .I1(input_valid_IBUF),
        .O(\input_reg[15]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair127" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__5 
       (.I0(flush_IBUF),
        .I1(input_out_valid_mesh_2),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair127" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__1 
       (.I0(input_in_IBUF[15]),
        .I1(flush_IBUF),
        .O(\input_reg[15]_i_2__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair159" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__5 
       (.I0(input_out_mesh_32[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [15]));
  LUT1 #(
    .INIT(2'h1)) 
    \input_reg[15]_i_3 
       (.I0(rst_n_IBUF),
        .O(rst_n));
  (* SOFT_HLUTNM = "soft_lutpair134" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__1 
       (.I0(input_in_IBUF[1]),
        .I1(flush_IBUF),
        .O(\input_reg[1]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair166" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__5 
       (.I0(input_out_mesh_32[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [1]));
  (* SOFT_HLUTNM = "soft_lutpair134" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__1 
       (.I0(input_in_IBUF[2]),
        .I1(flush_IBUF),
        .O(\input_reg[2]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair166" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__5 
       (.I0(input_out_mesh_32[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [2]));
  (* SOFT_HLUTNM = "soft_lutpair133" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__1 
       (.I0(input_in_IBUF[3]),
        .I1(flush_IBUF),
        .O(\input_reg[3]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair165" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__5 
       (.I0(input_out_mesh_32[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [3]));
  (* SOFT_HLUTNM = "soft_lutpair133" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__1 
       (.I0(input_in_IBUF[4]),
        .I1(flush_IBUF),
        .O(\input_reg[4]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair165" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__5 
       (.I0(input_out_mesh_32[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [4]));
  (* SOFT_HLUTNM = "soft_lutpair132" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__1 
       (.I0(input_in_IBUF[5]),
        .I1(flush_IBUF),
        .O(\input_reg[5]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair164" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__5 
       (.I0(input_out_mesh_32[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [5]));
  (* SOFT_HLUTNM = "soft_lutpair132" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__1 
       (.I0(input_in_IBUF[6]),
        .I1(flush_IBUF),
        .O(\input_reg[6]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair164" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__5 
       (.I0(input_out_mesh_32[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [6]));
  (* SOFT_HLUTNM = "soft_lutpair131" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__1 
       (.I0(input_in_IBUF[7]),
        .I1(flush_IBUF),
        .O(\input_reg[7]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair163" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__5 
       (.I0(input_out_mesh_32[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [7]));
  (* SOFT_HLUTNM = "soft_lutpair131" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__1 
       (.I0(input_in_IBUF[8]),
        .I1(flush_IBUF),
        .O(\input_reg[8]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair163" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__5 
       (.I0(input_out_mesh_32[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [8]));
  (* SOFT_HLUTNM = "soft_lutpair130" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__1 
       (.I0(input_in_IBUF[9]),
        .I1(flush_IBUF),
        .O(\input_reg[9]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair162" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__5 
       (.I0(input_out_mesh_32[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg_reg[15]_0 [9]));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[0]_i_1__1_n_0 ),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[10]_i_1__1_n_0 ),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[11]_i_1__1_n_0 ),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[12]_i_1__1_n_0 ),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[13]_i_1__1_n_0 ),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[14]_i_1__1_n_0 ),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[15]_i_2__1_n_0 ),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[1]_i_1__1_n_0 ),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[2]_i_1__1_n_0 ),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[3]_i_1__1_n_0 ),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[4]_i_1__1_n_0 ),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[5]_i_1__1_n_0 ),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[6]_i_1__1_n_0 ),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[7]_i_1__1_n_0 ),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[8]_i_1__1_n_0 ),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__1_n_0 ),
        .CLR(rst_n),
        .D(\input_reg[9]_i_1__1_n_0 ),
        .Q(input_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair126" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__1
       (.I0(input_valid_IBUF),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out_0));
  (* SOFT_HLUTNM = "soft_lutpair125" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__5
       (.I0(input_out_valid_mesh_2),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(rst_n),
        .D(input_valid_reg11_out_0),
        .Q(input_valid_reg));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,weight_reg__0}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
  (* SOFT_HLUTNM = "soft_lutpair151" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[0]_i_1__1 
       (.I0(weight_reg__0[0]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[0]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair146" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[10]_i_1__0 
       (.I0(weight_reg__0[10]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[10]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair146" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[11]_i_1__0 
       (.I0(weight_reg__0[11]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[11]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair145" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[12]_i_1__0 
       (.I0(weight_reg__0[12]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[12]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair145" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[13]_i_1__0 
       (.I0(weight_reg__0[13]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[13]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair144" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[14]_i_1__0 
       (.I0(weight_reg__0[14]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[14]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair144" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[15]_i_2__0 
       (.I0(weight_reg__0[15]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[15]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair151" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[1]_i_1__0 
       (.I0(weight_reg__0[1]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair150" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[2]_i_1__0 
       (.I0(weight_reg__0[2]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[2]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair150" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[3]_i_1__0 
       (.I0(weight_reg__0[3]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[3]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair149" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[4]_i_1__0 
       (.I0(weight_reg__0[4]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[4]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair149" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[5]_i_1__0 
       (.I0(weight_reg__0[5]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[5]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair148" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[6]_i_1__0 
       (.I0(weight_reg__0[6]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[6]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair148" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[7]_i_1__0 
       (.I0(weight_reg__0[7]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[7]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair147" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[8]_i_1__0 
       (.I0(weight_reg__0[8]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[8]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair147" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[9]_i_1__0 
       (.I0(weight_reg__0[9]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[9]_i_1__0_n_0 ));
  FDCE \weight_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[0]_i_1__1_n_0 ),
        .Q(weight_out_mesh_32[0]));
  FDCE \weight_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[10]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[10]));
  FDCE \weight_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[11]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[11]));
  FDCE \weight_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[12]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[12]));
  FDCE \weight_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[13]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[13]));
  FDCE \weight_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[14]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[14]));
  FDCE \weight_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[15]_i_2__0_n_0 ),
        .Q(weight_out_mesh_32[15]));
  FDCE \weight_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[1]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[1]));
  FDCE \weight_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[2]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[2]));
  FDCE \weight_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[3]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[3]));
  FDCE \weight_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[4]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[4]));
  FDCE \weight_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[5]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[5]));
  FDCE \weight_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[6]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[6]));
  FDCE \weight_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[7]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[7]));
  FDCE \weight_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[8]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[8]));
  FDCE \weight_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_out_reg[9]_i_1__0_n_0 ),
        .Q(weight_out_mesh_32[9]));
  (* SOFT_HLUTNM = "soft_lutpair159" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[0]_i_1__2 
       (.I0(weight_out_mesh_32[0]),
        .I1(flush_IBUF),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair154" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[10]_i_1__2 
       (.I0(weight_out_mesh_32[10]),
        .I1(flush_IBUF),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair153" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[11]_i_1__2 
       (.I0(weight_out_mesh_32[11]),
        .I1(flush_IBUF),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair153" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[12]_i_1__2 
       (.I0(weight_out_mesh_32[12]),
        .I1(flush_IBUF),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair152" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[13]_i_1__2 
       (.I0(weight_out_mesh_32[13]),
        .I1(flush_IBUF),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair152" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[14]_i_1__2 
       (.I0(weight_out_mesh_32[14]),
        .I1(flush_IBUF),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair135" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[15]_i_2__1 
       (.I0(weight_out_mesh_32[15]),
        .I1(flush_IBUF),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair158" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[1]_i_1__2 
       (.I0(weight_out_mesh_32[1]),
        .I1(flush_IBUF),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair158" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[2]_i_1__2 
       (.I0(weight_out_mesh_32[2]),
        .I1(flush_IBUF),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair157" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[3]_i_1__2 
       (.I0(weight_out_mesh_32[3]),
        .I1(flush_IBUF),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair157" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[4]_i_1__2 
       (.I0(weight_out_mesh_32[4]),
        .I1(flush_IBUF),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair156" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[5]_i_1__2 
       (.I0(weight_out_mesh_32[5]),
        .I1(flush_IBUF),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair156" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[6]_i_1__2 
       (.I0(weight_out_mesh_32[6]),
        .I1(flush_IBUF),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair155" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[7]_i_1__2 
       (.I0(weight_out_mesh_32[7]),
        .I1(flush_IBUF),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair155" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[8]_i_1__2 
       (.I0(weight_out_mesh_32[8]),
        .I1(flush_IBUF),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair154" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[9]_i_1__2 
       (.I0(weight_out_mesh_32[9]),
        .I1(flush_IBUF),
        .O(D[9]));
  FDCE \weight_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [0]),
        .Q(weight_reg__0[0]));
  FDCE \weight_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [10]),
        .Q(weight_reg__0[10]));
  FDCE \weight_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [11]),
        .Q(weight_reg__0[11]));
  FDCE \weight_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [12]),
        .Q(weight_reg__0[12]));
  FDCE \weight_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [13]),
        .Q(weight_reg__0[13]));
  FDCE \weight_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [14]),
        .Q(weight_reg__0[14]));
  FDCE \weight_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [15]),
        .Q(weight_reg__0[15]));
  FDCE \weight_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [1]),
        .Q(weight_reg__0[1]));
  FDCE \weight_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [2]),
        .Q(weight_reg__0[2]));
  FDCE \weight_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [3]),
        .Q(weight_reg__0[3]));
  FDCE \weight_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [4]),
        .Q(weight_reg__0[4]));
  FDCE \weight_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [5]),
        .Q(weight_reg__0[5]));
  FDCE \weight_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [6]),
        .Q(weight_reg__0[6]));
  FDCE \weight_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [7]),
        .Q(weight_reg__0[7]));
  FDCE \weight_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [8]),
        .Q(weight_reg__0[8]));
  FDCE \weight_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(rst_n),
        .D(\weight_reg_reg[15]_0 [9]),
        .Q(weight_reg__0[9]));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_10
   (Q,
    input_valid_reg11_out,
    E,
    input_valid_reg_reg_0,
    D,
    B,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    input_valid_reg11_out_0,
    flush_IBUF,
    array_busy_reg_reg,
    array_busy_reg_reg_0,
    input_valid_reg,
    weight_out_valid_mesh_13,
    array_busy_reg_i_5_0,
    array_busy_reg_i_5_1,
    array_busy_reg_i_5_2,
    accumulator_clr_IBUF,
    computing_reg_0,
    \input_reg_reg[15]_0 ,
    \input_reg_reg[15]_1 );
  output [31:0]Q;
  output input_valid_reg11_out;
  output [0:0]E;
  output input_valid_reg_reg_0;
  output [15:0]D;
  input [15:0]B;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input input_valid_reg11_out_0;
  input flush_IBUF;
  input array_busy_reg_reg;
  input array_busy_reg_reg_0;
  input input_valid_reg;
  input weight_out_valid_mesh_13;
  input array_busy_reg_i_5_0;
  input array_busy_reg_i_5_1;
  input array_busy_reg_i_5_2;
  input accumulator_clr_IBUF;
  input computing_reg_0;
  input [0:0]\input_reg_reg[15]_0 ;
  input [15:0]\input_reg_reg[15]_1 ;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__10_n_0 ;
  wire \accumulator[10]_i_1__10_n_0 ;
  wire \accumulator[11]_i_1__10_n_0 ;
  wire \accumulator[12]_i_1__10_n_0 ;
  wire \accumulator[13]_i_1__10_n_0 ;
  wire \accumulator[14]_i_1__10_n_0 ;
  wire \accumulator[15]_i_1__10_n_0 ;
  wire \accumulator[16]_i_1__10_n_0 ;
  wire \accumulator[17]_i_1__10_n_0 ;
  wire \accumulator[18]_i_1__10_n_0 ;
  wire \accumulator[19]_i_1__10_n_0 ;
  wire \accumulator[1]_i_1__10_n_0 ;
  wire \accumulator[20]_i_1__10_n_0 ;
  wire \accumulator[21]_i_1__10_n_0 ;
  wire \accumulator[22]_i_1__10_n_0 ;
  wire \accumulator[23]_i_1__10_n_0 ;
  wire \accumulator[24]_i_1__10_n_0 ;
  wire \accumulator[25]_i_1__10_n_0 ;
  wire \accumulator[26]_i_1__10_n_0 ;
  wire \accumulator[27]_i_1__10_n_0 ;
  wire \accumulator[28]_i_1__10_n_0 ;
  wire \accumulator[29]_i_1__10_n_0 ;
  wire \accumulator[2]_i_1__10_n_0 ;
  wire \accumulator[30]_i_1__10_n_0 ;
  wire \accumulator[31]_i_1__10_n_0 ;
  wire \accumulator[31]_i_2__10_n_0 ;
  wire \accumulator[3]_i_1__10_n_0 ;
  wire \accumulator[4]_i_1__10_n_0 ;
  wire \accumulator[5]_i_1__10_n_0 ;
  wire \accumulator[6]_i_1__10_n_0 ;
  wire \accumulator[7]_i_1__10_n_0 ;
  wire \accumulator[8]_i_1__10_n_0 ;
  wire \accumulator[9]_i_1__10_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire array_busy_reg_i_19_n_0;
  wire array_busy_reg_i_20_n_0;
  wire array_busy_reg_i_5_0;
  wire array_busy_reg_i_5_1;
  wire array_busy_reg_i_5_2;
  wire array_busy_reg_reg;
  wire array_busy_reg_reg_0;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_n_0;
  wire flush_IBUF;
  wire [15:0]input_out_mesh_176;
  wire \input_out_reg[0]_i_1__10_n_0 ;
  wire \input_out_reg[10]_i_1__10_n_0 ;
  wire \input_out_reg[11]_i_1__10_n_0 ;
  wire \input_out_reg[12]_i_1__10_n_0 ;
  wire \input_out_reg[13]_i_1__10_n_0 ;
  wire \input_out_reg[14]_i_1__10_n_0 ;
  wire \input_out_reg[15]_i_1__10_n_0 ;
  wire \input_out_reg[15]_i_2__10_n_0 ;
  wire \input_out_reg[1]_i_1__10_n_0 ;
  wire \input_out_reg[2]_i_1__10_n_0 ;
  wire \input_out_reg[3]_i_1__10_n_0 ;
  wire \input_out_reg[4]_i_1__10_n_0 ;
  wire \input_out_reg[5]_i_1__10_n_0 ;
  wire \input_out_reg[6]_i_1__10_n_0 ;
  wire \input_out_reg[7]_i_1__10_n_0 ;
  wire \input_out_reg[8]_i_1__10_n_0 ;
  wire \input_out_reg[9]_i_1__10_n_0 ;
  wire input_out_valid_mesh_11;
  wire input_out_valid_reg;
  wire [15:0]input_reg__0;
  wire [0:0]\input_reg_reg[15]_0 ;
  wire [15:0]\input_reg_reg[15]_1 ;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_0;
  wire input_valid_reg_0;
  wire input_valid_reg_reg_0;
  wire [31:0]signed_mac_result__0;
  wire weight_out_valid_mesh_13;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair465" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair460" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair459" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair459" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair458" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair458" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair457" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair457" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair456" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair456" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair455" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair464" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair455" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair454" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair454" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair453" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair453" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair452" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair452" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair451" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair451" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair450" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair464" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair450" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__10_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg_0),
        .I3(computing_reg_0),
        .O(\accumulator[31]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair449" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair463" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair463" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair462" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair462" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair461" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair461" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair460" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__10 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__10_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__10_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__10_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__10_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__10_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__10_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__10_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__10_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__10_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__10_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__10_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__10_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__10_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__10_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__10_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__10_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__10_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__10_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__10_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__10_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__10_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__10_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__10_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__10_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__10_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__10_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__10_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__10_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__10_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__10_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__10_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__10_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__10_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair448" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_19
       (.I0(input_valid_reg_0),
        .I1(input_valid_reg),
        .I2(input_out_valid_mesh_11),
        .I3(weight_out_valid_mesh_13),
        .O(array_busy_reg_i_19_n_0));
  LUT4 #(
    .INIT(16'h0001)) 
    array_busy_reg_i_20
       (.I0(computing_reg_n_0),
        .I1(array_busy_reg_i_5_0),
        .I2(array_busy_reg_i_5_1),
        .I3(array_busy_reg_i_5_2),
        .O(array_busy_reg_i_20_n_0));
  LUT4 #(
    .INIT(16'h0004)) 
    array_busy_reg_i_5
       (.I0(array_busy_reg_i_19_n_0),
        .I1(array_busy_reg_i_20_n_0),
        .I2(array_busy_reg_reg),
        .I3(array_busy_reg_reg_0),
        .O(input_valid_reg_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair449" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__10
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg_0),
        .I3(computing_reg_0),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair474" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[0]_i_1__10 
       (.I0(input_reg__0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg[0]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair469" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[10]_i_1__10 
       (.I0(input_reg__0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg[10]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair468" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[11]_i_1__10 
       (.I0(input_reg__0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg[11]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair468" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[12]_i_1__10 
       (.I0(input_reg__0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg[12]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair467" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[13]_i_1__10 
       (.I0(input_reg__0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg[13]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair467" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[14]_i_1__10 
       (.I0(input_reg__0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg[14]_i_1__10_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \input_out_reg[15]_i_1__10 
       (.I0(flush_IBUF),
        .I1(input_valid_reg_0),
        .O(\input_out_reg[15]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair466" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[15]_i_2__10 
       (.I0(input_reg__0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg[15]_i_2__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair473" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[1]_i_1__10 
       (.I0(input_reg__0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg[1]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair473" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[2]_i_1__10 
       (.I0(input_reg__0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg[2]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair472" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[3]_i_1__10 
       (.I0(input_reg__0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg[3]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair472" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[4]_i_1__10 
       (.I0(input_reg__0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg[4]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair471" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[5]_i_1__10 
       (.I0(input_reg__0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg[5]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair471" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[6]_i_1__10 
       (.I0(input_reg__0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg[6]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair470" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[7]_i_1__10 
       (.I0(input_reg__0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg[7]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair470" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[8]_i_1__10 
       (.I0(input_reg__0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg[8]_i_1__10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair469" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[9]_i_1__10 
       (.I0(input_reg__0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg[9]_i_1__10_n_0 ));
  FDCE \input_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[0]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[0]));
  FDCE \input_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[10]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[10]));
  FDCE \input_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[11]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[11]));
  FDCE \input_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[12]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[12]));
  FDCE \input_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[13]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[13]));
  FDCE \input_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[14]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[14]));
  FDCE \input_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[15]_i_2__10_n_0 ),
        .Q(input_out_mesh_176[15]));
  FDCE \input_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[1]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[1]));
  FDCE \input_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[2]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[2]));
  FDCE \input_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[3]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[3]));
  FDCE \input_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[4]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[4]));
  FDCE \input_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[5]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[5]));
  FDCE \input_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[6]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[6]));
  FDCE \input_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[7]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[7]));
  FDCE \input_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[8]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[8]));
  FDCE \input_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__10_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[9]_i_1__10_n_0 ),
        .Q(input_out_mesh_176[9]));
  (* SOFT_HLUTNM = "soft_lutpair448" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__10
       (.I0(input_valid_reg_0),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_mesh_11));
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__14 
       (.I0(input_out_mesh_176[0]),
        .I1(flush_IBUF),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair477" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__14 
       (.I0(input_out_mesh_176[10]),
        .I1(flush_IBUF),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair476" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__14 
       (.I0(input_out_mesh_176[11]),
        .I1(flush_IBUF),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair476" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__14 
       (.I0(input_out_mesh_176[12]),
        .I1(flush_IBUF),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair475" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__14 
       (.I0(input_out_mesh_176[13]),
        .I1(flush_IBUF),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair475" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__14 
       (.I0(input_out_mesh_176[14]),
        .I1(flush_IBUF),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair466" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__14 
       (.I0(flush_IBUF),
        .I1(input_out_valid_mesh_11),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair474" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__14 
       (.I0(input_out_mesh_176[15]),
        .I1(flush_IBUF),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair481" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__14 
       (.I0(input_out_mesh_176[1]),
        .I1(flush_IBUF),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair481" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__14 
       (.I0(input_out_mesh_176[2]),
        .I1(flush_IBUF),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair480" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__14 
       (.I0(input_out_mesh_176[3]),
        .I1(flush_IBUF),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair480" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__14 
       (.I0(input_out_mesh_176[4]),
        .I1(flush_IBUF),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair479" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__14 
       (.I0(input_out_mesh_176[5]),
        .I1(flush_IBUF),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair479" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__14 
       (.I0(input_out_mesh_176[6]),
        .I1(flush_IBUF),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair478" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__14 
       (.I0(input_out_mesh_176[7]),
        .I1(flush_IBUF),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair478" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__14 
       (.I0(input_out_mesh_176[8]),
        .I1(flush_IBUF),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair477" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__14 
       (.I0(input_out_mesh_176[9]),
        .I1(flush_IBUF),
        .O(D[9]));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [0]),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [10]),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [11]),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [12]),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [13]),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [14]),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [15]),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [1]),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [2]),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [3]),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [4]),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [5]),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [6]),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [7]),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [8]),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [9]),
        .Q(input_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair465" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__14
       (.I0(input_out_valid_mesh_11),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out_0),
        .Q(input_valid_reg_0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_11
   (B,
    Q,
    \weight_reg_reg[15]_0 ,
    weight_valid_reg_reg_0,
    weight_out_valid_mesh_12,
    weight_valid_reg_reg_1,
    weight_valid_reg15_out,
    weight_out_valid_reg_reg_0,
    input_valid_reg_reg_0,
    weight_out_valid_reg_reg_1,
    \weight_out_reg_reg[15]_0 ,
    \weight_out_reg_reg[14]_0 ,
    \weight_out_reg_reg[13]_0 ,
    \weight_out_reg_reg[12]_0 ,
    \weight_out_reg_reg[11]_0 ,
    \weight_out_reg_reg[10]_0 ,
    \weight_out_reg_reg[9]_0 ,
    \weight_out_reg_reg[8]_0 ,
    \weight_out_reg_reg[7]_0 ,
    \weight_out_reg_reg[6]_0 ,
    \weight_out_reg_reg[5]_0 ,
    \weight_out_reg_reg[4]_0 ,
    \weight_out_reg_reg[3]_0 ,
    \weight_out_reg_reg[2]_0 ,
    \weight_out_reg_reg[1]_0 ,
    \weight_out_reg_reg[0]_0 ,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    input_valid_reg11_out,
    flush_IBUF,
    weight_valid_IBUF,
    input_valid_reg,
    array_busy_reg_i_2,
    weight_in_IBUF,
    accumulator_clr_IBUF,
    E,
    D);
  output [15:0]B;
  output [31:0]Q;
  output [15:0]\weight_reg_reg[15]_0 ;
  output weight_valid_reg_reg_0;
  output weight_out_valid_mesh_12;
  output [0:0]weight_valid_reg_reg_1;
  output weight_valid_reg15_out;
  output weight_out_valid_reg_reg_0;
  output input_valid_reg_reg_0;
  output weight_out_valid_reg_reg_1;
  output \weight_out_reg_reg[15]_0 ;
  output \weight_out_reg_reg[14]_0 ;
  output \weight_out_reg_reg[13]_0 ;
  output \weight_out_reg_reg[12]_0 ;
  output \weight_out_reg_reg[11]_0 ;
  output \weight_out_reg_reg[10]_0 ;
  output \weight_out_reg_reg[9]_0 ;
  output \weight_out_reg_reg[8]_0 ;
  output \weight_out_reg_reg[7]_0 ;
  output \weight_out_reg_reg[6]_0 ;
  output \weight_out_reg_reg[5]_0 ;
  output \weight_out_reg_reg[4]_0 ;
  output \weight_out_reg_reg[3]_0 ;
  output \weight_out_reg_reg[2]_0 ;
  output \weight_out_reg_reg[1]_0 ;
  output \weight_out_reg_reg[0]_0 ;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input input_valid_reg11_out;
  input flush_IBUF;
  input weight_valid_IBUF;
  input input_valid_reg;
  input array_busy_reg_i_2;
  input [15:0]weight_in_IBUF;
  input accumulator_clr_IBUF;
  input [0:0]E;
  input [15:0]D;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__11_n_0 ;
  wire \accumulator[10]_i_1__11_n_0 ;
  wire \accumulator[11]_i_1__11_n_0 ;
  wire \accumulator[12]_i_1__11_n_0 ;
  wire \accumulator[13]_i_1__11_n_0 ;
  wire \accumulator[14]_i_1__11_n_0 ;
  wire \accumulator[15]_i_1__11_n_0 ;
  wire \accumulator[16]_i_1__11_n_0 ;
  wire \accumulator[17]_i_1__11_n_0 ;
  wire \accumulator[18]_i_1__11_n_0 ;
  wire \accumulator[19]_i_1__11_n_0 ;
  wire \accumulator[1]_i_1__11_n_0 ;
  wire \accumulator[20]_i_1__11_n_0 ;
  wire \accumulator[21]_i_1__11_n_0 ;
  wire \accumulator[22]_i_1__11_n_0 ;
  wire \accumulator[23]_i_1__11_n_0 ;
  wire \accumulator[24]_i_1__11_n_0 ;
  wire \accumulator[25]_i_1__11_n_0 ;
  wire \accumulator[26]_i_1__11_n_0 ;
  wire \accumulator[27]_i_1__11_n_0 ;
  wire \accumulator[28]_i_1__11_n_0 ;
  wire \accumulator[29]_i_1__11_n_0 ;
  wire \accumulator[2]_i_1__11_n_0 ;
  wire \accumulator[30]_i_1__11_n_0 ;
  wire \accumulator[31]_i_1__11_n_0 ;
  wire \accumulator[31]_i_2__11_n_0 ;
  wire \accumulator[3]_i_1__11_n_0 ;
  wire \accumulator[4]_i_1__11_n_0 ;
  wire \accumulator[5]_i_1__11_n_0 ;
  wire \accumulator[6]_i_1__11_n_0 ;
  wire \accumulator[7]_i_1__11_n_0 ;
  wire \accumulator[8]_i_1__11_n_0 ;
  wire \accumulator[9]_i_1__11_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire array_busy_reg_i_2;
  wire clk_IBUF_BUFG;
  wire computing_reg_n_0;
  wire flush_IBUF;
  wire input_out_valid_reg;
  wire input_out_valid_reg_reg_n_0;
  wire [15:0]input_reg__0;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg_0;
  wire input_valid_reg_reg_0;
  wire [31:0]signed_mac_result__0;
  wire [15:0]weight_in_IBUF;
  wire [15:0]weight_out_mesh_192;
  wire \weight_out_reg[0]_i_1_n_0 ;
  wire \weight_out_reg_reg[0]_0 ;
  wire \weight_out_reg_reg[10]_0 ;
  wire \weight_out_reg_reg[11]_0 ;
  wire \weight_out_reg_reg[12]_0 ;
  wire \weight_out_reg_reg[13]_0 ;
  wire \weight_out_reg_reg[14]_0 ;
  wire \weight_out_reg_reg[15]_0 ;
  wire \weight_out_reg_reg[1]_0 ;
  wire \weight_out_reg_reg[2]_0 ;
  wire \weight_out_reg_reg[3]_0 ;
  wire \weight_out_reg_reg[4]_0 ;
  wire \weight_out_reg_reg[5]_0 ;
  wire \weight_out_reg_reg[6]_0 ;
  wire \weight_out_reg_reg[7]_0 ;
  wire \weight_out_reg_reg[8]_0 ;
  wire \weight_out_reg_reg[9]_0 ;
  wire weight_out_valid_mesh_12;
  wire weight_out_valid_reg;
  wire weight_out_valid_reg_reg_0;
  wire weight_out_valid_reg_reg_1;
  wire \weight_reg[0]_i_1_n_0 ;
  wire \weight_reg[0]_i_2_n_0 ;
  wire \weight_reg[10]_i_1_n_0 ;
  wire \weight_reg[11]_i_1_n_0 ;
  wire \weight_reg[12]_i_1_n_0 ;
  wire \weight_reg[13]_i_1_n_0 ;
  wire \weight_reg[14]_i_1_n_0 ;
  wire \weight_reg[15]_i_1__2_n_0 ;
  wire \weight_reg[1]_i_1_n_0 ;
  wire \weight_reg[2]_i_1_n_0 ;
  wire \weight_reg[3]_i_1_n_0 ;
  wire \weight_reg[4]_i_1_n_0 ;
  wire \weight_reg[5]_i_1_n_0 ;
  wire \weight_reg[6]_i_1_n_0 ;
  wire \weight_reg[7]_i_1_n_0 ;
  wire \weight_reg[8]_i_1_n_0 ;
  wire \weight_reg[9]_i_1_n_0 ;
  wire [15:0]\weight_reg_reg[15]_0 ;
  wire weight_valid_IBUF;
  wire weight_valid_reg15_out;
  wire weight_valid_reg15_out_1;
  wire weight_valid_reg_reg_0;
  wire [0:0]weight_valid_reg_reg_1;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair500" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair495" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair494" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair494" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair493" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair493" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair492" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair492" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair491" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair491" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair490" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair499" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair490" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair489" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair489" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair488" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair488" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair487" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair487" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair486" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair486" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair485" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair499" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair485" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__11_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg_0),
        .I3(weight_valid_reg_reg_0),
        .O(\accumulator[31]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair484" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair498" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair498" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair497" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair497" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair496" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair496" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair495" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__11 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__11_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__11_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__11_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__11_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__11_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__11_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__11_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__11_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__11_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__11_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__11_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__11_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__11_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__11_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__11_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__11_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__11_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__11_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__11_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__11_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__11_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__11_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__11_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__11_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__11_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__11_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__11_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__11_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__11_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__11_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__11_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__11_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__11_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair483" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_26
       (.I0(weight_out_valid_mesh_12),
        .I1(weight_valid_reg_reg_0),
        .I2(input_out_valid_reg_reg_n_0),
        .I3(input_valid_reg_0),
        .O(weight_out_valid_reg_reg_1));
  (* SOFT_HLUTNM = "soft_lutpair482" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_9
       (.I0(input_valid_reg),
        .I1(weight_valid_reg_reg_0),
        .I2(computing_reg_n_0),
        .I3(array_busy_reg_i_2),
        .O(input_valid_reg_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair484" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__11
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg_0),
        .I3(weight_valid_reg_reg_0),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__11_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair502" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__11
       (.I0(input_valid_reg_0),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_reg_reg_n_0));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[0]),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[10]),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[11]),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[12]),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[13]),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[14]),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[15]),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[1]),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[2]),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[3]),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[4]),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[5]),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[6]),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[7]),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[8]),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[9]),
        .Q(input_reg__0[9]));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out),
        .Q(input_valid_reg_0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
  LUT2 #(
    .INIT(4'hE)) 
    \weight_out_reg[0]_i_1 
       (.I0(flush_IBUF),
        .I1(weight_valid_reg_reg_0),
        .O(\weight_out_reg[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair518" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[0]_i_1__2 
       (.I0(B[0]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [0]));
  (* SOFT_HLUTNM = "soft_lutpair513" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[10]_i_1__1 
       (.I0(B[10]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [10]));
  (* SOFT_HLUTNM = "soft_lutpair512" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[11]_i_1__1 
       (.I0(B[11]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [11]));
  (* SOFT_HLUTNM = "soft_lutpair512" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[12]_i_1__1 
       (.I0(B[12]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [12]));
  (* SOFT_HLUTNM = "soft_lutpair511" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[13]_i_1__1 
       (.I0(B[13]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [13]));
  (* SOFT_HLUTNM = "soft_lutpair511" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[14]_i_1__1 
       (.I0(B[14]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [14]));
  (* SOFT_HLUTNM = "soft_lutpair482" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \weight_out_reg[15]_i_1 
       (.I0(weight_valid_reg_reg_0),
        .I1(flush_IBUF),
        .O(weight_valid_reg_reg_1));
  (* SOFT_HLUTNM = "soft_lutpair502" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[15]_i_2__1 
       (.I0(B[15]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [15]));
  (* SOFT_HLUTNM = "soft_lutpair517" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[1]_i_1__1 
       (.I0(B[1]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [1]));
  (* SOFT_HLUTNM = "soft_lutpair517" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[2]_i_1__1 
       (.I0(B[2]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [2]));
  (* SOFT_HLUTNM = "soft_lutpair516" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[3]_i_1__1 
       (.I0(B[3]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [3]));
  (* SOFT_HLUTNM = "soft_lutpair516" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[4]_i_1__1 
       (.I0(B[4]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [4]));
  (* SOFT_HLUTNM = "soft_lutpair515" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[5]_i_1__1 
       (.I0(B[5]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [5]));
  (* SOFT_HLUTNM = "soft_lutpair515" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[6]_i_1__1 
       (.I0(B[6]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [6]));
  (* SOFT_HLUTNM = "soft_lutpair514" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[7]_i_1__1 
       (.I0(B[7]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [7]));
  (* SOFT_HLUTNM = "soft_lutpair514" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[8]_i_1__1 
       (.I0(B[8]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [8]));
  (* SOFT_HLUTNM = "soft_lutpair513" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[9]_i_1__1 
       (.I0(B[9]),
        .I1(flush_IBUF),
        .O(\weight_reg_reg[15]_0 [9]));
  FDCE \weight_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [0]),
        .Q(weight_out_mesh_192[0]));
  FDCE \weight_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [10]),
        .Q(weight_out_mesh_192[10]));
  FDCE \weight_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [11]),
        .Q(weight_out_mesh_192[11]));
  FDCE \weight_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [12]),
        .Q(weight_out_mesh_192[12]));
  FDCE \weight_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [13]),
        .Q(weight_out_mesh_192[13]));
  FDCE \weight_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [14]),
        .Q(weight_out_mesh_192[14]));
  FDCE \weight_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [15]),
        .Q(weight_out_mesh_192[15]));
  FDCE \weight_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [1]),
        .Q(weight_out_mesh_192[1]));
  FDCE \weight_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [2]),
        .Q(weight_out_mesh_192[2]));
  FDCE \weight_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [3]),
        .Q(weight_out_mesh_192[3]));
  FDCE \weight_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [4]),
        .Q(weight_out_mesh_192[4]));
  FDCE \weight_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [5]),
        .Q(weight_out_mesh_192[5]));
  FDCE \weight_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [6]),
        .Q(weight_out_mesh_192[6]));
  FDCE \weight_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [7]),
        .Q(weight_out_mesh_192[7]));
  FDCE \weight_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [8]),
        .Q(weight_out_mesh_192[8]));
  FDCE \weight_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_out_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [9]),
        .Q(weight_out_mesh_192[9]));
  (* SOFT_HLUTNM = "soft_lutpair501" *) 
  LUT2 #(
    .INIT(4'h2)) 
    weight_out_valid_reg_i_1__0
       (.I0(weight_valid_reg_reg_0),
        .I1(flush_IBUF),
        .O(weight_out_valid_reg));
  FDCE weight_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(weight_out_valid_reg),
        .Q(weight_out_valid_mesh_12));
  LUT2 #(
    .INIT(4'hE)) 
    \weight_reg[0]_i_1 
       (.I0(weight_valid_IBUF),
        .I1(flush_IBUF),
        .O(\weight_reg[0]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[0]_i_1__3 
       (.I0(weight_out_mesh_192[0]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[0]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair510" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[0]_i_2 
       (.I0(weight_in_IBUF[0]),
        .I1(flush_IBUF),
        .O(\weight_reg[0]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair505" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[10]_i_1 
       (.I0(weight_in_IBUF[10]),
        .I1(flush_IBUF),
        .O(\weight_reg[10]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair521" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[10]_i_1__3 
       (.I0(weight_out_mesh_192[10]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[10]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair505" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[11]_i_1 
       (.I0(weight_in_IBUF[11]),
        .I1(flush_IBUF),
        .O(\weight_reg[11]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair520" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[11]_i_1__3 
       (.I0(weight_out_mesh_192[11]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[11]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair504" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[12]_i_1 
       (.I0(weight_in_IBUF[12]),
        .I1(flush_IBUF),
        .O(\weight_reg[12]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair520" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[12]_i_1__3 
       (.I0(weight_out_mesh_192[12]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[12]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair504" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[13]_i_1 
       (.I0(weight_in_IBUF[13]),
        .I1(flush_IBUF),
        .O(\weight_reg[13]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair519" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[13]_i_1__3 
       (.I0(weight_out_mesh_192[13]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[13]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair503" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[14]_i_1 
       (.I0(weight_in_IBUF[14]),
        .I1(flush_IBUF),
        .O(\weight_reg[14]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair519" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[14]_i_1__3 
       (.I0(weight_out_mesh_192[14]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[14]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair500" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \weight_reg[15]_i_1 
       (.I0(flush_IBUF),
        .I1(weight_out_valid_mesh_12),
        .O(weight_out_valid_reg_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair503" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[15]_i_1__2 
       (.I0(weight_in_IBUF[15]),
        .I1(flush_IBUF),
        .O(\weight_reg[15]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair518" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[15]_i_1__3 
       (.I0(weight_out_mesh_192[15]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[15]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair510" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[1]_i_1 
       (.I0(weight_in_IBUF[1]),
        .I1(flush_IBUF),
        .O(\weight_reg[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair525" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[1]_i_1__3 
       (.I0(weight_out_mesh_192[1]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[1]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair509" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[2]_i_1 
       (.I0(weight_in_IBUF[2]),
        .I1(flush_IBUF),
        .O(\weight_reg[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair525" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[2]_i_1__3 
       (.I0(weight_out_mesh_192[2]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[2]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair509" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[3]_i_1 
       (.I0(weight_in_IBUF[3]),
        .I1(flush_IBUF),
        .O(\weight_reg[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair524" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[3]_i_1__3 
       (.I0(weight_out_mesh_192[3]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[3]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair508" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[4]_i_1 
       (.I0(weight_in_IBUF[4]),
        .I1(flush_IBUF),
        .O(\weight_reg[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair524" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[4]_i_1__3 
       (.I0(weight_out_mesh_192[4]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[4]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair508" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[5]_i_1 
       (.I0(weight_in_IBUF[5]),
        .I1(flush_IBUF),
        .O(\weight_reg[5]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair523" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[5]_i_1__3 
       (.I0(weight_out_mesh_192[5]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[5]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair507" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[6]_i_1 
       (.I0(weight_in_IBUF[6]),
        .I1(flush_IBUF),
        .O(\weight_reg[6]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair523" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[6]_i_1__3 
       (.I0(weight_out_mesh_192[6]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[6]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair507" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[7]_i_1 
       (.I0(weight_in_IBUF[7]),
        .I1(flush_IBUF),
        .O(\weight_reg[7]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair522" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[7]_i_1__3 
       (.I0(weight_out_mesh_192[7]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[7]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair506" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[8]_i_1 
       (.I0(weight_in_IBUF[8]),
        .I1(flush_IBUF),
        .O(\weight_reg[8]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair522" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[8]_i_1__3 
       (.I0(weight_out_mesh_192[8]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[8]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair506" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[9]_i_1 
       (.I0(weight_in_IBUF[9]),
        .I1(flush_IBUF),
        .O(\weight_reg[9]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair521" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[9]_i_1__3 
       (.I0(weight_out_mesh_192[9]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[9]_0 ));
  FDCE \weight_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[0]_i_2_n_0 ),
        .Q(B[0]));
  FDCE \weight_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[10]_i_1_n_0 ),
        .Q(B[10]));
  FDCE \weight_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[11]_i_1_n_0 ),
        .Q(B[11]));
  FDCE \weight_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[12]_i_1_n_0 ),
        .Q(B[12]));
  FDCE \weight_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[13]_i_1_n_0 ),
        .Q(B[13]));
  FDCE \weight_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[14]_i_1_n_0 ),
        .Q(B[14]));
  FDCE \weight_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[15]_i_1__2_n_0 ),
        .Q(B[15]));
  FDCE \weight_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[1]_i_1_n_0 ),
        .Q(B[1]));
  FDCE \weight_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[2]_i_1_n_0 ),
        .Q(B[2]));
  FDCE \weight_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[3]_i_1_n_0 ),
        .Q(B[3]));
  FDCE \weight_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[4]_i_1_n_0 ),
        .Q(B[4]));
  FDCE \weight_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[5]_i_1_n_0 ),
        .Q(B[5]));
  FDCE \weight_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[6]_i_1_n_0 ),
        .Q(B[6]));
  FDCE \weight_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[7]_i_1_n_0 ),
        .Q(B[7]));
  FDCE \weight_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[8]_i_1_n_0 ),
        .Q(B[8]));
  FDCE \weight_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg[0]_i_1_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg[9]_i_1_n_0 ),
        .Q(B[9]));
  (* SOFT_HLUTNM = "soft_lutpair501" *) 
  LUT2 #(
    .INIT(4'h2)) 
    weight_valid_reg_i_1
       (.I0(weight_valid_IBUF),
        .I1(flush_IBUF),
        .O(weight_valid_reg15_out_1));
  (* SOFT_HLUTNM = "soft_lutpair483" *) 
  LUT2 #(
    .INIT(4'h2)) 
    weight_valid_reg_i_1__0
       (.I0(weight_out_valid_mesh_12),
        .I1(flush_IBUF),
        .O(weight_valid_reg15_out));
  FDCE weight_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(weight_valid_reg15_out_1),
        .Q(weight_valid_reg_reg_0));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_12
   (B,
    Q,
    weight_valid_reg_reg_0,
    weight_valid_reg_reg_1,
    weight_out_valid_mesh_13,
    input_valid_reg,
    input_out_valid_reg_reg_0,
    weight_valid_reg15_out,
    weight_out_valid_reg_reg_0,
    weight_valid_reg_reg_2,
    input_out_valid_reg_reg_1,
    \weight_out_reg_reg[15]_0 ,
    \weight_out_reg_reg[14]_0 ,
    \weight_out_reg_reg[13]_0 ,
    \weight_out_reg_reg[12]_0 ,
    \weight_out_reg_reg[11]_0 ,
    \weight_out_reg_reg[10]_0 ,
    \weight_out_reg_reg[9]_0 ,
    \weight_out_reg_reg[8]_0 ,
    \weight_out_reg_reg[7]_0 ,
    \weight_out_reg_reg[6]_0 ,
    \weight_out_reg_reg[5]_0 ,
    \weight_out_reg_reg[4]_0 ,
    \weight_out_reg_reg[3]_0 ,
    \weight_out_reg_reg[2]_0 ,
    \weight_out_reg_reg[1]_0 ,
    \weight_out_reg_reg[0]_0 ,
    \weight_reg_reg[15]_0 ,
    \weight_reg_reg[0]_0 ,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    \weight_reg_reg[1]_0 ,
    \weight_reg_reg[2]_0 ,
    \weight_reg_reg[3]_0 ,
    \weight_reg_reg[4]_0 ,
    \weight_reg_reg[5]_0 ,
    \weight_reg_reg[6]_0 ,
    \weight_reg_reg[7]_0 ,
    \weight_reg_reg[8]_0 ,
    \weight_reg_reg[9]_0 ,
    \weight_reg_reg[10]_0 ,
    \weight_reg_reg[11]_0 ,
    \weight_reg_reg[12]_0 ,
    \weight_reg_reg[13]_0 ,
    \weight_reg_reg[14]_0 ,
    \weight_reg_reg[15]_1 ,
    weight_valid_reg15_out_0,
    input_valid_reg11_out,
    flush_IBUF,
    array_busy_reg_i_3,
    input_out_valid_mesh_5,
    input_out_valid_mesh_0,
    array_busy_reg_reg,
    array_busy_reg_reg_0,
    array_busy_reg_i_6_0,
    weight_out_valid_mesh_14,
    weight_out_valid_mesh_12,
    input_valid_reg_1,
    accumulator_clr_IBUF,
    E,
    D);
  output [15:0]B;
  output [31:0]Q;
  output weight_valid_reg_reg_0;
  output weight_valid_reg_reg_1;
  output weight_out_valid_mesh_13;
  output input_valid_reg;
  output input_out_valid_reg_reg_0;
  output weight_valid_reg15_out;
  output weight_out_valid_reg_reg_0;
  output weight_valid_reg_reg_2;
  output input_out_valid_reg_reg_1;
  output \weight_out_reg_reg[15]_0 ;
  output \weight_out_reg_reg[14]_0 ;
  output \weight_out_reg_reg[13]_0 ;
  output \weight_out_reg_reg[12]_0 ;
  output \weight_out_reg_reg[11]_0 ;
  output \weight_out_reg_reg[10]_0 ;
  output \weight_out_reg_reg[9]_0 ;
  output \weight_out_reg_reg[8]_0 ;
  output \weight_out_reg_reg[7]_0 ;
  output \weight_out_reg_reg[6]_0 ;
  output \weight_out_reg_reg[5]_0 ;
  output \weight_out_reg_reg[4]_0 ;
  output \weight_out_reg_reg[3]_0 ;
  output \weight_out_reg_reg[2]_0 ;
  output \weight_out_reg_reg[1]_0 ;
  output \weight_out_reg_reg[0]_0 ;
  input \weight_reg_reg[15]_0 ;
  input \weight_reg_reg[0]_0 ;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input \weight_reg_reg[1]_0 ;
  input \weight_reg_reg[2]_0 ;
  input \weight_reg_reg[3]_0 ;
  input \weight_reg_reg[4]_0 ;
  input \weight_reg_reg[5]_0 ;
  input \weight_reg_reg[6]_0 ;
  input \weight_reg_reg[7]_0 ;
  input \weight_reg_reg[8]_0 ;
  input \weight_reg_reg[9]_0 ;
  input \weight_reg_reg[10]_0 ;
  input \weight_reg_reg[11]_0 ;
  input \weight_reg_reg[12]_0 ;
  input \weight_reg_reg[13]_0 ;
  input \weight_reg_reg[14]_0 ;
  input \weight_reg_reg[15]_1 ;
  input weight_valid_reg15_out_0;
  input input_valid_reg11_out;
  input flush_IBUF;
  input array_busy_reg_i_3;
  input input_out_valid_mesh_5;
  input input_out_valid_mesh_0;
  input array_busy_reg_reg;
  input array_busy_reg_reg_0;
  input array_busy_reg_i_6_0;
  input weight_out_valid_mesh_14;
  input weight_out_valid_mesh_12;
  input input_valid_reg_1;
  input accumulator_clr_IBUF;
  input [0:0]E;
  input [15:0]D;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__12_n_0 ;
  wire \accumulator[10]_i_1__12_n_0 ;
  wire \accumulator[11]_i_1__12_n_0 ;
  wire \accumulator[12]_i_1__12_n_0 ;
  wire \accumulator[13]_i_1__12_n_0 ;
  wire \accumulator[14]_i_1__12_n_0 ;
  wire \accumulator[15]_i_1__12_n_0 ;
  wire \accumulator[16]_i_1__12_n_0 ;
  wire \accumulator[17]_i_1__12_n_0 ;
  wire \accumulator[18]_i_1__12_n_0 ;
  wire \accumulator[19]_i_1__12_n_0 ;
  wire \accumulator[1]_i_1__12_n_0 ;
  wire \accumulator[20]_i_1__12_n_0 ;
  wire \accumulator[21]_i_1__12_n_0 ;
  wire \accumulator[22]_i_1__12_n_0 ;
  wire \accumulator[23]_i_1__12_n_0 ;
  wire \accumulator[24]_i_1__12_n_0 ;
  wire \accumulator[25]_i_1__12_n_0 ;
  wire \accumulator[26]_i_1__12_n_0 ;
  wire \accumulator[27]_i_1__12_n_0 ;
  wire \accumulator[28]_i_1__12_n_0 ;
  wire \accumulator[29]_i_1__12_n_0 ;
  wire \accumulator[2]_i_1__12_n_0 ;
  wire \accumulator[30]_i_1__12_n_0 ;
  wire \accumulator[31]_i_1__12_n_0 ;
  wire \accumulator[31]_i_2__12_n_0 ;
  wire \accumulator[3]_i_1__12_n_0 ;
  wire \accumulator[4]_i_1__12_n_0 ;
  wire \accumulator[5]_i_1__12_n_0 ;
  wire \accumulator[6]_i_1__12_n_0 ;
  wire \accumulator[7]_i_1__12_n_0 ;
  wire \accumulator[8]_i_1__12_n_0 ;
  wire \accumulator[9]_i_1__12_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire array_busy_reg_i_24_n_0;
  wire array_busy_reg_i_25_n_0;
  wire array_busy_reg_i_3;
  wire array_busy_reg_i_6_0;
  wire array_busy_reg_reg;
  wire array_busy_reg_reg_0;
  wire clk_IBUF_BUFG;
  wire computing_reg_n_0;
  wire flush_IBUF;
  wire input_out_valid_mesh_0;
  wire input_out_valid_mesh_5;
  wire input_out_valid_reg;
  wire input_out_valid_reg_reg_0;
  wire input_out_valid_reg_reg_1;
  wire [15:0]input_reg__0;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg_1;
  wire [31:0]signed_mac_result__0;
  wire [15:0]weight_out_mesh_208;
  wire \weight_out_reg[0]_i_1__3_n_0 ;
  wire \weight_out_reg[10]_i_1__2_n_0 ;
  wire \weight_out_reg[11]_i_1__2_n_0 ;
  wire \weight_out_reg[12]_i_1__2_n_0 ;
  wire \weight_out_reg[13]_i_1__2_n_0 ;
  wire \weight_out_reg[14]_i_1__2_n_0 ;
  wire \weight_out_reg[15]_i_1__2_n_0 ;
  wire \weight_out_reg[1]_i_1__2_n_0 ;
  wire \weight_out_reg[2]_i_1__2_n_0 ;
  wire \weight_out_reg[3]_i_1__2_n_0 ;
  wire \weight_out_reg[4]_i_1__2_n_0 ;
  wire \weight_out_reg[5]_i_1__2_n_0 ;
  wire \weight_out_reg[6]_i_1__2_n_0 ;
  wire \weight_out_reg[7]_i_1__2_n_0 ;
  wire \weight_out_reg[8]_i_1__2_n_0 ;
  wire \weight_out_reg[9]_i_1__2_n_0 ;
  wire \weight_out_reg_reg[0]_0 ;
  wire \weight_out_reg_reg[10]_0 ;
  wire \weight_out_reg_reg[11]_0 ;
  wire \weight_out_reg_reg[12]_0 ;
  wire \weight_out_reg_reg[13]_0 ;
  wire \weight_out_reg_reg[14]_0 ;
  wire \weight_out_reg_reg[15]_0 ;
  wire \weight_out_reg_reg[1]_0 ;
  wire \weight_out_reg_reg[2]_0 ;
  wire \weight_out_reg_reg[3]_0 ;
  wire \weight_out_reg_reg[4]_0 ;
  wire \weight_out_reg_reg[5]_0 ;
  wire \weight_out_reg_reg[6]_0 ;
  wire \weight_out_reg_reg[7]_0 ;
  wire \weight_out_reg_reg[8]_0 ;
  wire \weight_out_reg_reg[9]_0 ;
  wire weight_out_valid_mesh_12;
  wire weight_out_valid_mesh_13;
  wire weight_out_valid_mesh_14;
  wire weight_out_valid_reg;
  wire weight_out_valid_reg_reg_0;
  wire \weight_reg_reg[0]_0 ;
  wire \weight_reg_reg[10]_0 ;
  wire \weight_reg_reg[11]_0 ;
  wire \weight_reg_reg[12]_0 ;
  wire \weight_reg_reg[13]_0 ;
  wire \weight_reg_reg[14]_0 ;
  wire \weight_reg_reg[15]_0 ;
  wire \weight_reg_reg[15]_1 ;
  wire \weight_reg_reg[1]_0 ;
  wire \weight_reg_reg[2]_0 ;
  wire \weight_reg_reg[3]_0 ;
  wire \weight_reg_reg[4]_0 ;
  wire \weight_reg_reg[5]_0 ;
  wire \weight_reg_reg[6]_0 ;
  wire \weight_reg_reg[7]_0 ;
  wire \weight_reg_reg[8]_0 ;
  wire \weight_reg_reg[9]_0 ;
  wire weight_valid_reg15_out;
  wire weight_valid_reg15_out_0;
  wire weight_valid_reg_reg_0;
  wire weight_valid_reg_reg_1;
  wire weight_valid_reg_reg_2;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair544" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair539" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair538" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair538" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair537" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair537" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair536" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair536" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair535" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair535" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair534" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair543" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair534" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair533" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair533" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair532" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair532" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair531" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair531" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair530" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair530" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair529" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair543" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair529" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__12_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(weight_valid_reg_reg_1),
        .O(\accumulator[31]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair528" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair542" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair542" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair541" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair541" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair540" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair540" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__12_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair539" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__12 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__12_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__12_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__12_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__12_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__12_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__12_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__12_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__12_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__12_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__12_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__12_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__12_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__12_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__12_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__12_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__12_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__12_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__12_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__12_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__12_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__12_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__12_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__12_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__12_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__12_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__12_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__12_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__12_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__12_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__12_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__12_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__12_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__12_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair526" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_13
       (.I0(weight_valid_reg_reg_1),
        .I1(array_busy_reg_i_3),
        .I2(input_out_valid_mesh_5),
        .I3(input_out_valid_mesh_0),
        .O(weight_valid_reg_reg_2));
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_24
       (.I0(computing_reg_n_0),
        .I1(weight_out_valid_mesh_12),
        .I2(weight_out_valid_mesh_14),
        .I3(input_valid_reg_1),
        .O(array_busy_reg_i_24_n_0));
  (* SOFT_HLUTNM = "soft_lutpair527" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_25
       (.I0(weight_out_valid_mesh_13),
        .I1(weight_valid_reg_reg_1),
        .I2(array_busy_reg_i_6_0),
        .I3(weight_out_valid_mesh_14),
        .O(array_busy_reg_i_25_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_6
       (.I0(array_busy_reg_reg),
        .I1(array_busy_reg_i_24_n_0),
        .I2(array_busy_reg_i_25_n_0),
        .I3(array_busy_reg_reg_0),
        .O(input_out_valid_reg_reg_1));
  (* SOFT_HLUTNM = "soft_lutpair528" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__12
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(weight_valid_reg_reg_1),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__12_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair545" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__12
       (.I0(input_valid_reg),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_reg_reg_0));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[0]),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[10]),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[11]),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[12]),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[13]),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[14]),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[15]),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[1]),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[2]),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[3]),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[4]),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[5]),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[6]),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[7]),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[8]),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[9]),
        .Q(input_reg__0[9]));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out),
        .Q(input_valid_reg));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
  (* SOFT_HLUTNM = "soft_lutpair553" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[0]_i_1__3 
       (.I0(B[0]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[0]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair548" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[10]_i_1__2 
       (.I0(B[10]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[10]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair548" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[11]_i_1__2 
       (.I0(B[11]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[11]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair547" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[12]_i_1__2 
       (.I0(B[12]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[12]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair547" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[13]_i_1__2 
       (.I0(B[13]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[13]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair546" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[14]_i_1__2 
       (.I0(B[14]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[14]_i_1__2_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \weight_out_reg[15]_i_1__0 
       (.I0(flush_IBUF),
        .I1(weight_valid_reg_reg_1),
        .O(weight_valid_reg_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair546" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[15]_i_1__2 
       (.I0(B[15]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[15]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair553" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[1]_i_1__2 
       (.I0(B[1]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[1]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair552" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[2]_i_1__2 
       (.I0(B[2]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[2]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair552" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[3]_i_1__2 
       (.I0(B[3]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[3]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair551" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[4]_i_1__2 
       (.I0(B[4]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[4]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair551" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[5]_i_1__2 
       (.I0(B[5]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[5]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair550" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[6]_i_1__2 
       (.I0(B[6]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[6]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair550" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[7]_i_1__2 
       (.I0(B[7]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[7]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair549" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[8]_i_1__2 
       (.I0(B[8]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[8]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair549" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[9]_i_1__2 
       (.I0(B[9]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[9]_i_1__2_n_0 ));
  FDCE \weight_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[0]_i_1__3_n_0 ),
        .Q(weight_out_mesh_208[0]));
  FDCE \weight_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[10]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[10]));
  FDCE \weight_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[11]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[11]));
  FDCE \weight_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[12]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[12]));
  FDCE \weight_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[13]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[13]));
  FDCE \weight_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[14]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[14]));
  FDCE \weight_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[15]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[15]));
  FDCE \weight_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[1]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[1]));
  FDCE \weight_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[2]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[2]));
  FDCE \weight_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[3]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[3]));
  FDCE \weight_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[4]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[4]));
  FDCE \weight_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[5]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[5]));
  FDCE \weight_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[6]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[6]));
  FDCE \weight_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[7]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[7]));
  FDCE \weight_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[8]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[8]));
  FDCE \weight_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[9]_i_1__2_n_0 ),
        .Q(weight_out_mesh_208[9]));
  (* SOFT_HLUTNM = "soft_lutpair526" *) 
  LUT2 #(
    .INIT(4'h2)) 
    weight_out_valid_reg_i_1__1
       (.I0(weight_valid_reg_reg_1),
        .I1(flush_IBUF),
        .O(weight_out_valid_reg));
  FDCE weight_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(weight_out_valid_reg),
        .Q(weight_out_valid_mesh_13));
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[0]_i_1__4 
       (.I0(weight_out_mesh_208[0]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[0]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair556" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[10]_i_1__4 
       (.I0(weight_out_mesh_208[10]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[10]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair555" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[11]_i_1__4 
       (.I0(weight_out_mesh_208[11]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[11]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair555" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[12]_i_1__4 
       (.I0(weight_out_mesh_208[12]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[12]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair554" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[13]_i_1__4 
       (.I0(weight_out_mesh_208[13]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[13]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair554" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[14]_i_1__4 
       (.I0(weight_out_mesh_208[14]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[14]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair544" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \weight_reg[15]_i_1__0 
       (.I0(flush_IBUF),
        .I1(weight_out_valid_mesh_13),
        .O(weight_out_valid_reg_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair545" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[15]_i_1__4 
       (.I0(weight_out_mesh_208[15]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[15]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair560" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[1]_i_1__4 
       (.I0(weight_out_mesh_208[1]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[1]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair560" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[2]_i_1__4 
       (.I0(weight_out_mesh_208[2]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[2]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair559" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[3]_i_1__4 
       (.I0(weight_out_mesh_208[3]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[3]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair559" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[4]_i_1__4 
       (.I0(weight_out_mesh_208[4]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[4]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair558" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[5]_i_1__4 
       (.I0(weight_out_mesh_208[5]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[5]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair558" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[6]_i_1__4 
       (.I0(weight_out_mesh_208[6]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[6]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair557" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[7]_i_1__4 
       (.I0(weight_out_mesh_208[7]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[7]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair557" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[8]_i_1__4 
       (.I0(weight_out_mesh_208[8]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[8]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair556" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[9]_i_1__4 
       (.I0(weight_out_mesh_208[9]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[9]_0 ));
  FDCE \weight_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[0]_0 ),
        .Q(B[0]));
  FDCE \weight_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[10]_0 ),
        .Q(B[10]));
  FDCE \weight_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[11]_0 ),
        .Q(B[11]));
  FDCE \weight_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[12]_0 ),
        .Q(B[12]));
  FDCE \weight_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[13]_0 ),
        .Q(B[13]));
  FDCE \weight_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[14]_0 ),
        .Q(B[14]));
  FDCE \weight_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_1 ),
        .Q(B[15]));
  FDCE \weight_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[1]_0 ),
        .Q(B[1]));
  FDCE \weight_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[2]_0 ),
        .Q(B[2]));
  FDCE \weight_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[3]_0 ),
        .Q(B[3]));
  FDCE \weight_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[4]_0 ),
        .Q(B[4]));
  FDCE \weight_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[5]_0 ),
        .Q(B[5]));
  FDCE \weight_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[6]_0 ),
        .Q(B[6]));
  FDCE \weight_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[7]_0 ),
        .Q(B[7]));
  FDCE \weight_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[8]_0 ),
        .Q(B[8]));
  FDCE \weight_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[9]_0 ),
        .Q(B[9]));
  (* SOFT_HLUTNM = "soft_lutpair527" *) 
  LUT2 #(
    .INIT(4'h2)) 
    weight_valid_reg_i_1__1
       (.I0(weight_out_valid_mesh_13),
        .I1(flush_IBUF),
        .O(weight_valid_reg15_out));
  FDCE weight_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(weight_valid_reg15_out_0),
        .Q(weight_valid_reg_reg_1));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_13
   (B,
    Q,
    weight_valid_reg_reg_0,
    computing_reg_0,
    weight_valid_reg_reg_1,
    weight_out_valid_mesh_14,
    input_valid_reg,
    input_out_valid_reg_reg_0,
    weight_valid_reg15_out,
    weight_out_valid_reg_reg_0,
    \weight_out_reg_reg[15]_0 ,
    \weight_out_reg_reg[14]_0 ,
    \weight_out_reg_reg[13]_0 ,
    \weight_out_reg_reg[12]_0 ,
    \weight_out_reg_reg[11]_0 ,
    \weight_out_reg_reg[10]_0 ,
    \weight_out_reg_reg[9]_0 ,
    \weight_out_reg_reg[8]_0 ,
    \weight_out_reg_reg[7]_0 ,
    \weight_out_reg_reg[6]_0 ,
    \weight_out_reg_reg[5]_0 ,
    \weight_out_reg_reg[4]_0 ,
    \weight_out_reg_reg[3]_0 ,
    \weight_out_reg_reg[2]_0 ,
    \weight_out_reg_reg[1]_0 ,
    \weight_out_reg_reg[0]_0 ,
    \weight_reg_reg[15]_0 ,
    \weight_reg_reg[0]_0 ,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    \weight_reg_reg[1]_0 ,
    \weight_reg_reg[2]_0 ,
    \weight_reg_reg[3]_0 ,
    \weight_reg_reg[4]_0 ,
    \weight_reg_reg[5]_0 ,
    \weight_reg_reg[6]_0 ,
    \weight_reg_reg[7]_0 ,
    \weight_reg_reg[8]_0 ,
    \weight_reg_reg[9]_0 ,
    \weight_reg_reg[10]_0 ,
    \weight_reg_reg[11]_0 ,
    \weight_reg_reg[12]_0 ,
    \weight_reg_reg[13]_0 ,
    \weight_reg_reg[14]_0 ,
    \weight_reg_reg[15]_1 ,
    weight_valid_reg15_out_0,
    input_valid_reg11_out,
    flush_IBUF,
    accumulator_clr_IBUF,
    E,
    D);
  output [15:0]B;
  output [31:0]Q;
  output weight_valid_reg_reg_0;
  output computing_reg_0;
  output weight_valid_reg_reg_1;
  output weight_out_valid_mesh_14;
  output input_valid_reg;
  output input_out_valid_reg_reg_0;
  output weight_valid_reg15_out;
  output weight_out_valid_reg_reg_0;
  output \weight_out_reg_reg[15]_0 ;
  output \weight_out_reg_reg[14]_0 ;
  output \weight_out_reg_reg[13]_0 ;
  output \weight_out_reg_reg[12]_0 ;
  output \weight_out_reg_reg[11]_0 ;
  output \weight_out_reg_reg[10]_0 ;
  output \weight_out_reg_reg[9]_0 ;
  output \weight_out_reg_reg[8]_0 ;
  output \weight_out_reg_reg[7]_0 ;
  output \weight_out_reg_reg[6]_0 ;
  output \weight_out_reg_reg[5]_0 ;
  output \weight_out_reg_reg[4]_0 ;
  output \weight_out_reg_reg[3]_0 ;
  output \weight_out_reg_reg[2]_0 ;
  output \weight_out_reg_reg[1]_0 ;
  output \weight_out_reg_reg[0]_0 ;
  input \weight_reg_reg[15]_0 ;
  input \weight_reg_reg[0]_0 ;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input \weight_reg_reg[1]_0 ;
  input \weight_reg_reg[2]_0 ;
  input \weight_reg_reg[3]_0 ;
  input \weight_reg_reg[4]_0 ;
  input \weight_reg_reg[5]_0 ;
  input \weight_reg_reg[6]_0 ;
  input \weight_reg_reg[7]_0 ;
  input \weight_reg_reg[8]_0 ;
  input \weight_reg_reg[9]_0 ;
  input \weight_reg_reg[10]_0 ;
  input \weight_reg_reg[11]_0 ;
  input \weight_reg_reg[12]_0 ;
  input \weight_reg_reg[13]_0 ;
  input \weight_reg_reg[14]_0 ;
  input \weight_reg_reg[15]_1 ;
  input weight_valid_reg15_out_0;
  input input_valid_reg11_out;
  input flush_IBUF;
  input accumulator_clr_IBUF;
  input [0:0]E;
  input [15:0]D;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__13_n_0 ;
  wire \accumulator[10]_i_1__13_n_0 ;
  wire \accumulator[11]_i_1__13_n_0 ;
  wire \accumulator[12]_i_1__13_n_0 ;
  wire \accumulator[13]_i_1__13_n_0 ;
  wire \accumulator[14]_i_1__13_n_0 ;
  wire \accumulator[15]_i_1__13_n_0 ;
  wire \accumulator[16]_i_1__13_n_0 ;
  wire \accumulator[17]_i_1__13_n_0 ;
  wire \accumulator[18]_i_1__13_n_0 ;
  wire \accumulator[19]_i_1__13_n_0 ;
  wire \accumulator[1]_i_1__13_n_0 ;
  wire \accumulator[20]_i_1__13_n_0 ;
  wire \accumulator[21]_i_1__13_n_0 ;
  wire \accumulator[22]_i_1__13_n_0 ;
  wire \accumulator[23]_i_1__13_n_0 ;
  wire \accumulator[24]_i_1__13_n_0 ;
  wire \accumulator[25]_i_1__13_n_0 ;
  wire \accumulator[26]_i_1__13_n_0 ;
  wire \accumulator[27]_i_1__13_n_0 ;
  wire \accumulator[28]_i_1__13_n_0 ;
  wire \accumulator[29]_i_1__13_n_0 ;
  wire \accumulator[2]_i_1__13_n_0 ;
  wire \accumulator[30]_i_1__13_n_0 ;
  wire \accumulator[31]_i_1__13_n_0 ;
  wire \accumulator[31]_i_2__13_n_0 ;
  wire \accumulator[3]_i_1__13_n_0 ;
  wire \accumulator[4]_i_1__13_n_0 ;
  wire \accumulator[5]_i_1__13_n_0 ;
  wire \accumulator[6]_i_1__13_n_0 ;
  wire \accumulator[7]_i_1__13_n_0 ;
  wire \accumulator[8]_i_1__13_n_0 ;
  wire \accumulator[9]_i_1__13_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire flush_IBUF;
  wire input_out_valid_reg;
  wire input_out_valid_reg_reg_0;
  wire [15:0]input_reg__0;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire [31:0]signed_mac_result__0;
  wire [15:0]weight_out_mesh_224;
  wire \weight_out_reg[0]_i_1__4_n_0 ;
  wire \weight_out_reg[10]_i_1__3_n_0 ;
  wire \weight_out_reg[11]_i_1__3_n_0 ;
  wire \weight_out_reg[12]_i_1__3_n_0 ;
  wire \weight_out_reg[13]_i_1__3_n_0 ;
  wire \weight_out_reg[14]_i_1__3_n_0 ;
  wire \weight_out_reg[15]_i_1__3_n_0 ;
  wire \weight_out_reg[1]_i_1__3_n_0 ;
  wire \weight_out_reg[2]_i_1__3_n_0 ;
  wire \weight_out_reg[3]_i_1__3_n_0 ;
  wire \weight_out_reg[4]_i_1__3_n_0 ;
  wire \weight_out_reg[5]_i_1__3_n_0 ;
  wire \weight_out_reg[6]_i_1__3_n_0 ;
  wire \weight_out_reg[7]_i_1__3_n_0 ;
  wire \weight_out_reg[8]_i_1__3_n_0 ;
  wire \weight_out_reg[9]_i_1__3_n_0 ;
  wire \weight_out_reg_reg[0]_0 ;
  wire \weight_out_reg_reg[10]_0 ;
  wire \weight_out_reg_reg[11]_0 ;
  wire \weight_out_reg_reg[12]_0 ;
  wire \weight_out_reg_reg[13]_0 ;
  wire \weight_out_reg_reg[14]_0 ;
  wire \weight_out_reg_reg[15]_0 ;
  wire \weight_out_reg_reg[1]_0 ;
  wire \weight_out_reg_reg[2]_0 ;
  wire \weight_out_reg_reg[3]_0 ;
  wire \weight_out_reg_reg[4]_0 ;
  wire \weight_out_reg_reg[5]_0 ;
  wire \weight_out_reg_reg[6]_0 ;
  wire \weight_out_reg_reg[7]_0 ;
  wire \weight_out_reg_reg[8]_0 ;
  wire \weight_out_reg_reg[9]_0 ;
  wire weight_out_valid_mesh_14;
  wire weight_out_valid_reg;
  wire weight_out_valid_reg_reg_0;
  wire \weight_reg_reg[0]_0 ;
  wire \weight_reg_reg[10]_0 ;
  wire \weight_reg_reg[11]_0 ;
  wire \weight_reg_reg[12]_0 ;
  wire \weight_reg_reg[13]_0 ;
  wire \weight_reg_reg[14]_0 ;
  wire \weight_reg_reg[15]_0 ;
  wire \weight_reg_reg[15]_1 ;
  wire \weight_reg_reg[1]_0 ;
  wire \weight_reg_reg[2]_0 ;
  wire \weight_reg_reg[3]_0 ;
  wire \weight_reg_reg[4]_0 ;
  wire \weight_reg_reg[5]_0 ;
  wire \weight_reg_reg[6]_0 ;
  wire \weight_reg_reg[7]_0 ;
  wire \weight_reg_reg[8]_0 ;
  wire \weight_reg_reg[9]_0 ;
  wire weight_valid_reg15_out;
  wire weight_valid_reg15_out_0;
  wire weight_valid_reg_reg_0;
  wire weight_valid_reg_reg_1;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair577" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair572" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair571" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair571" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair570" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair570" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair569" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair569" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair568" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair568" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair567" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair576" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair567" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair566" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair566" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair565" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair565" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair564" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair564" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair563" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair563" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair562" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair576" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair562" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__13_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(weight_valid_reg_reg_1),
        .O(\accumulator[31]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair561" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair575" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair575" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair574" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair574" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair573" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair573" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair572" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__13 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__13_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__13_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__13_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__13_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__13_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__13_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__13_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__13_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__13_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__13_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__13_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__13_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__13_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__13_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__13_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__13_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__13_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__13_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__13_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__13_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__13_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__13_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__13_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__13_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__13_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__13_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__13_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__13_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__13_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__13_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__13_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__13_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__13_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair561" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__13
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(weight_valid_reg_reg_1),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__13_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair578" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__13
       (.I0(input_valid_reg),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_reg_reg_0));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[0]),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[10]),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[11]),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[12]),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[13]),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[14]),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[15]),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[1]),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[2]),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[3]),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[4]),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[5]),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[6]),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[7]),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[8]),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[9]),
        .Q(input_reg__0[9]));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out),
        .Q(input_valid_reg));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
  (* SOFT_HLUTNM = "soft_lutpair587" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[0]_i_1__4 
       (.I0(B[0]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[0]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair582" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[10]_i_1__3 
       (.I0(B[10]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[10]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair581" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[11]_i_1__3 
       (.I0(B[11]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[11]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair581" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[12]_i_1__3 
       (.I0(B[12]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[12]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair580" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[13]_i_1__3 
       (.I0(B[13]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[13]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair580" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[14]_i_1__3 
       (.I0(B[14]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[14]_i_1__3_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \weight_out_reg[15]_i_1__1 
       (.I0(flush_IBUF),
        .I1(weight_valid_reg_reg_1),
        .O(weight_valid_reg_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair579" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[15]_i_1__3 
       (.I0(B[15]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[15]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair586" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[1]_i_1__3 
       (.I0(B[1]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[1]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair586" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[2]_i_1__3 
       (.I0(B[2]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[2]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair585" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[3]_i_1__3 
       (.I0(B[3]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[3]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair585" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[4]_i_1__3 
       (.I0(B[4]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[4]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair584" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[5]_i_1__3 
       (.I0(B[5]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[5]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair584" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[6]_i_1__3 
       (.I0(B[6]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[6]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair583" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[7]_i_1__3 
       (.I0(B[7]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[7]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair583" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[8]_i_1__3 
       (.I0(B[8]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[8]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair582" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_out_reg[9]_i_1__3 
       (.I0(B[9]),
        .I1(flush_IBUF),
        .O(\weight_out_reg[9]_i_1__3_n_0 ));
  FDCE \weight_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[0]_i_1__4_n_0 ),
        .Q(weight_out_mesh_224[0]));
  FDCE \weight_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[10]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[10]));
  FDCE \weight_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[11]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[11]));
  FDCE \weight_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[12]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[12]));
  FDCE \weight_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[13]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[13]));
  FDCE \weight_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[14]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[14]));
  FDCE \weight_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[15]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[15]));
  FDCE \weight_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[1]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[1]));
  FDCE \weight_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[2]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[2]));
  FDCE \weight_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[3]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[3]));
  FDCE \weight_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[4]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[4]));
  FDCE \weight_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[5]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[5]));
  FDCE \weight_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[6]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[6]));
  FDCE \weight_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[7]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[7]));
  FDCE \weight_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[8]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[8]));
  FDCE \weight_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(weight_valid_reg_reg_0),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_out_reg[9]_i_1__3_n_0 ),
        .Q(weight_out_mesh_224[9]));
  (* SOFT_HLUTNM = "soft_lutpair578" *) 
  LUT2 #(
    .INIT(4'h2)) 
    weight_out_valid_reg_i_1__2
       (.I0(weight_valid_reg_reg_1),
        .I1(flush_IBUF),
        .O(weight_out_valid_reg));
  FDCE weight_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(weight_out_valid_reg),
        .Q(weight_out_valid_mesh_14));
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[0]_i_1__5 
       (.I0(weight_out_mesh_224[0]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[0]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair590" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[10]_i_1__5 
       (.I0(weight_out_mesh_224[10]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[10]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair589" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[11]_i_1__5 
       (.I0(weight_out_mesh_224[11]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[11]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair589" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[12]_i_1__5 
       (.I0(weight_out_mesh_224[12]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[12]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair588" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[13]_i_1__5 
       (.I0(weight_out_mesh_224[13]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[13]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair588" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[14]_i_1__5 
       (.I0(weight_out_mesh_224[14]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[14]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair579" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \weight_reg[15]_i_1__1 
       (.I0(flush_IBUF),
        .I1(weight_out_valid_mesh_14),
        .O(weight_out_valid_reg_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair587" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[15]_i_1__5 
       (.I0(weight_out_mesh_224[15]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[15]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair594" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[1]_i_1__5 
       (.I0(weight_out_mesh_224[1]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[1]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair594" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[2]_i_1__5 
       (.I0(weight_out_mesh_224[2]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[2]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair593" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[3]_i_1__5 
       (.I0(weight_out_mesh_224[3]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[3]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair593" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[4]_i_1__5 
       (.I0(weight_out_mesh_224[4]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[4]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair592" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[5]_i_1__5 
       (.I0(weight_out_mesh_224[5]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[5]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair592" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[6]_i_1__5 
       (.I0(weight_out_mesh_224[6]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[6]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair591" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[7]_i_1__5 
       (.I0(weight_out_mesh_224[7]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[7]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair591" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[8]_i_1__5 
       (.I0(weight_out_mesh_224[8]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[8]_0 ));
  (* SOFT_HLUTNM = "soft_lutpair590" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \weight_reg[9]_i_1__5 
       (.I0(weight_out_mesh_224[9]),
        .I1(flush_IBUF),
        .O(\weight_out_reg_reg[9]_0 ));
  FDCE \weight_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[0]_0 ),
        .Q(B[0]));
  FDCE \weight_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[10]_0 ),
        .Q(B[10]));
  FDCE \weight_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[11]_0 ),
        .Q(B[11]));
  FDCE \weight_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[12]_0 ),
        .Q(B[12]));
  FDCE \weight_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[13]_0 ),
        .Q(B[13]));
  FDCE \weight_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[14]_0 ),
        .Q(B[14]));
  FDCE \weight_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_1 ),
        .Q(B[15]));
  FDCE \weight_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[1]_0 ),
        .Q(B[1]));
  FDCE \weight_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[2]_0 ),
        .Q(B[2]));
  FDCE \weight_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[3]_0 ),
        .Q(B[3]));
  FDCE \weight_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[4]_0 ),
        .Q(B[4]));
  FDCE \weight_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[5]_0 ),
        .Q(B[5]));
  FDCE \weight_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[6]_0 ),
        .Q(B[6]));
  FDCE \weight_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[7]_0 ),
        .Q(B[7]));
  FDCE \weight_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[8]_0 ),
        .Q(B[8]));
  FDCE \weight_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[9]_0 ),
        .Q(B[9]));
  (* SOFT_HLUTNM = "soft_lutpair577" *) 
  LUT2 #(
    .INIT(4'h2)) 
    weight_valid_reg_i_1__2
       (.I0(weight_out_valid_mesh_14),
        .I1(flush_IBUF),
        .O(weight_valid_reg15_out));
  FDCE weight_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(weight_valid_reg15_out_0),
        .Q(weight_valid_reg_reg_1));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_14
   (B,
    Q,
    weight_valid_reg_reg_0,
    input_valid_reg,
    weight_out_valid_reg,
    weight_valid_reg_reg_1,
    computing_reg_0,
    \weight_reg_reg[15]_0 ,
    \weight_reg_reg[0]_0 ,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    \weight_reg_reg[1]_0 ,
    \weight_reg_reg[2]_0 ,
    \weight_reg_reg[3]_0 ,
    \weight_reg_reg[4]_0 ,
    \weight_reg_reg[5]_0 ,
    \weight_reg_reg[6]_0 ,
    \weight_reg_reg[7]_0 ,
    \weight_reg_reg[8]_0 ,
    \weight_reg_reg[9]_0 ,
    \weight_reg_reg[10]_0 ,
    \weight_reg_reg[11]_0 ,
    \weight_reg_reg[12]_0 ,
    \weight_reg_reg[13]_0 ,
    \weight_reg_reg[14]_0 ,
    \weight_reg_reg[15]_1 ,
    weight_valid_reg15_out,
    input_valid_reg11_out,
    flush_IBUF,
    input_valid_reg_0,
    array_busy_reg_i_5,
    weight_out_valid_mesh_13,
    array_busy_reg_i_5_0,
    accumulator_clr_IBUF,
    E,
    D);
  output [15:0]B;
  output [31:0]Q;
  output weight_valid_reg_reg_0;
  output input_valid_reg;
  output weight_out_valid_reg;
  output weight_valid_reg_reg_1;
  output computing_reg_0;
  input \weight_reg_reg[15]_0 ;
  input \weight_reg_reg[0]_0 ;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input \weight_reg_reg[1]_0 ;
  input \weight_reg_reg[2]_0 ;
  input \weight_reg_reg[3]_0 ;
  input \weight_reg_reg[4]_0 ;
  input \weight_reg_reg[5]_0 ;
  input \weight_reg_reg[6]_0 ;
  input \weight_reg_reg[7]_0 ;
  input \weight_reg_reg[8]_0 ;
  input \weight_reg_reg[9]_0 ;
  input \weight_reg_reg[10]_0 ;
  input \weight_reg_reg[11]_0 ;
  input \weight_reg_reg[12]_0 ;
  input \weight_reg_reg[13]_0 ;
  input \weight_reg_reg[14]_0 ;
  input \weight_reg_reg[15]_1 ;
  input weight_valid_reg15_out;
  input input_valid_reg11_out;
  input flush_IBUF;
  input input_valid_reg_0;
  input array_busy_reg_i_5;
  input weight_out_valid_mesh_13;
  input array_busy_reg_i_5_0;
  input accumulator_clr_IBUF;
  input [0:0]E;
  input [15:0]D;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__14_n_0 ;
  wire \accumulator[10]_i_1__14_n_0 ;
  wire \accumulator[11]_i_1__14_n_0 ;
  wire \accumulator[12]_i_1__14_n_0 ;
  wire \accumulator[13]_i_1__14_n_0 ;
  wire \accumulator[14]_i_1__14_n_0 ;
  wire \accumulator[15]_i_1__14_n_0 ;
  wire \accumulator[16]_i_1__14_n_0 ;
  wire \accumulator[17]_i_1__14_n_0 ;
  wire \accumulator[18]_i_1__14_n_0 ;
  wire \accumulator[19]_i_1__14_n_0 ;
  wire \accumulator[1]_i_1__14_n_0 ;
  wire \accumulator[20]_i_1__14_n_0 ;
  wire \accumulator[21]_i_1__14_n_0 ;
  wire \accumulator[22]_i_1__14_n_0 ;
  wire \accumulator[23]_i_1__14_n_0 ;
  wire \accumulator[24]_i_1__14_n_0 ;
  wire \accumulator[25]_i_1__14_n_0 ;
  wire \accumulator[26]_i_1__14_n_0 ;
  wire \accumulator[27]_i_1__14_n_0 ;
  wire \accumulator[28]_i_1__14_n_0 ;
  wire \accumulator[29]_i_1__14_n_0 ;
  wire \accumulator[2]_i_1__14_n_0 ;
  wire \accumulator[30]_i_1__14_n_0 ;
  wire \accumulator[31]_i_1__14_n_0 ;
  wire \accumulator[31]_i_2__14_n_0 ;
  wire \accumulator[3]_i_1__14_n_0 ;
  wire \accumulator[4]_i_1__14_n_0 ;
  wire \accumulator[5]_i_1__14_n_0 ;
  wire \accumulator[6]_i_1__14_n_0 ;
  wire \accumulator[7]_i_1__14_n_0 ;
  wire \accumulator[8]_i_1__14_n_0 ;
  wire \accumulator[9]_i_1__14_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire array_busy_reg_i_5;
  wire array_busy_reg_i_5_0;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_n_0;
  wire flush_IBUF;
  wire input_out_valid_reg;
  wire input_out_valid_reg_reg_n_0;
  wire [15:0]input_reg__0;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg_0;
  wire [31:0]signed_mac_result__0;
  wire weight_out_valid_mesh_13;
  wire weight_out_valid_reg;
  wire \weight_reg_reg[0]_0 ;
  wire \weight_reg_reg[10]_0 ;
  wire \weight_reg_reg[11]_0 ;
  wire \weight_reg_reg[12]_0 ;
  wire \weight_reg_reg[13]_0 ;
  wire \weight_reg_reg[14]_0 ;
  wire \weight_reg_reg[15]_0 ;
  wire \weight_reg_reg[15]_1 ;
  wire \weight_reg_reg[1]_0 ;
  wire \weight_reg_reg[2]_0 ;
  wire \weight_reg_reg[3]_0 ;
  wire \weight_reg_reg[4]_0 ;
  wire \weight_reg_reg[5]_0 ;
  wire \weight_reg_reg[6]_0 ;
  wire \weight_reg_reg[7]_0 ;
  wire \weight_reg_reg[8]_0 ;
  wire \weight_reg_reg[9]_0 ;
  wire weight_valid_reg15_out;
  wire weight_valid_reg_reg_0;
  wire weight_valid_reg_reg_1;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair607" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair606" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair606" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair605" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair605" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair604" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair604" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair603" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair603" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair602" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair611" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair602" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair601" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair601" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair600" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair600" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair599" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair599" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair598" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair598" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair597" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair611" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair597" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__14_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(weight_valid_reg_reg_0),
        .O(\accumulator[31]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair596" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair610" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair610" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair609" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair609" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair608" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair608" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair607" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__14 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__14_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__14_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__14_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__14_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__14_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__14_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__14_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__14_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__14_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__14_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__14_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__14_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__14_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__14_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__14_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__14_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__14_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__14_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__14_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__14_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__14_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__14_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__14_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__14_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__14_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__14_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__14_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__14_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__14_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__14_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__14_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__14_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__14_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair595" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_21
       (.I0(weight_valid_reg_reg_0),
        .I1(input_valid_reg_0),
        .I2(input_out_valid_reg_reg_n_0),
        .I3(array_busy_reg_i_5),
        .O(weight_valid_reg_reg_1));
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_22
       (.I0(computing_reg_n_0),
        .I1(weight_out_valid_mesh_13),
        .I2(array_busy_reg_i_5_0),
        .I3(weight_valid_reg_reg_0),
        .O(computing_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair596" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__14
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(weight_valid_reg_reg_0),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__14_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_n_0));
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__14
       (.I0(input_valid_reg),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_reg_reg_n_0));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[0]),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[10]),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[11]),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[12]),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[13]),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[14]),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[15]),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[1]),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[2]),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[3]),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[4]),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[5]),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[6]),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[7]),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[8]),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(E),
        .CLR(\accumulator_reg[0]_0 ),
        .D(D[9]),
        .Q(input_reg__0[9]));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out),
        .Q(input_valid_reg));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
  (* SOFT_HLUTNM = "soft_lutpair595" *) 
  LUT2 #(
    .INIT(4'h2)) 
    weight_out_valid_reg_i_1
       (.I0(weight_valid_reg_reg_0),
        .I1(flush_IBUF),
        .O(weight_out_valid_reg));
  FDCE \weight_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[0]_0 ),
        .Q(B[0]));
  FDCE \weight_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[10]_0 ),
        .Q(B[10]));
  FDCE \weight_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[11]_0 ),
        .Q(B[11]));
  FDCE \weight_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[12]_0 ),
        .Q(B[12]));
  FDCE \weight_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[13]_0 ),
        .Q(B[13]));
  FDCE \weight_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[14]_0 ),
        .Q(B[14]));
  FDCE \weight_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_1 ),
        .Q(B[15]));
  FDCE \weight_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[1]_0 ),
        .Q(B[1]));
  FDCE \weight_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[2]_0 ),
        .Q(B[2]));
  FDCE \weight_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[3]_0 ),
        .Q(B[3]));
  FDCE \weight_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[4]_0 ),
        .Q(B[4]));
  FDCE \weight_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[5]_0 ),
        .Q(B[5]));
  FDCE \weight_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[6]_0 ),
        .Q(B[6]));
  FDCE \weight_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[7]_0 ),
        .Q(B[7]));
  FDCE \weight_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[8]_0 ),
        .Q(B[8]));
  FDCE \weight_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[9]_0 ),
        .Q(B[9]));
  FDCE weight_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(weight_valid_reg15_out),
        .Q(weight_valid_reg_reg_0));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_2
   (Q,
    weight_out_valid_reg_reg_0,
    input_valid_reg11_out,
    E,
    weight_out_valid_reg_reg_1,
    D,
    flush,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    weight_out_valid_reg,
    input_valid_IBUF,
    flush_IBUF,
    array_busy_reg_reg,
    array_busy_reg_reg_0,
    array_busy_reg_reg_1,
    computing_reg_0,
    array_busy_reg_i_3_0,
    input_out_valid_mesh_4,
    input_valid_reg,
    weight_out_valid_mesh_12,
    weight_out_valid_mesh_14,
    array_busy_reg_reg_2,
    array_busy_reg_reg_3,
    array_busy_reg_i_2_0,
    array_busy_reg_i_2_1,
    input_valid_reg_0,
    input_valid_reg_1,
    input_in_IBUF,
    array_busy_reg_reg_4,
    array_busy_reg_reg_5,
    array_busy_reg_reg_6,
    accumulator_clr_IBUF,
    \weight_reg_reg[0]_0 ,
    \weight_reg_reg[15]_0 );
  output [31:0]Q;
  output weight_out_valid_reg_reg_0;
  output input_valid_reg11_out;
  output [0:0]E;
  output weight_out_valid_reg_reg_1;
  output [15:0]D;
  output flush;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input weight_out_valid_reg;
  input [0:0]input_valid_IBUF;
  input flush_IBUF;
  input array_busy_reg_reg;
  input array_busy_reg_reg_0;
  input array_busy_reg_reg_1;
  input computing_reg_0;
  input array_busy_reg_i_3_0;
  input input_out_valid_mesh_4;
  input input_valid_reg;
  input weight_out_valid_mesh_12;
  input weight_out_valid_mesh_14;
  input array_busy_reg_reg_2;
  input array_busy_reg_reg_3;
  input array_busy_reg_i_2_0;
  input array_busy_reg_i_2_1;
  input input_valid_reg_0;
  input input_valid_reg_1;
  input [15:0]input_in_IBUF;
  input array_busy_reg_reg_4;
  input array_busy_reg_reg_5;
  input array_busy_reg_reg_6;
  input accumulator_clr_IBUF;
  input \weight_reg_reg[0]_0 ;
  input [15:0]\weight_reg_reg[15]_0 ;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__2_n_0 ;
  wire \accumulator[10]_i_1__2_n_0 ;
  wire \accumulator[11]_i_1__2_n_0 ;
  wire \accumulator[12]_i_1__2_n_0 ;
  wire \accumulator[13]_i_1__2_n_0 ;
  wire \accumulator[14]_i_1__2_n_0 ;
  wire \accumulator[15]_i_1__2_n_0 ;
  wire \accumulator[16]_i_1__2_n_0 ;
  wire \accumulator[17]_i_1__2_n_0 ;
  wire \accumulator[18]_i_1__2_n_0 ;
  wire \accumulator[19]_i_1__2_n_0 ;
  wire \accumulator[1]_i_1__2_n_0 ;
  wire \accumulator[20]_i_1__2_n_0 ;
  wire \accumulator[21]_i_1__2_n_0 ;
  wire \accumulator[22]_i_1__2_n_0 ;
  wire \accumulator[23]_i_1__2_n_0 ;
  wire \accumulator[24]_i_1__2_n_0 ;
  wire \accumulator[25]_i_1__2_n_0 ;
  wire \accumulator[26]_i_1__2_n_0 ;
  wire \accumulator[27]_i_1__2_n_0 ;
  wire \accumulator[28]_i_1__2_n_0 ;
  wire \accumulator[29]_i_1__2_n_0 ;
  wire \accumulator[2]_i_1__2_n_0 ;
  wire \accumulator[30]_i_1__2_n_0 ;
  wire \accumulator[31]_i_1__2_n_0 ;
  wire \accumulator[31]_i_2__2_n_0 ;
  wire \accumulator[3]_i_1__2_n_0 ;
  wire \accumulator[4]_i_1__2_n_0 ;
  wire \accumulator[5]_i_1__2_n_0 ;
  wire \accumulator[6]_i_1__2_n_0 ;
  wire \accumulator[7]_i_1__2_n_0 ;
  wire \accumulator[8]_i_1__2_n_0 ;
  wire \accumulator[9]_i_1__2_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire array_busy_reg_i_11_n_0;
  wire array_busy_reg_i_2_0;
  wire array_busy_reg_i_2_1;
  wire array_busy_reg_i_2_n_0;
  wire array_busy_reg_i_3_0;
  wire array_busy_reg_i_3_n_0;
  wire array_busy_reg_i_7_n_0;
  wire array_busy_reg_i_8_n_0;
  wire array_busy_reg_reg;
  wire array_busy_reg_reg_0;
  wire array_busy_reg_reg_1;
  wire array_busy_reg_reg_2;
  wire array_busy_reg_reg_3;
  wire array_busy_reg_reg_4;
  wire array_busy_reg_reg_5;
  wire array_busy_reg_reg_6;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_n_0;
  wire flush;
  wire flush_IBUF;
  wire [15:0]input_in_IBUF;
  wire [15:0]input_out_mesh_48;
  wire \input_out_reg[0]_i_1__2_n_0 ;
  wire \input_out_reg[10]_i_1__2_n_0 ;
  wire \input_out_reg[11]_i_1__2_n_0 ;
  wire \input_out_reg[12]_i_1__2_n_0 ;
  wire \input_out_reg[13]_i_1__2_n_0 ;
  wire \input_out_reg[14]_i_1__2_n_0 ;
  wire \input_out_reg[15]_i_1__2_n_0 ;
  wire \input_out_reg[15]_i_2__2_n_0 ;
  wire \input_out_reg[1]_i_1__2_n_0 ;
  wire \input_out_reg[2]_i_1__2_n_0 ;
  wire \input_out_reg[3]_i_1__2_n_0 ;
  wire \input_out_reg[4]_i_1__2_n_0 ;
  wire \input_out_reg[5]_i_1__2_n_0 ;
  wire \input_out_reg[6]_i_1__2_n_0 ;
  wire \input_out_reg[7]_i_1__2_n_0 ;
  wire \input_out_reg[8]_i_1__2_n_0 ;
  wire \input_out_reg[9]_i_1__2_n_0 ;
  wire input_out_valid_mesh_3;
  wire input_out_valid_mesh_4;
  wire input_out_valid_reg;
  wire \input_reg[0]_i_1__2_n_0 ;
  wire \input_reg[10]_i_1__2_n_0 ;
  wire \input_reg[11]_i_1__2_n_0 ;
  wire \input_reg[12]_i_1__2_n_0 ;
  wire \input_reg[13]_i_1__2_n_0 ;
  wire \input_reg[14]_i_1__2_n_0 ;
  wire \input_reg[15]_i_1__2_n_0 ;
  wire \input_reg[15]_i_2__2_n_0 ;
  wire \input_reg[1]_i_1__2_n_0 ;
  wire \input_reg[2]_i_1__2_n_0 ;
  wire \input_reg[3]_i_1__2_n_0 ;
  wire \input_reg[4]_i_1__2_n_0 ;
  wire \input_reg[5]_i_1__2_n_0 ;
  wire \input_reg[6]_i_1__2_n_0 ;
  wire \input_reg[7]_i_1__2_n_0 ;
  wire \input_reg[8]_i_1__2_n_0 ;
  wire \input_reg[9]_i_1__2_n_0 ;
  wire [15:0]input_reg__0;
  wire [0:0]input_valid_IBUF;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_3;
  wire input_valid_reg_0;
  wire input_valid_reg_1;
  wire input_valid_reg_2;
  wire [31:0]signed_mac_result__0;
  wire weight_out_valid_mesh_12;
  wire weight_out_valid_mesh_14;
  wire weight_out_valid_reg;
  wire weight_out_valid_reg_reg_0;
  wire weight_out_valid_reg_reg_1;
  wire [15:0]weight_reg__0;
  wire \weight_reg_reg[0]_0 ;
  wire [15:0]\weight_reg_reg[15]_0 ;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair185" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair180" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair179" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair179" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair178" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair178" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair177" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair177" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair176" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair176" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair175" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair184" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair175" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair174" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair174" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair173" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair173" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair172" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair172" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair171" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair171" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair170" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair184" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair170" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__2_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg_2),
        .I3(computing_reg_0),
        .O(\accumulator[31]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair169" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair183" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair183" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair182" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair182" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair181" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair181" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair180" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__2 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__2_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__2_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__2_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__2_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__2_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__2_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__2_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__2_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__2_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__2_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__2_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__2_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__2_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__2_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__2_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__2_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__2_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__2_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__2_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__2_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__2_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__2_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__2_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__2_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__2_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__2_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__2_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__2_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__2_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__2_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__2_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__2_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__2_n_0 ),
        .Q(Q[9]));
  LUT6 #(
    .INIT(64'h5555555555545555)) 
    array_busy_reg_i_1
       (.I0(flush_IBUF),
        .I1(array_busy_reg_i_2_n_0),
        .I2(array_busy_reg_i_3_n_0),
        .I3(array_busy_reg_reg_4),
        .I4(array_busy_reg_reg_5),
        .I5(array_busy_reg_reg_6),
        .O(flush));
  (* SOFT_HLUTNM = "soft_lutpair167" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_11
       (.I0(input_out_valid_mesh_3),
        .I1(computing_reg_0),
        .I2(array_busy_reg_i_3_0),
        .I3(input_out_valid_mesh_4),
        .O(array_busy_reg_i_11_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_18
       (.I0(weight_out_valid_reg_reg_0),
        .I1(input_valid_reg),
        .I2(weight_out_valid_mesh_12),
        .I3(weight_out_valid_mesh_14),
        .O(weight_out_valid_reg_reg_1));
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_2
       (.I0(array_busy_reg_i_7_n_0),
        .I1(array_busy_reg_i_8_n_0),
        .I2(array_busy_reg_reg_2),
        .I3(array_busy_reg_reg_3),
        .O(array_busy_reg_i_2_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_3
       (.I0(array_busy_reg_i_11_n_0),
        .I1(array_busy_reg_reg),
        .I2(array_busy_reg_reg_0),
        .I3(array_busy_reg_reg_1),
        .O(array_busy_reg_i_3_n_0));
  (* SOFT_HLUTNM = "soft_lutpair168" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_7
       (.I0(computing_reg_n_0),
        .I1(input_valid_reg_2),
        .I2(array_busy_reg_i_2_0),
        .I3(array_busy_reg_i_2_1),
        .O(array_busy_reg_i_7_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_8
       (.I0(weight_out_valid_reg_reg_0),
        .I1(input_valid_reg_0),
        .I2(input_valid_reg_1),
        .I3(weight_out_valid_mesh_12),
        .O(array_busy_reg_i_8_n_0));
  (* SOFT_HLUTNM = "soft_lutpair169" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__2
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg_2),
        .I3(computing_reg_0),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair202" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[0]_i_1__2 
       (.I0(input_reg__0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg[0]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair197" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[10]_i_1__2 
       (.I0(input_reg__0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg[10]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair197" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[11]_i_1__2 
       (.I0(input_reg__0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg[11]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair196" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[12]_i_1__2 
       (.I0(input_reg__0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg[12]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair196" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[13]_i_1__2 
       (.I0(input_reg__0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg[13]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair195" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[14]_i_1__2 
       (.I0(input_reg__0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg[14]_i_1__2_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \input_out_reg[15]_i_1__2 
       (.I0(flush_IBUF),
        .I1(input_valid_reg_2),
        .O(\input_out_reg[15]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair195" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[15]_i_2__2 
       (.I0(input_reg__0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg[15]_i_2__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair202" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[1]_i_1__2 
       (.I0(input_reg__0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg[1]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair201" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[2]_i_1__2 
       (.I0(input_reg__0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg[2]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair201" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[3]_i_1__2 
       (.I0(input_reg__0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg[3]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair200" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[4]_i_1__2 
       (.I0(input_reg__0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg[4]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair200" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[5]_i_1__2 
       (.I0(input_reg__0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg[5]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair199" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[6]_i_1__2 
       (.I0(input_reg__0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg[6]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair199" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[7]_i_1__2 
       (.I0(input_reg__0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg[7]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair198" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[8]_i_1__2 
       (.I0(input_reg__0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg[8]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair198" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[9]_i_1__2 
       (.I0(input_reg__0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg[9]_i_1__2_n_0 ));
  FDCE \input_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[0]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[0]));
  FDCE \input_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[10]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[10]));
  FDCE \input_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[11]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[11]));
  FDCE \input_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[12]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[12]));
  FDCE \input_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[13]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[13]));
  FDCE \input_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[14]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[14]));
  FDCE \input_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[15]_i_2__2_n_0 ),
        .Q(input_out_mesh_48[15]));
  FDCE \input_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[1]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[1]));
  FDCE \input_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[2]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[2]));
  FDCE \input_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[3]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[3]));
  FDCE \input_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[4]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[4]));
  FDCE \input_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[5]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[5]));
  FDCE \input_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[6]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[6]));
  FDCE \input_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[7]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[7]));
  FDCE \input_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[8]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[8]));
  FDCE \input_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[9]_i_1__2_n_0 ),
        .Q(input_out_mesh_48[9]));
  (* SOFT_HLUTNM = "soft_lutpair168" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__2
       (.I0(input_valid_reg_2),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_mesh_3));
  (* SOFT_HLUTNM = "soft_lutpair194" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__2 
       (.I0(input_in_IBUF[0]),
        .I1(flush_IBUF),
        .O(\input_reg[0]_i_1__2_n_0 ));
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__6 
       (.I0(input_out_mesh_48[0]),
        .I1(flush_IBUF),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair189" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__2 
       (.I0(input_in_IBUF[10]),
        .I1(flush_IBUF),
        .O(\input_reg[10]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair205" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__6 
       (.I0(input_out_mesh_48[10]),
        .I1(flush_IBUF),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair189" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__2 
       (.I0(input_in_IBUF[11]),
        .I1(flush_IBUF),
        .O(\input_reg[11]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair204" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__6 
       (.I0(input_out_mesh_48[11]),
        .I1(flush_IBUF),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair188" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__2 
       (.I0(input_in_IBUF[12]),
        .I1(flush_IBUF),
        .O(\input_reg[12]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair204" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__6 
       (.I0(input_out_mesh_48[12]),
        .I1(flush_IBUF),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair188" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__2 
       (.I0(input_in_IBUF[13]),
        .I1(flush_IBUF),
        .O(\input_reg[13]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair203" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__6 
       (.I0(input_out_mesh_48[13]),
        .I1(flush_IBUF),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair187" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__2 
       (.I0(input_in_IBUF[14]),
        .I1(flush_IBUF),
        .O(\input_reg[14]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair203" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__6 
       (.I0(input_out_mesh_48[14]),
        .I1(flush_IBUF),
        .O(D[14]));
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__2 
       (.I0(flush_IBUF),
        .I1(input_valid_IBUF),
        .O(\input_reg[15]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair185" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__6 
       (.I0(flush_IBUF),
        .I1(input_out_valid_mesh_3),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair187" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__2 
       (.I0(input_in_IBUF[15]),
        .I1(flush_IBUF),
        .O(\input_reg[15]_i_2__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair186" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__6 
       (.I0(input_out_mesh_48[15]),
        .I1(flush_IBUF),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair194" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__2 
       (.I0(input_in_IBUF[1]),
        .I1(flush_IBUF),
        .O(\input_reg[1]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair209" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__6 
       (.I0(input_out_mesh_48[1]),
        .I1(flush_IBUF),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair193" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__2 
       (.I0(input_in_IBUF[2]),
        .I1(flush_IBUF),
        .O(\input_reg[2]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair209" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__6 
       (.I0(input_out_mesh_48[2]),
        .I1(flush_IBUF),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair193" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__2 
       (.I0(input_in_IBUF[3]),
        .I1(flush_IBUF),
        .O(\input_reg[3]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair208" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__6 
       (.I0(input_out_mesh_48[3]),
        .I1(flush_IBUF),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair192" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__2 
       (.I0(input_in_IBUF[4]),
        .I1(flush_IBUF),
        .O(\input_reg[4]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair208" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__6 
       (.I0(input_out_mesh_48[4]),
        .I1(flush_IBUF),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair192" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__2 
       (.I0(input_in_IBUF[5]),
        .I1(flush_IBUF),
        .O(\input_reg[5]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair207" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__6 
       (.I0(input_out_mesh_48[5]),
        .I1(flush_IBUF),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair191" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__2 
       (.I0(input_in_IBUF[6]),
        .I1(flush_IBUF),
        .O(\input_reg[6]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair207" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__6 
       (.I0(input_out_mesh_48[6]),
        .I1(flush_IBUF),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair191" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__2 
       (.I0(input_in_IBUF[7]),
        .I1(flush_IBUF),
        .O(\input_reg[7]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair206" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__6 
       (.I0(input_out_mesh_48[7]),
        .I1(flush_IBUF),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair190" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__2 
       (.I0(input_in_IBUF[8]),
        .I1(flush_IBUF),
        .O(\input_reg[8]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair206" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__6 
       (.I0(input_out_mesh_48[8]),
        .I1(flush_IBUF),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair190" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__2 
       (.I0(input_in_IBUF[9]),
        .I1(flush_IBUF),
        .O(\input_reg[9]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair205" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__6 
       (.I0(input_out_mesh_48[9]),
        .I1(flush_IBUF),
        .O(D[9]));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[0]_i_1__2_n_0 ),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[10]_i_1__2_n_0 ),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[11]_i_1__2_n_0 ),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[12]_i_1__2_n_0 ),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[13]_i_1__2_n_0 ),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[14]_i_1__2_n_0 ),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[15]_i_2__2_n_0 ),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[1]_i_1__2_n_0 ),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[2]_i_1__2_n_0 ),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[3]_i_1__2_n_0 ),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[4]_i_1__2_n_0 ),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[5]_i_1__2_n_0 ),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[6]_i_1__2_n_0 ),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[7]_i_1__2_n_0 ),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[8]_i_1__2_n_0 ),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg[15]_i_1__2_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg[9]_i_1__2_n_0 ),
        .Q(input_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair186" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__2
       (.I0(input_valid_IBUF),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out_3));
  (* SOFT_HLUTNM = "soft_lutpair167" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__6
       (.I0(input_out_valid_mesh_3),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out_3),
        .Q(input_valid_reg_2));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,weight_reg__0}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
  FDCE weight_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(weight_out_valid_reg),
        .Q(weight_out_valid_reg_reg_0));
  FDCE \weight_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [0]),
        .Q(weight_reg__0[0]));
  FDCE \weight_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [10]),
        .Q(weight_reg__0[10]));
  FDCE \weight_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [11]),
        .Q(weight_reg__0[11]));
  FDCE \weight_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [12]),
        .Q(weight_reg__0[12]));
  FDCE \weight_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [13]),
        .Q(weight_reg__0[13]));
  FDCE \weight_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [14]),
        .Q(weight_reg__0[14]));
  FDCE \weight_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [15]),
        .Q(weight_reg__0[15]));
  FDCE \weight_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [1]),
        .Q(weight_reg__0[1]));
  FDCE \weight_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [2]),
        .Q(weight_reg__0[2]));
  FDCE \weight_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [3]),
        .Q(weight_reg__0[3]));
  FDCE \weight_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [4]),
        .Q(weight_reg__0[4]));
  FDCE \weight_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [5]),
        .Q(weight_reg__0[5]));
  FDCE \weight_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [6]),
        .Q(weight_reg__0[6]));
  FDCE \weight_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [7]),
        .Q(weight_reg__0[7]));
  FDCE \weight_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [8]),
        .Q(weight_reg__0[8]));
  FDCE \weight_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\weight_reg_reg[0]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\weight_reg_reg[15]_0 [9]),
        .Q(weight_reg__0[9]));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_3
   (Q,
    computing_reg_0,
    input_valid_reg,
    input_out_valid_mesh_4,
    input_valid_reg11_out,
    E,
    D,
    B,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    input_valid_reg11_out_0,
    flush_IBUF,
    accumulator_clr_IBUF,
    computing_reg_1,
    \input_reg_reg[15]_0 ,
    \input_reg_reg[15]_1 );
  output [31:0]Q;
  output computing_reg_0;
  output input_valid_reg;
  output input_out_valid_mesh_4;
  output input_valid_reg11_out;
  output [0:0]E;
  output [15:0]D;
  input [15:0]B;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input input_valid_reg11_out_0;
  input flush_IBUF;
  input accumulator_clr_IBUF;
  input computing_reg_1;
  input [0:0]\input_reg_reg[15]_0 ;
  input [15:0]\input_reg_reg[15]_1 ;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__3_n_0 ;
  wire \accumulator[10]_i_1__3_n_0 ;
  wire \accumulator[11]_i_1__3_n_0 ;
  wire \accumulator[12]_i_1__3_n_0 ;
  wire \accumulator[13]_i_1__3_n_0 ;
  wire \accumulator[14]_i_1__3_n_0 ;
  wire \accumulator[15]_i_1__3_n_0 ;
  wire \accumulator[16]_i_1__3_n_0 ;
  wire \accumulator[17]_i_1__3_n_0 ;
  wire \accumulator[18]_i_1__3_n_0 ;
  wire \accumulator[19]_i_1__3_n_0 ;
  wire \accumulator[1]_i_1__3_n_0 ;
  wire \accumulator[20]_i_1__3_n_0 ;
  wire \accumulator[21]_i_1__3_n_0 ;
  wire \accumulator[22]_i_1__3_n_0 ;
  wire \accumulator[23]_i_1__3_n_0 ;
  wire \accumulator[24]_i_1__3_n_0 ;
  wire \accumulator[25]_i_1__3_n_0 ;
  wire \accumulator[26]_i_1__3_n_0 ;
  wire \accumulator[27]_i_1__3_n_0 ;
  wire \accumulator[28]_i_1__3_n_0 ;
  wire \accumulator[29]_i_1__3_n_0 ;
  wire \accumulator[2]_i_1__3_n_0 ;
  wire \accumulator[30]_i_1__3_n_0 ;
  wire \accumulator[31]_i_1__3_n_0 ;
  wire \accumulator[31]_i_2__3_n_0 ;
  wire \accumulator[3]_i_1__3_n_0 ;
  wire \accumulator[4]_i_1__3_n_0 ;
  wire \accumulator[5]_i_1__3_n_0 ;
  wire \accumulator[6]_i_1__3_n_0 ;
  wire \accumulator[7]_i_1__3_n_0 ;
  wire \accumulator[8]_i_1__3_n_0 ;
  wire \accumulator[9]_i_1__3_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_1;
  wire flush_IBUF;
  wire [15:0]input_out_mesh_64;
  wire \input_out_reg[0]_i_1__3_n_0 ;
  wire \input_out_reg[10]_i_1__3_n_0 ;
  wire \input_out_reg[11]_i_1__3_n_0 ;
  wire \input_out_reg[12]_i_1__3_n_0 ;
  wire \input_out_reg[13]_i_1__3_n_0 ;
  wire \input_out_reg[14]_i_1__3_n_0 ;
  wire \input_out_reg[15]_i_1__3_n_0 ;
  wire \input_out_reg[15]_i_2__3_n_0 ;
  wire \input_out_reg[1]_i_1__3_n_0 ;
  wire \input_out_reg[2]_i_1__3_n_0 ;
  wire \input_out_reg[3]_i_1__3_n_0 ;
  wire \input_out_reg[4]_i_1__3_n_0 ;
  wire \input_out_reg[5]_i_1__3_n_0 ;
  wire \input_out_reg[6]_i_1__3_n_0 ;
  wire \input_out_reg[7]_i_1__3_n_0 ;
  wire \input_out_reg[8]_i_1__3_n_0 ;
  wire \input_out_reg[9]_i_1__3_n_0 ;
  wire input_out_valid_mesh_4;
  wire input_out_valid_reg;
  wire [15:0]input_reg__0;
  wire [0:0]\input_reg_reg[15]_0 ;
  wire [15:0]\input_reg_reg[15]_1 ;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_0;
  wire [31:0]signed_mac_result__0;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair226" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair221" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair220" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair220" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair219" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair219" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair218" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair218" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair217" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair217" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair216" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair225" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair216" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair215" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair215" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair214" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair214" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair213" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair213" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair212" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair212" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair211" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair225" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair211" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__3_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(\accumulator[31]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair210" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair224" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair224" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair223" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair223" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair222" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair222" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair221" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__3 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__3_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__3_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__3_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__3_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__3_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__3_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__3_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__3_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__3_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__3_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__3_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__3_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__3_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__3_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__3_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__3_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__3_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__3_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__3_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__3_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__3_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__3_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__3_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__3_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__3_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__3_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__3_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__3_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__3_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__3_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__3_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__3_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__3_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair210" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__3
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair235" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[0]_i_1__3 
       (.I0(input_reg__0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg[0]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair230" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[10]_i_1__3 
       (.I0(input_reg__0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg[10]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair230" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[11]_i_1__3 
       (.I0(input_reg__0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg[11]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair229" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[12]_i_1__3 
       (.I0(input_reg__0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg[12]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair229" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[13]_i_1__3 
       (.I0(input_reg__0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg[13]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair228" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[14]_i_1__3 
       (.I0(input_reg__0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg[14]_i_1__3_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \input_out_reg[15]_i_1__3 
       (.I0(flush_IBUF),
        .I1(input_valid_reg),
        .O(\input_out_reg[15]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair228" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[15]_i_2__3 
       (.I0(input_reg__0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg[15]_i_2__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair235" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[1]_i_1__3 
       (.I0(input_reg__0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg[1]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair234" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[2]_i_1__3 
       (.I0(input_reg__0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg[2]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair234" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[3]_i_1__3 
       (.I0(input_reg__0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg[3]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair233" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[4]_i_1__3 
       (.I0(input_reg__0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg[4]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair233" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[5]_i_1__3 
       (.I0(input_reg__0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg[5]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair232" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[6]_i_1__3 
       (.I0(input_reg__0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg[6]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair232" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[7]_i_1__3 
       (.I0(input_reg__0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg[7]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair231" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[8]_i_1__3 
       (.I0(input_reg__0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg[8]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair231" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[9]_i_1__3 
       (.I0(input_reg__0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg[9]_i_1__3_n_0 ));
  FDCE \input_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[0]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[0]));
  FDCE \input_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[10]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[10]));
  FDCE \input_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[11]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[11]));
  FDCE \input_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[12]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[12]));
  FDCE \input_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[13]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[13]));
  FDCE \input_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[14]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[14]));
  FDCE \input_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[15]_i_2__3_n_0 ),
        .Q(input_out_mesh_64[15]));
  FDCE \input_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[1]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[1]));
  FDCE \input_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[2]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[2]));
  FDCE \input_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[3]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[3]));
  FDCE \input_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[4]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[4]));
  FDCE \input_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[5]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[5]));
  FDCE \input_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[6]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[6]));
  FDCE \input_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[7]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[7]));
  FDCE \input_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[8]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[8]));
  FDCE \input_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__3_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[9]_i_1__3_n_0 ),
        .Q(input_out_mesh_64[9]));
  (* SOFT_HLUTNM = "soft_lutpair227" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__3
       (.I0(input_valid_reg),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_mesh_4));
  (* SOFT_HLUTNM = "soft_lutpair243" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__7 
       (.I0(input_out_mesh_64[0]),
        .I1(flush_IBUF),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair238" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__7 
       (.I0(input_out_mesh_64[10]),
        .I1(flush_IBUF),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair238" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__7 
       (.I0(input_out_mesh_64[11]),
        .I1(flush_IBUF),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair237" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__7 
       (.I0(input_out_mesh_64[12]),
        .I1(flush_IBUF),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair237" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__7 
       (.I0(input_out_mesh_64[13]),
        .I1(flush_IBUF),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair236" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__7 
       (.I0(input_out_mesh_64[14]),
        .I1(flush_IBUF),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair227" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__7 
       (.I0(flush_IBUF),
        .I1(input_out_valid_mesh_4),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair236" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__7 
       (.I0(input_out_mesh_64[15]),
        .I1(flush_IBUF),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair243" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__7 
       (.I0(input_out_mesh_64[1]),
        .I1(flush_IBUF),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair242" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__7 
       (.I0(input_out_mesh_64[2]),
        .I1(flush_IBUF),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair242" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__7 
       (.I0(input_out_mesh_64[3]),
        .I1(flush_IBUF),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair241" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__7 
       (.I0(input_out_mesh_64[4]),
        .I1(flush_IBUF),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair241" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__7 
       (.I0(input_out_mesh_64[5]),
        .I1(flush_IBUF),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair240" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__7 
       (.I0(input_out_mesh_64[6]),
        .I1(flush_IBUF),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair240" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__7 
       (.I0(input_out_mesh_64[7]),
        .I1(flush_IBUF),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair239" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__7 
       (.I0(input_out_mesh_64[8]),
        .I1(flush_IBUF),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair239" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__7 
       (.I0(input_out_mesh_64[9]),
        .I1(flush_IBUF),
        .O(D[9]));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [0]),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [10]),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [11]),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [12]),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [13]),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [14]),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [15]),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [1]),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [2]),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [3]),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [4]),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [5]),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [6]),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [7]),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [8]),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [9]),
        .Q(input_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair226" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__7
       (.I0(input_out_valid_mesh_4),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out_0),
        .Q(input_valid_reg));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_4
   (Q,
    input_out_valid_mesh_5,
    input_valid_reg11_out,
    E,
    computing_reg_0,
    D,
    B,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    input_valid_reg11_out_0,
    flush_IBUF,
    input_out_valid_mesh_6,
    weight_out_valid_mesh_14,
    accumulator_clr_IBUF,
    computing_reg_1,
    \input_reg_reg[15]_0 ,
    \input_reg_reg[15]_1 );
  output [31:0]Q;
  output input_out_valid_mesh_5;
  output input_valid_reg11_out;
  output [0:0]E;
  output computing_reg_0;
  output [15:0]D;
  input [15:0]B;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input input_valid_reg11_out_0;
  input flush_IBUF;
  input input_out_valid_mesh_6;
  input weight_out_valid_mesh_14;
  input accumulator_clr_IBUF;
  input computing_reg_1;
  input [0:0]\input_reg_reg[15]_0 ;
  input [15:0]\input_reg_reg[15]_1 ;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__4_n_0 ;
  wire \accumulator[10]_i_1__4_n_0 ;
  wire \accumulator[11]_i_1__4_n_0 ;
  wire \accumulator[12]_i_1__4_n_0 ;
  wire \accumulator[13]_i_1__4_n_0 ;
  wire \accumulator[14]_i_1__4_n_0 ;
  wire \accumulator[15]_i_1__4_n_0 ;
  wire \accumulator[16]_i_1__4_n_0 ;
  wire \accumulator[17]_i_1__4_n_0 ;
  wire \accumulator[18]_i_1__4_n_0 ;
  wire \accumulator[19]_i_1__4_n_0 ;
  wire \accumulator[1]_i_1__4_n_0 ;
  wire \accumulator[20]_i_1__4_n_0 ;
  wire \accumulator[21]_i_1__4_n_0 ;
  wire \accumulator[22]_i_1__4_n_0 ;
  wire \accumulator[23]_i_1__4_n_0 ;
  wire \accumulator[24]_i_1__4_n_0 ;
  wire \accumulator[25]_i_1__4_n_0 ;
  wire \accumulator[26]_i_1__4_n_0 ;
  wire \accumulator[27]_i_1__4_n_0 ;
  wire \accumulator[28]_i_1__4_n_0 ;
  wire \accumulator[29]_i_1__4_n_0 ;
  wire \accumulator[2]_i_1__4_n_0 ;
  wire \accumulator[30]_i_1__4_n_0 ;
  wire \accumulator[31]_i_1__4_n_0 ;
  wire \accumulator[31]_i_2__4_n_0 ;
  wire \accumulator[3]_i_1__4_n_0 ;
  wire \accumulator[4]_i_1__4_n_0 ;
  wire \accumulator[5]_i_1__4_n_0 ;
  wire \accumulator[6]_i_1__4_n_0 ;
  wire \accumulator[7]_i_1__4_n_0 ;
  wire \accumulator[8]_i_1__4_n_0 ;
  wire \accumulator[9]_i_1__4_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_1;
  wire computing_reg_n_0;
  wire flush_IBUF;
  wire [15:0]input_out_mesh_80;
  wire \input_out_reg[0]_i_1__4_n_0 ;
  wire \input_out_reg[10]_i_1__4_n_0 ;
  wire \input_out_reg[11]_i_1__4_n_0 ;
  wire \input_out_reg[12]_i_1__4_n_0 ;
  wire \input_out_reg[13]_i_1__4_n_0 ;
  wire \input_out_reg[14]_i_1__4_n_0 ;
  wire \input_out_reg[15]_i_1__4_n_0 ;
  wire \input_out_reg[15]_i_2__4_n_0 ;
  wire \input_out_reg[1]_i_1__4_n_0 ;
  wire \input_out_reg[2]_i_1__4_n_0 ;
  wire \input_out_reg[3]_i_1__4_n_0 ;
  wire \input_out_reg[4]_i_1__4_n_0 ;
  wire \input_out_reg[5]_i_1__4_n_0 ;
  wire \input_out_reg[6]_i_1__4_n_0 ;
  wire \input_out_reg[7]_i_1__4_n_0 ;
  wire \input_out_reg[8]_i_1__4_n_0 ;
  wire \input_out_reg[9]_i_1__4_n_0 ;
  wire input_out_valid_mesh_5;
  wire input_out_valid_mesh_6;
  wire input_out_valid_reg;
  wire [15:0]input_reg__0;
  wire [0:0]\input_reg_reg[15]_0 ;
  wire [15:0]\input_reg_reg[15]_1 ;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_0;
  wire [31:0]signed_mac_result__0;
  wire weight_out_valid_mesh_14;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair261" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair256" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair255" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair255" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair254" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair254" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair253" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair253" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair252" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair252" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair251" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair260" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair251" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair250" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair250" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair249" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair249" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair248" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair248" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair247" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair247" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair246" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair260" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair246" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__4_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(\accumulator[31]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair245" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair259" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair259" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair258" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair258" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair257" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair257" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair256" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__4 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__4_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__4_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__4_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__4_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__4_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__4_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__4_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__4_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__4_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__4_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__4_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__4_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__4_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__4_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__4_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__4_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__4_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__4_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__4_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__4_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__4_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__4_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__4_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__4_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__4_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__4_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__4_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__4_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__4_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__4_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__4_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__4_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__4_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair244" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_14
       (.I0(computing_reg_n_0),
        .I1(input_valid_reg),
        .I2(input_out_valid_mesh_6),
        .I3(weight_out_valid_mesh_14),
        .O(computing_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair245" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__4
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair270" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[0]_i_1__4 
       (.I0(input_reg__0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg[0]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair265" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[10]_i_1__4 
       (.I0(input_reg__0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg[10]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair264" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[11]_i_1__4 
       (.I0(input_reg__0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg[11]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair264" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[12]_i_1__4 
       (.I0(input_reg__0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg[12]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair263" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[13]_i_1__4 
       (.I0(input_reg__0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg[13]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair263" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[14]_i_1__4 
       (.I0(input_reg__0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg[14]_i_1__4_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \input_out_reg[15]_i_1__4 
       (.I0(flush_IBUF),
        .I1(input_valid_reg),
        .O(\input_out_reg[15]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair262" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[15]_i_2__4 
       (.I0(input_reg__0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg[15]_i_2__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair269" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[1]_i_1__4 
       (.I0(input_reg__0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg[1]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair269" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[2]_i_1__4 
       (.I0(input_reg__0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg[2]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair268" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[3]_i_1__4 
       (.I0(input_reg__0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg[3]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair268" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[4]_i_1__4 
       (.I0(input_reg__0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg[4]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair267" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[5]_i_1__4 
       (.I0(input_reg__0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg[5]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair267" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[6]_i_1__4 
       (.I0(input_reg__0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg[6]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair266" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[7]_i_1__4 
       (.I0(input_reg__0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg[7]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair266" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[8]_i_1__4 
       (.I0(input_reg__0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg[8]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair265" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[9]_i_1__4 
       (.I0(input_reg__0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg[9]_i_1__4_n_0 ));
  FDCE \input_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[0]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[0]));
  FDCE \input_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[10]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[10]));
  FDCE \input_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[11]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[11]));
  FDCE \input_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[12]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[12]));
  FDCE \input_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[13]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[13]));
  FDCE \input_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[14]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[14]));
  FDCE \input_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[15]_i_2__4_n_0 ),
        .Q(input_out_mesh_80[15]));
  FDCE \input_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[1]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[1]));
  FDCE \input_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[2]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[2]));
  FDCE \input_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[3]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[3]));
  FDCE \input_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[4]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[4]));
  FDCE \input_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[5]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[5]));
  FDCE \input_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[6]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[6]));
  FDCE \input_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[7]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[7]));
  FDCE \input_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[8]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[8]));
  FDCE \input_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__4_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[9]_i_1__4_n_0 ),
        .Q(input_out_mesh_80[9]));
  (* SOFT_HLUTNM = "soft_lutpair244" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__4
       (.I0(input_valid_reg),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_mesh_5));
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__8 
       (.I0(input_out_mesh_80[0]),
        .I1(flush_IBUF),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair273" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__8 
       (.I0(input_out_mesh_80[10]),
        .I1(flush_IBUF),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair272" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__8 
       (.I0(input_out_mesh_80[11]),
        .I1(flush_IBUF),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair272" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__8 
       (.I0(input_out_mesh_80[12]),
        .I1(flush_IBUF),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair271" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__8 
       (.I0(input_out_mesh_80[13]),
        .I1(flush_IBUF),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair271" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__8 
       (.I0(input_out_mesh_80[14]),
        .I1(flush_IBUF),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair262" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__8 
       (.I0(flush_IBUF),
        .I1(input_out_valid_mesh_5),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair270" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__8 
       (.I0(input_out_mesh_80[15]),
        .I1(flush_IBUF),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair277" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__8 
       (.I0(input_out_mesh_80[1]),
        .I1(flush_IBUF),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair277" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__8 
       (.I0(input_out_mesh_80[2]),
        .I1(flush_IBUF),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair276" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__8 
       (.I0(input_out_mesh_80[3]),
        .I1(flush_IBUF),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair276" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__8 
       (.I0(input_out_mesh_80[4]),
        .I1(flush_IBUF),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair275" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__8 
       (.I0(input_out_mesh_80[5]),
        .I1(flush_IBUF),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair275" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__8 
       (.I0(input_out_mesh_80[6]),
        .I1(flush_IBUF),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair274" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__8 
       (.I0(input_out_mesh_80[7]),
        .I1(flush_IBUF),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair274" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__8 
       (.I0(input_out_mesh_80[8]),
        .I1(flush_IBUF),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair273" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__8 
       (.I0(input_out_mesh_80[9]),
        .I1(flush_IBUF),
        .O(D[9]));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [0]),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [10]),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [11]),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [12]),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [13]),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [14]),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [15]),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [1]),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [2]),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [3]),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [4]),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [5]),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [6]),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [7]),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [8]),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [9]),
        .Q(input_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair261" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__8
       (.I0(input_out_valid_mesh_5),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out_0),
        .Q(input_valid_reg));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_5
   (Q,
    computing_reg_0,
    input_valid_reg,
    input_out_valid_mesh_6,
    input_valid_reg11_out,
    E,
    D,
    B,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    input_valid_reg11_out_0,
    flush_IBUF,
    accumulator_clr_IBUF,
    computing_reg_1,
    \input_reg_reg[15]_0 ,
    \input_reg_reg[15]_1 );
  output [31:0]Q;
  output computing_reg_0;
  output input_valid_reg;
  output input_out_valid_mesh_6;
  output input_valid_reg11_out;
  output [0:0]E;
  output [15:0]D;
  input [15:0]B;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input input_valid_reg11_out_0;
  input flush_IBUF;
  input accumulator_clr_IBUF;
  input computing_reg_1;
  input [0:0]\input_reg_reg[15]_0 ;
  input [15:0]\input_reg_reg[15]_1 ;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__5_n_0 ;
  wire \accumulator[10]_i_1__5_n_0 ;
  wire \accumulator[11]_i_1__5_n_0 ;
  wire \accumulator[12]_i_1__5_n_0 ;
  wire \accumulator[13]_i_1__5_n_0 ;
  wire \accumulator[14]_i_1__5_n_0 ;
  wire \accumulator[15]_i_1__5_n_0 ;
  wire \accumulator[16]_i_1__5_n_0 ;
  wire \accumulator[17]_i_1__5_n_0 ;
  wire \accumulator[18]_i_1__5_n_0 ;
  wire \accumulator[19]_i_1__5_n_0 ;
  wire \accumulator[1]_i_1__5_n_0 ;
  wire \accumulator[20]_i_1__5_n_0 ;
  wire \accumulator[21]_i_1__5_n_0 ;
  wire \accumulator[22]_i_1__5_n_0 ;
  wire \accumulator[23]_i_1__5_n_0 ;
  wire \accumulator[24]_i_1__5_n_0 ;
  wire \accumulator[25]_i_1__5_n_0 ;
  wire \accumulator[26]_i_1__5_n_0 ;
  wire \accumulator[27]_i_1__5_n_0 ;
  wire \accumulator[28]_i_1__5_n_0 ;
  wire \accumulator[29]_i_1__5_n_0 ;
  wire \accumulator[2]_i_1__5_n_0 ;
  wire \accumulator[30]_i_1__5_n_0 ;
  wire \accumulator[31]_i_1__5_n_0 ;
  wire \accumulator[31]_i_2__5_n_0 ;
  wire \accumulator[3]_i_1__5_n_0 ;
  wire \accumulator[4]_i_1__5_n_0 ;
  wire \accumulator[5]_i_1__5_n_0 ;
  wire \accumulator[6]_i_1__5_n_0 ;
  wire \accumulator[7]_i_1__5_n_0 ;
  wire \accumulator[8]_i_1__5_n_0 ;
  wire \accumulator[9]_i_1__5_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_1;
  wire flush_IBUF;
  wire [15:0]input_out_mesh_96;
  wire \input_out_reg[0]_i_1__5_n_0 ;
  wire \input_out_reg[10]_i_1__5_n_0 ;
  wire \input_out_reg[11]_i_1__5_n_0 ;
  wire \input_out_reg[12]_i_1__5_n_0 ;
  wire \input_out_reg[13]_i_1__5_n_0 ;
  wire \input_out_reg[14]_i_1__5_n_0 ;
  wire \input_out_reg[15]_i_1__5_n_0 ;
  wire \input_out_reg[15]_i_2__5_n_0 ;
  wire \input_out_reg[1]_i_1__5_n_0 ;
  wire \input_out_reg[2]_i_1__5_n_0 ;
  wire \input_out_reg[3]_i_1__5_n_0 ;
  wire \input_out_reg[4]_i_1__5_n_0 ;
  wire \input_out_reg[5]_i_1__5_n_0 ;
  wire \input_out_reg[6]_i_1__5_n_0 ;
  wire \input_out_reg[7]_i_1__5_n_0 ;
  wire \input_out_reg[8]_i_1__5_n_0 ;
  wire \input_out_reg[9]_i_1__5_n_0 ;
  wire input_out_valid_mesh_6;
  wire input_out_valid_reg;
  wire [15:0]input_reg__0;
  wire [0:0]\input_reg_reg[15]_0 ;
  wire [15:0]\input_reg_reg[15]_1 ;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_0;
  wire [31:0]signed_mac_result__0;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair294" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair289" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair288" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair288" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair287" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair287" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair286" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair286" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair285" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair285" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair284" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair293" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair284" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair283" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair283" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair282" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair282" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair281" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair281" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair280" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair280" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair279" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair293" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair279" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__5_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(\accumulator[31]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair278" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair292" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair292" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair291" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair291" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair290" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair290" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair289" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__5 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__5_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__5_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__5_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__5_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__5_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__5_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__5_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__5_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__5_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__5_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__5_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__5_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__5_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__5_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__5_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__5_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__5_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__5_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__5_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__5_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__5_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__5_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__5_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__5_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__5_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__5_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__5_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__5_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__5_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__5_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__5_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__5_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__5_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair278" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__5
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair303" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[0]_i_1__5 
       (.I0(input_reg__0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg[0]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair298" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[10]_i_1__5 
       (.I0(input_reg__0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg[10]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair298" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[11]_i_1__5 
       (.I0(input_reg__0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg[11]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair297" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[12]_i_1__5 
       (.I0(input_reg__0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg[12]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair297" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[13]_i_1__5 
       (.I0(input_reg__0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg[13]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair296" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[14]_i_1__5 
       (.I0(input_reg__0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg[14]_i_1__5_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \input_out_reg[15]_i_1__5 
       (.I0(flush_IBUF),
        .I1(input_valid_reg),
        .O(\input_out_reg[15]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair296" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[15]_i_2__5 
       (.I0(input_reg__0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg[15]_i_2__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair303" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[1]_i_1__5 
       (.I0(input_reg__0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg[1]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair302" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[2]_i_1__5 
       (.I0(input_reg__0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg[2]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair302" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[3]_i_1__5 
       (.I0(input_reg__0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg[3]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair301" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[4]_i_1__5 
       (.I0(input_reg__0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg[4]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair301" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[5]_i_1__5 
       (.I0(input_reg__0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg[5]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair300" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[6]_i_1__5 
       (.I0(input_reg__0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg[6]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair300" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[7]_i_1__5 
       (.I0(input_reg__0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg[7]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair299" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[8]_i_1__5 
       (.I0(input_reg__0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg[8]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair299" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[9]_i_1__5 
       (.I0(input_reg__0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg[9]_i_1__5_n_0 ));
  FDCE \input_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[0]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[0]));
  FDCE \input_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[10]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[10]));
  FDCE \input_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[11]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[11]));
  FDCE \input_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[12]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[12]));
  FDCE \input_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[13]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[13]));
  FDCE \input_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[14]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[14]));
  FDCE \input_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[15]_i_2__5_n_0 ),
        .Q(input_out_mesh_96[15]));
  FDCE \input_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[1]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[1]));
  FDCE \input_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[2]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[2]));
  FDCE \input_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[3]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[3]));
  FDCE \input_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[4]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[4]));
  FDCE \input_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[5]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[5]));
  FDCE \input_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[6]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[6]));
  FDCE \input_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[7]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[7]));
  FDCE \input_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[8]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[8]));
  FDCE \input_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__5_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[9]_i_1__5_n_0 ),
        .Q(input_out_mesh_96[9]));
  (* SOFT_HLUTNM = "soft_lutpair295" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__5
       (.I0(input_valid_reg),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_mesh_6));
  (* SOFT_HLUTNM = "soft_lutpair311" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__9 
       (.I0(input_out_mesh_96[0]),
        .I1(flush_IBUF),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair306" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__9 
       (.I0(input_out_mesh_96[10]),
        .I1(flush_IBUF),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair306" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__9 
       (.I0(input_out_mesh_96[11]),
        .I1(flush_IBUF),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair305" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__9 
       (.I0(input_out_mesh_96[12]),
        .I1(flush_IBUF),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair305" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__9 
       (.I0(input_out_mesh_96[13]),
        .I1(flush_IBUF),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair304" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__9 
       (.I0(input_out_mesh_96[14]),
        .I1(flush_IBUF),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair295" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__9 
       (.I0(flush_IBUF),
        .I1(input_out_valid_mesh_6),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair304" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__9 
       (.I0(input_out_mesh_96[15]),
        .I1(flush_IBUF),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair311" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__9 
       (.I0(input_out_mesh_96[1]),
        .I1(flush_IBUF),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair310" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__9 
       (.I0(input_out_mesh_96[2]),
        .I1(flush_IBUF),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair310" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__9 
       (.I0(input_out_mesh_96[3]),
        .I1(flush_IBUF),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair309" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__9 
       (.I0(input_out_mesh_96[4]),
        .I1(flush_IBUF),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair309" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__9 
       (.I0(input_out_mesh_96[5]),
        .I1(flush_IBUF),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair308" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__9 
       (.I0(input_out_mesh_96[6]),
        .I1(flush_IBUF),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair308" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__9 
       (.I0(input_out_mesh_96[7]),
        .I1(flush_IBUF),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair307" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__9 
       (.I0(input_out_mesh_96[8]),
        .I1(flush_IBUF),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair307" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__9 
       (.I0(input_out_mesh_96[9]),
        .I1(flush_IBUF),
        .O(D[9]));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [0]),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [10]),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [11]),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [12]),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [13]),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [14]),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [15]),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [1]),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [2]),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [3]),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [4]),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [5]),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [6]),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [7]),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [8]),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [9]),
        .Q(input_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair294" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__9
       (.I0(input_out_valid_mesh_6),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out_0),
        .Q(input_valid_reg));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_6
   (Q,
    computing_reg_0,
    input_valid_reg11_out,
    E,
    computing_reg_1,
    D,
    B,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    input_valid_reg11_out_0,
    flush_IBUF,
    array_busy_reg_i_4,
    input_out_valid_mesh_2,
    accumulator_clr_IBUF,
    computing_reg_2,
    \input_reg_reg[15]_0 ,
    \input_reg_reg[15]_1 );
  output [31:0]Q;
  output computing_reg_0;
  output input_valid_reg11_out;
  output [0:0]E;
  output computing_reg_1;
  output [15:0]D;
  input [15:0]B;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input input_valid_reg11_out_0;
  input flush_IBUF;
  input array_busy_reg_i_4;
  input input_out_valid_mesh_2;
  input accumulator_clr_IBUF;
  input computing_reg_2;
  input [0:0]\input_reg_reg[15]_0 ;
  input [15:0]\input_reg_reg[15]_1 ;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__6_n_0 ;
  wire \accumulator[10]_i_1__6_n_0 ;
  wire \accumulator[11]_i_1__6_n_0 ;
  wire \accumulator[12]_i_1__6_n_0 ;
  wire \accumulator[13]_i_1__6_n_0 ;
  wire \accumulator[14]_i_1__6_n_0 ;
  wire \accumulator[15]_i_1__6_n_0 ;
  wire \accumulator[16]_i_1__6_n_0 ;
  wire \accumulator[17]_i_1__6_n_0 ;
  wire \accumulator[18]_i_1__6_n_0 ;
  wire \accumulator[19]_i_1__6_n_0 ;
  wire \accumulator[1]_i_1__6_n_0 ;
  wire \accumulator[20]_i_1__6_n_0 ;
  wire \accumulator[21]_i_1__6_n_0 ;
  wire \accumulator[22]_i_1__6_n_0 ;
  wire \accumulator[23]_i_1__6_n_0 ;
  wire \accumulator[24]_i_1__6_n_0 ;
  wire \accumulator[25]_i_1__6_n_0 ;
  wire \accumulator[26]_i_1__6_n_0 ;
  wire \accumulator[27]_i_1__6_n_0 ;
  wire \accumulator[28]_i_1__6_n_0 ;
  wire \accumulator[29]_i_1__6_n_0 ;
  wire \accumulator[2]_i_1__6_n_0 ;
  wire \accumulator[30]_i_1__6_n_0 ;
  wire \accumulator[31]_i_1__6_n_0 ;
  wire \accumulator[31]_i_2__6_n_0 ;
  wire \accumulator[3]_i_1__6_n_0 ;
  wire \accumulator[4]_i_1__6_n_0 ;
  wire \accumulator[5]_i_1__6_n_0 ;
  wire \accumulator[6]_i_1__6_n_0 ;
  wire \accumulator[7]_i_1__6_n_0 ;
  wire \accumulator[8]_i_1__6_n_0 ;
  wire \accumulator[9]_i_1__6_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire array_busy_reg_i_4;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_1;
  wire computing_reg_2;
  wire flush_IBUF;
  wire [15:0]input_out_mesh_112;
  wire \input_out_reg[0]_i_1__6_n_0 ;
  wire \input_out_reg[10]_i_1__6_n_0 ;
  wire \input_out_reg[11]_i_1__6_n_0 ;
  wire \input_out_reg[12]_i_1__6_n_0 ;
  wire \input_out_reg[13]_i_1__6_n_0 ;
  wire \input_out_reg[14]_i_1__6_n_0 ;
  wire \input_out_reg[15]_i_1__6_n_0 ;
  wire \input_out_reg[15]_i_2__6_n_0 ;
  wire \input_out_reg[1]_i_1__6_n_0 ;
  wire \input_out_reg[2]_i_1__6_n_0 ;
  wire \input_out_reg[3]_i_1__6_n_0 ;
  wire \input_out_reg[4]_i_1__6_n_0 ;
  wire \input_out_reg[5]_i_1__6_n_0 ;
  wire \input_out_reg[6]_i_1__6_n_0 ;
  wire \input_out_reg[7]_i_1__6_n_0 ;
  wire \input_out_reg[8]_i_1__6_n_0 ;
  wire \input_out_reg[9]_i_1__6_n_0 ;
  wire input_out_valid_mesh_2;
  wire input_out_valid_mesh_7;
  wire input_out_valid_reg;
  wire [15:0]input_reg__0;
  wire [0:0]\input_reg_reg[15]_0 ;
  wire [15:0]\input_reg_reg[15]_1 ;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_0;
  wire [31:0]signed_mac_result__0;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair329" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair324" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair323" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair323" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair322" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair322" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair321" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair321" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair320" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair320" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair319" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair328" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair319" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair318" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair318" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair317" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair317" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair316" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair316" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair315" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair315" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair314" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair328" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair314" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__6_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_2),
        .O(\accumulator[31]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair313" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair327" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair327" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair326" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair326" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair325" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair325" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair324" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__6 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__6_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__6_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__6_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__6_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__6_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__6_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__6_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__6_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__6_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__6_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__6_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__6_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__6_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__6_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__6_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__6_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__6_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__6_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__6_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__6_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__6_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__6_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__6_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__6_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__6_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__6_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__6_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__6_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__6_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__6_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__6_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__6_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__6_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair312" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_17
       (.I0(array_busy_reg_i_4),
        .I1(input_out_valid_mesh_7),
        .I2(input_valid_reg),
        .I3(input_out_valid_mesh_2),
        .O(computing_reg_1));
  (* SOFT_HLUTNM = "soft_lutpair313" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__6
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_2),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair338" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[0]_i_1__6 
       (.I0(input_reg__0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg[0]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair333" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[10]_i_1__6 
       (.I0(input_reg__0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg[10]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair333" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[11]_i_1__6 
       (.I0(input_reg__0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg[11]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair332" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[12]_i_1__6 
       (.I0(input_reg__0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg[12]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair332" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[13]_i_1__6 
       (.I0(input_reg__0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg[13]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair331" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[14]_i_1__6 
       (.I0(input_reg__0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg[14]_i_1__6_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \input_out_reg[15]_i_1__6 
       (.I0(flush_IBUF),
        .I1(input_valid_reg),
        .O(\input_out_reg[15]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair331" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[15]_i_2__6 
       (.I0(input_reg__0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg[15]_i_2__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair338" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[1]_i_1__6 
       (.I0(input_reg__0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg[1]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair337" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[2]_i_1__6 
       (.I0(input_reg__0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg[2]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair337" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[3]_i_1__6 
       (.I0(input_reg__0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg[3]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair336" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[4]_i_1__6 
       (.I0(input_reg__0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg[4]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair336" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[5]_i_1__6 
       (.I0(input_reg__0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg[5]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair335" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[6]_i_1__6 
       (.I0(input_reg__0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg[6]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair335" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[7]_i_1__6 
       (.I0(input_reg__0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg[7]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair334" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[8]_i_1__6 
       (.I0(input_reg__0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg[8]_i_1__6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair334" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[9]_i_1__6 
       (.I0(input_reg__0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg[9]_i_1__6_n_0 ));
  FDCE \input_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[0]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[0]));
  FDCE \input_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[10]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[10]));
  FDCE \input_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[11]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[11]));
  FDCE \input_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[12]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[12]));
  FDCE \input_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[13]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[13]));
  FDCE \input_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[14]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[14]));
  FDCE \input_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[15]_i_2__6_n_0 ),
        .Q(input_out_mesh_112[15]));
  FDCE \input_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[1]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[1]));
  FDCE \input_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[2]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[2]));
  FDCE \input_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[3]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[3]));
  FDCE \input_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[4]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[4]));
  FDCE \input_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[5]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[5]));
  FDCE \input_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[6]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[6]));
  FDCE \input_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[7]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[7]));
  FDCE \input_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[8]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[8]));
  FDCE \input_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__6_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[9]_i_1__6_n_0 ),
        .Q(input_out_mesh_112[9]));
  (* SOFT_HLUTNM = "soft_lutpair330" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__6
       (.I0(input_valid_reg),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_mesh_7));
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__10 
       (.I0(input_out_mesh_112[0]),
        .I1(flush_IBUF),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair341" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__10 
       (.I0(input_out_mesh_112[10]),
        .I1(flush_IBUF),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair340" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__10 
       (.I0(input_out_mesh_112[11]),
        .I1(flush_IBUF),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair340" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__10 
       (.I0(input_out_mesh_112[12]),
        .I1(flush_IBUF),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair339" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__10 
       (.I0(input_out_mesh_112[13]),
        .I1(flush_IBUF),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair339" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__10 
       (.I0(input_out_mesh_112[14]),
        .I1(flush_IBUF),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair329" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__10 
       (.I0(flush_IBUF),
        .I1(input_out_valid_mesh_7),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair330" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__10 
       (.I0(input_out_mesh_112[15]),
        .I1(flush_IBUF),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair345" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__10 
       (.I0(input_out_mesh_112[1]),
        .I1(flush_IBUF),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair345" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__10 
       (.I0(input_out_mesh_112[2]),
        .I1(flush_IBUF),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair344" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__10 
       (.I0(input_out_mesh_112[3]),
        .I1(flush_IBUF),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair344" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__10 
       (.I0(input_out_mesh_112[4]),
        .I1(flush_IBUF),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair343" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__10 
       (.I0(input_out_mesh_112[5]),
        .I1(flush_IBUF),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair343" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__10 
       (.I0(input_out_mesh_112[6]),
        .I1(flush_IBUF),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair342" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__10 
       (.I0(input_out_mesh_112[7]),
        .I1(flush_IBUF),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair342" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__10 
       (.I0(input_out_mesh_112[8]),
        .I1(flush_IBUF),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair341" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__10 
       (.I0(input_out_mesh_112[9]),
        .I1(flush_IBUF),
        .O(D[9]));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [0]),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [10]),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [11]),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [12]),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [13]),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [14]),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [15]),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [1]),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [2]),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [3]),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [4]),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [5]),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [6]),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [7]),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [8]),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [9]),
        .Q(input_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair312" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__10
       (.I0(input_out_valid_mesh_7),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out_0),
        .Q(input_valid_reg));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_7
   (Q,
    input_valid_reg11_out,
    E,
    computing_reg_0,
    input_valid_reg_reg_0,
    D,
    B,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    input_valid_reg11_out_0,
    flush_IBUF,
    array_busy_reg_i_4,
    array_busy_reg_i_4_0,
    input_valid_reg,
    input_valid_reg_1,
    computing_reg_1,
    accumulator_clr_IBUF,
    \input_reg_reg[15]_0 ,
    \input_reg_reg[15]_1 );
  output [31:0]Q;
  output input_valid_reg11_out;
  output [0:0]E;
  output computing_reg_0;
  output input_valid_reg_reg_0;
  output [15:0]D;
  input [15:0]B;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input input_valid_reg11_out_0;
  input flush_IBUF;
  input array_busy_reg_i_4;
  input array_busy_reg_i_4_0;
  input input_valid_reg;
  input input_valid_reg_1;
  input computing_reg_1;
  input accumulator_clr_IBUF;
  input [0:0]\input_reg_reg[15]_0 ;
  input [15:0]\input_reg_reg[15]_1 ;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__7_n_0 ;
  wire \accumulator[10]_i_1__7_n_0 ;
  wire \accumulator[11]_i_1__7_n_0 ;
  wire \accumulator[12]_i_1__7_n_0 ;
  wire \accumulator[13]_i_1__7_n_0 ;
  wire \accumulator[14]_i_1__7_n_0 ;
  wire \accumulator[15]_i_1__7_n_0 ;
  wire \accumulator[16]_i_1__7_n_0 ;
  wire \accumulator[17]_i_1__7_n_0 ;
  wire \accumulator[18]_i_1__7_n_0 ;
  wire \accumulator[19]_i_1__7_n_0 ;
  wire \accumulator[1]_i_1__7_n_0 ;
  wire \accumulator[20]_i_1__7_n_0 ;
  wire \accumulator[21]_i_1__7_n_0 ;
  wire \accumulator[22]_i_1__7_n_0 ;
  wire \accumulator[23]_i_1__7_n_0 ;
  wire \accumulator[24]_i_1__7_n_0 ;
  wire \accumulator[25]_i_1__7_n_0 ;
  wire \accumulator[26]_i_1__7_n_0 ;
  wire \accumulator[27]_i_1__7_n_0 ;
  wire \accumulator[28]_i_1__7_n_0 ;
  wire \accumulator[29]_i_1__7_n_0 ;
  wire \accumulator[2]_i_1__7_n_0 ;
  wire \accumulator[30]_i_1__7_n_0 ;
  wire \accumulator[31]_i_1__7_n_0 ;
  wire \accumulator[31]_i_2__7_n_0 ;
  wire \accumulator[3]_i_1__7_n_0 ;
  wire \accumulator[4]_i_1__7_n_0 ;
  wire \accumulator[5]_i_1__7_n_0 ;
  wire \accumulator[6]_i_1__7_n_0 ;
  wire \accumulator[7]_i_1__7_n_0 ;
  wire \accumulator[8]_i_1__7_n_0 ;
  wire \accumulator[9]_i_1__7_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire array_busy_reg_i_4;
  wire array_busy_reg_i_4_0;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_1;
  wire computing_reg_n_0;
  wire flush_IBUF;
  wire [15:0]input_out_mesh_128;
  wire \input_out_reg[0]_i_1__7_n_0 ;
  wire \input_out_reg[10]_i_1__7_n_0 ;
  wire \input_out_reg[11]_i_1__7_n_0 ;
  wire \input_out_reg[12]_i_1__7_n_0 ;
  wire \input_out_reg[13]_i_1__7_n_0 ;
  wire \input_out_reg[14]_i_1__7_n_0 ;
  wire \input_out_reg[15]_i_1__7_n_0 ;
  wire \input_out_reg[15]_i_2__7_n_0 ;
  wire \input_out_reg[1]_i_1__7_n_0 ;
  wire \input_out_reg[2]_i_1__7_n_0 ;
  wire \input_out_reg[3]_i_1__7_n_0 ;
  wire \input_out_reg[4]_i_1__7_n_0 ;
  wire \input_out_reg[5]_i_1__7_n_0 ;
  wire \input_out_reg[6]_i_1__7_n_0 ;
  wire \input_out_reg[7]_i_1__7_n_0 ;
  wire \input_out_reg[8]_i_1__7_n_0 ;
  wire \input_out_reg[9]_i_1__7_n_0 ;
  wire input_out_valid_mesh_8;
  wire input_out_valid_reg;
  wire [15:0]input_reg__0;
  wire [0:0]\input_reg_reg[15]_0 ;
  wire [15:0]\input_reg_reg[15]_1 ;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_0;
  wire input_valid_reg_0;
  wire input_valid_reg_1;
  wire input_valid_reg_reg_0;
  wire [31:0]signed_mac_result__0;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair363" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair358" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair357" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair357" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair356" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair356" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair355" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair355" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair354" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair354" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair353" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair362" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair353" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair352" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair352" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair351" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair351" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair350" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair350" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair349" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair349" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair348" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair362" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair348" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__7_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg_0),
        .I3(computing_reg_1),
        .O(\accumulator[31]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair347" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair361" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair361" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair360" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair360" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair359" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair359" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair358" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__7 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__7_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__7_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__7_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__7_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__7_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__7_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__7_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__7_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__7_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__7_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__7_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__7_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__7_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__7_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__7_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__7_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__7_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__7_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__7_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__7_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__7_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__7_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__7_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__7_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__7_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__7_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__7_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__7_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__7_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__7_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__7_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__7_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__7_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair346" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_10
       (.I0(input_valid_reg_1),
        .I1(input_valid_reg_0),
        .I2(input_out_valid_mesh_8),
        .I3(computing_reg_1),
        .O(input_valid_reg_reg_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_16
       (.I0(computing_reg_n_0),
        .I1(array_busy_reg_i_4),
        .I2(array_busy_reg_i_4_0),
        .I3(input_valid_reg),
        .O(computing_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair347" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__7
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg_0),
        .I3(computing_reg_1),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair372" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[0]_i_1__7 
       (.I0(input_reg__0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg[0]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair367" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[10]_i_1__7 
       (.I0(input_reg__0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg[10]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair366" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[11]_i_1__7 
       (.I0(input_reg__0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg[11]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair366" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[12]_i_1__7 
       (.I0(input_reg__0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg[12]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair365" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[13]_i_1__7 
       (.I0(input_reg__0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg[13]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair365" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[14]_i_1__7 
       (.I0(input_reg__0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg[14]_i_1__7_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \input_out_reg[15]_i_1__7 
       (.I0(flush_IBUF),
        .I1(input_valid_reg_0),
        .O(\input_out_reg[15]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair364" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[15]_i_2__7 
       (.I0(input_reg__0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg[15]_i_2__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair371" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[1]_i_1__7 
       (.I0(input_reg__0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg[1]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair371" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[2]_i_1__7 
       (.I0(input_reg__0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg[2]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair370" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[3]_i_1__7 
       (.I0(input_reg__0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg[3]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair370" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[4]_i_1__7 
       (.I0(input_reg__0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg[4]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair369" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[5]_i_1__7 
       (.I0(input_reg__0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg[5]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair369" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[6]_i_1__7 
       (.I0(input_reg__0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg[6]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair368" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[7]_i_1__7 
       (.I0(input_reg__0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg[7]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair368" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[8]_i_1__7 
       (.I0(input_reg__0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg[8]_i_1__7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair367" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[9]_i_1__7 
       (.I0(input_reg__0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg[9]_i_1__7_n_0 ));
  FDCE \input_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[0]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[0]));
  FDCE \input_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[10]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[10]));
  FDCE \input_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[11]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[11]));
  FDCE \input_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[12]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[12]));
  FDCE \input_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[13]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[13]));
  FDCE \input_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[14]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[14]));
  FDCE \input_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[15]_i_2__7_n_0 ),
        .Q(input_out_mesh_128[15]));
  FDCE \input_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[1]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[1]));
  FDCE \input_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[2]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[2]));
  FDCE \input_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[3]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[3]));
  FDCE \input_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[4]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[4]));
  FDCE \input_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[5]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[5]));
  FDCE \input_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[6]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[6]));
  FDCE \input_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[7]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[7]));
  FDCE \input_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[8]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[8]));
  FDCE \input_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__7_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[9]_i_1__7_n_0 ),
        .Q(input_out_mesh_128[9]));
  (* SOFT_HLUTNM = "soft_lutpair346" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__7
       (.I0(input_valid_reg_0),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_mesh_8));
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__11 
       (.I0(input_out_mesh_128[0]),
        .I1(flush_IBUF),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair375" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__11 
       (.I0(input_out_mesh_128[10]),
        .I1(flush_IBUF),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair374" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__11 
       (.I0(input_out_mesh_128[11]),
        .I1(flush_IBUF),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair374" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__11 
       (.I0(input_out_mesh_128[12]),
        .I1(flush_IBUF),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair373" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__11 
       (.I0(input_out_mesh_128[13]),
        .I1(flush_IBUF),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair373" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__11 
       (.I0(input_out_mesh_128[14]),
        .I1(flush_IBUF),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair364" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__11 
       (.I0(flush_IBUF),
        .I1(input_out_valid_mesh_8),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair372" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__11 
       (.I0(input_out_mesh_128[15]),
        .I1(flush_IBUF),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair379" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__11 
       (.I0(input_out_mesh_128[1]),
        .I1(flush_IBUF),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair379" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__11 
       (.I0(input_out_mesh_128[2]),
        .I1(flush_IBUF),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair378" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__11 
       (.I0(input_out_mesh_128[3]),
        .I1(flush_IBUF),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair378" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__11 
       (.I0(input_out_mesh_128[4]),
        .I1(flush_IBUF),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair377" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__11 
       (.I0(input_out_mesh_128[5]),
        .I1(flush_IBUF),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair377" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__11 
       (.I0(input_out_mesh_128[6]),
        .I1(flush_IBUF),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair376" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__11 
       (.I0(input_out_mesh_128[7]),
        .I1(flush_IBUF),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair376" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__11 
       (.I0(input_out_mesh_128[8]),
        .I1(flush_IBUF),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair375" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__11 
       (.I0(input_out_mesh_128[9]),
        .I1(flush_IBUF),
        .O(D[9]));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [0]),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [10]),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [11]),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [12]),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [13]),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [14]),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [15]),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [1]),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [2]),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [3]),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [4]),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [5]),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [6]),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [7]),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [8]),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [9]),
        .Q(input_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair363" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__11
       (.I0(input_out_valid_mesh_8),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out_0),
        .Q(input_valid_reg_0));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_8
   (Q,
    input_valid_reg,
    input_valid_reg11_out,
    E,
    computing_reg_0,
    D,
    B,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    input_valid_reg11_out_0,
    flush_IBUF,
    array_busy_reg_reg,
    array_busy_reg_reg_0,
    array_busy_reg_reg_1,
    computing_reg_1,
    input_out_valid_mesh_10,
    accumulator_clr_IBUF,
    \input_reg_reg[15]_0 ,
    \input_reg_reg[15]_1 );
  output [31:0]Q;
  output input_valid_reg;
  output input_valid_reg11_out;
  output [0:0]E;
  output computing_reg_0;
  output [15:0]D;
  input [15:0]B;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input input_valid_reg11_out_0;
  input flush_IBUF;
  input array_busy_reg_reg;
  input array_busy_reg_reg_0;
  input array_busy_reg_reg_1;
  input computing_reg_1;
  input input_out_valid_mesh_10;
  input accumulator_clr_IBUF;
  input [0:0]\input_reg_reg[15]_0 ;
  input [15:0]\input_reg_reg[15]_1 ;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__8_n_0 ;
  wire \accumulator[10]_i_1__8_n_0 ;
  wire \accumulator[11]_i_1__8_n_0 ;
  wire \accumulator[12]_i_1__8_n_0 ;
  wire \accumulator[13]_i_1__8_n_0 ;
  wire \accumulator[14]_i_1__8_n_0 ;
  wire \accumulator[15]_i_1__8_n_0 ;
  wire \accumulator[16]_i_1__8_n_0 ;
  wire \accumulator[17]_i_1__8_n_0 ;
  wire \accumulator[18]_i_1__8_n_0 ;
  wire \accumulator[19]_i_1__8_n_0 ;
  wire \accumulator[1]_i_1__8_n_0 ;
  wire \accumulator[20]_i_1__8_n_0 ;
  wire \accumulator[21]_i_1__8_n_0 ;
  wire \accumulator[22]_i_1__8_n_0 ;
  wire \accumulator[23]_i_1__8_n_0 ;
  wire \accumulator[24]_i_1__8_n_0 ;
  wire \accumulator[25]_i_1__8_n_0 ;
  wire \accumulator[26]_i_1__8_n_0 ;
  wire \accumulator[27]_i_1__8_n_0 ;
  wire \accumulator[28]_i_1__8_n_0 ;
  wire \accumulator[29]_i_1__8_n_0 ;
  wire \accumulator[2]_i_1__8_n_0 ;
  wire \accumulator[30]_i_1__8_n_0 ;
  wire \accumulator[31]_i_1__8_n_0 ;
  wire \accumulator[31]_i_2__8_n_0 ;
  wire \accumulator[3]_i_1__8_n_0 ;
  wire \accumulator[4]_i_1__8_n_0 ;
  wire \accumulator[5]_i_1__8_n_0 ;
  wire \accumulator[6]_i_1__8_n_0 ;
  wire \accumulator[7]_i_1__8_n_0 ;
  wire \accumulator[8]_i_1__8_n_0 ;
  wire \accumulator[9]_i_1__8_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire array_busy_reg_i_15_n_0;
  wire array_busy_reg_reg;
  wire array_busy_reg_reg_0;
  wire array_busy_reg_reg_1;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_1;
  wire computing_reg_n_0;
  wire flush_IBUF;
  wire [15:0]input_out_mesh_144;
  wire \input_out_reg[0]_i_1__8_n_0 ;
  wire \input_out_reg[10]_i_1__8_n_0 ;
  wire \input_out_reg[11]_i_1__8_n_0 ;
  wire \input_out_reg[12]_i_1__8_n_0 ;
  wire \input_out_reg[13]_i_1__8_n_0 ;
  wire \input_out_reg[14]_i_1__8_n_0 ;
  wire \input_out_reg[15]_i_1__8_n_0 ;
  wire \input_out_reg[15]_i_2__8_n_0 ;
  wire \input_out_reg[1]_i_1__8_n_0 ;
  wire \input_out_reg[2]_i_1__8_n_0 ;
  wire \input_out_reg[3]_i_1__8_n_0 ;
  wire \input_out_reg[4]_i_1__8_n_0 ;
  wire \input_out_reg[5]_i_1__8_n_0 ;
  wire \input_out_reg[6]_i_1__8_n_0 ;
  wire \input_out_reg[7]_i_1__8_n_0 ;
  wire \input_out_reg[8]_i_1__8_n_0 ;
  wire \input_out_reg[9]_i_1__8_n_0 ;
  wire input_out_valid_mesh_10;
  wire input_out_valid_mesh_9;
  wire input_out_valid_reg;
  wire [15:0]input_reg__0;
  wire [0:0]\input_reg_reg[15]_0 ;
  wire [15:0]\input_reg_reg[15]_1 ;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_0;
  wire [31:0]signed_mac_result__0;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair397" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair392" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair391" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair391" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair390" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair390" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair389" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair389" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair388" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair388" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair387" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair396" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair387" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair386" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair386" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair385" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair385" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair384" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair384" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair383" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair383" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair382" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair396" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair382" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__8_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(\accumulator[31]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair381" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair395" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair395" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair394" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair394" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair393" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair393" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair392" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__8 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__8_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__8_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__8_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__8_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__8_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__8_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__8_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__8_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__8_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__8_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__8_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__8_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__8_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__8_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__8_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__8_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__8_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__8_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__8_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__8_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__8_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__8_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__8_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__8_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__8_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__8_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__8_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__8_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__8_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__8_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__8_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__8_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__8_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair380" *) 
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_15
       (.I0(computing_reg_n_0),
        .I1(computing_reg_1),
        .I2(input_out_valid_mesh_10),
        .I3(input_out_valid_mesh_9),
        .O(array_busy_reg_i_15_n_0));
  LUT4 #(
    .INIT(16'hFFFE)) 
    array_busy_reg_i_4
       (.I0(array_busy_reg_i_15_n_0),
        .I1(array_busy_reg_reg),
        .I2(array_busy_reg_reg_0),
        .I3(array_busy_reg_reg_1),
        .O(computing_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair381" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__8
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_n_0));
  (* SOFT_HLUTNM = "soft_lutpair406" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[0]_i_1__8 
       (.I0(input_reg__0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg[0]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair401" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[10]_i_1__8 
       (.I0(input_reg__0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg[10]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair401" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[11]_i_1__8 
       (.I0(input_reg__0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg[11]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair400" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[12]_i_1__8 
       (.I0(input_reg__0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg[12]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair400" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[13]_i_1__8 
       (.I0(input_reg__0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg[13]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair399" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[14]_i_1__8 
       (.I0(input_reg__0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg[14]_i_1__8_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \input_out_reg[15]_i_1__8 
       (.I0(flush_IBUF),
        .I1(input_valid_reg),
        .O(\input_out_reg[15]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair399" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[15]_i_2__8 
       (.I0(input_reg__0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg[15]_i_2__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair406" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[1]_i_1__8 
       (.I0(input_reg__0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg[1]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair405" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[2]_i_1__8 
       (.I0(input_reg__0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg[2]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair405" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[3]_i_1__8 
       (.I0(input_reg__0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg[3]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair404" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[4]_i_1__8 
       (.I0(input_reg__0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg[4]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair404" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[5]_i_1__8 
       (.I0(input_reg__0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg[5]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair403" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[6]_i_1__8 
       (.I0(input_reg__0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg[6]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair403" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[7]_i_1__8 
       (.I0(input_reg__0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg[7]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair402" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[8]_i_1__8 
       (.I0(input_reg__0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg[8]_i_1__8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair402" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[9]_i_1__8 
       (.I0(input_reg__0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg[9]_i_1__8_n_0 ));
  FDCE \input_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[0]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[0]));
  FDCE \input_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[10]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[10]));
  FDCE \input_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[11]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[11]));
  FDCE \input_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[12]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[12]));
  FDCE \input_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[13]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[13]));
  FDCE \input_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[14]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[14]));
  FDCE \input_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[15]_i_2__8_n_0 ),
        .Q(input_out_mesh_144[15]));
  FDCE \input_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[1]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[1]));
  FDCE \input_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[2]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[2]));
  FDCE \input_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[3]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[3]));
  FDCE \input_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[4]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[4]));
  FDCE \input_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[5]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[5]));
  FDCE \input_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[6]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[6]));
  FDCE \input_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[7]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[7]));
  FDCE \input_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[8]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[8]));
  FDCE \input_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__8_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[9]_i_1__8_n_0 ),
        .Q(input_out_mesh_144[9]));
  (* SOFT_HLUTNM = "soft_lutpair398" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__8
       (.I0(input_valid_reg),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_mesh_9));
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__12 
       (.I0(input_out_mesh_144[0]),
        .I1(flush_IBUF),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair409" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__12 
       (.I0(input_out_mesh_144[10]),
        .I1(flush_IBUF),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair408" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__12 
       (.I0(input_out_mesh_144[11]),
        .I1(flush_IBUF),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair408" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__12 
       (.I0(input_out_mesh_144[12]),
        .I1(flush_IBUF),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair407" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__12 
       (.I0(input_out_mesh_144[13]),
        .I1(flush_IBUF),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair407" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__12 
       (.I0(input_out_mesh_144[14]),
        .I1(flush_IBUF),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair397" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__12 
       (.I0(flush_IBUF),
        .I1(input_out_valid_mesh_9),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair398" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__12 
       (.I0(input_out_mesh_144[15]),
        .I1(flush_IBUF),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair413" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__12 
       (.I0(input_out_mesh_144[1]),
        .I1(flush_IBUF),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair413" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__12 
       (.I0(input_out_mesh_144[2]),
        .I1(flush_IBUF),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair412" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__12 
       (.I0(input_out_mesh_144[3]),
        .I1(flush_IBUF),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair412" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__12 
       (.I0(input_out_mesh_144[4]),
        .I1(flush_IBUF),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair411" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__12 
       (.I0(input_out_mesh_144[5]),
        .I1(flush_IBUF),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair411" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__12 
       (.I0(input_out_mesh_144[6]),
        .I1(flush_IBUF),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair410" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__12 
       (.I0(input_out_mesh_144[7]),
        .I1(flush_IBUF),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair410" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__12 
       (.I0(input_out_mesh_144[8]),
        .I1(flush_IBUF),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair409" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__12 
       (.I0(input_out_mesh_144[9]),
        .I1(flush_IBUF),
        .O(D[9]));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [0]),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [10]),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [11]),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [12]),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [13]),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [14]),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [15]),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [1]),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [2]),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [3]),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [4]),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [5]),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [6]),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [7]),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [8]),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [9]),
        .Q(input_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair380" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__12
       (.I0(input_out_valid_mesh_9),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out_0),
        .Q(input_valid_reg));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
endmodule

(* ORIG_REF_NAME = "os_pe" *) 
module os_pe_9
   (Q,
    computing_reg_0,
    input_valid_reg,
    input_out_valid_mesh_10,
    input_valid_reg11_out,
    E,
    D,
    B,
    clk_IBUF_BUFG,
    \accumulator_reg[0]_0 ,
    input_valid_reg11_out_0,
    flush_IBUF,
    accumulator_clr_IBUF,
    computing_reg_1,
    \input_reg_reg[15]_0 ,
    \input_reg_reg[15]_1 );
  output [31:0]Q;
  output computing_reg_0;
  output input_valid_reg;
  output input_out_valid_mesh_10;
  output input_valid_reg11_out;
  output [0:0]E;
  output [15:0]D;
  input [15:0]B;
  input clk_IBUF_BUFG;
  input \accumulator_reg[0]_0 ;
  input input_valid_reg11_out_0;
  input flush_IBUF;
  input accumulator_clr_IBUF;
  input computing_reg_1;
  input [0:0]\input_reg_reg[15]_0 ;
  input [15:0]\input_reg_reg[15]_1 ;

  wire \<const0> ;
  wire \<const1> ;
  wire [15:0]B;
  wire [15:0]D;
  wire [0:0]E;
  wire GND_2;
  wire [31:0]Q;
  wire \accumulator[0]_i_1__9_n_0 ;
  wire \accumulator[10]_i_1__9_n_0 ;
  wire \accumulator[11]_i_1__9_n_0 ;
  wire \accumulator[12]_i_1__9_n_0 ;
  wire \accumulator[13]_i_1__9_n_0 ;
  wire \accumulator[14]_i_1__9_n_0 ;
  wire \accumulator[15]_i_1__9_n_0 ;
  wire \accumulator[16]_i_1__9_n_0 ;
  wire \accumulator[17]_i_1__9_n_0 ;
  wire \accumulator[18]_i_1__9_n_0 ;
  wire \accumulator[19]_i_1__9_n_0 ;
  wire \accumulator[1]_i_1__9_n_0 ;
  wire \accumulator[20]_i_1__9_n_0 ;
  wire \accumulator[21]_i_1__9_n_0 ;
  wire \accumulator[22]_i_1__9_n_0 ;
  wire \accumulator[23]_i_1__9_n_0 ;
  wire \accumulator[24]_i_1__9_n_0 ;
  wire \accumulator[25]_i_1__9_n_0 ;
  wire \accumulator[26]_i_1__9_n_0 ;
  wire \accumulator[27]_i_1__9_n_0 ;
  wire \accumulator[28]_i_1__9_n_0 ;
  wire \accumulator[29]_i_1__9_n_0 ;
  wire \accumulator[2]_i_1__9_n_0 ;
  wire \accumulator[30]_i_1__9_n_0 ;
  wire \accumulator[31]_i_1__9_n_0 ;
  wire \accumulator[31]_i_2__9_n_0 ;
  wire \accumulator[3]_i_1__9_n_0 ;
  wire \accumulator[4]_i_1__9_n_0 ;
  wire \accumulator[5]_i_1__9_n_0 ;
  wire \accumulator[6]_i_1__9_n_0 ;
  wire \accumulator[7]_i_1__9_n_0 ;
  wire \accumulator[8]_i_1__9_n_0 ;
  wire \accumulator[9]_i_1__9_n_0 ;
  wire accumulator_clr_IBUF;
  wire \accumulator_reg[0]_0 ;
  wire accumulator_valid_reg4_out;
  wire clk_IBUF_BUFG;
  wire computing_reg_0;
  wire computing_reg_1;
  wire flush_IBUF;
  wire [15:0]input_out_mesh_160;
  wire \input_out_reg[0]_i_1__9_n_0 ;
  wire \input_out_reg[10]_i_1__9_n_0 ;
  wire \input_out_reg[11]_i_1__9_n_0 ;
  wire \input_out_reg[12]_i_1__9_n_0 ;
  wire \input_out_reg[13]_i_1__9_n_0 ;
  wire \input_out_reg[14]_i_1__9_n_0 ;
  wire \input_out_reg[15]_i_1__9_n_0 ;
  wire \input_out_reg[15]_i_2__9_n_0 ;
  wire \input_out_reg[1]_i_1__9_n_0 ;
  wire \input_out_reg[2]_i_1__9_n_0 ;
  wire \input_out_reg[3]_i_1__9_n_0 ;
  wire \input_out_reg[4]_i_1__9_n_0 ;
  wire \input_out_reg[5]_i_1__9_n_0 ;
  wire \input_out_reg[6]_i_1__9_n_0 ;
  wire \input_out_reg[7]_i_1__9_n_0 ;
  wire \input_out_reg[8]_i_1__9_n_0 ;
  wire \input_out_reg[9]_i_1__9_n_0 ;
  wire input_out_valid_mesh_10;
  wire input_out_valid_reg;
  wire [15:0]input_reg__0;
  wire [0:0]\input_reg_reg[15]_0 ;
  wire [15:0]\input_reg_reg[15]_1 ;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_0;
  wire [31:0]signed_mac_result__0;

  GND GND
       (.G(\<const0> ));
  GND GND_1
       (.G(GND_2));
  VCC VCC
       (.P(\<const1> ));
  (* SOFT_HLUTNM = "soft_lutpair430" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[0]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[0]),
        .O(\accumulator[0]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair425" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[10]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[10]),
        .O(\accumulator[10]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair424" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[11]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[11]),
        .O(\accumulator[11]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair424" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[12]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[12]),
        .O(\accumulator[12]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair423" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[13]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[13]),
        .O(\accumulator[13]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair423" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[14]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[14]),
        .O(\accumulator[14]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair422" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[15]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[15]),
        .O(\accumulator[15]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair422" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[16]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[16]),
        .O(\accumulator[16]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair421" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[17]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[17]),
        .O(\accumulator[17]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair421" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[18]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[18]),
        .O(\accumulator[18]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair420" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[19]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[19]),
        .O(\accumulator[19]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair429" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[1]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[1]),
        .O(\accumulator[1]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair420" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[20]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[20]),
        .O(\accumulator[20]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair419" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[21]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[21]),
        .O(\accumulator[21]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair419" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[22]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[22]),
        .O(\accumulator[22]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair418" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[23]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[23]),
        .O(\accumulator[23]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair418" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[24]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[24]),
        .O(\accumulator[24]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair417" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[25]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[25]),
        .O(\accumulator[25]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair417" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[26]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[26]),
        .O(\accumulator[26]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair416" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[27]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[27]),
        .O(\accumulator[27]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair416" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[28]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[28]),
        .O(\accumulator[28]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair415" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[29]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[29]),
        .O(\accumulator[29]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair429" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[2]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[2]),
        .O(\accumulator[2]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair415" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[30]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[30]),
        .O(\accumulator[30]_i_1__9_n_0 ));
  LUT4 #(
    .INIT(16'hFEEE)) 
    \accumulator[31]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(\accumulator[31]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair414" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[31]_i_2__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[31]),
        .O(\accumulator[31]_i_2__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair428" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[3]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[3]),
        .O(\accumulator[3]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair428" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[4]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[4]),
        .O(\accumulator[4]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair427" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[5]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[5]),
        .O(\accumulator[5]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair427" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[6]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[6]),
        .O(\accumulator[6]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair426" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[7]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[7]),
        .O(\accumulator[7]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair426" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[8]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[8]),
        .O(\accumulator[8]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair425" *) 
  LUT3 #(
    .INIT(8'h10)) 
    \accumulator[9]_i_1__9 
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(signed_mac_result__0[9]),
        .O(\accumulator[9]_i_1__9_n_0 ));
  FDCE \accumulator_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[0]_i_1__9_n_0 ),
        .Q(Q[0]));
  FDCE \accumulator_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[10]_i_1__9_n_0 ),
        .Q(Q[10]));
  FDCE \accumulator_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[11]_i_1__9_n_0 ),
        .Q(Q[11]));
  FDCE \accumulator_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[12]_i_1__9_n_0 ),
        .Q(Q[12]));
  FDCE \accumulator_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[13]_i_1__9_n_0 ),
        .Q(Q[13]));
  FDCE \accumulator_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[14]_i_1__9_n_0 ),
        .Q(Q[14]));
  FDCE \accumulator_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[15]_i_1__9_n_0 ),
        .Q(Q[15]));
  FDCE \accumulator_reg[16] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[16]_i_1__9_n_0 ),
        .Q(Q[16]));
  FDCE \accumulator_reg[17] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[17]_i_1__9_n_0 ),
        .Q(Q[17]));
  FDCE \accumulator_reg[18] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[18]_i_1__9_n_0 ),
        .Q(Q[18]));
  FDCE \accumulator_reg[19] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[19]_i_1__9_n_0 ),
        .Q(Q[19]));
  FDCE \accumulator_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[1]_i_1__9_n_0 ),
        .Q(Q[1]));
  FDCE \accumulator_reg[20] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[20]_i_1__9_n_0 ),
        .Q(Q[20]));
  FDCE \accumulator_reg[21] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[21]_i_1__9_n_0 ),
        .Q(Q[21]));
  FDCE \accumulator_reg[22] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[22]_i_1__9_n_0 ),
        .Q(Q[22]));
  FDCE \accumulator_reg[23] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[23]_i_1__9_n_0 ),
        .Q(Q[23]));
  FDCE \accumulator_reg[24] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[24]_i_1__9_n_0 ),
        .Q(Q[24]));
  FDCE \accumulator_reg[25] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[25]_i_1__9_n_0 ),
        .Q(Q[25]));
  FDCE \accumulator_reg[26] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[26]_i_1__9_n_0 ),
        .Q(Q[26]));
  FDCE \accumulator_reg[27] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[27]_i_1__9_n_0 ),
        .Q(Q[27]));
  FDCE \accumulator_reg[28] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[28]_i_1__9_n_0 ),
        .Q(Q[28]));
  FDCE \accumulator_reg[29] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[29]_i_1__9_n_0 ),
        .Q(Q[29]));
  FDCE \accumulator_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[2]_i_1__9_n_0 ),
        .Q(Q[2]));
  FDCE \accumulator_reg[30] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[30]_i_1__9_n_0 ),
        .Q(Q[30]));
  FDCE \accumulator_reg[31] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[31]_i_2__9_n_0 ),
        .Q(Q[31]));
  FDCE \accumulator_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[3]_i_1__9_n_0 ),
        .Q(Q[3]));
  FDCE \accumulator_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[4]_i_1__9_n_0 ),
        .Q(Q[4]));
  FDCE \accumulator_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[5]_i_1__9_n_0 ),
        .Q(Q[5]));
  FDCE \accumulator_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[6]_i_1__9_n_0 ),
        .Q(Q[6]));
  FDCE \accumulator_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[7]_i_1__9_n_0 ),
        .Q(Q[7]));
  FDCE \accumulator_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[8]_i_1__9_n_0 ),
        .Q(Q[8]));
  FDCE \accumulator_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\accumulator[9]_i_1__9_n_0 ),
        .Q(Q[9]));
  (* SOFT_HLUTNM = "soft_lutpair414" *) 
  LUT4 #(
    .INIT(16'h1000)) 
    computing_i_1__9
       (.I0(flush_IBUF),
        .I1(accumulator_clr_IBUF),
        .I2(input_valid_reg),
        .I3(computing_reg_1),
        .O(accumulator_valid_reg4_out));
  FDCE computing_reg
       (.C(clk_IBUF_BUFG),
        .CE(\accumulator[31]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(accumulator_valid_reg4_out),
        .Q(computing_reg_0));
  (* SOFT_HLUTNM = "soft_lutpair439" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[0]_i_1__9 
       (.I0(input_reg__0[0]),
        .I1(flush_IBUF),
        .O(\input_out_reg[0]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair434" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[10]_i_1__9 
       (.I0(input_reg__0[10]),
        .I1(flush_IBUF),
        .O(\input_out_reg[10]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair434" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[11]_i_1__9 
       (.I0(input_reg__0[11]),
        .I1(flush_IBUF),
        .O(\input_out_reg[11]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair433" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[12]_i_1__9 
       (.I0(input_reg__0[12]),
        .I1(flush_IBUF),
        .O(\input_out_reg[12]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair433" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[13]_i_1__9 
       (.I0(input_reg__0[13]),
        .I1(flush_IBUF),
        .O(\input_out_reg[13]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair432" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[14]_i_1__9 
       (.I0(input_reg__0[14]),
        .I1(flush_IBUF),
        .O(\input_out_reg[14]_i_1__9_n_0 ));
  LUT2 #(
    .INIT(4'hE)) 
    \input_out_reg[15]_i_1__9 
       (.I0(flush_IBUF),
        .I1(input_valid_reg),
        .O(\input_out_reg[15]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair432" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[15]_i_2__9 
       (.I0(input_reg__0[15]),
        .I1(flush_IBUF),
        .O(\input_out_reg[15]_i_2__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair439" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[1]_i_1__9 
       (.I0(input_reg__0[1]),
        .I1(flush_IBUF),
        .O(\input_out_reg[1]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair438" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[2]_i_1__9 
       (.I0(input_reg__0[2]),
        .I1(flush_IBUF),
        .O(\input_out_reg[2]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair438" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[3]_i_1__9 
       (.I0(input_reg__0[3]),
        .I1(flush_IBUF),
        .O(\input_out_reg[3]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair437" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[4]_i_1__9 
       (.I0(input_reg__0[4]),
        .I1(flush_IBUF),
        .O(\input_out_reg[4]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair437" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[5]_i_1__9 
       (.I0(input_reg__0[5]),
        .I1(flush_IBUF),
        .O(\input_out_reg[5]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair436" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[6]_i_1__9 
       (.I0(input_reg__0[6]),
        .I1(flush_IBUF),
        .O(\input_out_reg[6]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair436" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[7]_i_1__9 
       (.I0(input_reg__0[7]),
        .I1(flush_IBUF),
        .O(\input_out_reg[7]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair435" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[8]_i_1__9 
       (.I0(input_reg__0[8]),
        .I1(flush_IBUF),
        .O(\input_out_reg[8]_i_1__9_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair435" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_out_reg[9]_i_1__9 
       (.I0(input_reg__0[9]),
        .I1(flush_IBUF),
        .O(\input_out_reg[9]_i_1__9_n_0 ));
  FDCE \input_out_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[0]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[0]));
  FDCE \input_out_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[10]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[10]));
  FDCE \input_out_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[11]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[11]));
  FDCE \input_out_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[12]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[12]));
  FDCE \input_out_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[13]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[13]));
  FDCE \input_out_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[14]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[14]));
  FDCE \input_out_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[15]_i_2__9_n_0 ),
        .Q(input_out_mesh_160[15]));
  FDCE \input_out_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[1]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[1]));
  FDCE \input_out_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[2]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[2]));
  FDCE \input_out_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[3]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[3]));
  FDCE \input_out_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[4]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[4]));
  FDCE \input_out_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[5]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[5]));
  FDCE \input_out_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[6]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[6]));
  FDCE \input_out_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[7]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[7]));
  FDCE \input_out_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[8]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[8]));
  FDCE \input_out_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_out_reg[15]_i_1__9_n_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_out_reg[9]_i_1__9_n_0 ),
        .Q(input_out_mesh_160[9]));
  (* SOFT_HLUTNM = "soft_lutpair431" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_out_valid_reg_i_1__9
       (.I0(input_valid_reg),
        .I1(flush_IBUF),
        .O(input_out_valid_reg));
  FDCE input_out_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_out_valid_reg),
        .Q(input_out_valid_mesh_10));
  (* SOFT_HLUTNM = "soft_lutpair447" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[0]_i_1__13 
       (.I0(input_out_mesh_160[0]),
        .I1(flush_IBUF),
        .O(D[0]));
  (* SOFT_HLUTNM = "soft_lutpair442" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[10]_i_1__13 
       (.I0(input_out_mesh_160[10]),
        .I1(flush_IBUF),
        .O(D[10]));
  (* SOFT_HLUTNM = "soft_lutpair442" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[11]_i_1__13 
       (.I0(input_out_mesh_160[11]),
        .I1(flush_IBUF),
        .O(D[11]));
  (* SOFT_HLUTNM = "soft_lutpair441" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[12]_i_1__13 
       (.I0(input_out_mesh_160[12]),
        .I1(flush_IBUF),
        .O(D[12]));
  (* SOFT_HLUTNM = "soft_lutpair441" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[13]_i_1__13 
       (.I0(input_out_mesh_160[13]),
        .I1(flush_IBUF),
        .O(D[13]));
  (* SOFT_HLUTNM = "soft_lutpair440" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[14]_i_1__13 
       (.I0(input_out_mesh_160[14]),
        .I1(flush_IBUF),
        .O(D[14]));
  (* SOFT_HLUTNM = "soft_lutpair431" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \input_reg[15]_i_1__13 
       (.I0(flush_IBUF),
        .I1(input_out_valid_mesh_10),
        .O(E));
  (* SOFT_HLUTNM = "soft_lutpair440" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[15]_i_2__13 
       (.I0(input_out_mesh_160[15]),
        .I1(flush_IBUF),
        .O(D[15]));
  (* SOFT_HLUTNM = "soft_lutpair447" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[1]_i_1__13 
       (.I0(input_out_mesh_160[1]),
        .I1(flush_IBUF),
        .O(D[1]));
  (* SOFT_HLUTNM = "soft_lutpair446" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[2]_i_1__13 
       (.I0(input_out_mesh_160[2]),
        .I1(flush_IBUF),
        .O(D[2]));
  (* SOFT_HLUTNM = "soft_lutpair446" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[3]_i_1__13 
       (.I0(input_out_mesh_160[3]),
        .I1(flush_IBUF),
        .O(D[3]));
  (* SOFT_HLUTNM = "soft_lutpair445" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[4]_i_1__13 
       (.I0(input_out_mesh_160[4]),
        .I1(flush_IBUF),
        .O(D[4]));
  (* SOFT_HLUTNM = "soft_lutpair445" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[5]_i_1__13 
       (.I0(input_out_mesh_160[5]),
        .I1(flush_IBUF),
        .O(D[5]));
  (* SOFT_HLUTNM = "soft_lutpair444" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[6]_i_1__13 
       (.I0(input_out_mesh_160[6]),
        .I1(flush_IBUF),
        .O(D[6]));
  (* SOFT_HLUTNM = "soft_lutpair444" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[7]_i_1__13 
       (.I0(input_out_mesh_160[7]),
        .I1(flush_IBUF),
        .O(D[7]));
  (* SOFT_HLUTNM = "soft_lutpair443" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[8]_i_1__13 
       (.I0(input_out_mesh_160[8]),
        .I1(flush_IBUF),
        .O(D[8]));
  (* SOFT_HLUTNM = "soft_lutpair443" *) 
  LUT2 #(
    .INIT(4'h2)) 
    \input_reg[9]_i_1__13 
       (.I0(input_out_mesh_160[9]),
        .I1(flush_IBUF),
        .O(D[9]));
  FDCE \input_reg_reg[0] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [0]),
        .Q(input_reg__0[0]));
  FDCE \input_reg_reg[10] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [10]),
        .Q(input_reg__0[10]));
  FDCE \input_reg_reg[11] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [11]),
        .Q(input_reg__0[11]));
  FDCE \input_reg_reg[12] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [12]),
        .Q(input_reg__0[12]));
  FDCE \input_reg_reg[13] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [13]),
        .Q(input_reg__0[13]));
  FDCE \input_reg_reg[14] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [14]),
        .Q(input_reg__0[14]));
  FDCE \input_reg_reg[15] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [15]),
        .Q(input_reg__0[15]));
  FDCE \input_reg_reg[1] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [1]),
        .Q(input_reg__0[1]));
  FDCE \input_reg_reg[2] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [2]),
        .Q(input_reg__0[2]));
  FDCE \input_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [3]),
        .Q(input_reg__0[3]));
  FDCE \input_reg_reg[4] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [4]),
        .Q(input_reg__0[4]));
  FDCE \input_reg_reg[5] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [5]),
        .Q(input_reg__0[5]));
  FDCE \input_reg_reg[6] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [6]),
        .Q(input_reg__0[6]));
  FDCE \input_reg_reg[7] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [7]),
        .Q(input_reg__0[7]));
  FDCE \input_reg_reg[8] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [8]),
        .Q(input_reg__0[8]));
  FDCE \input_reg_reg[9] 
       (.C(clk_IBUF_BUFG),
        .CE(\input_reg_reg[15]_0 ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(\input_reg_reg[15]_1 [9]),
        .Q(input_reg__0[9]));
  (* SOFT_HLUTNM = "soft_lutpair430" *) 
  LUT2 #(
    .INIT(4'h2)) 
    input_valid_reg_i_1__13
       (.I0(input_out_valid_mesh_10),
        .I1(flush_IBUF),
        .O(input_valid_reg11_out));
  FDCE input_valid_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\accumulator_reg[0]_0 ),
        .D(input_valid_reg11_out_0),
        .Q(input_valid_reg));
  (* METHODOLOGY_DRC_VIOS = "{SYNTH-13 {cell *THIS*}}" *) 
  DSP48E1 #(
    .ACASCREG(0),
    .ADREG(1),
    .ALUMODEREG(0),
    .AREG(0),
    .AUTORESET_PATDET("NO_RESET"),
    .A_INPUT("DIRECT"),
    .BCASCREG(0),
    .BREG(0),
    .B_INPUT("DIRECT"),
    .CARRYINREG(0),
    .CARRYINSELREG(0),
    .CREG(0),
    .DREG(1),
    .INMODEREG(0),
    .MASK(48'h3FFFFFFFFFFF),
    .MREG(0),
    .OPMODEREG(0),
    .PATTERN(48'h000000000000),
    .PREG(0),
    .SEL_MASK("MASK"),
    .SEL_PATTERN("PATTERN"),
    .USE_DPORT("FALSE"),
    .USE_MULT("MULTIPLY"),
    .USE_PATTERN_DETECT("NO_PATDET"),
    .USE_SIMD("ONE48")) 
    signed_mac_result
       (.A({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,input_reg__0}),
        .ACIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .ALUMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .B({\<const0> ,\<const0> ,B}),
        .BCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .C({Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q[31],Q}),
        .CARRYCASCIN(\<const0> ),
        .CARRYIN(\<const0> ),
        .CARRYINSEL({\<const0> ,\<const0> ,\<const0> }),
        .CEA1(\<const0> ),
        .CEA2(\<const0> ),
        .CEAD(\<const0> ),
        .CEALUMODE(\<const0> ),
        .CEB1(\<const0> ),
        .CEB2(\<const0> ),
        .CEC(\<const0> ),
        .CECARRYIN(\<const0> ),
        .CECTRL(\<const0> ),
        .CED(\<const0> ),
        .CEINMODE(\<const0> ),
        .CEM(\<const0> ),
        .CEP(\<const0> ),
        .CLK(\<const0> ),
        .D({GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2,GND_2}),
        .INMODE({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .MULTSIGNIN(\<const0> ),
        .OPMODE({\<const0> ,\<const1> ,\<const1> ,\<const0> ,\<const1> ,\<const0> ,\<const1> }),
        .P(signed_mac_result__0),
        .PCIN({\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> ,\<const0> }),
        .RSTA(\<const0> ),
        .RSTALLCARRYIN(\<const0> ),
        .RSTALUMODE(\<const0> ),
        .RSTB(\<const0> ),
        .RSTC(\<const0> ),
        .RSTCTRL(\<const0> ),
        .RSTD(\<const0> ),
        .RSTINMODE(\<const0> ),
        .RSTM(\<const0> ),
        .RSTP(\<const0> ));
endmodule

(* ACC_WIDTH = "32" *) (* ARRAY_SIZE = "4" *) (* DATA_WIDTH = "16" *) 
(* WEIGHT_WIDTH = "16" *) 
(* STRUCTURAL_NETLIST = "yes" *)
module systolic_array_os_4x4
   (clk,
    rst_n,
    input_in,
    input_valid,
    input_ready,
    weight_in,
    weight_valid,
    weight_ready,
    output_read,
    output_data,
    output_valid,
    accumulator_clr,
    flush,
    clk_enable,
    busy);
  input clk;
  input rst_n;
  input [63:0]input_in;
  input [3:0]input_valid;
  output [3:0]input_ready;
  input [15:0]weight_in;
  input weight_valid;
  output weight_ready;
  input output_read;
  output [511:0]output_data;
  output [15:0]output_valid;
  input accumulator_clr;
  input flush;
  input clk_enable;
  output busy;

  wire \<const0> ;
  wire \<const1> ;
  wire accumulator_clr;
  wire accumulator_clr_IBUF;
  wire array_busy_reg_reg_n_0;
  wire busy;
  wire busy_OBUF;
  wire clk;
  wire clk_IBUF;
  wire clk_IBUF_BUFG;
  wire flush;
  wire flush_IBUF;
  wire \gen_row[0].gen_col[0].pe_inst_n_32 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_36 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_37 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_38 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_39 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_40 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_41 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_42 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_43 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_44 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_45 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_46 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_47 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_48 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_49 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_50 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_51 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_52 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_53 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_54 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_55 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_56 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_57 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_58 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_59 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_60 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_61 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_62 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_63 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_64 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_65 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_66 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_67 ;
  wire \gen_row[0].gen_col[0].pe_inst_n_68 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_33 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_34 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_35 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_36 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_37 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_38 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_39 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_40 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_41 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_42 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_43 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_44 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_45 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_46 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_47 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_48 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_49 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_50 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_51 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_52 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_53 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_54 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_55 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_56 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_57 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_58 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_59 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_60 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_61 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_62 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_63 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_64 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_65 ;
  wire \gen_row[0].gen_col[1].pe_inst_n_66 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_32 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_36 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_37 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_38 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_39 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_40 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_41 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_42 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_43 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_44 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_45 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_46 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_47 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_48 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_49 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_50 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_51 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_52 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_53 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_54 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_55 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_56 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_57 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_58 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_59 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_60 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_61 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_62 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_63 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_64 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_65 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_66 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_67 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_68 ;
  wire \gen_row[0].gen_col[2].pe_inst_n_69 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_32 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_34 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_35 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_36 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_37 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_38 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_39 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_40 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_41 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_42 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_43 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_44 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_45 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_46 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_47 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_48 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_49 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_50 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_51 ;
  wire \gen_row[0].gen_col[3].pe_inst_n_52 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_32 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_36 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_37 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_38 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_39 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_40 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_41 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_42 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_43 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_44 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_45 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_46 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_47 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_48 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_49 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_50 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_51 ;
  wire \gen_row[1].gen_col[0].pe_inst_n_52 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_34 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_35 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_36 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_37 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_38 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_39 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_40 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_41 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_42 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_43 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_44 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_45 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_46 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_47 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_48 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_49 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_50 ;
  wire \gen_row[1].gen_col[1].pe_inst_n_51 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_32 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_36 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_37 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_38 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_39 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_40 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_41 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_42 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_43 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_44 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_45 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_46 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_47 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_48 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_49 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_50 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_51 ;
  wire \gen_row[1].gen_col[2].pe_inst_n_52 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_32 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_34 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_35 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_36 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_37 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_38 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_39 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_40 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_41 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_42 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_43 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_44 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_45 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_46 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_47 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_48 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_49 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_50 ;
  wire \gen_row[1].gen_col[3].pe_inst_n_51 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_33 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_34 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_35 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_36 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_37 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_38 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_39 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_40 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_41 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_42 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_43 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_44 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_45 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_46 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_47 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_48 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_49 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_50 ;
  wire \gen_row[2].gen_col[0].pe_inst_n_51 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_34 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_35 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_36 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_37 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_38 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_39 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_40 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_41 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_42 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_43 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_44 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_45 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_46 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_47 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_48 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_49 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_50 ;
  wire \gen_row[2].gen_col[1].pe_inst_n_51 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_32 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_36 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_37 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_38 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_39 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_40 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_41 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_42 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_43 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_44 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_45 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_46 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_47 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_48 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_49 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_50 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_51 ;
  wire \gen_row[2].gen_col[2].pe_inst_n_52 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_33 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_34 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_35 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_36 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_37 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_38 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_39 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_40 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_41 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_42 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_43 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_44 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_45 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_46 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_47 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_48 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_49 ;
  wire \gen_row[2].gen_col[3].pe_inst_n_50 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_48 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_49 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_50 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_51 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_52 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_53 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_54 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_55 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_56 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_57 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_58 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_59 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_60 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_61 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_62 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_63 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_64 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_66 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_68 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_69 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_70 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_71 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_72 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_73 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_74 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_75 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_76 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_77 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_78 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_79 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_80 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_81 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_82 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_83 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_84 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_85 ;
  wire \gen_row[3].gen_col[0].pe_inst_n_86 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_48 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_49 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_52 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_54 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_55 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_56 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_57 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_58 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_59 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_60 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_61 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_62 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_63 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_64 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_65 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_66 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_67 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_68 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_69 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_70 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_71 ;
  wire \gen_row[3].gen_col[1].pe_inst_n_72 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_48 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_49 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_50 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_53 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_55 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_56 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_57 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_58 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_59 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_60 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_61 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_62 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_63 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_64 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_65 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_66 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_67 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_68 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_69 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_70 ;
  wire \gen_row[3].gen_col[2].pe_inst_n_71 ;
  wire \gen_row[3].gen_col[3].pe_inst_n_48 ;
  wire \gen_row[3].gen_col[3].pe_inst_n_51 ;
  wire \gen_row[3].gen_col[3].pe_inst_n_52 ;
  wire [63:0]input_in;
  wire [63:0]input_in_IBUF;
  wire input_out_valid_mesh_0;
  wire input_out_valid_mesh_10;
  wire input_out_valid_mesh_2;
  wire input_out_valid_mesh_4;
  wire input_out_valid_mesh_5;
  wire input_out_valid_mesh_6;
  wire [3:0]input_ready;
  wire [2:2]input_ready_comb;
  wire [3:0]input_valid;
  wire [3:0]input_valid_IBUF;
  wire input_valid_reg;
  wire input_valid_reg11_out;
  wire input_valid_reg11_out_0;
  wire input_valid_reg11_out_1;
  wire input_valid_reg11_out_10;
  wire input_valid_reg11_out_11;
  wire input_valid_reg11_out_13;
  wire input_valid_reg11_out_15;
  wire input_valid_reg11_out_3;
  wire input_valid_reg11_out_4;
  wire input_valid_reg11_out_6;
  wire input_valid_reg11_out_7;
  wire input_valid_reg11_out_9;
  wire input_valid_reg_12;
  wire input_valid_reg_14;
  wire input_valid_reg_17;
  wire input_valid_reg_2;
  wire input_valid_reg_20;
  wire input_valid_reg_22;
  wire input_valid_reg_5;
  wire input_valid_reg_8;
  wire [511:0]output_data;
  wire [511:0]output_data_OBUF;
  wire [15:0]output_valid;
  wire rst_n;
  wire rst_n_IBUF;
  wire [15:0]weight_in;
  wire [15:0]weight_in_IBUF;
  wire weight_out_valid_mesh_12;
  wire weight_out_valid_mesh_13;
  wire weight_out_valid_mesh_14;
  wire weight_out_valid_reg;
  wire weight_ready;
  wire weight_ready_OBUF;
  wire [15:0]weight_reg__0;
  wire [15:0]weight_reg__0_18;
  wire [15:0]weight_reg__0_21;
  wire [15:0]weight_reg__0_23;
  wire weight_valid;
  wire weight_valid_IBUF;
  wire weight_valid_reg15_out;
  wire weight_valid_reg15_out_16;
  wire weight_valid_reg15_out_19;

  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  IBUF accumulator_clr_IBUF_inst
       (.I(accumulator_clr),
        .O(accumulator_clr_IBUF));
  FDCE array_busy_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .D(\gen_row[0].gen_col[3].pe_inst_n_52 ),
        .Q(array_busy_reg_reg_n_0));
  OBUF busy_OBUF_inst
       (.I(busy_OBUF),
        .O(busy));
  FDCE busy_reg_reg
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .D(array_busy_reg_reg_n_0),
        .Q(busy_OBUF));
  BUFG clk_IBUF_BUFG_inst
       (.I(clk_IBUF),
        .O(clk_IBUF_BUFG));
  IBUF clk_IBUF_inst
       (.I(clk),
        .O(clk_IBUF));
  IBUF flush_IBUF_inst
       (.I(flush),
        .O(flush_IBUF));
  os_pe \gen_row[0].gen_col[0].pe_inst 
       (.B(weight_reg__0),
        .D({\gen_row[0].gen_col[0].pe_inst_n_37 ,\gen_row[0].gen_col[0].pe_inst_n_38 ,\gen_row[0].gen_col[0].pe_inst_n_39 ,\gen_row[0].gen_col[0].pe_inst_n_40 ,\gen_row[0].gen_col[0].pe_inst_n_41 ,\gen_row[0].gen_col[0].pe_inst_n_42 ,\gen_row[0].gen_col[0].pe_inst_n_43 ,\gen_row[0].gen_col[0].pe_inst_n_44 ,\gen_row[0].gen_col[0].pe_inst_n_45 ,\gen_row[0].gen_col[0].pe_inst_n_46 ,\gen_row[0].gen_col[0].pe_inst_n_47 ,\gen_row[0].gen_col[0].pe_inst_n_48 ,\gen_row[0].gen_col[0].pe_inst_n_49 ,\gen_row[0].gen_col[0].pe_inst_n_50 ,\gen_row[0].gen_col[0].pe_inst_n_51 ,\gen_row[0].gen_col[0].pe_inst_n_52 }),
        .E(\gen_row[0].gen_col[0].pe_inst_n_36 ),
        .Q(output_data_OBUF[31:0]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[0].gen_col[0].pe_inst_n_32 ),
        .computing_reg_1(\gen_row[3].gen_col[0].pe_inst_n_64 ),
        .flush_IBUF(flush_IBUF),
        .input_in_IBUF(input_in_IBUF[15:0]),
        .\input_out_reg_reg[15]_0 ({\gen_row[0].gen_col[0].pe_inst_n_53 ,\gen_row[0].gen_col[0].pe_inst_n_54 ,\gen_row[0].gen_col[0].pe_inst_n_55 ,\gen_row[0].gen_col[0].pe_inst_n_56 ,\gen_row[0].gen_col[0].pe_inst_n_57 ,\gen_row[0].gen_col[0].pe_inst_n_58 ,\gen_row[0].gen_col[0].pe_inst_n_59 ,\gen_row[0].gen_col[0].pe_inst_n_60 ,\gen_row[0].gen_col[0].pe_inst_n_61 ,\gen_row[0].gen_col[0].pe_inst_n_62 ,\gen_row[0].gen_col[0].pe_inst_n_63 ,\gen_row[0].gen_col[0].pe_inst_n_64 ,\gen_row[0].gen_col[0].pe_inst_n_65 ,\gen_row[0].gen_col[0].pe_inst_n_66 ,\gen_row[0].gen_col[0].pe_inst_n_67 ,\gen_row[0].gen_col[0].pe_inst_n_68 }),
        .input_out_valid_mesh_0(input_out_valid_mesh_0),
        .input_valid_IBUF(input_valid_IBUF[0]),
        .input_valid_reg(input_valid_reg),
        .input_valid_reg11_out(input_valid_reg11_out),
        .\weight_out_reg_reg[15]_0 (\gen_row[3].gen_col[0].pe_inst_n_66 ),
        .\weight_out_reg_reg[15]_1 ({\gen_row[3].gen_col[0].pe_inst_n_48 ,\gen_row[3].gen_col[0].pe_inst_n_49 ,\gen_row[3].gen_col[0].pe_inst_n_50 ,\gen_row[3].gen_col[0].pe_inst_n_51 ,\gen_row[3].gen_col[0].pe_inst_n_52 ,\gen_row[3].gen_col[0].pe_inst_n_53 ,\gen_row[3].gen_col[0].pe_inst_n_54 ,\gen_row[3].gen_col[0].pe_inst_n_55 ,\gen_row[3].gen_col[0].pe_inst_n_56 ,\gen_row[3].gen_col[0].pe_inst_n_57 ,\gen_row[3].gen_col[0].pe_inst_n_58 ,\gen_row[3].gen_col[0].pe_inst_n_59 ,\gen_row[3].gen_col[0].pe_inst_n_60 ,\gen_row[3].gen_col[0].pe_inst_n_61 ,\gen_row[3].gen_col[0].pe_inst_n_62 ,\gen_row[3].gen_col[0].pe_inst_n_63 }));
  os_pe_0 \gen_row[0].gen_col[1].pe_inst 
       (.D({\gen_row[0].gen_col[1].pe_inst_n_35 ,\gen_row[0].gen_col[1].pe_inst_n_36 ,\gen_row[0].gen_col[1].pe_inst_n_37 ,\gen_row[0].gen_col[1].pe_inst_n_38 ,\gen_row[0].gen_col[1].pe_inst_n_39 ,\gen_row[0].gen_col[1].pe_inst_n_40 ,\gen_row[0].gen_col[1].pe_inst_n_41 ,\gen_row[0].gen_col[1].pe_inst_n_42 ,\gen_row[0].gen_col[1].pe_inst_n_43 ,\gen_row[0].gen_col[1].pe_inst_n_44 ,\gen_row[0].gen_col[1].pe_inst_n_45 ,\gen_row[0].gen_col[1].pe_inst_n_46 ,\gen_row[0].gen_col[1].pe_inst_n_47 ,\gen_row[0].gen_col[1].pe_inst_n_48 ,\gen_row[0].gen_col[1].pe_inst_n_49 ,\gen_row[0].gen_col[1].pe_inst_n_50 }),
        .E(\gen_row[0].gen_col[1].pe_inst_n_33 ),
        .Q(output_data_OBUF[63:32]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .array_busy_reg_i_6(\gen_row[3].gen_col[3].pe_inst_n_48 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[3].gen_col[1].pe_inst_n_49 ),
        .flush_IBUF(flush_IBUF),
        .input_in_IBUF(input_in_IBUF[31:16]),
        .\input_out_reg_reg[15]_0 ({\gen_row[0].gen_col[1].pe_inst_n_51 ,\gen_row[0].gen_col[1].pe_inst_n_52 ,\gen_row[0].gen_col[1].pe_inst_n_53 ,\gen_row[0].gen_col[1].pe_inst_n_54 ,\gen_row[0].gen_col[1].pe_inst_n_55 ,\gen_row[0].gen_col[1].pe_inst_n_56 ,\gen_row[0].gen_col[1].pe_inst_n_57 ,\gen_row[0].gen_col[1].pe_inst_n_58 ,\gen_row[0].gen_col[1].pe_inst_n_59 ,\gen_row[0].gen_col[1].pe_inst_n_60 ,\gen_row[0].gen_col[1].pe_inst_n_61 ,\gen_row[0].gen_col[1].pe_inst_n_62 ,\gen_row[0].gen_col[1].pe_inst_n_63 ,\gen_row[0].gen_col[1].pe_inst_n_64 ,\gen_row[0].gen_col[1].pe_inst_n_65 ,\gen_row[0].gen_col[1].pe_inst_n_66 }),
        .input_out_valid_reg_reg_0(\gen_row[0].gen_col[1].pe_inst_n_34 ),
        .input_valid_IBUF(input_valid_IBUF[1]),
        .input_valid_reg11_out(input_valid_reg11_out_0),
        .\weight_out_reg_reg[0]_0 (\gen_row[3].gen_col[1].pe_inst_n_48 ),
        .\weight_reg_reg[0]_0 (\gen_row[3].gen_col[0].pe_inst_n_68 ),
        .\weight_reg_reg[15]_0 ({\gen_row[0].gen_col[0].pe_inst_n_37 ,\gen_row[0].gen_col[0].pe_inst_n_38 ,\gen_row[0].gen_col[0].pe_inst_n_39 ,\gen_row[0].gen_col[0].pe_inst_n_40 ,\gen_row[0].gen_col[0].pe_inst_n_41 ,\gen_row[0].gen_col[0].pe_inst_n_42 ,\gen_row[0].gen_col[0].pe_inst_n_43 ,\gen_row[0].gen_col[0].pe_inst_n_44 ,\gen_row[0].gen_col[0].pe_inst_n_45 ,\gen_row[0].gen_col[0].pe_inst_n_46 ,\gen_row[0].gen_col[0].pe_inst_n_47 ,\gen_row[0].gen_col[0].pe_inst_n_48 ,\gen_row[0].gen_col[0].pe_inst_n_49 ,\gen_row[0].gen_col[0].pe_inst_n_50 ,\gen_row[0].gen_col[0].pe_inst_n_51 ,\gen_row[0].gen_col[0].pe_inst_n_52 }));
  os_pe_1 \gen_row[0].gen_col[2].pe_inst 
       (.D({\gen_row[0].gen_col[2].pe_inst_n_38 ,\gen_row[0].gen_col[2].pe_inst_n_39 ,\gen_row[0].gen_col[2].pe_inst_n_40 ,\gen_row[0].gen_col[2].pe_inst_n_41 ,\gen_row[0].gen_col[2].pe_inst_n_42 ,\gen_row[0].gen_col[2].pe_inst_n_43 ,\gen_row[0].gen_col[2].pe_inst_n_44 ,\gen_row[0].gen_col[2].pe_inst_n_45 ,\gen_row[0].gen_col[2].pe_inst_n_46 ,\gen_row[0].gen_col[2].pe_inst_n_47 ,\gen_row[0].gen_col[2].pe_inst_n_48 ,\gen_row[0].gen_col[2].pe_inst_n_49 ,\gen_row[0].gen_col[2].pe_inst_n_50 ,\gen_row[0].gen_col[2].pe_inst_n_51 ,\gen_row[0].gen_col[2].pe_inst_n_52 ,\gen_row[0].gen_col[2].pe_inst_n_53 }),
        .E(\gen_row[0].gen_col[2].pe_inst_n_36 ),
        .Q(output_data_OBUF[95:64]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .array_busy_reg_i_3(\gen_row[0].gen_col[0].pe_inst_n_32 ),
        .array_busy_reg_i_3_0(\gen_row[3].gen_col[2].pe_inst_n_53 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[0].gen_col[2].pe_inst_n_37 ),
        .computing_reg_1(\gen_row[3].gen_col[2].pe_inst_n_50 ),
        .flush_IBUF(flush_IBUF),
        .input_in_IBUF(input_in_IBUF[47:32]),
        .\input_out_reg_reg[15]_0 ({\gen_row[0].gen_col[2].pe_inst_n_54 ,\gen_row[0].gen_col[2].pe_inst_n_55 ,\gen_row[0].gen_col[2].pe_inst_n_56 ,\gen_row[0].gen_col[2].pe_inst_n_57 ,\gen_row[0].gen_col[2].pe_inst_n_58 ,\gen_row[0].gen_col[2].pe_inst_n_59 ,\gen_row[0].gen_col[2].pe_inst_n_60 ,\gen_row[0].gen_col[2].pe_inst_n_61 ,\gen_row[0].gen_col[2].pe_inst_n_62 ,\gen_row[0].gen_col[2].pe_inst_n_63 ,\gen_row[0].gen_col[2].pe_inst_n_64 ,\gen_row[0].gen_col[2].pe_inst_n_65 ,\gen_row[0].gen_col[2].pe_inst_n_66 ,\gen_row[0].gen_col[2].pe_inst_n_67 ,\gen_row[0].gen_col[2].pe_inst_n_68 ,\gen_row[0].gen_col[2].pe_inst_n_69 }),
        .input_out_valid_mesh_2(input_out_valid_mesh_2),
        .input_valid_IBUF(input_valid_IBUF[2]),
        .input_valid_reg(input_valid_reg_2),
        .input_valid_reg11_out(input_valid_reg11_out_1),
        .rst_n(\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .rst_n_IBUF(rst_n_IBUF),
        .\weight_out_reg_reg[0]_0 (\gen_row[3].gen_col[2].pe_inst_n_48 ),
        .weight_out_valid_mesh_13(weight_out_valid_mesh_13),
        .\weight_reg_reg[0]_0 (\gen_row[3].gen_col[1].pe_inst_n_54 ),
        .\weight_reg_reg[15]_0 ({\gen_row[0].gen_col[1].pe_inst_n_35 ,\gen_row[0].gen_col[1].pe_inst_n_36 ,\gen_row[0].gen_col[1].pe_inst_n_37 ,\gen_row[0].gen_col[1].pe_inst_n_38 ,\gen_row[0].gen_col[1].pe_inst_n_39 ,\gen_row[0].gen_col[1].pe_inst_n_40 ,\gen_row[0].gen_col[1].pe_inst_n_41 ,\gen_row[0].gen_col[1].pe_inst_n_42 ,\gen_row[0].gen_col[1].pe_inst_n_43 ,\gen_row[0].gen_col[1].pe_inst_n_44 ,\gen_row[0].gen_col[1].pe_inst_n_45 ,\gen_row[0].gen_col[1].pe_inst_n_46 ,\gen_row[0].gen_col[1].pe_inst_n_47 ,\gen_row[0].gen_col[1].pe_inst_n_48 ,\gen_row[0].gen_col[1].pe_inst_n_49 ,\gen_row[0].gen_col[1].pe_inst_n_50 }));
  os_pe_2 \gen_row[0].gen_col[3].pe_inst 
       (.D({\gen_row[0].gen_col[3].pe_inst_n_36 ,\gen_row[0].gen_col[3].pe_inst_n_37 ,\gen_row[0].gen_col[3].pe_inst_n_38 ,\gen_row[0].gen_col[3].pe_inst_n_39 ,\gen_row[0].gen_col[3].pe_inst_n_40 ,\gen_row[0].gen_col[3].pe_inst_n_41 ,\gen_row[0].gen_col[3].pe_inst_n_42 ,\gen_row[0].gen_col[3].pe_inst_n_43 ,\gen_row[0].gen_col[3].pe_inst_n_44 ,\gen_row[0].gen_col[3].pe_inst_n_45 ,\gen_row[0].gen_col[3].pe_inst_n_46 ,\gen_row[0].gen_col[3].pe_inst_n_47 ,\gen_row[0].gen_col[3].pe_inst_n_48 ,\gen_row[0].gen_col[3].pe_inst_n_49 ,\gen_row[0].gen_col[3].pe_inst_n_50 ,\gen_row[0].gen_col[3].pe_inst_n_51 }),
        .E(\gen_row[0].gen_col[3].pe_inst_n_34 ),
        .Q(output_data_OBUF[127:96]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .array_busy_reg_i_2_0(\gen_row[3].gen_col[2].pe_inst_n_49 ),
        .array_busy_reg_i_2_1(\gen_row[3].gen_col[1].pe_inst_n_49 ),
        .array_busy_reg_i_3_0(\gen_row[1].gen_col[3].pe_inst_n_32 ),
        .array_busy_reg_reg(\gen_row[0].gen_col[2].pe_inst_n_37 ),
        .array_busy_reg_reg_0(\gen_row[3].gen_col[1].pe_inst_n_55 ),
        .array_busy_reg_reg_1(\gen_row[1].gen_col[1].pe_inst_n_35 ),
        .array_busy_reg_reg_2(\gen_row[3].gen_col[0].pe_inst_n_69 ),
        .array_busy_reg_reg_3(\gen_row[2].gen_col[0].pe_inst_n_35 ),
        .array_busy_reg_reg_4(\gen_row[2].gen_col[1].pe_inst_n_35 ),
        .array_busy_reg_reg_5(\gen_row[2].gen_col[3].pe_inst_n_34 ),
        .array_busy_reg_reg_6(\gen_row[3].gen_col[1].pe_inst_n_56 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[3].gen_col[3].pe_inst_n_48 ),
        .flush(\gen_row[0].gen_col[3].pe_inst_n_52 ),
        .flush_IBUF(flush_IBUF),
        .input_in_IBUF(input_in_IBUF[63:48]),
        .input_out_valid_mesh_4(input_out_valid_mesh_4),
        .input_valid_IBUF(input_valid_IBUF[3]),
        .input_valid_reg(input_valid_reg_2),
        .input_valid_reg11_out(input_valid_reg11_out_3),
        .input_valid_reg_0(input_valid_reg_22),
        .input_valid_reg_1(input_valid_reg_20),
        .weight_out_valid_mesh_12(weight_out_valid_mesh_12),
        .weight_out_valid_mesh_14(weight_out_valid_mesh_14),
        .weight_out_valid_reg(weight_out_valid_reg),
        .weight_out_valid_reg_reg_0(\gen_row[0].gen_col[3].pe_inst_n_32 ),
        .weight_out_valid_reg_reg_1(\gen_row[0].gen_col[3].pe_inst_n_35 ),
        .\weight_reg_reg[0]_0 (\gen_row[3].gen_col[2].pe_inst_n_55 ),
        .\weight_reg_reg[15]_0 ({\gen_row[0].gen_col[2].pe_inst_n_38 ,\gen_row[0].gen_col[2].pe_inst_n_39 ,\gen_row[0].gen_col[2].pe_inst_n_40 ,\gen_row[0].gen_col[2].pe_inst_n_41 ,\gen_row[0].gen_col[2].pe_inst_n_42 ,\gen_row[0].gen_col[2].pe_inst_n_43 ,\gen_row[0].gen_col[2].pe_inst_n_44 ,\gen_row[0].gen_col[2].pe_inst_n_45 ,\gen_row[0].gen_col[2].pe_inst_n_46 ,\gen_row[0].gen_col[2].pe_inst_n_47 ,\gen_row[0].gen_col[2].pe_inst_n_48 ,\gen_row[0].gen_col[2].pe_inst_n_49 ,\gen_row[0].gen_col[2].pe_inst_n_50 ,\gen_row[0].gen_col[2].pe_inst_n_51 ,\gen_row[0].gen_col[2].pe_inst_n_52 ,\gen_row[0].gen_col[2].pe_inst_n_53 }));
  os_pe_3 \gen_row[1].gen_col[0].pe_inst 
       (.B(weight_reg__0),
        .D({\gen_row[1].gen_col[0].pe_inst_n_37 ,\gen_row[1].gen_col[0].pe_inst_n_38 ,\gen_row[1].gen_col[0].pe_inst_n_39 ,\gen_row[1].gen_col[0].pe_inst_n_40 ,\gen_row[1].gen_col[0].pe_inst_n_41 ,\gen_row[1].gen_col[0].pe_inst_n_42 ,\gen_row[1].gen_col[0].pe_inst_n_43 ,\gen_row[1].gen_col[0].pe_inst_n_44 ,\gen_row[1].gen_col[0].pe_inst_n_45 ,\gen_row[1].gen_col[0].pe_inst_n_46 ,\gen_row[1].gen_col[0].pe_inst_n_47 ,\gen_row[1].gen_col[0].pe_inst_n_48 ,\gen_row[1].gen_col[0].pe_inst_n_49 ,\gen_row[1].gen_col[0].pe_inst_n_50 ,\gen_row[1].gen_col[0].pe_inst_n_51 ,\gen_row[1].gen_col[0].pe_inst_n_52 }),
        .E(\gen_row[1].gen_col[0].pe_inst_n_36 ),
        .Q(output_data_OBUF[159:128]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[1].gen_col[0].pe_inst_n_32 ),
        .computing_reg_1(\gen_row[3].gen_col[0].pe_inst_n_64 ),
        .flush_IBUF(flush_IBUF),
        .input_out_valid_mesh_4(input_out_valid_mesh_4),
        .\input_reg_reg[15]_0 (\gen_row[0].gen_col[0].pe_inst_n_36 ),
        .\input_reg_reg[15]_1 ({\gen_row[0].gen_col[0].pe_inst_n_53 ,\gen_row[0].gen_col[0].pe_inst_n_54 ,\gen_row[0].gen_col[0].pe_inst_n_55 ,\gen_row[0].gen_col[0].pe_inst_n_56 ,\gen_row[0].gen_col[0].pe_inst_n_57 ,\gen_row[0].gen_col[0].pe_inst_n_58 ,\gen_row[0].gen_col[0].pe_inst_n_59 ,\gen_row[0].gen_col[0].pe_inst_n_60 ,\gen_row[0].gen_col[0].pe_inst_n_61 ,\gen_row[0].gen_col[0].pe_inst_n_62 ,\gen_row[0].gen_col[0].pe_inst_n_63 ,\gen_row[0].gen_col[0].pe_inst_n_64 ,\gen_row[0].gen_col[0].pe_inst_n_65 ,\gen_row[0].gen_col[0].pe_inst_n_66 ,\gen_row[0].gen_col[0].pe_inst_n_67 ,\gen_row[0].gen_col[0].pe_inst_n_68 }),
        .input_valid_reg(input_valid_reg_5),
        .input_valid_reg11_out(input_valid_reg11_out_4),
        .input_valid_reg11_out_0(input_valid_reg11_out));
  os_pe_4 \gen_row[1].gen_col[1].pe_inst 
       (.B(weight_reg__0_18),
        .D({\gen_row[1].gen_col[1].pe_inst_n_36 ,\gen_row[1].gen_col[1].pe_inst_n_37 ,\gen_row[1].gen_col[1].pe_inst_n_38 ,\gen_row[1].gen_col[1].pe_inst_n_39 ,\gen_row[1].gen_col[1].pe_inst_n_40 ,\gen_row[1].gen_col[1].pe_inst_n_41 ,\gen_row[1].gen_col[1].pe_inst_n_42 ,\gen_row[1].gen_col[1].pe_inst_n_43 ,\gen_row[1].gen_col[1].pe_inst_n_44 ,\gen_row[1].gen_col[1].pe_inst_n_45 ,\gen_row[1].gen_col[1].pe_inst_n_46 ,\gen_row[1].gen_col[1].pe_inst_n_47 ,\gen_row[1].gen_col[1].pe_inst_n_48 ,\gen_row[1].gen_col[1].pe_inst_n_49 ,\gen_row[1].gen_col[1].pe_inst_n_50 ,\gen_row[1].gen_col[1].pe_inst_n_51 }),
        .E(\gen_row[1].gen_col[1].pe_inst_n_34 ),
        .Q(output_data_OBUF[191:160]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[1].gen_col[1].pe_inst_n_35 ),
        .computing_reg_1(\gen_row[3].gen_col[1].pe_inst_n_49 ),
        .flush_IBUF(flush_IBUF),
        .input_out_valid_mesh_5(input_out_valid_mesh_5),
        .input_out_valid_mesh_6(input_out_valid_mesh_6),
        .\input_reg_reg[15]_0 (\gen_row[0].gen_col[1].pe_inst_n_33 ),
        .\input_reg_reg[15]_1 ({\gen_row[0].gen_col[1].pe_inst_n_51 ,\gen_row[0].gen_col[1].pe_inst_n_52 ,\gen_row[0].gen_col[1].pe_inst_n_53 ,\gen_row[0].gen_col[1].pe_inst_n_54 ,\gen_row[0].gen_col[1].pe_inst_n_55 ,\gen_row[0].gen_col[1].pe_inst_n_56 ,\gen_row[0].gen_col[1].pe_inst_n_57 ,\gen_row[0].gen_col[1].pe_inst_n_58 ,\gen_row[0].gen_col[1].pe_inst_n_59 ,\gen_row[0].gen_col[1].pe_inst_n_60 ,\gen_row[0].gen_col[1].pe_inst_n_61 ,\gen_row[0].gen_col[1].pe_inst_n_62 ,\gen_row[0].gen_col[1].pe_inst_n_63 ,\gen_row[0].gen_col[1].pe_inst_n_64 ,\gen_row[0].gen_col[1].pe_inst_n_65 ,\gen_row[0].gen_col[1].pe_inst_n_66 }),
        .input_valid_reg11_out(input_valid_reg11_out_6),
        .input_valid_reg11_out_0(input_valid_reg11_out_0),
        .weight_out_valid_mesh_14(weight_out_valid_mesh_14));
  os_pe_5 \gen_row[1].gen_col[2].pe_inst 
       (.B(weight_reg__0_21),
        .D({\gen_row[1].gen_col[2].pe_inst_n_37 ,\gen_row[1].gen_col[2].pe_inst_n_38 ,\gen_row[1].gen_col[2].pe_inst_n_39 ,\gen_row[1].gen_col[2].pe_inst_n_40 ,\gen_row[1].gen_col[2].pe_inst_n_41 ,\gen_row[1].gen_col[2].pe_inst_n_42 ,\gen_row[1].gen_col[2].pe_inst_n_43 ,\gen_row[1].gen_col[2].pe_inst_n_44 ,\gen_row[1].gen_col[2].pe_inst_n_45 ,\gen_row[1].gen_col[2].pe_inst_n_46 ,\gen_row[1].gen_col[2].pe_inst_n_47 ,\gen_row[1].gen_col[2].pe_inst_n_48 ,\gen_row[1].gen_col[2].pe_inst_n_49 ,\gen_row[1].gen_col[2].pe_inst_n_50 ,\gen_row[1].gen_col[2].pe_inst_n_51 ,\gen_row[1].gen_col[2].pe_inst_n_52 }),
        .E(\gen_row[1].gen_col[2].pe_inst_n_36 ),
        .Q(output_data_OBUF[223:192]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[1].gen_col[2].pe_inst_n_32 ),
        .computing_reg_1(\gen_row[3].gen_col[2].pe_inst_n_50 ),
        .flush_IBUF(flush_IBUF),
        .input_out_valid_mesh_6(input_out_valid_mesh_6),
        .\input_reg_reg[15]_0 (\gen_row[0].gen_col[2].pe_inst_n_36 ),
        .\input_reg_reg[15]_1 ({\gen_row[0].gen_col[2].pe_inst_n_54 ,\gen_row[0].gen_col[2].pe_inst_n_55 ,\gen_row[0].gen_col[2].pe_inst_n_56 ,\gen_row[0].gen_col[2].pe_inst_n_57 ,\gen_row[0].gen_col[2].pe_inst_n_58 ,\gen_row[0].gen_col[2].pe_inst_n_59 ,\gen_row[0].gen_col[2].pe_inst_n_60 ,\gen_row[0].gen_col[2].pe_inst_n_61 ,\gen_row[0].gen_col[2].pe_inst_n_62 ,\gen_row[0].gen_col[2].pe_inst_n_63 ,\gen_row[0].gen_col[2].pe_inst_n_64 ,\gen_row[0].gen_col[2].pe_inst_n_65 ,\gen_row[0].gen_col[2].pe_inst_n_66 ,\gen_row[0].gen_col[2].pe_inst_n_67 ,\gen_row[0].gen_col[2].pe_inst_n_68 ,\gen_row[0].gen_col[2].pe_inst_n_69 }),
        .input_valid_reg(input_valid_reg_8),
        .input_valid_reg11_out(input_valid_reg11_out_7),
        .input_valid_reg11_out_0(input_valid_reg11_out_1));
  os_pe_6 \gen_row[1].gen_col[3].pe_inst 
       (.B(weight_reg__0_23),
        .D({\gen_row[1].gen_col[3].pe_inst_n_36 ,\gen_row[1].gen_col[3].pe_inst_n_37 ,\gen_row[1].gen_col[3].pe_inst_n_38 ,\gen_row[1].gen_col[3].pe_inst_n_39 ,\gen_row[1].gen_col[3].pe_inst_n_40 ,\gen_row[1].gen_col[3].pe_inst_n_41 ,\gen_row[1].gen_col[3].pe_inst_n_42 ,\gen_row[1].gen_col[3].pe_inst_n_43 ,\gen_row[1].gen_col[3].pe_inst_n_44 ,\gen_row[1].gen_col[3].pe_inst_n_45 ,\gen_row[1].gen_col[3].pe_inst_n_46 ,\gen_row[1].gen_col[3].pe_inst_n_47 ,\gen_row[1].gen_col[3].pe_inst_n_48 ,\gen_row[1].gen_col[3].pe_inst_n_49 ,\gen_row[1].gen_col[3].pe_inst_n_50 ,\gen_row[1].gen_col[3].pe_inst_n_51 }),
        .E(\gen_row[1].gen_col[3].pe_inst_n_34 ),
        .Q(output_data_OBUF[255:224]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .array_busy_reg_i_4(\gen_row[1].gen_col[2].pe_inst_n_32 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[1].gen_col[3].pe_inst_n_32 ),
        .computing_reg_1(\gen_row[1].gen_col[3].pe_inst_n_35 ),
        .computing_reg_2(\gen_row[3].gen_col[3].pe_inst_n_48 ),
        .flush_IBUF(flush_IBUF),
        .input_out_valid_mesh_2(input_out_valid_mesh_2),
        .\input_reg_reg[15]_0 (\gen_row[0].gen_col[3].pe_inst_n_34 ),
        .\input_reg_reg[15]_1 ({\gen_row[0].gen_col[3].pe_inst_n_36 ,\gen_row[0].gen_col[3].pe_inst_n_37 ,\gen_row[0].gen_col[3].pe_inst_n_38 ,\gen_row[0].gen_col[3].pe_inst_n_39 ,\gen_row[0].gen_col[3].pe_inst_n_40 ,\gen_row[0].gen_col[3].pe_inst_n_41 ,\gen_row[0].gen_col[3].pe_inst_n_42 ,\gen_row[0].gen_col[3].pe_inst_n_43 ,\gen_row[0].gen_col[3].pe_inst_n_44 ,\gen_row[0].gen_col[3].pe_inst_n_45 ,\gen_row[0].gen_col[3].pe_inst_n_46 ,\gen_row[0].gen_col[3].pe_inst_n_47 ,\gen_row[0].gen_col[3].pe_inst_n_48 ,\gen_row[0].gen_col[3].pe_inst_n_49 ,\gen_row[0].gen_col[3].pe_inst_n_50 ,\gen_row[0].gen_col[3].pe_inst_n_51 }),
        .input_valid_reg11_out(input_valid_reg11_out_9),
        .input_valid_reg11_out_0(input_valid_reg11_out_3));
  os_pe_7 \gen_row[2].gen_col[0].pe_inst 
       (.B(weight_reg__0),
        .D({\gen_row[2].gen_col[0].pe_inst_n_36 ,\gen_row[2].gen_col[0].pe_inst_n_37 ,\gen_row[2].gen_col[0].pe_inst_n_38 ,\gen_row[2].gen_col[0].pe_inst_n_39 ,\gen_row[2].gen_col[0].pe_inst_n_40 ,\gen_row[2].gen_col[0].pe_inst_n_41 ,\gen_row[2].gen_col[0].pe_inst_n_42 ,\gen_row[2].gen_col[0].pe_inst_n_43 ,\gen_row[2].gen_col[0].pe_inst_n_44 ,\gen_row[2].gen_col[0].pe_inst_n_45 ,\gen_row[2].gen_col[0].pe_inst_n_46 ,\gen_row[2].gen_col[0].pe_inst_n_47 ,\gen_row[2].gen_col[0].pe_inst_n_48 ,\gen_row[2].gen_col[0].pe_inst_n_49 ,\gen_row[2].gen_col[0].pe_inst_n_50 ,\gen_row[2].gen_col[0].pe_inst_n_51 }),
        .E(\gen_row[2].gen_col[0].pe_inst_n_33 ),
        .Q(output_data_OBUF[287:256]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .array_busy_reg_i_4(\gen_row[3].gen_col[2].pe_inst_n_50 ),
        .array_busy_reg_i_4_0(\gen_row[0].gen_col[3].pe_inst_n_32 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[2].gen_col[0].pe_inst_n_34 ),
        .computing_reg_1(\gen_row[3].gen_col[0].pe_inst_n_64 ),
        .flush_IBUF(flush_IBUF),
        .\input_reg_reg[15]_0 (\gen_row[1].gen_col[0].pe_inst_n_36 ),
        .\input_reg_reg[15]_1 ({\gen_row[1].gen_col[0].pe_inst_n_37 ,\gen_row[1].gen_col[0].pe_inst_n_38 ,\gen_row[1].gen_col[0].pe_inst_n_39 ,\gen_row[1].gen_col[0].pe_inst_n_40 ,\gen_row[1].gen_col[0].pe_inst_n_41 ,\gen_row[1].gen_col[0].pe_inst_n_42 ,\gen_row[1].gen_col[0].pe_inst_n_43 ,\gen_row[1].gen_col[0].pe_inst_n_44 ,\gen_row[1].gen_col[0].pe_inst_n_45 ,\gen_row[1].gen_col[0].pe_inst_n_46 ,\gen_row[1].gen_col[0].pe_inst_n_47 ,\gen_row[1].gen_col[0].pe_inst_n_48 ,\gen_row[1].gen_col[0].pe_inst_n_49 ,\gen_row[1].gen_col[0].pe_inst_n_50 ,\gen_row[1].gen_col[0].pe_inst_n_51 ,\gen_row[1].gen_col[0].pe_inst_n_52 }),
        .input_valid_reg(input_valid_reg_8),
        .input_valid_reg11_out(input_valid_reg11_out_10),
        .input_valid_reg11_out_0(input_valid_reg11_out_4),
        .input_valid_reg_1(input_valid_reg_17),
        .input_valid_reg_reg_0(\gen_row[2].gen_col[0].pe_inst_n_35 ));
  os_pe_8 \gen_row[2].gen_col[1].pe_inst 
       (.B(weight_reg__0_18),
        .D({\gen_row[2].gen_col[1].pe_inst_n_36 ,\gen_row[2].gen_col[1].pe_inst_n_37 ,\gen_row[2].gen_col[1].pe_inst_n_38 ,\gen_row[2].gen_col[1].pe_inst_n_39 ,\gen_row[2].gen_col[1].pe_inst_n_40 ,\gen_row[2].gen_col[1].pe_inst_n_41 ,\gen_row[2].gen_col[1].pe_inst_n_42 ,\gen_row[2].gen_col[1].pe_inst_n_43 ,\gen_row[2].gen_col[1].pe_inst_n_44 ,\gen_row[2].gen_col[1].pe_inst_n_45 ,\gen_row[2].gen_col[1].pe_inst_n_46 ,\gen_row[2].gen_col[1].pe_inst_n_47 ,\gen_row[2].gen_col[1].pe_inst_n_48 ,\gen_row[2].gen_col[1].pe_inst_n_49 ,\gen_row[2].gen_col[1].pe_inst_n_50 ,\gen_row[2].gen_col[1].pe_inst_n_51 }),
        .E(\gen_row[2].gen_col[1].pe_inst_n_34 ),
        .Q(output_data_OBUF[319:288]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .array_busy_reg_reg(\gen_row[2].gen_col[0].pe_inst_n_34 ),
        .array_busy_reg_reg_0(\gen_row[1].gen_col[3].pe_inst_n_35 ),
        .array_busy_reg_reg_1(\gen_row[0].gen_col[3].pe_inst_n_35 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[2].gen_col[1].pe_inst_n_35 ),
        .computing_reg_1(\gen_row[3].gen_col[1].pe_inst_n_49 ),
        .flush_IBUF(flush_IBUF),
        .input_out_valid_mesh_10(input_out_valid_mesh_10),
        .\input_reg_reg[15]_0 (\gen_row[1].gen_col[1].pe_inst_n_34 ),
        .\input_reg_reg[15]_1 ({\gen_row[1].gen_col[1].pe_inst_n_36 ,\gen_row[1].gen_col[1].pe_inst_n_37 ,\gen_row[1].gen_col[1].pe_inst_n_38 ,\gen_row[1].gen_col[1].pe_inst_n_39 ,\gen_row[1].gen_col[1].pe_inst_n_40 ,\gen_row[1].gen_col[1].pe_inst_n_41 ,\gen_row[1].gen_col[1].pe_inst_n_42 ,\gen_row[1].gen_col[1].pe_inst_n_43 ,\gen_row[1].gen_col[1].pe_inst_n_44 ,\gen_row[1].gen_col[1].pe_inst_n_45 ,\gen_row[1].gen_col[1].pe_inst_n_46 ,\gen_row[1].gen_col[1].pe_inst_n_47 ,\gen_row[1].gen_col[1].pe_inst_n_48 ,\gen_row[1].gen_col[1].pe_inst_n_49 ,\gen_row[1].gen_col[1].pe_inst_n_50 ,\gen_row[1].gen_col[1].pe_inst_n_51 }),
        .input_valid_reg(input_valid_reg_12),
        .input_valid_reg11_out(input_valid_reg11_out_11),
        .input_valid_reg11_out_0(input_valid_reg11_out_6));
  os_pe_9 \gen_row[2].gen_col[2].pe_inst 
       (.B(weight_reg__0_21),
        .D({\gen_row[2].gen_col[2].pe_inst_n_37 ,\gen_row[2].gen_col[2].pe_inst_n_38 ,\gen_row[2].gen_col[2].pe_inst_n_39 ,\gen_row[2].gen_col[2].pe_inst_n_40 ,\gen_row[2].gen_col[2].pe_inst_n_41 ,\gen_row[2].gen_col[2].pe_inst_n_42 ,\gen_row[2].gen_col[2].pe_inst_n_43 ,\gen_row[2].gen_col[2].pe_inst_n_44 ,\gen_row[2].gen_col[2].pe_inst_n_45 ,\gen_row[2].gen_col[2].pe_inst_n_46 ,\gen_row[2].gen_col[2].pe_inst_n_47 ,\gen_row[2].gen_col[2].pe_inst_n_48 ,\gen_row[2].gen_col[2].pe_inst_n_49 ,\gen_row[2].gen_col[2].pe_inst_n_50 ,\gen_row[2].gen_col[2].pe_inst_n_51 ,\gen_row[2].gen_col[2].pe_inst_n_52 }),
        .E(\gen_row[2].gen_col[2].pe_inst_n_36 ),
        .Q(output_data_OBUF[351:320]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[2].gen_col[2].pe_inst_n_32 ),
        .computing_reg_1(\gen_row[3].gen_col[2].pe_inst_n_50 ),
        .flush_IBUF(flush_IBUF),
        .input_out_valid_mesh_10(input_out_valid_mesh_10),
        .\input_reg_reg[15]_0 (\gen_row[1].gen_col[2].pe_inst_n_36 ),
        .\input_reg_reg[15]_1 ({\gen_row[1].gen_col[2].pe_inst_n_37 ,\gen_row[1].gen_col[2].pe_inst_n_38 ,\gen_row[1].gen_col[2].pe_inst_n_39 ,\gen_row[1].gen_col[2].pe_inst_n_40 ,\gen_row[1].gen_col[2].pe_inst_n_41 ,\gen_row[1].gen_col[2].pe_inst_n_42 ,\gen_row[1].gen_col[2].pe_inst_n_43 ,\gen_row[1].gen_col[2].pe_inst_n_44 ,\gen_row[1].gen_col[2].pe_inst_n_45 ,\gen_row[1].gen_col[2].pe_inst_n_46 ,\gen_row[1].gen_col[2].pe_inst_n_47 ,\gen_row[1].gen_col[2].pe_inst_n_48 ,\gen_row[1].gen_col[2].pe_inst_n_49 ,\gen_row[1].gen_col[2].pe_inst_n_50 ,\gen_row[1].gen_col[2].pe_inst_n_51 ,\gen_row[1].gen_col[2].pe_inst_n_52 }),
        .input_valid_reg(input_valid_reg_14),
        .input_valid_reg11_out(input_valid_reg11_out_13),
        .input_valid_reg11_out_0(input_valid_reg11_out_7));
  os_pe_10 \gen_row[2].gen_col[3].pe_inst 
       (.B(weight_reg__0_23),
        .D({\gen_row[2].gen_col[3].pe_inst_n_35 ,\gen_row[2].gen_col[3].pe_inst_n_36 ,\gen_row[2].gen_col[3].pe_inst_n_37 ,\gen_row[2].gen_col[3].pe_inst_n_38 ,\gen_row[2].gen_col[3].pe_inst_n_39 ,\gen_row[2].gen_col[3].pe_inst_n_40 ,\gen_row[2].gen_col[3].pe_inst_n_41 ,\gen_row[2].gen_col[3].pe_inst_n_42 ,\gen_row[2].gen_col[3].pe_inst_n_43 ,\gen_row[2].gen_col[3].pe_inst_n_44 ,\gen_row[2].gen_col[3].pe_inst_n_45 ,\gen_row[2].gen_col[3].pe_inst_n_46 ,\gen_row[2].gen_col[3].pe_inst_n_47 ,\gen_row[2].gen_col[3].pe_inst_n_48 ,\gen_row[2].gen_col[3].pe_inst_n_49 ,\gen_row[2].gen_col[3].pe_inst_n_50 }),
        .E(\gen_row[2].gen_col[3].pe_inst_n_33 ),
        .Q(output_data_OBUF[383:352]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .array_busy_reg_i_5_0(\gen_row[3].gen_col[2].pe_inst_n_50 ),
        .array_busy_reg_i_5_1(\gen_row[0].gen_col[3].pe_inst_n_32 ),
        .array_busy_reg_i_5_2(\gen_row[2].gen_col[2].pe_inst_n_32 ),
        .array_busy_reg_reg(\gen_row[3].gen_col[3].pe_inst_n_51 ),
        .array_busy_reg_reg_0(\gen_row[3].gen_col[3].pe_inst_n_52 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[3].gen_col[3].pe_inst_n_48 ),
        .flush_IBUF(flush_IBUF),
        .\input_reg_reg[15]_0 (\gen_row[1].gen_col[3].pe_inst_n_34 ),
        .\input_reg_reg[15]_1 ({\gen_row[1].gen_col[3].pe_inst_n_36 ,\gen_row[1].gen_col[3].pe_inst_n_37 ,\gen_row[1].gen_col[3].pe_inst_n_38 ,\gen_row[1].gen_col[3].pe_inst_n_39 ,\gen_row[1].gen_col[3].pe_inst_n_40 ,\gen_row[1].gen_col[3].pe_inst_n_41 ,\gen_row[1].gen_col[3].pe_inst_n_42 ,\gen_row[1].gen_col[3].pe_inst_n_43 ,\gen_row[1].gen_col[3].pe_inst_n_44 ,\gen_row[1].gen_col[3].pe_inst_n_45 ,\gen_row[1].gen_col[3].pe_inst_n_46 ,\gen_row[1].gen_col[3].pe_inst_n_47 ,\gen_row[1].gen_col[3].pe_inst_n_48 ,\gen_row[1].gen_col[3].pe_inst_n_49 ,\gen_row[1].gen_col[3].pe_inst_n_50 ,\gen_row[1].gen_col[3].pe_inst_n_51 }),
        .input_valid_reg(input_valid_reg_12),
        .input_valid_reg11_out(input_valid_reg11_out_15),
        .input_valid_reg11_out_0(input_valid_reg11_out_9),
        .input_valid_reg_reg_0(\gen_row[2].gen_col[3].pe_inst_n_34 ),
        .weight_out_valid_mesh_13(weight_out_valid_mesh_13));
  os_pe_11 \gen_row[3].gen_col[0].pe_inst 
       (.B(weight_reg__0),
        .D({\gen_row[2].gen_col[0].pe_inst_n_36 ,\gen_row[2].gen_col[0].pe_inst_n_37 ,\gen_row[2].gen_col[0].pe_inst_n_38 ,\gen_row[2].gen_col[0].pe_inst_n_39 ,\gen_row[2].gen_col[0].pe_inst_n_40 ,\gen_row[2].gen_col[0].pe_inst_n_41 ,\gen_row[2].gen_col[0].pe_inst_n_42 ,\gen_row[2].gen_col[0].pe_inst_n_43 ,\gen_row[2].gen_col[0].pe_inst_n_44 ,\gen_row[2].gen_col[0].pe_inst_n_45 ,\gen_row[2].gen_col[0].pe_inst_n_46 ,\gen_row[2].gen_col[0].pe_inst_n_47 ,\gen_row[2].gen_col[0].pe_inst_n_48 ,\gen_row[2].gen_col[0].pe_inst_n_49 ,\gen_row[2].gen_col[0].pe_inst_n_50 ,\gen_row[2].gen_col[0].pe_inst_n_51 }),
        .E(\gen_row[2].gen_col[0].pe_inst_n_33 ),
        .Q(output_data_OBUF[415:384]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .array_busy_reg_i_2(\gen_row[3].gen_col[2].pe_inst_n_50 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .flush_IBUF(flush_IBUF),
        .input_valid_reg(input_valid_reg_5),
        .input_valid_reg11_out(input_valid_reg11_out_10),
        .input_valid_reg_reg_0(\gen_row[3].gen_col[0].pe_inst_n_69 ),
        .weight_in_IBUF(weight_in_IBUF),
        .\weight_out_reg_reg[0]_0 (\gen_row[3].gen_col[0].pe_inst_n_86 ),
        .\weight_out_reg_reg[10]_0 (\gen_row[3].gen_col[0].pe_inst_n_76 ),
        .\weight_out_reg_reg[11]_0 (\gen_row[3].gen_col[0].pe_inst_n_75 ),
        .\weight_out_reg_reg[12]_0 (\gen_row[3].gen_col[0].pe_inst_n_74 ),
        .\weight_out_reg_reg[13]_0 (\gen_row[3].gen_col[0].pe_inst_n_73 ),
        .\weight_out_reg_reg[14]_0 (\gen_row[3].gen_col[0].pe_inst_n_72 ),
        .\weight_out_reg_reg[15]_0 (\gen_row[3].gen_col[0].pe_inst_n_71 ),
        .\weight_out_reg_reg[1]_0 (\gen_row[3].gen_col[0].pe_inst_n_85 ),
        .\weight_out_reg_reg[2]_0 (\gen_row[3].gen_col[0].pe_inst_n_84 ),
        .\weight_out_reg_reg[3]_0 (\gen_row[3].gen_col[0].pe_inst_n_83 ),
        .\weight_out_reg_reg[4]_0 (\gen_row[3].gen_col[0].pe_inst_n_82 ),
        .\weight_out_reg_reg[5]_0 (\gen_row[3].gen_col[0].pe_inst_n_81 ),
        .\weight_out_reg_reg[6]_0 (\gen_row[3].gen_col[0].pe_inst_n_80 ),
        .\weight_out_reg_reg[7]_0 (\gen_row[3].gen_col[0].pe_inst_n_79 ),
        .\weight_out_reg_reg[8]_0 (\gen_row[3].gen_col[0].pe_inst_n_78 ),
        .\weight_out_reg_reg[9]_0 (\gen_row[3].gen_col[0].pe_inst_n_77 ),
        .weight_out_valid_mesh_12(weight_out_valid_mesh_12),
        .weight_out_valid_reg_reg_0(\gen_row[3].gen_col[0].pe_inst_n_68 ),
        .weight_out_valid_reg_reg_1(\gen_row[3].gen_col[0].pe_inst_n_70 ),
        .\weight_reg_reg[15]_0 ({\gen_row[3].gen_col[0].pe_inst_n_48 ,\gen_row[3].gen_col[0].pe_inst_n_49 ,\gen_row[3].gen_col[0].pe_inst_n_50 ,\gen_row[3].gen_col[0].pe_inst_n_51 ,\gen_row[3].gen_col[0].pe_inst_n_52 ,\gen_row[3].gen_col[0].pe_inst_n_53 ,\gen_row[3].gen_col[0].pe_inst_n_54 ,\gen_row[3].gen_col[0].pe_inst_n_55 ,\gen_row[3].gen_col[0].pe_inst_n_56 ,\gen_row[3].gen_col[0].pe_inst_n_57 ,\gen_row[3].gen_col[0].pe_inst_n_58 ,\gen_row[3].gen_col[0].pe_inst_n_59 ,\gen_row[3].gen_col[0].pe_inst_n_60 ,\gen_row[3].gen_col[0].pe_inst_n_61 ,\gen_row[3].gen_col[0].pe_inst_n_62 ,\gen_row[3].gen_col[0].pe_inst_n_63 }),
        .weight_valid_IBUF(weight_valid_IBUF),
        .weight_valid_reg15_out(weight_valid_reg15_out),
        .weight_valid_reg_reg_0(\gen_row[3].gen_col[0].pe_inst_n_64 ),
        .weight_valid_reg_reg_1(\gen_row[3].gen_col[0].pe_inst_n_66 ));
  os_pe_12 \gen_row[3].gen_col[1].pe_inst 
       (.B(weight_reg__0_18),
        .D({\gen_row[2].gen_col[1].pe_inst_n_36 ,\gen_row[2].gen_col[1].pe_inst_n_37 ,\gen_row[2].gen_col[1].pe_inst_n_38 ,\gen_row[2].gen_col[1].pe_inst_n_39 ,\gen_row[2].gen_col[1].pe_inst_n_40 ,\gen_row[2].gen_col[1].pe_inst_n_41 ,\gen_row[2].gen_col[1].pe_inst_n_42 ,\gen_row[2].gen_col[1].pe_inst_n_43 ,\gen_row[2].gen_col[1].pe_inst_n_44 ,\gen_row[2].gen_col[1].pe_inst_n_45 ,\gen_row[2].gen_col[1].pe_inst_n_46 ,\gen_row[2].gen_col[1].pe_inst_n_47 ,\gen_row[2].gen_col[1].pe_inst_n_48 ,\gen_row[2].gen_col[1].pe_inst_n_49 ,\gen_row[2].gen_col[1].pe_inst_n_50 ,\gen_row[2].gen_col[1].pe_inst_n_51 }),
        .E(\gen_row[2].gen_col[1].pe_inst_n_34 ),
        .Q(output_data_OBUF[447:416]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .array_busy_reg_i_3(\gen_row[3].gen_col[0].pe_inst_n_64 ),
        .array_busy_reg_i_6_0(\gen_row[1].gen_col[0].pe_inst_n_32 ),
        .array_busy_reg_reg(\gen_row[0].gen_col[1].pe_inst_n_34 ),
        .array_busy_reg_reg_0(\gen_row[3].gen_col[0].pe_inst_n_70 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .flush_IBUF(flush_IBUF),
        .input_out_valid_mesh_0(input_out_valid_mesh_0),
        .input_out_valid_mesh_5(input_out_valid_mesh_5),
        .input_out_valid_reg_reg_0(\gen_row[3].gen_col[1].pe_inst_n_52 ),
        .input_out_valid_reg_reg_1(\gen_row[3].gen_col[1].pe_inst_n_56 ),
        .input_valid_reg(input_valid_reg_17),
        .input_valid_reg11_out(input_valid_reg11_out_11),
        .input_valid_reg_1(input_valid_reg),
        .\weight_out_reg_reg[0]_0 (\gen_row[3].gen_col[1].pe_inst_n_72 ),
        .\weight_out_reg_reg[10]_0 (\gen_row[3].gen_col[1].pe_inst_n_62 ),
        .\weight_out_reg_reg[11]_0 (\gen_row[3].gen_col[1].pe_inst_n_61 ),
        .\weight_out_reg_reg[12]_0 (\gen_row[3].gen_col[1].pe_inst_n_60 ),
        .\weight_out_reg_reg[13]_0 (\gen_row[3].gen_col[1].pe_inst_n_59 ),
        .\weight_out_reg_reg[14]_0 (\gen_row[3].gen_col[1].pe_inst_n_58 ),
        .\weight_out_reg_reg[15]_0 (\gen_row[3].gen_col[1].pe_inst_n_57 ),
        .\weight_out_reg_reg[1]_0 (\gen_row[3].gen_col[1].pe_inst_n_71 ),
        .\weight_out_reg_reg[2]_0 (\gen_row[3].gen_col[1].pe_inst_n_70 ),
        .\weight_out_reg_reg[3]_0 (\gen_row[3].gen_col[1].pe_inst_n_69 ),
        .\weight_out_reg_reg[4]_0 (\gen_row[3].gen_col[1].pe_inst_n_68 ),
        .\weight_out_reg_reg[5]_0 (\gen_row[3].gen_col[1].pe_inst_n_67 ),
        .\weight_out_reg_reg[6]_0 (\gen_row[3].gen_col[1].pe_inst_n_66 ),
        .\weight_out_reg_reg[7]_0 (\gen_row[3].gen_col[1].pe_inst_n_65 ),
        .\weight_out_reg_reg[8]_0 (\gen_row[3].gen_col[1].pe_inst_n_64 ),
        .\weight_out_reg_reg[9]_0 (\gen_row[3].gen_col[1].pe_inst_n_63 ),
        .weight_out_valid_mesh_12(weight_out_valid_mesh_12),
        .weight_out_valid_mesh_13(weight_out_valid_mesh_13),
        .weight_out_valid_mesh_14(weight_out_valid_mesh_14),
        .weight_out_valid_reg_reg_0(\gen_row[3].gen_col[1].pe_inst_n_54 ),
        .\weight_reg_reg[0]_0 (\gen_row[3].gen_col[0].pe_inst_n_86 ),
        .\weight_reg_reg[10]_0 (\gen_row[3].gen_col[0].pe_inst_n_76 ),
        .\weight_reg_reg[11]_0 (\gen_row[3].gen_col[0].pe_inst_n_75 ),
        .\weight_reg_reg[12]_0 (\gen_row[3].gen_col[0].pe_inst_n_74 ),
        .\weight_reg_reg[13]_0 (\gen_row[3].gen_col[0].pe_inst_n_73 ),
        .\weight_reg_reg[14]_0 (\gen_row[3].gen_col[0].pe_inst_n_72 ),
        .\weight_reg_reg[15]_0 (\gen_row[3].gen_col[0].pe_inst_n_68 ),
        .\weight_reg_reg[15]_1 (\gen_row[3].gen_col[0].pe_inst_n_71 ),
        .\weight_reg_reg[1]_0 (\gen_row[3].gen_col[0].pe_inst_n_85 ),
        .\weight_reg_reg[2]_0 (\gen_row[3].gen_col[0].pe_inst_n_84 ),
        .\weight_reg_reg[3]_0 (\gen_row[3].gen_col[0].pe_inst_n_83 ),
        .\weight_reg_reg[4]_0 (\gen_row[3].gen_col[0].pe_inst_n_82 ),
        .\weight_reg_reg[5]_0 (\gen_row[3].gen_col[0].pe_inst_n_81 ),
        .\weight_reg_reg[6]_0 (\gen_row[3].gen_col[0].pe_inst_n_80 ),
        .\weight_reg_reg[7]_0 (\gen_row[3].gen_col[0].pe_inst_n_79 ),
        .\weight_reg_reg[8]_0 (\gen_row[3].gen_col[0].pe_inst_n_78 ),
        .\weight_reg_reg[9]_0 (\gen_row[3].gen_col[0].pe_inst_n_77 ),
        .weight_valid_reg15_out(weight_valid_reg15_out_16),
        .weight_valid_reg15_out_0(weight_valid_reg15_out),
        .weight_valid_reg_reg_0(\gen_row[3].gen_col[1].pe_inst_n_48 ),
        .weight_valid_reg_reg_1(\gen_row[3].gen_col[1].pe_inst_n_49 ),
        .weight_valid_reg_reg_2(\gen_row[3].gen_col[1].pe_inst_n_55 ));
  os_pe_13 \gen_row[3].gen_col[2].pe_inst 
       (.B(weight_reg__0_21),
        .D({\gen_row[2].gen_col[2].pe_inst_n_37 ,\gen_row[2].gen_col[2].pe_inst_n_38 ,\gen_row[2].gen_col[2].pe_inst_n_39 ,\gen_row[2].gen_col[2].pe_inst_n_40 ,\gen_row[2].gen_col[2].pe_inst_n_41 ,\gen_row[2].gen_col[2].pe_inst_n_42 ,\gen_row[2].gen_col[2].pe_inst_n_43 ,\gen_row[2].gen_col[2].pe_inst_n_44 ,\gen_row[2].gen_col[2].pe_inst_n_45 ,\gen_row[2].gen_col[2].pe_inst_n_46 ,\gen_row[2].gen_col[2].pe_inst_n_47 ,\gen_row[2].gen_col[2].pe_inst_n_48 ,\gen_row[2].gen_col[2].pe_inst_n_49 ,\gen_row[2].gen_col[2].pe_inst_n_50 ,\gen_row[2].gen_col[2].pe_inst_n_51 ,\gen_row[2].gen_col[2].pe_inst_n_52 }),
        .E(\gen_row[2].gen_col[2].pe_inst_n_36 ),
        .Q(output_data_OBUF[479:448]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[3].gen_col[2].pe_inst_n_49 ),
        .flush_IBUF(flush_IBUF),
        .input_out_valid_reg_reg_0(\gen_row[3].gen_col[2].pe_inst_n_53 ),
        .input_valid_reg(input_valid_reg_20),
        .input_valid_reg11_out(input_valid_reg11_out_13),
        .\weight_out_reg_reg[0]_0 (\gen_row[3].gen_col[2].pe_inst_n_71 ),
        .\weight_out_reg_reg[10]_0 (\gen_row[3].gen_col[2].pe_inst_n_61 ),
        .\weight_out_reg_reg[11]_0 (\gen_row[3].gen_col[2].pe_inst_n_60 ),
        .\weight_out_reg_reg[12]_0 (\gen_row[3].gen_col[2].pe_inst_n_59 ),
        .\weight_out_reg_reg[13]_0 (\gen_row[3].gen_col[2].pe_inst_n_58 ),
        .\weight_out_reg_reg[14]_0 (\gen_row[3].gen_col[2].pe_inst_n_57 ),
        .\weight_out_reg_reg[15]_0 (\gen_row[3].gen_col[2].pe_inst_n_56 ),
        .\weight_out_reg_reg[1]_0 (\gen_row[3].gen_col[2].pe_inst_n_70 ),
        .\weight_out_reg_reg[2]_0 (\gen_row[3].gen_col[2].pe_inst_n_69 ),
        .\weight_out_reg_reg[3]_0 (\gen_row[3].gen_col[2].pe_inst_n_68 ),
        .\weight_out_reg_reg[4]_0 (\gen_row[3].gen_col[2].pe_inst_n_67 ),
        .\weight_out_reg_reg[5]_0 (\gen_row[3].gen_col[2].pe_inst_n_66 ),
        .\weight_out_reg_reg[6]_0 (\gen_row[3].gen_col[2].pe_inst_n_65 ),
        .\weight_out_reg_reg[7]_0 (\gen_row[3].gen_col[2].pe_inst_n_64 ),
        .\weight_out_reg_reg[8]_0 (\gen_row[3].gen_col[2].pe_inst_n_63 ),
        .\weight_out_reg_reg[9]_0 (\gen_row[3].gen_col[2].pe_inst_n_62 ),
        .weight_out_valid_mesh_14(weight_out_valid_mesh_14),
        .weight_out_valid_reg_reg_0(\gen_row[3].gen_col[2].pe_inst_n_55 ),
        .\weight_reg_reg[0]_0 (\gen_row[3].gen_col[1].pe_inst_n_72 ),
        .\weight_reg_reg[10]_0 (\gen_row[3].gen_col[1].pe_inst_n_62 ),
        .\weight_reg_reg[11]_0 (\gen_row[3].gen_col[1].pe_inst_n_61 ),
        .\weight_reg_reg[12]_0 (\gen_row[3].gen_col[1].pe_inst_n_60 ),
        .\weight_reg_reg[13]_0 (\gen_row[3].gen_col[1].pe_inst_n_59 ),
        .\weight_reg_reg[14]_0 (\gen_row[3].gen_col[1].pe_inst_n_58 ),
        .\weight_reg_reg[15]_0 (\gen_row[3].gen_col[1].pe_inst_n_54 ),
        .\weight_reg_reg[15]_1 (\gen_row[3].gen_col[1].pe_inst_n_57 ),
        .\weight_reg_reg[1]_0 (\gen_row[3].gen_col[1].pe_inst_n_71 ),
        .\weight_reg_reg[2]_0 (\gen_row[3].gen_col[1].pe_inst_n_70 ),
        .\weight_reg_reg[3]_0 (\gen_row[3].gen_col[1].pe_inst_n_69 ),
        .\weight_reg_reg[4]_0 (\gen_row[3].gen_col[1].pe_inst_n_68 ),
        .\weight_reg_reg[5]_0 (\gen_row[3].gen_col[1].pe_inst_n_67 ),
        .\weight_reg_reg[6]_0 (\gen_row[3].gen_col[1].pe_inst_n_66 ),
        .\weight_reg_reg[7]_0 (\gen_row[3].gen_col[1].pe_inst_n_65 ),
        .\weight_reg_reg[8]_0 (\gen_row[3].gen_col[1].pe_inst_n_64 ),
        .\weight_reg_reg[9]_0 (\gen_row[3].gen_col[1].pe_inst_n_63 ),
        .weight_valid_reg15_out(weight_valid_reg15_out_19),
        .weight_valid_reg15_out_0(weight_valid_reg15_out_16),
        .weight_valid_reg_reg_0(\gen_row[3].gen_col[2].pe_inst_n_48 ),
        .weight_valid_reg_reg_1(\gen_row[3].gen_col[2].pe_inst_n_50 ));
  os_pe_14 \gen_row[3].gen_col[3].pe_inst 
       (.B(weight_reg__0_23),
        .D({\gen_row[2].gen_col[3].pe_inst_n_35 ,\gen_row[2].gen_col[3].pe_inst_n_36 ,\gen_row[2].gen_col[3].pe_inst_n_37 ,\gen_row[2].gen_col[3].pe_inst_n_38 ,\gen_row[2].gen_col[3].pe_inst_n_39 ,\gen_row[2].gen_col[3].pe_inst_n_40 ,\gen_row[2].gen_col[3].pe_inst_n_41 ,\gen_row[2].gen_col[3].pe_inst_n_42 ,\gen_row[2].gen_col[3].pe_inst_n_43 ,\gen_row[2].gen_col[3].pe_inst_n_44 ,\gen_row[2].gen_col[3].pe_inst_n_45 ,\gen_row[2].gen_col[3].pe_inst_n_46 ,\gen_row[2].gen_col[3].pe_inst_n_47 ,\gen_row[2].gen_col[3].pe_inst_n_48 ,\gen_row[2].gen_col[3].pe_inst_n_49 ,\gen_row[2].gen_col[3].pe_inst_n_50 }),
        .E(\gen_row[2].gen_col[3].pe_inst_n_33 ),
        .Q(output_data_OBUF[511:480]),
        .accumulator_clr_IBUF(accumulator_clr_IBUF),
        .\accumulator_reg[0]_0 (\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .array_busy_reg_i_5(\gen_row[3].gen_col[2].pe_inst_n_50 ),
        .array_busy_reg_i_5_0(\gen_row[3].gen_col[1].pe_inst_n_52 ),
        .clk_IBUF_BUFG(clk_IBUF_BUFG),
        .computing_reg_0(\gen_row[3].gen_col[3].pe_inst_n_52 ),
        .flush_IBUF(flush_IBUF),
        .input_valid_reg(input_valid_reg_22),
        .input_valid_reg11_out(input_valid_reg11_out_15),
        .input_valid_reg_0(input_valid_reg_14),
        .weight_out_valid_mesh_13(weight_out_valid_mesh_13),
        .weight_out_valid_reg(weight_out_valid_reg),
        .\weight_reg_reg[0]_0 (\gen_row[3].gen_col[2].pe_inst_n_71 ),
        .\weight_reg_reg[10]_0 (\gen_row[3].gen_col[2].pe_inst_n_61 ),
        .\weight_reg_reg[11]_0 (\gen_row[3].gen_col[2].pe_inst_n_60 ),
        .\weight_reg_reg[12]_0 (\gen_row[3].gen_col[2].pe_inst_n_59 ),
        .\weight_reg_reg[13]_0 (\gen_row[3].gen_col[2].pe_inst_n_58 ),
        .\weight_reg_reg[14]_0 (\gen_row[3].gen_col[2].pe_inst_n_57 ),
        .\weight_reg_reg[15]_0 (\gen_row[3].gen_col[2].pe_inst_n_55 ),
        .\weight_reg_reg[15]_1 (\gen_row[3].gen_col[2].pe_inst_n_56 ),
        .\weight_reg_reg[1]_0 (\gen_row[3].gen_col[2].pe_inst_n_70 ),
        .\weight_reg_reg[2]_0 (\gen_row[3].gen_col[2].pe_inst_n_69 ),
        .\weight_reg_reg[3]_0 (\gen_row[3].gen_col[2].pe_inst_n_68 ),
        .\weight_reg_reg[4]_0 (\gen_row[3].gen_col[2].pe_inst_n_67 ),
        .\weight_reg_reg[5]_0 (\gen_row[3].gen_col[2].pe_inst_n_66 ),
        .\weight_reg_reg[6]_0 (\gen_row[3].gen_col[2].pe_inst_n_65 ),
        .\weight_reg_reg[7]_0 (\gen_row[3].gen_col[2].pe_inst_n_64 ),
        .\weight_reg_reg[8]_0 (\gen_row[3].gen_col[2].pe_inst_n_63 ),
        .\weight_reg_reg[9]_0 (\gen_row[3].gen_col[2].pe_inst_n_62 ),
        .weight_valid_reg15_out(weight_valid_reg15_out_19),
        .weight_valid_reg_reg_0(\gen_row[3].gen_col[3].pe_inst_n_48 ),
        .weight_valid_reg_reg_1(\gen_row[3].gen_col[3].pe_inst_n_51 ));
  IBUF \input_in_IBUF[0]_inst 
       (.I(input_in[0]),
        .O(input_in_IBUF[0]));
  IBUF \input_in_IBUF[10]_inst 
       (.I(input_in[10]),
        .O(input_in_IBUF[10]));
  IBUF \input_in_IBUF[11]_inst 
       (.I(input_in[11]),
        .O(input_in_IBUF[11]));
  IBUF \input_in_IBUF[12]_inst 
       (.I(input_in[12]),
        .O(input_in_IBUF[12]));
  IBUF \input_in_IBUF[13]_inst 
       (.I(input_in[13]),
        .O(input_in_IBUF[13]));
  IBUF \input_in_IBUF[14]_inst 
       (.I(input_in[14]),
        .O(input_in_IBUF[14]));
  IBUF \input_in_IBUF[15]_inst 
       (.I(input_in[15]),
        .O(input_in_IBUF[15]));
  IBUF \input_in_IBUF[16]_inst 
       (.I(input_in[16]),
        .O(input_in_IBUF[16]));
  IBUF \input_in_IBUF[17]_inst 
       (.I(input_in[17]),
        .O(input_in_IBUF[17]));
  IBUF \input_in_IBUF[18]_inst 
       (.I(input_in[18]),
        .O(input_in_IBUF[18]));
  IBUF \input_in_IBUF[19]_inst 
       (.I(input_in[19]),
        .O(input_in_IBUF[19]));
  IBUF \input_in_IBUF[1]_inst 
       (.I(input_in[1]),
        .O(input_in_IBUF[1]));
  IBUF \input_in_IBUF[20]_inst 
       (.I(input_in[20]),
        .O(input_in_IBUF[20]));
  IBUF \input_in_IBUF[21]_inst 
       (.I(input_in[21]),
        .O(input_in_IBUF[21]));
  IBUF \input_in_IBUF[22]_inst 
       (.I(input_in[22]),
        .O(input_in_IBUF[22]));
  IBUF \input_in_IBUF[23]_inst 
       (.I(input_in[23]),
        .O(input_in_IBUF[23]));
  IBUF \input_in_IBUF[24]_inst 
       (.I(input_in[24]),
        .O(input_in_IBUF[24]));
  IBUF \input_in_IBUF[25]_inst 
       (.I(input_in[25]),
        .O(input_in_IBUF[25]));
  IBUF \input_in_IBUF[26]_inst 
       (.I(input_in[26]),
        .O(input_in_IBUF[26]));
  IBUF \input_in_IBUF[27]_inst 
       (.I(input_in[27]),
        .O(input_in_IBUF[27]));
  IBUF \input_in_IBUF[28]_inst 
       (.I(input_in[28]),
        .O(input_in_IBUF[28]));
  IBUF \input_in_IBUF[29]_inst 
       (.I(input_in[29]),
        .O(input_in_IBUF[29]));
  IBUF \input_in_IBUF[2]_inst 
       (.I(input_in[2]),
        .O(input_in_IBUF[2]));
  IBUF \input_in_IBUF[30]_inst 
       (.I(input_in[30]),
        .O(input_in_IBUF[30]));
  IBUF \input_in_IBUF[31]_inst 
       (.I(input_in[31]),
        .O(input_in_IBUF[31]));
  IBUF \input_in_IBUF[32]_inst 
       (.I(input_in[32]),
        .O(input_in_IBUF[32]));
  IBUF \input_in_IBUF[33]_inst 
       (.I(input_in[33]),
        .O(input_in_IBUF[33]));
  IBUF \input_in_IBUF[34]_inst 
       (.I(input_in[34]),
        .O(input_in_IBUF[34]));
  IBUF \input_in_IBUF[35]_inst 
       (.I(input_in[35]),
        .O(input_in_IBUF[35]));
  IBUF \input_in_IBUF[36]_inst 
       (.I(input_in[36]),
        .O(input_in_IBUF[36]));
  IBUF \input_in_IBUF[37]_inst 
       (.I(input_in[37]),
        .O(input_in_IBUF[37]));
  IBUF \input_in_IBUF[38]_inst 
       (.I(input_in[38]),
        .O(input_in_IBUF[38]));
  IBUF \input_in_IBUF[39]_inst 
       (.I(input_in[39]),
        .O(input_in_IBUF[39]));
  IBUF \input_in_IBUF[3]_inst 
       (.I(input_in[3]),
        .O(input_in_IBUF[3]));
  IBUF \input_in_IBUF[40]_inst 
       (.I(input_in[40]),
        .O(input_in_IBUF[40]));
  IBUF \input_in_IBUF[41]_inst 
       (.I(input_in[41]),
        .O(input_in_IBUF[41]));
  IBUF \input_in_IBUF[42]_inst 
       (.I(input_in[42]),
        .O(input_in_IBUF[42]));
  IBUF \input_in_IBUF[43]_inst 
       (.I(input_in[43]),
        .O(input_in_IBUF[43]));
  IBUF \input_in_IBUF[44]_inst 
       (.I(input_in[44]),
        .O(input_in_IBUF[44]));
  IBUF \input_in_IBUF[45]_inst 
       (.I(input_in[45]),
        .O(input_in_IBUF[45]));
  IBUF \input_in_IBUF[46]_inst 
       (.I(input_in[46]),
        .O(input_in_IBUF[46]));
  IBUF \input_in_IBUF[47]_inst 
       (.I(input_in[47]),
        .O(input_in_IBUF[47]));
  IBUF \input_in_IBUF[48]_inst 
       (.I(input_in[48]),
        .O(input_in_IBUF[48]));
  IBUF \input_in_IBUF[49]_inst 
       (.I(input_in[49]),
        .O(input_in_IBUF[49]));
  IBUF \input_in_IBUF[4]_inst 
       (.I(input_in[4]),
        .O(input_in_IBUF[4]));
  IBUF \input_in_IBUF[50]_inst 
       (.I(input_in[50]),
        .O(input_in_IBUF[50]));
  IBUF \input_in_IBUF[51]_inst 
       (.I(input_in[51]),
        .O(input_in_IBUF[51]));
  IBUF \input_in_IBUF[52]_inst 
       (.I(input_in[52]),
        .O(input_in_IBUF[52]));
  IBUF \input_in_IBUF[53]_inst 
       (.I(input_in[53]),
        .O(input_in_IBUF[53]));
  IBUF \input_in_IBUF[54]_inst 
       (.I(input_in[54]),
        .O(input_in_IBUF[54]));
  IBUF \input_in_IBUF[55]_inst 
       (.I(input_in[55]),
        .O(input_in_IBUF[55]));
  IBUF \input_in_IBUF[56]_inst 
       (.I(input_in[56]),
        .O(input_in_IBUF[56]));
  IBUF \input_in_IBUF[57]_inst 
       (.I(input_in[57]),
        .O(input_in_IBUF[57]));
  IBUF \input_in_IBUF[58]_inst 
       (.I(input_in[58]),
        .O(input_in_IBUF[58]));
  IBUF \input_in_IBUF[59]_inst 
       (.I(input_in[59]),
        .O(input_in_IBUF[59]));
  IBUF \input_in_IBUF[5]_inst 
       (.I(input_in[5]),
        .O(input_in_IBUF[5]));
  IBUF \input_in_IBUF[60]_inst 
       (.I(input_in[60]),
        .O(input_in_IBUF[60]));
  IBUF \input_in_IBUF[61]_inst 
       (.I(input_in[61]),
        .O(input_in_IBUF[61]));
  IBUF \input_in_IBUF[62]_inst 
       (.I(input_in[62]),
        .O(input_in_IBUF[62]));
  IBUF \input_in_IBUF[63]_inst 
       (.I(input_in[63]),
        .O(input_in_IBUF[63]));
  IBUF \input_in_IBUF[6]_inst 
       (.I(input_in[6]),
        .O(input_in_IBUF[6]));
  IBUF \input_in_IBUF[7]_inst 
       (.I(input_in[7]),
        .O(input_in_IBUF[7]));
  IBUF \input_in_IBUF[8]_inst 
       (.I(input_in[8]),
        .O(input_in_IBUF[8]));
  IBUF \input_in_IBUF[9]_inst 
       (.I(input_in[9]),
        .O(input_in_IBUF[9]));
  OBUF \input_ready_OBUF[0]_inst 
       (.I(weight_ready_OBUF),
        .O(input_ready[0]));
  OBUF \input_ready_OBUF[1]_inst 
       (.I(weight_ready_OBUF),
        .O(input_ready[1]));
  OBUF \input_ready_OBUF[2]_inst 
       (.I(weight_ready_OBUF),
        .O(input_ready[2]));
  OBUF \input_ready_OBUF[3]_inst 
       (.I(weight_ready_OBUF),
        .O(input_ready[3]));
  LUT1 #(
    .INIT(2'h1)) 
    \input_ready_reg[3]_i_1 
       (.I0(flush_IBUF),
        .O(input_ready_comb));
  FDCE \input_ready_reg_reg[3] 
       (.C(clk_IBUF_BUFG),
        .CE(\<const1> ),
        .CLR(\gen_row[0].gen_col[2].pe_inst_n_32 ),
        .D(input_ready_comb),
        .Q(weight_ready_OBUF));
  IBUF \input_valid_IBUF[0]_inst 
       (.I(input_valid[0]),
        .O(input_valid_IBUF[0]));
  IBUF \input_valid_IBUF[1]_inst 
       (.I(input_valid[1]),
        .O(input_valid_IBUF[1]));
  IBUF \input_valid_IBUF[2]_inst 
       (.I(input_valid[2]),
        .O(input_valid_IBUF[2]));
  IBUF \input_valid_IBUF[3]_inst 
       (.I(input_valid[3]),
        .O(input_valid_IBUF[3]));
  OBUF \output_data_OBUF[0]_inst 
       (.I(output_data_OBUF[0]),
        .O(output_data[0]));
  OBUF \output_data_OBUF[100]_inst 
       (.I(output_data_OBUF[100]),
        .O(output_data[100]));
  OBUF \output_data_OBUF[101]_inst 
       (.I(output_data_OBUF[101]),
        .O(output_data[101]));
  OBUF \output_data_OBUF[102]_inst 
       (.I(output_data_OBUF[102]),
        .O(output_data[102]));
  OBUF \output_data_OBUF[103]_inst 
       (.I(output_data_OBUF[103]),
        .O(output_data[103]));
  OBUF \output_data_OBUF[104]_inst 
       (.I(output_data_OBUF[104]),
        .O(output_data[104]));
  OBUF \output_data_OBUF[105]_inst 
       (.I(output_data_OBUF[105]),
        .O(output_data[105]));
  OBUF \output_data_OBUF[106]_inst 
       (.I(output_data_OBUF[106]),
        .O(output_data[106]));
  OBUF \output_data_OBUF[107]_inst 
       (.I(output_data_OBUF[107]),
        .O(output_data[107]));
  OBUF \output_data_OBUF[108]_inst 
       (.I(output_data_OBUF[108]),
        .O(output_data[108]));
  OBUF \output_data_OBUF[109]_inst 
       (.I(output_data_OBUF[109]),
        .O(output_data[109]));
  OBUF \output_data_OBUF[10]_inst 
       (.I(output_data_OBUF[10]),
        .O(output_data[10]));
  OBUF \output_data_OBUF[110]_inst 
       (.I(output_data_OBUF[110]),
        .O(output_data[110]));
  OBUF \output_data_OBUF[111]_inst 
       (.I(output_data_OBUF[111]),
        .O(output_data[111]));
  OBUF \output_data_OBUF[112]_inst 
       (.I(output_data_OBUF[112]),
        .O(output_data[112]));
  OBUF \output_data_OBUF[113]_inst 
       (.I(output_data_OBUF[113]),
        .O(output_data[113]));
  OBUF \output_data_OBUF[114]_inst 
       (.I(output_data_OBUF[114]),
        .O(output_data[114]));
  OBUF \output_data_OBUF[115]_inst 
       (.I(output_data_OBUF[115]),
        .O(output_data[115]));
  OBUF \output_data_OBUF[116]_inst 
       (.I(output_data_OBUF[116]),
        .O(output_data[116]));
  OBUF \output_data_OBUF[117]_inst 
       (.I(output_data_OBUF[117]),
        .O(output_data[117]));
  OBUF \output_data_OBUF[118]_inst 
       (.I(output_data_OBUF[118]),
        .O(output_data[118]));
  OBUF \output_data_OBUF[119]_inst 
       (.I(output_data_OBUF[119]),
        .O(output_data[119]));
  OBUF \output_data_OBUF[11]_inst 
       (.I(output_data_OBUF[11]),
        .O(output_data[11]));
  OBUF \output_data_OBUF[120]_inst 
       (.I(output_data_OBUF[120]),
        .O(output_data[120]));
  OBUF \output_data_OBUF[121]_inst 
       (.I(output_data_OBUF[121]),
        .O(output_data[121]));
  OBUF \output_data_OBUF[122]_inst 
       (.I(output_data_OBUF[122]),
        .O(output_data[122]));
  OBUF \output_data_OBUF[123]_inst 
       (.I(output_data_OBUF[123]),
        .O(output_data[123]));
  OBUF \output_data_OBUF[124]_inst 
       (.I(output_data_OBUF[124]),
        .O(output_data[124]));
  OBUF \output_data_OBUF[125]_inst 
       (.I(output_data_OBUF[125]),
        .O(output_data[125]));
  OBUF \output_data_OBUF[126]_inst 
       (.I(output_data_OBUF[126]),
        .O(output_data[126]));
  OBUF \output_data_OBUF[127]_inst 
       (.I(output_data_OBUF[127]),
        .O(output_data[127]));
  OBUF \output_data_OBUF[128]_inst 
       (.I(output_data_OBUF[128]),
        .O(output_data[128]));
  OBUF \output_data_OBUF[129]_inst 
       (.I(output_data_OBUF[129]),
        .O(output_data[129]));
  OBUF \output_data_OBUF[12]_inst 
       (.I(output_data_OBUF[12]),
        .O(output_data[12]));
  OBUF \output_data_OBUF[130]_inst 
       (.I(output_data_OBUF[130]),
        .O(output_data[130]));
  OBUF \output_data_OBUF[131]_inst 
       (.I(output_data_OBUF[131]),
        .O(output_data[131]));
  OBUF \output_data_OBUF[132]_inst 
       (.I(output_data_OBUF[132]),
        .O(output_data[132]));
  OBUF \output_data_OBUF[133]_inst 
       (.I(output_data_OBUF[133]),
        .O(output_data[133]));
  OBUF \output_data_OBUF[134]_inst 
       (.I(output_data_OBUF[134]),
        .O(output_data[134]));
  OBUF \output_data_OBUF[135]_inst 
       (.I(output_data_OBUF[135]),
        .O(output_data[135]));
  OBUF \output_data_OBUF[136]_inst 
       (.I(output_data_OBUF[136]),
        .O(output_data[136]));
  OBUF \output_data_OBUF[137]_inst 
       (.I(output_data_OBUF[137]),
        .O(output_data[137]));
  OBUF \output_data_OBUF[138]_inst 
       (.I(output_data_OBUF[138]),
        .O(output_data[138]));
  OBUF \output_data_OBUF[139]_inst 
       (.I(output_data_OBUF[139]),
        .O(output_data[139]));
  OBUF \output_data_OBUF[13]_inst 
       (.I(output_data_OBUF[13]),
        .O(output_data[13]));
  OBUF \output_data_OBUF[140]_inst 
       (.I(output_data_OBUF[140]),
        .O(output_data[140]));
  OBUF \output_data_OBUF[141]_inst 
       (.I(output_data_OBUF[141]),
        .O(output_data[141]));
  OBUF \output_data_OBUF[142]_inst 
       (.I(output_data_OBUF[142]),
        .O(output_data[142]));
  OBUF \output_data_OBUF[143]_inst 
       (.I(output_data_OBUF[143]),
        .O(output_data[143]));
  OBUF \output_data_OBUF[144]_inst 
       (.I(output_data_OBUF[144]),
        .O(output_data[144]));
  OBUF \output_data_OBUF[145]_inst 
       (.I(output_data_OBUF[145]),
        .O(output_data[145]));
  OBUF \output_data_OBUF[146]_inst 
       (.I(output_data_OBUF[146]),
        .O(output_data[146]));
  OBUF \output_data_OBUF[147]_inst 
       (.I(output_data_OBUF[147]),
        .O(output_data[147]));
  OBUF \output_data_OBUF[148]_inst 
       (.I(output_data_OBUF[148]),
        .O(output_data[148]));
  OBUF \output_data_OBUF[149]_inst 
       (.I(output_data_OBUF[149]),
        .O(output_data[149]));
  OBUF \output_data_OBUF[14]_inst 
       (.I(output_data_OBUF[14]),
        .O(output_data[14]));
  OBUF \output_data_OBUF[150]_inst 
       (.I(output_data_OBUF[150]),
        .O(output_data[150]));
  OBUF \output_data_OBUF[151]_inst 
       (.I(output_data_OBUF[151]),
        .O(output_data[151]));
  OBUF \output_data_OBUF[152]_inst 
       (.I(output_data_OBUF[152]),
        .O(output_data[152]));
  OBUF \output_data_OBUF[153]_inst 
       (.I(output_data_OBUF[153]),
        .O(output_data[153]));
  OBUF \output_data_OBUF[154]_inst 
       (.I(output_data_OBUF[154]),
        .O(output_data[154]));
  OBUF \output_data_OBUF[155]_inst 
       (.I(output_data_OBUF[155]),
        .O(output_data[155]));
  OBUF \output_data_OBUF[156]_inst 
       (.I(output_data_OBUF[156]),
        .O(output_data[156]));
  OBUF \output_data_OBUF[157]_inst 
       (.I(output_data_OBUF[157]),
        .O(output_data[157]));
  OBUF \output_data_OBUF[158]_inst 
       (.I(output_data_OBUF[158]),
        .O(output_data[158]));
  OBUF \output_data_OBUF[159]_inst 
       (.I(output_data_OBUF[159]),
        .O(output_data[159]));
  OBUF \output_data_OBUF[15]_inst 
       (.I(output_data_OBUF[15]),
        .O(output_data[15]));
  OBUF \output_data_OBUF[160]_inst 
       (.I(output_data_OBUF[160]),
        .O(output_data[160]));
  OBUF \output_data_OBUF[161]_inst 
       (.I(output_data_OBUF[161]),
        .O(output_data[161]));
  OBUF \output_data_OBUF[162]_inst 
       (.I(output_data_OBUF[162]),
        .O(output_data[162]));
  OBUF \output_data_OBUF[163]_inst 
       (.I(output_data_OBUF[163]),
        .O(output_data[163]));
  OBUF \output_data_OBUF[164]_inst 
       (.I(output_data_OBUF[164]),
        .O(output_data[164]));
  OBUF \output_data_OBUF[165]_inst 
       (.I(output_data_OBUF[165]),
        .O(output_data[165]));
  OBUF \output_data_OBUF[166]_inst 
       (.I(output_data_OBUF[166]),
        .O(output_data[166]));
  OBUF \output_data_OBUF[167]_inst 
       (.I(output_data_OBUF[167]),
        .O(output_data[167]));
  OBUF \output_data_OBUF[168]_inst 
       (.I(output_data_OBUF[168]),
        .O(output_data[168]));
  OBUF \output_data_OBUF[169]_inst 
       (.I(output_data_OBUF[169]),
        .O(output_data[169]));
  OBUF \output_data_OBUF[16]_inst 
       (.I(output_data_OBUF[16]),
        .O(output_data[16]));
  OBUF \output_data_OBUF[170]_inst 
       (.I(output_data_OBUF[170]),
        .O(output_data[170]));
  OBUF \output_data_OBUF[171]_inst 
       (.I(output_data_OBUF[171]),
        .O(output_data[171]));
  OBUF \output_data_OBUF[172]_inst 
       (.I(output_data_OBUF[172]),
        .O(output_data[172]));
  OBUF \output_data_OBUF[173]_inst 
       (.I(output_data_OBUF[173]),
        .O(output_data[173]));
  OBUF \output_data_OBUF[174]_inst 
       (.I(output_data_OBUF[174]),
        .O(output_data[174]));
  OBUF \output_data_OBUF[175]_inst 
       (.I(output_data_OBUF[175]),
        .O(output_data[175]));
  OBUF \output_data_OBUF[176]_inst 
       (.I(output_data_OBUF[176]),
        .O(output_data[176]));
  OBUF \output_data_OBUF[177]_inst 
       (.I(output_data_OBUF[177]),
        .O(output_data[177]));
  OBUF \output_data_OBUF[178]_inst 
       (.I(output_data_OBUF[178]),
        .O(output_data[178]));
  OBUF \output_data_OBUF[179]_inst 
       (.I(output_data_OBUF[179]),
        .O(output_data[179]));
  OBUF \output_data_OBUF[17]_inst 
       (.I(output_data_OBUF[17]),
        .O(output_data[17]));
  OBUF \output_data_OBUF[180]_inst 
       (.I(output_data_OBUF[180]),
        .O(output_data[180]));
  OBUF \output_data_OBUF[181]_inst 
       (.I(output_data_OBUF[181]),
        .O(output_data[181]));
  OBUF \output_data_OBUF[182]_inst 
       (.I(output_data_OBUF[182]),
        .O(output_data[182]));
  OBUF \output_data_OBUF[183]_inst 
       (.I(output_data_OBUF[183]),
        .O(output_data[183]));
  OBUF \output_data_OBUF[184]_inst 
       (.I(output_data_OBUF[184]),
        .O(output_data[184]));
  OBUF \output_data_OBUF[185]_inst 
       (.I(output_data_OBUF[185]),
        .O(output_data[185]));
  OBUF \output_data_OBUF[186]_inst 
       (.I(output_data_OBUF[186]),
        .O(output_data[186]));
  OBUF \output_data_OBUF[187]_inst 
       (.I(output_data_OBUF[187]),
        .O(output_data[187]));
  OBUF \output_data_OBUF[188]_inst 
       (.I(output_data_OBUF[188]),
        .O(output_data[188]));
  OBUF \output_data_OBUF[189]_inst 
       (.I(output_data_OBUF[189]),
        .O(output_data[189]));
  OBUF \output_data_OBUF[18]_inst 
       (.I(output_data_OBUF[18]),
        .O(output_data[18]));
  OBUF \output_data_OBUF[190]_inst 
       (.I(output_data_OBUF[190]),
        .O(output_data[190]));
  OBUF \output_data_OBUF[191]_inst 
       (.I(output_data_OBUF[191]),
        .O(output_data[191]));
  OBUF \output_data_OBUF[192]_inst 
       (.I(output_data_OBUF[192]),
        .O(output_data[192]));
  OBUF \output_data_OBUF[193]_inst 
       (.I(output_data_OBUF[193]),
        .O(output_data[193]));
  OBUF \output_data_OBUF[194]_inst 
       (.I(output_data_OBUF[194]),
        .O(output_data[194]));
  OBUF \output_data_OBUF[195]_inst 
       (.I(output_data_OBUF[195]),
        .O(output_data[195]));
  OBUF \output_data_OBUF[196]_inst 
       (.I(output_data_OBUF[196]),
        .O(output_data[196]));
  OBUF \output_data_OBUF[197]_inst 
       (.I(output_data_OBUF[197]),
        .O(output_data[197]));
  OBUF \output_data_OBUF[198]_inst 
       (.I(output_data_OBUF[198]),
        .O(output_data[198]));
  OBUF \output_data_OBUF[199]_inst 
       (.I(output_data_OBUF[199]),
        .O(output_data[199]));
  OBUF \output_data_OBUF[19]_inst 
       (.I(output_data_OBUF[19]),
        .O(output_data[19]));
  OBUF \output_data_OBUF[1]_inst 
       (.I(output_data_OBUF[1]),
        .O(output_data[1]));
  OBUF \output_data_OBUF[200]_inst 
       (.I(output_data_OBUF[200]),
        .O(output_data[200]));
  OBUF \output_data_OBUF[201]_inst 
       (.I(output_data_OBUF[201]),
        .O(output_data[201]));
  OBUF \output_data_OBUF[202]_inst 
       (.I(output_data_OBUF[202]),
        .O(output_data[202]));
  OBUF \output_data_OBUF[203]_inst 
       (.I(output_data_OBUF[203]),
        .O(output_data[203]));
  OBUF \output_data_OBUF[204]_inst 
       (.I(output_data_OBUF[204]),
        .O(output_data[204]));
  OBUF \output_data_OBUF[205]_inst 
       (.I(output_data_OBUF[205]),
        .O(output_data[205]));
  OBUF \output_data_OBUF[206]_inst 
       (.I(output_data_OBUF[206]),
        .O(output_data[206]));
  OBUF \output_data_OBUF[207]_inst 
       (.I(output_data_OBUF[207]),
        .O(output_data[207]));
  OBUF \output_data_OBUF[208]_inst 
       (.I(output_data_OBUF[208]),
        .O(output_data[208]));
  OBUF \output_data_OBUF[209]_inst 
       (.I(output_data_OBUF[209]),
        .O(output_data[209]));
  OBUF \output_data_OBUF[20]_inst 
       (.I(output_data_OBUF[20]),
        .O(output_data[20]));
  OBUF \output_data_OBUF[210]_inst 
       (.I(output_data_OBUF[210]),
        .O(output_data[210]));
  OBUF \output_data_OBUF[211]_inst 
       (.I(output_data_OBUF[211]),
        .O(output_data[211]));
  OBUF \output_data_OBUF[212]_inst 
       (.I(output_data_OBUF[212]),
        .O(output_data[212]));
  OBUF \output_data_OBUF[213]_inst 
       (.I(output_data_OBUF[213]),
        .O(output_data[213]));
  OBUF \output_data_OBUF[214]_inst 
       (.I(output_data_OBUF[214]),
        .O(output_data[214]));
  OBUF \output_data_OBUF[215]_inst 
       (.I(output_data_OBUF[215]),
        .O(output_data[215]));
  OBUF \output_data_OBUF[216]_inst 
       (.I(output_data_OBUF[216]),
        .O(output_data[216]));
  OBUF \output_data_OBUF[217]_inst 
       (.I(output_data_OBUF[217]),
        .O(output_data[217]));
  OBUF \output_data_OBUF[218]_inst 
       (.I(output_data_OBUF[218]),
        .O(output_data[218]));
  OBUF \output_data_OBUF[219]_inst 
       (.I(output_data_OBUF[219]),
        .O(output_data[219]));
  OBUF \output_data_OBUF[21]_inst 
       (.I(output_data_OBUF[21]),
        .O(output_data[21]));
  OBUF \output_data_OBUF[220]_inst 
       (.I(output_data_OBUF[220]),
        .O(output_data[220]));
  OBUF \output_data_OBUF[221]_inst 
       (.I(output_data_OBUF[221]),
        .O(output_data[221]));
  OBUF \output_data_OBUF[222]_inst 
       (.I(output_data_OBUF[222]),
        .O(output_data[222]));
  OBUF \output_data_OBUF[223]_inst 
       (.I(output_data_OBUF[223]),
        .O(output_data[223]));
  OBUF \output_data_OBUF[224]_inst 
       (.I(output_data_OBUF[224]),
        .O(output_data[224]));
  OBUF \output_data_OBUF[225]_inst 
       (.I(output_data_OBUF[225]),
        .O(output_data[225]));
  OBUF \output_data_OBUF[226]_inst 
       (.I(output_data_OBUF[226]),
        .O(output_data[226]));
  OBUF \output_data_OBUF[227]_inst 
       (.I(output_data_OBUF[227]),
        .O(output_data[227]));
  OBUF \output_data_OBUF[228]_inst 
       (.I(output_data_OBUF[228]),
        .O(output_data[228]));
  OBUF \output_data_OBUF[229]_inst 
       (.I(output_data_OBUF[229]),
        .O(output_data[229]));
  OBUF \output_data_OBUF[22]_inst 
       (.I(output_data_OBUF[22]),
        .O(output_data[22]));
  OBUF \output_data_OBUF[230]_inst 
       (.I(output_data_OBUF[230]),
        .O(output_data[230]));
  OBUF \output_data_OBUF[231]_inst 
       (.I(output_data_OBUF[231]),
        .O(output_data[231]));
  OBUF \output_data_OBUF[232]_inst 
       (.I(output_data_OBUF[232]),
        .O(output_data[232]));
  OBUF \output_data_OBUF[233]_inst 
       (.I(output_data_OBUF[233]),
        .O(output_data[233]));
  OBUF \output_data_OBUF[234]_inst 
       (.I(output_data_OBUF[234]),
        .O(output_data[234]));
  OBUF \output_data_OBUF[235]_inst 
       (.I(output_data_OBUF[235]),
        .O(output_data[235]));
  OBUF \output_data_OBUF[236]_inst 
       (.I(output_data_OBUF[236]),
        .O(output_data[236]));
  OBUF \output_data_OBUF[237]_inst 
       (.I(output_data_OBUF[237]),
        .O(output_data[237]));
  OBUF \output_data_OBUF[238]_inst 
       (.I(output_data_OBUF[238]),
        .O(output_data[238]));
  OBUF \output_data_OBUF[239]_inst 
       (.I(output_data_OBUF[239]),
        .O(output_data[239]));
  OBUF \output_data_OBUF[23]_inst 
       (.I(output_data_OBUF[23]),
        .O(output_data[23]));
  OBUF \output_data_OBUF[240]_inst 
       (.I(output_data_OBUF[240]),
        .O(output_data[240]));
  OBUF \output_data_OBUF[241]_inst 
       (.I(output_data_OBUF[241]),
        .O(output_data[241]));
  OBUF \output_data_OBUF[242]_inst 
       (.I(output_data_OBUF[242]),
        .O(output_data[242]));
  OBUF \output_data_OBUF[243]_inst 
       (.I(output_data_OBUF[243]),
        .O(output_data[243]));
  OBUF \output_data_OBUF[244]_inst 
       (.I(output_data_OBUF[244]),
        .O(output_data[244]));
  OBUF \output_data_OBUF[245]_inst 
       (.I(output_data_OBUF[245]),
        .O(output_data[245]));
  OBUF \output_data_OBUF[246]_inst 
       (.I(output_data_OBUF[246]),
        .O(output_data[246]));
  OBUF \output_data_OBUF[247]_inst 
       (.I(output_data_OBUF[247]),
        .O(output_data[247]));
  OBUF \output_data_OBUF[248]_inst 
       (.I(output_data_OBUF[248]),
        .O(output_data[248]));
  OBUF \output_data_OBUF[249]_inst 
       (.I(output_data_OBUF[249]),
        .O(output_data[249]));
  OBUF \output_data_OBUF[24]_inst 
       (.I(output_data_OBUF[24]),
        .O(output_data[24]));
  OBUF \output_data_OBUF[250]_inst 
       (.I(output_data_OBUF[250]),
        .O(output_data[250]));
  OBUF \output_data_OBUF[251]_inst 
       (.I(output_data_OBUF[251]),
        .O(output_data[251]));
  OBUF \output_data_OBUF[252]_inst 
       (.I(output_data_OBUF[252]),
        .O(output_data[252]));
  OBUF \output_data_OBUF[253]_inst 
       (.I(output_data_OBUF[253]),
        .O(output_data[253]));
  OBUF \output_data_OBUF[254]_inst 
       (.I(output_data_OBUF[254]),
        .O(output_data[254]));
  OBUF \output_data_OBUF[255]_inst 
       (.I(output_data_OBUF[255]),
        .O(output_data[255]));
  OBUF \output_data_OBUF[256]_inst 
       (.I(output_data_OBUF[256]),
        .O(output_data[256]));
  OBUF \output_data_OBUF[257]_inst 
       (.I(output_data_OBUF[257]),
        .O(output_data[257]));
  OBUF \output_data_OBUF[258]_inst 
       (.I(output_data_OBUF[258]),
        .O(output_data[258]));
  OBUF \output_data_OBUF[259]_inst 
       (.I(output_data_OBUF[259]),
        .O(output_data[259]));
  OBUF \output_data_OBUF[25]_inst 
       (.I(output_data_OBUF[25]),
        .O(output_data[25]));
  OBUF \output_data_OBUF[260]_inst 
       (.I(output_data_OBUF[260]),
        .O(output_data[260]));
  OBUF \output_data_OBUF[261]_inst 
       (.I(output_data_OBUF[261]),
        .O(output_data[261]));
  OBUF \output_data_OBUF[262]_inst 
       (.I(output_data_OBUF[262]),
        .O(output_data[262]));
  OBUF \output_data_OBUF[263]_inst 
       (.I(output_data_OBUF[263]),
        .O(output_data[263]));
  OBUF \output_data_OBUF[264]_inst 
       (.I(output_data_OBUF[264]),
        .O(output_data[264]));
  OBUF \output_data_OBUF[265]_inst 
       (.I(output_data_OBUF[265]),
        .O(output_data[265]));
  OBUF \output_data_OBUF[266]_inst 
       (.I(output_data_OBUF[266]),
        .O(output_data[266]));
  OBUF \output_data_OBUF[267]_inst 
       (.I(output_data_OBUF[267]),
        .O(output_data[267]));
  OBUF \output_data_OBUF[268]_inst 
       (.I(output_data_OBUF[268]),
        .O(output_data[268]));
  OBUF \output_data_OBUF[269]_inst 
       (.I(output_data_OBUF[269]),
        .O(output_data[269]));
  OBUF \output_data_OBUF[26]_inst 
       (.I(output_data_OBUF[26]),
        .O(output_data[26]));
  OBUF \output_data_OBUF[270]_inst 
       (.I(output_data_OBUF[270]),
        .O(output_data[270]));
  OBUF \output_data_OBUF[271]_inst 
       (.I(output_data_OBUF[271]),
        .O(output_data[271]));
  OBUF \output_data_OBUF[272]_inst 
       (.I(output_data_OBUF[272]),
        .O(output_data[272]));
  OBUF \output_data_OBUF[273]_inst 
       (.I(output_data_OBUF[273]),
        .O(output_data[273]));
  OBUF \output_data_OBUF[274]_inst 
       (.I(output_data_OBUF[274]),
        .O(output_data[274]));
  OBUF \output_data_OBUF[275]_inst 
       (.I(output_data_OBUF[275]),
        .O(output_data[275]));
  OBUF \output_data_OBUF[276]_inst 
       (.I(output_data_OBUF[276]),
        .O(output_data[276]));
  OBUF \output_data_OBUF[277]_inst 
       (.I(output_data_OBUF[277]),
        .O(output_data[277]));
  OBUF \output_data_OBUF[278]_inst 
       (.I(output_data_OBUF[278]),
        .O(output_data[278]));
  OBUF \output_data_OBUF[279]_inst 
       (.I(output_data_OBUF[279]),
        .O(output_data[279]));
  OBUF \output_data_OBUF[27]_inst 
       (.I(output_data_OBUF[27]),
        .O(output_data[27]));
  OBUF \output_data_OBUF[280]_inst 
       (.I(output_data_OBUF[280]),
        .O(output_data[280]));
  OBUF \output_data_OBUF[281]_inst 
       (.I(output_data_OBUF[281]),
        .O(output_data[281]));
  OBUF \output_data_OBUF[282]_inst 
       (.I(output_data_OBUF[282]),
        .O(output_data[282]));
  OBUF \output_data_OBUF[283]_inst 
       (.I(output_data_OBUF[283]),
        .O(output_data[283]));
  OBUF \output_data_OBUF[284]_inst 
       (.I(output_data_OBUF[284]),
        .O(output_data[284]));
  OBUF \output_data_OBUF[285]_inst 
       (.I(output_data_OBUF[285]),
        .O(output_data[285]));
  OBUF \output_data_OBUF[286]_inst 
       (.I(output_data_OBUF[286]),
        .O(output_data[286]));
  OBUF \output_data_OBUF[287]_inst 
       (.I(output_data_OBUF[287]),
        .O(output_data[287]));
  OBUF \output_data_OBUF[288]_inst 
       (.I(output_data_OBUF[288]),
        .O(output_data[288]));
  OBUF \output_data_OBUF[289]_inst 
       (.I(output_data_OBUF[289]),
        .O(output_data[289]));
  OBUF \output_data_OBUF[28]_inst 
       (.I(output_data_OBUF[28]),
        .O(output_data[28]));
  OBUF \output_data_OBUF[290]_inst 
       (.I(output_data_OBUF[290]),
        .O(output_data[290]));
  OBUF \output_data_OBUF[291]_inst 
       (.I(output_data_OBUF[291]),
        .O(output_data[291]));
  OBUF \output_data_OBUF[292]_inst 
       (.I(output_data_OBUF[292]),
        .O(output_data[292]));
  OBUF \output_data_OBUF[293]_inst 
       (.I(output_data_OBUF[293]),
        .O(output_data[293]));
  OBUF \output_data_OBUF[294]_inst 
       (.I(output_data_OBUF[294]),
        .O(output_data[294]));
  OBUF \output_data_OBUF[295]_inst 
       (.I(output_data_OBUF[295]),
        .O(output_data[295]));
  OBUF \output_data_OBUF[296]_inst 
       (.I(output_data_OBUF[296]),
        .O(output_data[296]));
  OBUF \output_data_OBUF[297]_inst 
       (.I(output_data_OBUF[297]),
        .O(output_data[297]));
  OBUF \output_data_OBUF[298]_inst 
       (.I(output_data_OBUF[298]),
        .O(output_data[298]));
  OBUF \output_data_OBUF[299]_inst 
       (.I(output_data_OBUF[299]),
        .O(output_data[299]));
  OBUF \output_data_OBUF[29]_inst 
       (.I(output_data_OBUF[29]),
        .O(output_data[29]));
  OBUF \output_data_OBUF[2]_inst 
       (.I(output_data_OBUF[2]),
        .O(output_data[2]));
  OBUF \output_data_OBUF[300]_inst 
       (.I(output_data_OBUF[300]),
        .O(output_data[300]));
  OBUF \output_data_OBUF[301]_inst 
       (.I(output_data_OBUF[301]),
        .O(output_data[301]));
  OBUF \output_data_OBUF[302]_inst 
       (.I(output_data_OBUF[302]),
        .O(output_data[302]));
  OBUF \output_data_OBUF[303]_inst 
       (.I(output_data_OBUF[303]),
        .O(output_data[303]));
  OBUF \output_data_OBUF[304]_inst 
       (.I(output_data_OBUF[304]),
        .O(output_data[304]));
  OBUF \output_data_OBUF[305]_inst 
       (.I(output_data_OBUF[305]),
        .O(output_data[305]));
  OBUF \output_data_OBUF[306]_inst 
       (.I(output_data_OBUF[306]),
        .O(output_data[306]));
  OBUF \output_data_OBUF[307]_inst 
       (.I(output_data_OBUF[307]),
        .O(output_data[307]));
  OBUF \output_data_OBUF[308]_inst 
       (.I(output_data_OBUF[308]),
        .O(output_data[308]));
  OBUF \output_data_OBUF[309]_inst 
       (.I(output_data_OBUF[309]),
        .O(output_data[309]));
  OBUF \output_data_OBUF[30]_inst 
       (.I(output_data_OBUF[30]),
        .O(output_data[30]));
  OBUF \output_data_OBUF[310]_inst 
       (.I(output_data_OBUF[310]),
        .O(output_data[310]));
  OBUF \output_data_OBUF[311]_inst 
       (.I(output_data_OBUF[311]),
        .O(output_data[311]));
  OBUF \output_data_OBUF[312]_inst 
       (.I(output_data_OBUF[312]),
        .O(output_data[312]));
  OBUF \output_data_OBUF[313]_inst 
       (.I(output_data_OBUF[313]),
        .O(output_data[313]));
  OBUF \output_data_OBUF[314]_inst 
       (.I(output_data_OBUF[314]),
        .O(output_data[314]));
  OBUF \output_data_OBUF[315]_inst 
       (.I(output_data_OBUF[315]),
        .O(output_data[315]));
  OBUF \output_data_OBUF[316]_inst 
       (.I(output_data_OBUF[316]),
        .O(output_data[316]));
  OBUF \output_data_OBUF[317]_inst 
       (.I(output_data_OBUF[317]),
        .O(output_data[317]));
  OBUF \output_data_OBUF[318]_inst 
       (.I(output_data_OBUF[318]),
        .O(output_data[318]));
  OBUF \output_data_OBUF[319]_inst 
       (.I(output_data_OBUF[319]),
        .O(output_data[319]));
  OBUF \output_data_OBUF[31]_inst 
       (.I(output_data_OBUF[31]),
        .O(output_data[31]));
  OBUF \output_data_OBUF[320]_inst 
       (.I(output_data_OBUF[320]),
        .O(output_data[320]));
  OBUF \output_data_OBUF[321]_inst 
       (.I(output_data_OBUF[321]),
        .O(output_data[321]));
  OBUF \output_data_OBUF[322]_inst 
       (.I(output_data_OBUF[322]),
        .O(output_data[322]));
  OBUF \output_data_OBUF[323]_inst 
       (.I(output_data_OBUF[323]),
        .O(output_data[323]));
  OBUF \output_data_OBUF[324]_inst 
       (.I(output_data_OBUF[324]),
        .O(output_data[324]));
  OBUF \output_data_OBUF[325]_inst 
       (.I(output_data_OBUF[325]),
        .O(output_data[325]));
  OBUF \output_data_OBUF[326]_inst 
       (.I(output_data_OBUF[326]),
        .O(output_data[326]));
  OBUF \output_data_OBUF[327]_inst 
       (.I(output_data_OBUF[327]),
        .O(output_data[327]));
  OBUF \output_data_OBUF[328]_inst 
       (.I(output_data_OBUF[328]),
        .O(output_data[328]));
  OBUF \output_data_OBUF[329]_inst 
       (.I(output_data_OBUF[329]),
        .O(output_data[329]));
  OBUF \output_data_OBUF[32]_inst 
       (.I(output_data_OBUF[32]),
        .O(output_data[32]));
  OBUF \output_data_OBUF[330]_inst 
       (.I(output_data_OBUF[330]),
        .O(output_data[330]));
  OBUF \output_data_OBUF[331]_inst 
       (.I(output_data_OBUF[331]),
        .O(output_data[331]));
  OBUF \output_data_OBUF[332]_inst 
       (.I(output_data_OBUF[332]),
        .O(output_data[332]));
  OBUF \output_data_OBUF[333]_inst 
       (.I(output_data_OBUF[333]),
        .O(output_data[333]));
  OBUF \output_data_OBUF[334]_inst 
       (.I(output_data_OBUF[334]),
        .O(output_data[334]));
  OBUF \output_data_OBUF[335]_inst 
       (.I(output_data_OBUF[335]),
        .O(output_data[335]));
  OBUF \output_data_OBUF[336]_inst 
       (.I(output_data_OBUF[336]),
        .O(output_data[336]));
  OBUF \output_data_OBUF[337]_inst 
       (.I(output_data_OBUF[337]),
        .O(output_data[337]));
  OBUF \output_data_OBUF[338]_inst 
       (.I(output_data_OBUF[338]),
        .O(output_data[338]));
  OBUF \output_data_OBUF[339]_inst 
       (.I(output_data_OBUF[339]),
        .O(output_data[339]));
  OBUF \output_data_OBUF[33]_inst 
       (.I(output_data_OBUF[33]),
        .O(output_data[33]));
  OBUF \output_data_OBUF[340]_inst 
       (.I(output_data_OBUF[340]),
        .O(output_data[340]));
  OBUF \output_data_OBUF[341]_inst 
       (.I(output_data_OBUF[341]),
        .O(output_data[341]));
  OBUF \output_data_OBUF[342]_inst 
       (.I(output_data_OBUF[342]),
        .O(output_data[342]));
  OBUF \output_data_OBUF[343]_inst 
       (.I(output_data_OBUF[343]),
        .O(output_data[343]));
  OBUF \output_data_OBUF[344]_inst 
       (.I(output_data_OBUF[344]),
        .O(output_data[344]));
  OBUF \output_data_OBUF[345]_inst 
       (.I(output_data_OBUF[345]),
        .O(output_data[345]));
  OBUF \output_data_OBUF[346]_inst 
       (.I(output_data_OBUF[346]),
        .O(output_data[346]));
  OBUF \output_data_OBUF[347]_inst 
       (.I(output_data_OBUF[347]),
        .O(output_data[347]));
  OBUF \output_data_OBUF[348]_inst 
       (.I(output_data_OBUF[348]),
        .O(output_data[348]));
  OBUF \output_data_OBUF[349]_inst 
       (.I(output_data_OBUF[349]),
        .O(output_data[349]));
  OBUF \output_data_OBUF[34]_inst 
       (.I(output_data_OBUF[34]),
        .O(output_data[34]));
  OBUF \output_data_OBUF[350]_inst 
       (.I(output_data_OBUF[350]),
        .O(output_data[350]));
  OBUF \output_data_OBUF[351]_inst 
       (.I(output_data_OBUF[351]),
        .O(output_data[351]));
  OBUF \output_data_OBUF[352]_inst 
       (.I(output_data_OBUF[352]),
        .O(output_data[352]));
  OBUF \output_data_OBUF[353]_inst 
       (.I(output_data_OBUF[353]),
        .O(output_data[353]));
  OBUF \output_data_OBUF[354]_inst 
       (.I(output_data_OBUF[354]),
        .O(output_data[354]));
  OBUF \output_data_OBUF[355]_inst 
       (.I(output_data_OBUF[355]),
        .O(output_data[355]));
  OBUF \output_data_OBUF[356]_inst 
       (.I(output_data_OBUF[356]),
        .O(output_data[356]));
  OBUF \output_data_OBUF[357]_inst 
       (.I(output_data_OBUF[357]),
        .O(output_data[357]));
  OBUF \output_data_OBUF[358]_inst 
       (.I(output_data_OBUF[358]),
        .O(output_data[358]));
  OBUF \output_data_OBUF[359]_inst 
       (.I(output_data_OBUF[359]),
        .O(output_data[359]));
  OBUF \output_data_OBUF[35]_inst 
       (.I(output_data_OBUF[35]),
        .O(output_data[35]));
  OBUF \output_data_OBUF[360]_inst 
       (.I(output_data_OBUF[360]),
        .O(output_data[360]));
  OBUF \output_data_OBUF[361]_inst 
       (.I(output_data_OBUF[361]),
        .O(output_data[361]));
  OBUF \output_data_OBUF[362]_inst 
       (.I(output_data_OBUF[362]),
        .O(output_data[362]));
  OBUF \output_data_OBUF[363]_inst 
       (.I(output_data_OBUF[363]),
        .O(output_data[363]));
  OBUF \output_data_OBUF[364]_inst 
       (.I(output_data_OBUF[364]),
        .O(output_data[364]));
  OBUF \output_data_OBUF[365]_inst 
       (.I(output_data_OBUF[365]),
        .O(output_data[365]));
  OBUF \output_data_OBUF[366]_inst 
       (.I(output_data_OBUF[366]),
        .O(output_data[366]));
  OBUF \output_data_OBUF[367]_inst 
       (.I(output_data_OBUF[367]),
        .O(output_data[367]));
  OBUF \output_data_OBUF[368]_inst 
       (.I(output_data_OBUF[368]),
        .O(output_data[368]));
  OBUF \output_data_OBUF[369]_inst 
       (.I(output_data_OBUF[369]),
        .O(output_data[369]));
  OBUF \output_data_OBUF[36]_inst 
       (.I(output_data_OBUF[36]),
        .O(output_data[36]));
  OBUF \output_data_OBUF[370]_inst 
       (.I(output_data_OBUF[370]),
        .O(output_data[370]));
  OBUF \output_data_OBUF[371]_inst 
       (.I(output_data_OBUF[371]),
        .O(output_data[371]));
  OBUF \output_data_OBUF[372]_inst 
       (.I(output_data_OBUF[372]),
        .O(output_data[372]));
  OBUF \output_data_OBUF[373]_inst 
       (.I(output_data_OBUF[373]),
        .O(output_data[373]));
  OBUF \output_data_OBUF[374]_inst 
       (.I(output_data_OBUF[374]),
        .O(output_data[374]));
  OBUF \output_data_OBUF[375]_inst 
       (.I(output_data_OBUF[375]),
        .O(output_data[375]));
  OBUF \output_data_OBUF[376]_inst 
       (.I(output_data_OBUF[376]),
        .O(output_data[376]));
  OBUF \output_data_OBUF[377]_inst 
       (.I(output_data_OBUF[377]),
        .O(output_data[377]));
  OBUF \output_data_OBUF[378]_inst 
       (.I(output_data_OBUF[378]),
        .O(output_data[378]));
  OBUF \output_data_OBUF[379]_inst 
       (.I(output_data_OBUF[379]),
        .O(output_data[379]));
  OBUF \output_data_OBUF[37]_inst 
       (.I(output_data_OBUF[37]),
        .O(output_data[37]));
  OBUF \output_data_OBUF[380]_inst 
       (.I(output_data_OBUF[380]),
        .O(output_data[380]));
  OBUF \output_data_OBUF[381]_inst 
       (.I(output_data_OBUF[381]),
        .O(output_data[381]));
  OBUF \output_data_OBUF[382]_inst 
       (.I(output_data_OBUF[382]),
        .O(output_data[382]));
  OBUF \output_data_OBUF[383]_inst 
       (.I(output_data_OBUF[383]),
        .O(output_data[383]));
  OBUF \output_data_OBUF[384]_inst 
       (.I(output_data_OBUF[384]),
        .O(output_data[384]));
  OBUF \output_data_OBUF[385]_inst 
       (.I(output_data_OBUF[385]),
        .O(output_data[385]));
  OBUF \output_data_OBUF[386]_inst 
       (.I(output_data_OBUF[386]),
        .O(output_data[386]));
  OBUF \output_data_OBUF[387]_inst 
       (.I(output_data_OBUF[387]),
        .O(output_data[387]));
  OBUF \output_data_OBUF[388]_inst 
       (.I(output_data_OBUF[388]),
        .O(output_data[388]));
  OBUF \output_data_OBUF[389]_inst 
       (.I(output_data_OBUF[389]),
        .O(output_data[389]));
  OBUF \output_data_OBUF[38]_inst 
       (.I(output_data_OBUF[38]),
        .O(output_data[38]));
  OBUF \output_data_OBUF[390]_inst 
       (.I(output_data_OBUF[390]),
        .O(output_data[390]));
  OBUF \output_data_OBUF[391]_inst 
       (.I(output_data_OBUF[391]),
        .O(output_data[391]));
  OBUF \output_data_OBUF[392]_inst 
       (.I(output_data_OBUF[392]),
        .O(output_data[392]));
  OBUF \output_data_OBUF[393]_inst 
       (.I(output_data_OBUF[393]),
        .O(output_data[393]));
  OBUF \output_data_OBUF[394]_inst 
       (.I(output_data_OBUF[394]),
        .O(output_data[394]));
  OBUF \output_data_OBUF[395]_inst 
       (.I(output_data_OBUF[395]),
        .O(output_data[395]));
  OBUF \output_data_OBUF[396]_inst 
       (.I(output_data_OBUF[396]),
        .O(output_data[396]));
  OBUF \output_data_OBUF[397]_inst 
       (.I(output_data_OBUF[397]),
        .O(output_data[397]));
  OBUF \output_data_OBUF[398]_inst 
       (.I(output_data_OBUF[398]),
        .O(output_data[398]));
  OBUF \output_data_OBUF[399]_inst 
       (.I(output_data_OBUF[399]),
        .O(output_data[399]));
  OBUF \output_data_OBUF[39]_inst 
       (.I(output_data_OBUF[39]),
        .O(output_data[39]));
  OBUF \output_data_OBUF[3]_inst 
       (.I(output_data_OBUF[3]),
        .O(output_data[3]));
  OBUF \output_data_OBUF[400]_inst 
       (.I(output_data_OBUF[400]),
        .O(output_data[400]));
  OBUF \output_data_OBUF[401]_inst 
       (.I(output_data_OBUF[401]),
        .O(output_data[401]));
  OBUF \output_data_OBUF[402]_inst 
       (.I(output_data_OBUF[402]),
        .O(output_data[402]));
  OBUF \output_data_OBUF[403]_inst 
       (.I(output_data_OBUF[403]),
        .O(output_data[403]));
  OBUF \output_data_OBUF[404]_inst 
       (.I(output_data_OBUF[404]),
        .O(output_data[404]));
  OBUF \output_data_OBUF[405]_inst 
       (.I(output_data_OBUF[405]),
        .O(output_data[405]));
  OBUF \output_data_OBUF[406]_inst 
       (.I(output_data_OBUF[406]),
        .O(output_data[406]));
  OBUF \output_data_OBUF[407]_inst 
       (.I(output_data_OBUF[407]),
        .O(output_data[407]));
  OBUF \output_data_OBUF[408]_inst 
       (.I(output_data_OBUF[408]),
        .O(output_data[408]));
  OBUF \output_data_OBUF[409]_inst 
       (.I(output_data_OBUF[409]),
        .O(output_data[409]));
  OBUF \output_data_OBUF[40]_inst 
       (.I(output_data_OBUF[40]),
        .O(output_data[40]));
  OBUF \output_data_OBUF[410]_inst 
       (.I(output_data_OBUF[410]),
        .O(output_data[410]));
  OBUF \output_data_OBUF[411]_inst 
       (.I(output_data_OBUF[411]),
        .O(output_data[411]));
  OBUF \output_data_OBUF[412]_inst 
       (.I(output_data_OBUF[412]),
        .O(output_data[412]));
  OBUF \output_data_OBUF[413]_inst 
       (.I(output_data_OBUF[413]),
        .O(output_data[413]));
  OBUF \output_data_OBUF[414]_inst 
       (.I(output_data_OBUF[414]),
        .O(output_data[414]));
  OBUF \output_data_OBUF[415]_inst 
       (.I(output_data_OBUF[415]),
        .O(output_data[415]));
  OBUF \output_data_OBUF[416]_inst 
       (.I(output_data_OBUF[416]),
        .O(output_data[416]));
  OBUF \output_data_OBUF[417]_inst 
       (.I(output_data_OBUF[417]),
        .O(output_data[417]));
  OBUF \output_data_OBUF[418]_inst 
       (.I(output_data_OBUF[418]),
        .O(output_data[418]));
  OBUF \output_data_OBUF[419]_inst 
       (.I(output_data_OBUF[419]),
        .O(output_data[419]));
  OBUF \output_data_OBUF[41]_inst 
       (.I(output_data_OBUF[41]),
        .O(output_data[41]));
  OBUF \output_data_OBUF[420]_inst 
       (.I(output_data_OBUF[420]),
        .O(output_data[420]));
  OBUF \output_data_OBUF[421]_inst 
       (.I(output_data_OBUF[421]),
        .O(output_data[421]));
  OBUF \output_data_OBUF[422]_inst 
       (.I(output_data_OBUF[422]),
        .O(output_data[422]));
  OBUF \output_data_OBUF[423]_inst 
       (.I(output_data_OBUF[423]),
        .O(output_data[423]));
  OBUF \output_data_OBUF[424]_inst 
       (.I(output_data_OBUF[424]),
        .O(output_data[424]));
  OBUF \output_data_OBUF[425]_inst 
       (.I(output_data_OBUF[425]),
        .O(output_data[425]));
  OBUF \output_data_OBUF[426]_inst 
       (.I(output_data_OBUF[426]),
        .O(output_data[426]));
  OBUF \output_data_OBUF[427]_inst 
       (.I(output_data_OBUF[427]),
        .O(output_data[427]));
  OBUF \output_data_OBUF[428]_inst 
       (.I(output_data_OBUF[428]),
        .O(output_data[428]));
  OBUF \output_data_OBUF[429]_inst 
       (.I(output_data_OBUF[429]),
        .O(output_data[429]));
  OBUF \output_data_OBUF[42]_inst 
       (.I(output_data_OBUF[42]),
        .O(output_data[42]));
  OBUF \output_data_OBUF[430]_inst 
       (.I(output_data_OBUF[430]),
        .O(output_data[430]));
  OBUF \output_data_OBUF[431]_inst 
       (.I(output_data_OBUF[431]),
        .O(output_data[431]));
  OBUF \output_data_OBUF[432]_inst 
       (.I(output_data_OBUF[432]),
        .O(output_data[432]));
  OBUF \output_data_OBUF[433]_inst 
       (.I(output_data_OBUF[433]),
        .O(output_data[433]));
  OBUF \output_data_OBUF[434]_inst 
       (.I(output_data_OBUF[434]),
        .O(output_data[434]));
  OBUF \output_data_OBUF[435]_inst 
       (.I(output_data_OBUF[435]),
        .O(output_data[435]));
  OBUF \output_data_OBUF[436]_inst 
       (.I(output_data_OBUF[436]),
        .O(output_data[436]));
  OBUF \output_data_OBUF[437]_inst 
       (.I(output_data_OBUF[437]),
        .O(output_data[437]));
  OBUF \output_data_OBUF[438]_inst 
       (.I(output_data_OBUF[438]),
        .O(output_data[438]));
  OBUF \output_data_OBUF[439]_inst 
       (.I(output_data_OBUF[439]),
        .O(output_data[439]));
  OBUF \output_data_OBUF[43]_inst 
       (.I(output_data_OBUF[43]),
        .O(output_data[43]));
  OBUF \output_data_OBUF[440]_inst 
       (.I(output_data_OBUF[440]),
        .O(output_data[440]));
  OBUF \output_data_OBUF[441]_inst 
       (.I(output_data_OBUF[441]),
        .O(output_data[441]));
  OBUF \output_data_OBUF[442]_inst 
       (.I(output_data_OBUF[442]),
        .O(output_data[442]));
  OBUF \output_data_OBUF[443]_inst 
       (.I(output_data_OBUF[443]),
        .O(output_data[443]));
  OBUF \output_data_OBUF[444]_inst 
       (.I(output_data_OBUF[444]),
        .O(output_data[444]));
  OBUF \output_data_OBUF[445]_inst 
       (.I(output_data_OBUF[445]),
        .O(output_data[445]));
  OBUF \output_data_OBUF[446]_inst 
       (.I(output_data_OBUF[446]),
        .O(output_data[446]));
  OBUF \output_data_OBUF[447]_inst 
       (.I(output_data_OBUF[447]),
        .O(output_data[447]));
  OBUF \output_data_OBUF[448]_inst 
       (.I(output_data_OBUF[448]),
        .O(output_data[448]));
  OBUF \output_data_OBUF[449]_inst 
       (.I(output_data_OBUF[449]),
        .O(output_data[449]));
  OBUF \output_data_OBUF[44]_inst 
       (.I(output_data_OBUF[44]),
        .O(output_data[44]));
  OBUF \output_data_OBUF[450]_inst 
       (.I(output_data_OBUF[450]),
        .O(output_data[450]));
  OBUF \output_data_OBUF[451]_inst 
       (.I(output_data_OBUF[451]),
        .O(output_data[451]));
  OBUF \output_data_OBUF[452]_inst 
       (.I(output_data_OBUF[452]),
        .O(output_data[452]));
  OBUF \output_data_OBUF[453]_inst 
       (.I(output_data_OBUF[453]),
        .O(output_data[453]));
  OBUF \output_data_OBUF[454]_inst 
       (.I(output_data_OBUF[454]),
        .O(output_data[454]));
  OBUF \output_data_OBUF[455]_inst 
       (.I(output_data_OBUF[455]),
        .O(output_data[455]));
  OBUF \output_data_OBUF[456]_inst 
       (.I(output_data_OBUF[456]),
        .O(output_data[456]));
  OBUF \output_data_OBUF[457]_inst 
       (.I(output_data_OBUF[457]),
        .O(output_data[457]));
  OBUF \output_data_OBUF[458]_inst 
       (.I(output_data_OBUF[458]),
        .O(output_data[458]));
  OBUF \output_data_OBUF[459]_inst 
       (.I(output_data_OBUF[459]),
        .O(output_data[459]));
  OBUF \output_data_OBUF[45]_inst 
       (.I(output_data_OBUF[45]),
        .O(output_data[45]));
  OBUF \output_data_OBUF[460]_inst 
       (.I(output_data_OBUF[460]),
        .O(output_data[460]));
  OBUF \output_data_OBUF[461]_inst 
       (.I(output_data_OBUF[461]),
        .O(output_data[461]));
  OBUF \output_data_OBUF[462]_inst 
       (.I(output_data_OBUF[462]),
        .O(output_data[462]));
  OBUF \output_data_OBUF[463]_inst 
       (.I(output_data_OBUF[463]),
        .O(output_data[463]));
  OBUF \output_data_OBUF[464]_inst 
       (.I(output_data_OBUF[464]),
        .O(output_data[464]));
  OBUF \output_data_OBUF[465]_inst 
       (.I(output_data_OBUF[465]),
        .O(output_data[465]));
  OBUF \output_data_OBUF[466]_inst 
       (.I(output_data_OBUF[466]),
        .O(output_data[466]));
  OBUF \output_data_OBUF[467]_inst 
       (.I(output_data_OBUF[467]),
        .O(output_data[467]));
  OBUF \output_data_OBUF[468]_inst 
       (.I(output_data_OBUF[468]),
        .O(output_data[468]));
  OBUF \output_data_OBUF[469]_inst 
       (.I(output_data_OBUF[469]),
        .O(output_data[469]));
  OBUF \output_data_OBUF[46]_inst 
       (.I(output_data_OBUF[46]),
        .O(output_data[46]));
  OBUF \output_data_OBUF[470]_inst 
       (.I(output_data_OBUF[470]),
        .O(output_data[470]));
  OBUF \output_data_OBUF[471]_inst 
       (.I(output_data_OBUF[471]),
        .O(output_data[471]));
  OBUF \output_data_OBUF[472]_inst 
       (.I(output_data_OBUF[472]),
        .O(output_data[472]));
  OBUF \output_data_OBUF[473]_inst 
       (.I(output_data_OBUF[473]),
        .O(output_data[473]));
  OBUF \output_data_OBUF[474]_inst 
       (.I(output_data_OBUF[474]),
        .O(output_data[474]));
  OBUF \output_data_OBUF[475]_inst 
       (.I(output_data_OBUF[475]),
        .O(output_data[475]));
  OBUF \output_data_OBUF[476]_inst 
       (.I(output_data_OBUF[476]),
        .O(output_data[476]));
  OBUF \output_data_OBUF[477]_inst 
       (.I(output_data_OBUF[477]),
        .O(output_data[477]));
  OBUF \output_data_OBUF[478]_inst 
       (.I(output_data_OBUF[478]),
        .O(output_data[478]));
  OBUF \output_data_OBUF[479]_inst 
       (.I(output_data_OBUF[479]),
        .O(output_data[479]));
  OBUF \output_data_OBUF[47]_inst 
       (.I(output_data_OBUF[47]),
        .O(output_data[47]));
  OBUF \output_data_OBUF[480]_inst 
       (.I(output_data_OBUF[480]),
        .O(output_data[480]));
  OBUF \output_data_OBUF[481]_inst 
       (.I(output_data_OBUF[481]),
        .O(output_data[481]));
  OBUF \output_data_OBUF[482]_inst 
       (.I(output_data_OBUF[482]),
        .O(output_data[482]));
  OBUF \output_data_OBUF[483]_inst 
       (.I(output_data_OBUF[483]),
        .O(output_data[483]));
  OBUF \output_data_OBUF[484]_inst 
       (.I(output_data_OBUF[484]),
        .O(output_data[484]));
  OBUF \output_data_OBUF[485]_inst 
       (.I(output_data_OBUF[485]),
        .O(output_data[485]));
  OBUF \output_data_OBUF[486]_inst 
       (.I(output_data_OBUF[486]),
        .O(output_data[486]));
  OBUF \output_data_OBUF[487]_inst 
       (.I(output_data_OBUF[487]),
        .O(output_data[487]));
  OBUF \output_data_OBUF[488]_inst 
       (.I(output_data_OBUF[488]),
        .O(output_data[488]));
  OBUF \output_data_OBUF[489]_inst 
       (.I(output_data_OBUF[489]),
        .O(output_data[489]));
  OBUF \output_data_OBUF[48]_inst 
       (.I(output_data_OBUF[48]),
        .O(output_data[48]));
  OBUF \output_data_OBUF[490]_inst 
       (.I(output_data_OBUF[490]),
        .O(output_data[490]));
  OBUF \output_data_OBUF[491]_inst 
       (.I(output_data_OBUF[491]),
        .O(output_data[491]));
  OBUF \output_data_OBUF[492]_inst 
       (.I(output_data_OBUF[492]),
        .O(output_data[492]));
  OBUF \output_data_OBUF[493]_inst 
       (.I(output_data_OBUF[493]),
        .O(output_data[493]));
  OBUF \output_data_OBUF[494]_inst 
       (.I(output_data_OBUF[494]),
        .O(output_data[494]));
  OBUF \output_data_OBUF[495]_inst 
       (.I(output_data_OBUF[495]),
        .O(output_data[495]));
  OBUF \output_data_OBUF[496]_inst 
       (.I(output_data_OBUF[496]),
        .O(output_data[496]));
  OBUF \output_data_OBUF[497]_inst 
       (.I(output_data_OBUF[497]),
        .O(output_data[497]));
  OBUF \output_data_OBUF[498]_inst 
       (.I(output_data_OBUF[498]),
        .O(output_data[498]));
  OBUF \output_data_OBUF[499]_inst 
       (.I(output_data_OBUF[499]),
        .O(output_data[499]));
  OBUF \output_data_OBUF[49]_inst 
       (.I(output_data_OBUF[49]),
        .O(output_data[49]));
  OBUF \output_data_OBUF[4]_inst 
       (.I(output_data_OBUF[4]),
        .O(output_data[4]));
  OBUF \output_data_OBUF[500]_inst 
       (.I(output_data_OBUF[500]),
        .O(output_data[500]));
  OBUF \output_data_OBUF[501]_inst 
       (.I(output_data_OBUF[501]),
        .O(output_data[501]));
  OBUF \output_data_OBUF[502]_inst 
       (.I(output_data_OBUF[502]),
        .O(output_data[502]));
  OBUF \output_data_OBUF[503]_inst 
       (.I(output_data_OBUF[503]),
        .O(output_data[503]));
  OBUF \output_data_OBUF[504]_inst 
       (.I(output_data_OBUF[504]),
        .O(output_data[504]));
  OBUF \output_data_OBUF[505]_inst 
       (.I(output_data_OBUF[505]),
        .O(output_data[505]));
  OBUF \output_data_OBUF[506]_inst 
       (.I(output_data_OBUF[506]),
        .O(output_data[506]));
  OBUF \output_data_OBUF[507]_inst 
       (.I(output_data_OBUF[507]),
        .O(output_data[507]));
  OBUF \output_data_OBUF[508]_inst 
       (.I(output_data_OBUF[508]),
        .O(output_data[508]));
  OBUF \output_data_OBUF[509]_inst 
       (.I(output_data_OBUF[509]),
        .O(output_data[509]));
  OBUF \output_data_OBUF[50]_inst 
       (.I(output_data_OBUF[50]),
        .O(output_data[50]));
  OBUF \output_data_OBUF[510]_inst 
       (.I(output_data_OBUF[510]),
        .O(output_data[510]));
  OBUF \output_data_OBUF[511]_inst 
       (.I(output_data_OBUF[511]),
        .O(output_data[511]));
  OBUF \output_data_OBUF[51]_inst 
       (.I(output_data_OBUF[51]),
        .O(output_data[51]));
  OBUF \output_data_OBUF[52]_inst 
       (.I(output_data_OBUF[52]),
        .O(output_data[52]));
  OBUF \output_data_OBUF[53]_inst 
       (.I(output_data_OBUF[53]),
        .O(output_data[53]));
  OBUF \output_data_OBUF[54]_inst 
       (.I(output_data_OBUF[54]),
        .O(output_data[54]));
  OBUF \output_data_OBUF[55]_inst 
       (.I(output_data_OBUF[55]),
        .O(output_data[55]));
  OBUF \output_data_OBUF[56]_inst 
       (.I(output_data_OBUF[56]),
        .O(output_data[56]));
  OBUF \output_data_OBUF[57]_inst 
       (.I(output_data_OBUF[57]),
        .O(output_data[57]));
  OBUF \output_data_OBUF[58]_inst 
       (.I(output_data_OBUF[58]),
        .O(output_data[58]));
  OBUF \output_data_OBUF[59]_inst 
       (.I(output_data_OBUF[59]),
        .O(output_data[59]));
  OBUF \output_data_OBUF[5]_inst 
       (.I(output_data_OBUF[5]),
        .O(output_data[5]));
  OBUF \output_data_OBUF[60]_inst 
       (.I(output_data_OBUF[60]),
        .O(output_data[60]));
  OBUF \output_data_OBUF[61]_inst 
       (.I(output_data_OBUF[61]),
        .O(output_data[61]));
  OBUF \output_data_OBUF[62]_inst 
       (.I(output_data_OBUF[62]),
        .O(output_data[62]));
  OBUF \output_data_OBUF[63]_inst 
       (.I(output_data_OBUF[63]),
        .O(output_data[63]));
  OBUF \output_data_OBUF[64]_inst 
       (.I(output_data_OBUF[64]),
        .O(output_data[64]));
  OBUF \output_data_OBUF[65]_inst 
       (.I(output_data_OBUF[65]),
        .O(output_data[65]));
  OBUF \output_data_OBUF[66]_inst 
       (.I(output_data_OBUF[66]),
        .O(output_data[66]));
  OBUF \output_data_OBUF[67]_inst 
       (.I(output_data_OBUF[67]),
        .O(output_data[67]));
  OBUF \output_data_OBUF[68]_inst 
       (.I(output_data_OBUF[68]),
        .O(output_data[68]));
  OBUF \output_data_OBUF[69]_inst 
       (.I(output_data_OBUF[69]),
        .O(output_data[69]));
  OBUF \output_data_OBUF[6]_inst 
       (.I(output_data_OBUF[6]),
        .O(output_data[6]));
  OBUF \output_data_OBUF[70]_inst 
       (.I(output_data_OBUF[70]),
        .O(output_data[70]));
  OBUF \output_data_OBUF[71]_inst 
       (.I(output_data_OBUF[71]),
        .O(output_data[71]));
  OBUF \output_data_OBUF[72]_inst 
       (.I(output_data_OBUF[72]),
        .O(output_data[72]));
  OBUF \output_data_OBUF[73]_inst 
       (.I(output_data_OBUF[73]),
        .O(output_data[73]));
  OBUF \output_data_OBUF[74]_inst 
       (.I(output_data_OBUF[74]),
        .O(output_data[74]));
  OBUF \output_data_OBUF[75]_inst 
       (.I(output_data_OBUF[75]),
        .O(output_data[75]));
  OBUF \output_data_OBUF[76]_inst 
       (.I(output_data_OBUF[76]),
        .O(output_data[76]));
  OBUF \output_data_OBUF[77]_inst 
       (.I(output_data_OBUF[77]),
        .O(output_data[77]));
  OBUF \output_data_OBUF[78]_inst 
       (.I(output_data_OBUF[78]),
        .O(output_data[78]));
  OBUF \output_data_OBUF[79]_inst 
       (.I(output_data_OBUF[79]),
        .O(output_data[79]));
  OBUF \output_data_OBUF[7]_inst 
       (.I(output_data_OBUF[7]),
        .O(output_data[7]));
  OBUF \output_data_OBUF[80]_inst 
       (.I(output_data_OBUF[80]),
        .O(output_data[80]));
  OBUF \output_data_OBUF[81]_inst 
       (.I(output_data_OBUF[81]),
        .O(output_data[81]));
  OBUF \output_data_OBUF[82]_inst 
       (.I(output_data_OBUF[82]),
        .O(output_data[82]));
  OBUF \output_data_OBUF[83]_inst 
       (.I(output_data_OBUF[83]),
        .O(output_data[83]));
  OBUF \output_data_OBUF[84]_inst 
       (.I(output_data_OBUF[84]),
        .O(output_data[84]));
  OBUF \output_data_OBUF[85]_inst 
       (.I(output_data_OBUF[85]),
        .O(output_data[85]));
  OBUF \output_data_OBUF[86]_inst 
       (.I(output_data_OBUF[86]),
        .O(output_data[86]));
  OBUF \output_data_OBUF[87]_inst 
       (.I(output_data_OBUF[87]),
        .O(output_data[87]));
  OBUF \output_data_OBUF[88]_inst 
       (.I(output_data_OBUF[88]),
        .O(output_data[88]));
  OBUF \output_data_OBUF[89]_inst 
       (.I(output_data_OBUF[89]),
        .O(output_data[89]));
  OBUF \output_data_OBUF[8]_inst 
       (.I(output_data_OBUF[8]),
        .O(output_data[8]));
  OBUF \output_data_OBUF[90]_inst 
       (.I(output_data_OBUF[90]),
        .O(output_data[90]));
  OBUF \output_data_OBUF[91]_inst 
       (.I(output_data_OBUF[91]),
        .O(output_data[91]));
  OBUF \output_data_OBUF[92]_inst 
       (.I(output_data_OBUF[92]),
        .O(output_data[92]));
  OBUF \output_data_OBUF[93]_inst 
       (.I(output_data_OBUF[93]),
        .O(output_data[93]));
  OBUF \output_data_OBUF[94]_inst 
       (.I(output_data_OBUF[94]),
        .O(output_data[94]));
  OBUF \output_data_OBUF[95]_inst 
       (.I(output_data_OBUF[95]),
        .O(output_data[95]));
  OBUF \output_data_OBUF[96]_inst 
       (.I(output_data_OBUF[96]),
        .O(output_data[96]));
  OBUF \output_data_OBUF[97]_inst 
       (.I(output_data_OBUF[97]),
        .O(output_data[97]));
  OBUF \output_data_OBUF[98]_inst 
       (.I(output_data_OBUF[98]),
        .O(output_data[98]));
  OBUF \output_data_OBUF[99]_inst 
       (.I(output_data_OBUF[99]),
        .O(output_data[99]));
  OBUF \output_data_OBUF[9]_inst 
       (.I(output_data_OBUF[9]),
        .O(output_data[9]));
  OBUF \output_valid_OBUF[0]_inst 
       (.I(\<const0> ),
        .O(output_valid[0]));
  OBUF \output_valid_OBUF[10]_inst 
       (.I(\<const0> ),
        .O(output_valid[10]));
  OBUF \output_valid_OBUF[11]_inst 
       (.I(\<const0> ),
        .O(output_valid[11]));
  OBUF \output_valid_OBUF[12]_inst 
       (.I(\<const0> ),
        .O(output_valid[12]));
  OBUF \output_valid_OBUF[13]_inst 
       (.I(\<const0> ),
        .O(output_valid[13]));
  OBUF \output_valid_OBUF[14]_inst 
       (.I(\<const0> ),
        .O(output_valid[14]));
  OBUF \output_valid_OBUF[15]_inst 
       (.I(\<const0> ),
        .O(output_valid[15]));
  OBUF \output_valid_OBUF[1]_inst 
       (.I(\<const0> ),
        .O(output_valid[1]));
  OBUF \output_valid_OBUF[2]_inst 
       (.I(\<const0> ),
        .O(output_valid[2]));
  OBUF \output_valid_OBUF[3]_inst 
       (.I(\<const0> ),
        .O(output_valid[3]));
  OBUF \output_valid_OBUF[4]_inst 
       (.I(\<const0> ),
        .O(output_valid[4]));
  OBUF \output_valid_OBUF[5]_inst 
       (.I(\<const0> ),
        .O(output_valid[5]));
  OBUF \output_valid_OBUF[6]_inst 
       (.I(\<const0> ),
        .O(output_valid[6]));
  OBUF \output_valid_OBUF[7]_inst 
       (.I(\<const0> ),
        .O(output_valid[7]));
  OBUF \output_valid_OBUF[8]_inst 
       (.I(\<const0> ),
        .O(output_valid[8]));
  OBUF \output_valid_OBUF[9]_inst 
       (.I(\<const0> ),
        .O(output_valid[9]));
  IBUF rst_n_IBUF_inst
       (.I(rst_n),
        .O(rst_n_IBUF));
  IBUF \weight_in_IBUF[0]_inst 
       (.I(weight_in[0]),
        .O(weight_in_IBUF[0]));
  IBUF \weight_in_IBUF[10]_inst 
       (.I(weight_in[10]),
        .O(weight_in_IBUF[10]));
  IBUF \weight_in_IBUF[11]_inst 
       (.I(weight_in[11]),
        .O(weight_in_IBUF[11]));
  IBUF \weight_in_IBUF[12]_inst 
       (.I(weight_in[12]),
        .O(weight_in_IBUF[12]));
  IBUF \weight_in_IBUF[13]_inst 
       (.I(weight_in[13]),
        .O(weight_in_IBUF[13]));
  IBUF \weight_in_IBUF[14]_inst 
       (.I(weight_in[14]),
        .O(weight_in_IBUF[14]));
  IBUF \weight_in_IBUF[15]_inst 
       (.I(weight_in[15]),
        .O(weight_in_IBUF[15]));
  IBUF \weight_in_IBUF[1]_inst 
       (.I(weight_in[1]),
        .O(weight_in_IBUF[1]));
  IBUF \weight_in_IBUF[2]_inst 
       (.I(weight_in[2]),
        .O(weight_in_IBUF[2]));
  IBUF \weight_in_IBUF[3]_inst 
       (.I(weight_in[3]),
        .O(weight_in_IBUF[3]));
  IBUF \weight_in_IBUF[4]_inst 
       (.I(weight_in[4]),
        .O(weight_in_IBUF[4]));
  IBUF \weight_in_IBUF[5]_inst 
       (.I(weight_in[5]),
        .O(weight_in_IBUF[5]));
  IBUF \weight_in_IBUF[6]_inst 
       (.I(weight_in[6]),
        .O(weight_in_IBUF[6]));
  IBUF \weight_in_IBUF[7]_inst 
       (.I(weight_in[7]),
        .O(weight_in_IBUF[7]));
  IBUF \weight_in_IBUF[8]_inst 
       (.I(weight_in[8]),
        .O(weight_in_IBUF[8]));
  IBUF \weight_in_IBUF[9]_inst 
       (.I(weight_in[9]),
        .O(weight_in_IBUF[9]));
  OBUF weight_ready_OBUF_inst
       (.I(weight_ready_OBUF),
        .O(weight_ready));
  IBUF weight_valid_IBUF_inst
       (.I(weight_valid),
        .O(weight_valid_IBUF));
endmodule
