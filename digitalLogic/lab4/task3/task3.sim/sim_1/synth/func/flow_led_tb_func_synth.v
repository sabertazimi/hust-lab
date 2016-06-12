// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.1 (lin64) Build 1538259 Fri Apr  8 15:45:23 MDT 2016
// Date        : Sun Jun 12 18:41:16 2016
// Host        : avalon running 64-bit Ubuntu 16.04 LTS
// Command     : write_verilog -mode funcsim -nolib -force -file
//               /home/sabertazimi/gitrepo/hust-lab/digitalLogic/lab4/task3/task3.sim/sim_1/synth/func/flow_led_tb_func_synth.v
// Design      : flow_led
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module binary_counter
   (CLK,
    clk_src,
    AR,
    clk_sel_IBUF);
  output CLK;
  input clk_src;
  input [0:0]AR;
  input [4:0]clk_sel_IBUF;

  wire [0:0]AR;
  wire CLK;
  wire \FSM_sequential_state[3]_i_10_n_0 ;
  wire \FSM_sequential_state[3]_i_11_n_0 ;
  wire \FSM_sequential_state[3]_i_12_n_0 ;
  wire \FSM_sequential_state[3]_i_13_n_0 ;
  wire \FSM_sequential_state[3]_i_14_n_0 ;
  wire \FSM_sequential_state[3]_i_7_n_0 ;
  wire \FSM_sequential_state[3]_i_8_n_0 ;
  wire \FSM_sequential_state[3]_i_9_n_0 ;
  wire \FSM_sequential_state_reg[3]_i_3_n_0 ;
  wire \FSM_sequential_state_reg[3]_i_4_n_0 ;
  wire \FSM_sequential_state_reg[3]_i_5_n_0 ;
  wire \FSM_sequential_state_reg[3]_i_6_n_0 ;
  wire [31:0]clk_group;
  wire \clk_group[0]_i_5_n_0 ;
  wire \clk_group_reg[0]_i_1_n_0 ;
  wire \clk_group_reg[0]_i_1_n_1 ;
  wire \clk_group_reg[0]_i_1_n_2 ;
  wire \clk_group_reg[0]_i_1_n_3 ;
  wire \clk_group_reg[0]_i_1_n_4 ;
  wire \clk_group_reg[0]_i_1_n_5 ;
  wire \clk_group_reg[0]_i_1_n_6 ;
  wire \clk_group_reg[0]_i_1_n_7 ;
  wire \clk_group_reg[12]_i_1_n_0 ;
  wire \clk_group_reg[12]_i_1_n_1 ;
  wire \clk_group_reg[12]_i_1_n_2 ;
  wire \clk_group_reg[12]_i_1_n_3 ;
  wire \clk_group_reg[12]_i_1_n_4 ;
  wire \clk_group_reg[12]_i_1_n_5 ;
  wire \clk_group_reg[12]_i_1_n_6 ;
  wire \clk_group_reg[12]_i_1_n_7 ;
  wire \clk_group_reg[16]_i_1_n_0 ;
  wire \clk_group_reg[16]_i_1_n_1 ;
  wire \clk_group_reg[16]_i_1_n_2 ;
  wire \clk_group_reg[16]_i_1_n_3 ;
  wire \clk_group_reg[16]_i_1_n_4 ;
  wire \clk_group_reg[16]_i_1_n_5 ;
  wire \clk_group_reg[16]_i_1_n_6 ;
  wire \clk_group_reg[16]_i_1_n_7 ;
  wire \clk_group_reg[20]_i_1_n_0 ;
  wire \clk_group_reg[20]_i_1_n_1 ;
  wire \clk_group_reg[20]_i_1_n_2 ;
  wire \clk_group_reg[20]_i_1_n_3 ;
  wire \clk_group_reg[20]_i_1_n_4 ;
  wire \clk_group_reg[20]_i_1_n_5 ;
  wire \clk_group_reg[20]_i_1_n_6 ;
  wire \clk_group_reg[20]_i_1_n_7 ;
  wire \clk_group_reg[24]_i_1_n_0 ;
  wire \clk_group_reg[24]_i_1_n_1 ;
  wire \clk_group_reg[24]_i_1_n_2 ;
  wire \clk_group_reg[24]_i_1_n_3 ;
  wire \clk_group_reg[24]_i_1_n_4 ;
  wire \clk_group_reg[24]_i_1_n_5 ;
  wire \clk_group_reg[24]_i_1_n_6 ;
  wire \clk_group_reg[24]_i_1_n_7 ;
  wire \clk_group_reg[28]_i_1_n_1 ;
  wire \clk_group_reg[28]_i_1_n_2 ;
  wire \clk_group_reg[28]_i_1_n_3 ;
  wire \clk_group_reg[28]_i_1_n_4 ;
  wire \clk_group_reg[28]_i_1_n_5 ;
  wire \clk_group_reg[28]_i_1_n_6 ;
  wire \clk_group_reg[28]_i_1_n_7 ;
  wire \clk_group_reg[4]_i_1_n_0 ;
  wire \clk_group_reg[4]_i_1_n_1 ;
  wire \clk_group_reg[4]_i_1_n_2 ;
  wire \clk_group_reg[4]_i_1_n_3 ;
  wire \clk_group_reg[4]_i_1_n_4 ;
  wire \clk_group_reg[4]_i_1_n_5 ;
  wire \clk_group_reg[4]_i_1_n_6 ;
  wire \clk_group_reg[4]_i_1_n_7 ;
  wire \clk_group_reg[8]_i_1_n_0 ;
  wire \clk_group_reg[8]_i_1_n_1 ;
  wire \clk_group_reg[8]_i_1_n_2 ;
  wire \clk_group_reg[8]_i_1_n_3 ;
  wire \clk_group_reg[8]_i_1_n_4 ;
  wire \clk_group_reg[8]_i_1_n_5 ;
  wire \clk_group_reg[8]_i_1_n_6 ;
  wire \clk_group_reg[8]_i_1_n_7 ;
  wire [4:0]clk_sel_IBUF;
  wire clk_src;
  wire [3:3]\NLW_clk_group_reg[28]_i_1_CO_UNCONNECTED ;

  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \FSM_sequential_state[3]_i_10 
       (.I0(clk_group[23]),
        .I1(clk_group[22]),
        .I2(clk_sel_IBUF[1]),
        .I3(clk_group[21]),
        .I4(clk_sel_IBUF[0]),
        .I5(clk_group[20]),
        .O(\FSM_sequential_state[3]_i_10_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \FSM_sequential_state[3]_i_11 
       (.I0(clk_group[11]),
        .I1(clk_group[10]),
        .I2(clk_sel_IBUF[1]),
        .I3(clk_group[9]),
        .I4(clk_sel_IBUF[0]),
        .I5(clk_group[8]),
        .O(\FSM_sequential_state[3]_i_11_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \FSM_sequential_state[3]_i_12 
       (.I0(clk_group[15]),
        .I1(clk_group[14]),
        .I2(clk_sel_IBUF[1]),
        .I3(clk_group[13]),
        .I4(clk_sel_IBUF[0]),
        .I5(clk_group[12]),
        .O(\FSM_sequential_state[3]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \FSM_sequential_state[3]_i_13 
       (.I0(clk_group[3]),
        .I1(clk_group[2]),
        .I2(clk_sel_IBUF[1]),
        .I3(clk_group[1]),
        .I4(clk_sel_IBUF[0]),
        .I5(clk_group[0]),
        .O(\FSM_sequential_state[3]_i_13_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \FSM_sequential_state[3]_i_14 
       (.I0(clk_group[7]),
        .I1(clk_group[6]),
        .I2(clk_sel_IBUF[1]),
        .I3(clk_group[5]),
        .I4(clk_sel_IBUF[0]),
        .I5(clk_group[4]),
        .O(\FSM_sequential_state[3]_i_14_n_0 ));
  LUT6 #(
    .INIT(64'hAACCAACCF0FFF000)) 
    \FSM_sequential_state[3]_i_2 
       (.I0(\FSM_sequential_state_reg[3]_i_3_n_0 ),
        .I1(\FSM_sequential_state_reg[3]_i_4_n_0 ),
        .I2(\FSM_sequential_state_reg[3]_i_5_n_0 ),
        .I3(clk_sel_IBUF[3]),
        .I4(\FSM_sequential_state_reg[3]_i_6_n_0 ),
        .I5(clk_sel_IBUF[4]),
        .O(CLK));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \FSM_sequential_state[3]_i_7 
       (.I0(clk_group[27]),
        .I1(clk_group[26]),
        .I2(clk_sel_IBUF[1]),
        .I3(clk_group[25]),
        .I4(clk_sel_IBUF[0]),
        .I5(clk_group[24]),
        .O(\FSM_sequential_state[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \FSM_sequential_state[3]_i_8 
       (.I0(clk_group[31]),
        .I1(clk_group[30]),
        .I2(clk_sel_IBUF[1]),
        .I3(clk_group[29]),
        .I4(clk_sel_IBUF[0]),
        .I5(clk_group[28]),
        .O(\FSM_sequential_state[3]_i_8_n_0 ));
  LUT6 #(
    .INIT(64'hAFA0CFCFAFA0C0C0)) 
    \FSM_sequential_state[3]_i_9 
       (.I0(clk_group[19]),
        .I1(clk_group[18]),
        .I2(clk_sel_IBUF[1]),
        .I3(clk_group[17]),
        .I4(clk_sel_IBUF[0]),
        .I5(clk_group[16]),
        .O(\FSM_sequential_state[3]_i_9_n_0 ));
  MUXF7 \FSM_sequential_state_reg[3]_i_3 
       (.I0(\FSM_sequential_state[3]_i_7_n_0 ),
        .I1(\FSM_sequential_state[3]_i_8_n_0 ),
        .O(\FSM_sequential_state_reg[3]_i_3_n_0 ),
        .S(clk_sel_IBUF[2]));
  MUXF7 \FSM_sequential_state_reg[3]_i_4 
       (.I0(\FSM_sequential_state[3]_i_9_n_0 ),
        .I1(\FSM_sequential_state[3]_i_10_n_0 ),
        .O(\FSM_sequential_state_reg[3]_i_4_n_0 ),
        .S(clk_sel_IBUF[2]));
  MUXF7 \FSM_sequential_state_reg[3]_i_5 
       (.I0(\FSM_sequential_state[3]_i_11_n_0 ),
        .I1(\FSM_sequential_state[3]_i_12_n_0 ),
        .O(\FSM_sequential_state_reg[3]_i_5_n_0 ),
        .S(clk_sel_IBUF[2]));
  MUXF7 \FSM_sequential_state_reg[3]_i_6 
       (.I0(\FSM_sequential_state[3]_i_13_n_0 ),
        .I1(\FSM_sequential_state[3]_i_14_n_0 ),
        .O(\FSM_sequential_state_reg[3]_i_6_n_0 ),
        .S(clk_sel_IBUF[2]));
  LUT1 #(
    .INIT(2'h1)) 
    \clk_group[0]_i_5 
       (.I0(clk_group[0]),
        .O(\clk_group[0]_i_5_n_0 ));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[0] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[0]_i_1_n_7 ),
        .Q(clk_group[0]));
  CARRY4 \clk_group_reg[0]_i_1 
       (.CI(1'b0),
        .CO({\clk_group_reg[0]_i_1_n_0 ,\clk_group_reg[0]_i_1_n_1 ,\clk_group_reg[0]_i_1_n_2 ,\clk_group_reg[0]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b1}),
        .O({\clk_group_reg[0]_i_1_n_4 ,\clk_group_reg[0]_i_1_n_5 ,\clk_group_reg[0]_i_1_n_6 ,\clk_group_reg[0]_i_1_n_7 }),
        .S({clk_group[3:1],\clk_group[0]_i_5_n_0 }));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[10] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[8]_i_1_n_5 ),
        .Q(clk_group[10]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[11] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[8]_i_1_n_4 ),
        .Q(clk_group[11]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[12] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[12]_i_1_n_7 ),
        .Q(clk_group[12]));
  CARRY4 \clk_group_reg[12]_i_1 
       (.CI(\clk_group_reg[8]_i_1_n_0 ),
        .CO({\clk_group_reg[12]_i_1_n_0 ,\clk_group_reg[12]_i_1_n_1 ,\clk_group_reg[12]_i_1_n_2 ,\clk_group_reg[12]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\clk_group_reg[12]_i_1_n_4 ,\clk_group_reg[12]_i_1_n_5 ,\clk_group_reg[12]_i_1_n_6 ,\clk_group_reg[12]_i_1_n_7 }),
        .S(clk_group[15:12]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[13] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[12]_i_1_n_6 ),
        .Q(clk_group[13]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[14] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[12]_i_1_n_5 ),
        .Q(clk_group[14]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[15] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[12]_i_1_n_4 ),
        .Q(clk_group[15]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[16] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[16]_i_1_n_7 ),
        .Q(clk_group[16]));
  CARRY4 \clk_group_reg[16]_i_1 
       (.CI(\clk_group_reg[12]_i_1_n_0 ),
        .CO({\clk_group_reg[16]_i_1_n_0 ,\clk_group_reg[16]_i_1_n_1 ,\clk_group_reg[16]_i_1_n_2 ,\clk_group_reg[16]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\clk_group_reg[16]_i_1_n_4 ,\clk_group_reg[16]_i_1_n_5 ,\clk_group_reg[16]_i_1_n_6 ,\clk_group_reg[16]_i_1_n_7 }),
        .S(clk_group[19:16]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[17] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[16]_i_1_n_6 ),
        .Q(clk_group[17]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[18] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[16]_i_1_n_5 ),
        .Q(clk_group[18]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[19] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[16]_i_1_n_4 ),
        .Q(clk_group[19]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[1] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[0]_i_1_n_6 ),
        .Q(clk_group[1]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[20] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[20]_i_1_n_7 ),
        .Q(clk_group[20]));
  CARRY4 \clk_group_reg[20]_i_1 
       (.CI(\clk_group_reg[16]_i_1_n_0 ),
        .CO({\clk_group_reg[20]_i_1_n_0 ,\clk_group_reg[20]_i_1_n_1 ,\clk_group_reg[20]_i_1_n_2 ,\clk_group_reg[20]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\clk_group_reg[20]_i_1_n_4 ,\clk_group_reg[20]_i_1_n_5 ,\clk_group_reg[20]_i_1_n_6 ,\clk_group_reg[20]_i_1_n_7 }),
        .S(clk_group[23:20]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[21] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[20]_i_1_n_6 ),
        .Q(clk_group[21]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[22] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[20]_i_1_n_5 ),
        .Q(clk_group[22]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[23] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[20]_i_1_n_4 ),
        .Q(clk_group[23]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[24] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[24]_i_1_n_7 ),
        .Q(clk_group[24]));
  CARRY4 \clk_group_reg[24]_i_1 
       (.CI(\clk_group_reg[20]_i_1_n_0 ),
        .CO({\clk_group_reg[24]_i_1_n_0 ,\clk_group_reg[24]_i_1_n_1 ,\clk_group_reg[24]_i_1_n_2 ,\clk_group_reg[24]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\clk_group_reg[24]_i_1_n_4 ,\clk_group_reg[24]_i_1_n_5 ,\clk_group_reg[24]_i_1_n_6 ,\clk_group_reg[24]_i_1_n_7 }),
        .S(clk_group[27:24]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[25] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[24]_i_1_n_6 ),
        .Q(clk_group[25]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[26] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[24]_i_1_n_5 ),
        .Q(clk_group[26]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[27] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[24]_i_1_n_4 ),
        .Q(clk_group[27]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[28] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[28]_i_1_n_7 ),
        .Q(clk_group[28]));
  CARRY4 \clk_group_reg[28]_i_1 
       (.CI(\clk_group_reg[24]_i_1_n_0 ),
        .CO({\NLW_clk_group_reg[28]_i_1_CO_UNCONNECTED [3],\clk_group_reg[28]_i_1_n_1 ,\clk_group_reg[28]_i_1_n_2 ,\clk_group_reg[28]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\clk_group_reg[28]_i_1_n_4 ,\clk_group_reg[28]_i_1_n_5 ,\clk_group_reg[28]_i_1_n_6 ,\clk_group_reg[28]_i_1_n_7 }),
        .S(clk_group[31:28]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[29] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[28]_i_1_n_6 ),
        .Q(clk_group[29]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[2] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[0]_i_1_n_5 ),
        .Q(clk_group[2]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[30] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[28]_i_1_n_5 ),
        .Q(clk_group[30]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[31] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[28]_i_1_n_4 ),
        .Q(clk_group[31]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[3] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[0]_i_1_n_4 ),
        .Q(clk_group[3]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[4] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[4]_i_1_n_7 ),
        .Q(clk_group[4]));
  CARRY4 \clk_group_reg[4]_i_1 
       (.CI(\clk_group_reg[0]_i_1_n_0 ),
        .CO({\clk_group_reg[4]_i_1_n_0 ,\clk_group_reg[4]_i_1_n_1 ,\clk_group_reg[4]_i_1_n_2 ,\clk_group_reg[4]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\clk_group_reg[4]_i_1_n_4 ,\clk_group_reg[4]_i_1_n_5 ,\clk_group_reg[4]_i_1_n_6 ,\clk_group_reg[4]_i_1_n_7 }),
        .S(clk_group[7:4]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[5] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[4]_i_1_n_6 ),
        .Q(clk_group[5]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[6] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[4]_i_1_n_5 ),
        .Q(clk_group[6]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[7] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[4]_i_1_n_4 ),
        .Q(clk_group[7]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[8] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[8]_i_1_n_7 ),
        .Q(clk_group[8]));
  CARRY4 \clk_group_reg[8]_i_1 
       (.CI(\clk_group_reg[4]_i_1_n_0 ),
        .CO({\clk_group_reg[8]_i_1_n_0 ,\clk_group_reg[8]_i_1_n_1 ,\clk_group_reg[8]_i_1_n_2 ,\clk_group_reg[8]_i_1_n_3 }),
        .CYINIT(1'b0),
        .DI({1'b0,1'b0,1'b0,1'b0}),
        .O({\clk_group_reg[8]_i_1_n_4 ,\clk_group_reg[8]_i_1_n_5 ,\clk_group_reg[8]_i_1_n_6 ,\clk_group_reg[8]_i_1_n_7 }),
        .S(clk_group[11:8]));
  FDCE #(
    .INIT(1'b0)) 
    \clk_group_reg[9] 
       (.C(clk_src),
        .CE(1'b1),
        .CLR(AR),
        .D(\clk_group_reg[8]_i_1_n_6 ),
        .Q(clk_group[9]));
endmodule

(* LEN = "32" *) (* l0 = "0" *) (* l1 = "1" *) 
(* l10 = "15" *) (* l11 = "14" *) (* l12 = "10" *) 
(* l13 = "11" *) (* l14 = "9" *) (* l15 = "8" *) 
(* l2 = "3" *) (* l3 = "2" *) (* l4 = "6" *) 
(* l5 = "7" *) (* l6 = "5" *) (* l7 = "4" *) 
(* l8 = "12" *) (* l9 = "13" *) 
(* NotValidForBitStream *)
module flow_led
   (clk_src,
    reset,
    clk_sel,
    M,
    state);
  input clk_src;
  input reset;
  input [4:0]clk_sel;
  input M;
  output [3:0]state;

  wire \FSM_sequential_state[0]_i_1_n_0 ;
  wire \FSM_sequential_state[1]_i_1_n_0 ;
  wire \FSM_sequential_state[2]_i_1_n_0 ;
  wire \FSM_sequential_state[3]_i_1_n_0 ;
  wire M;
  wire M_IBUF;
  wire clk;
  wire [4:0]clk_sel;
  wire [4:0]clk_sel_IBUF;
  wire clk_src;
  wire clk_src_IBUF;
  wire clk_src_IBUF_BUFG;
  wire reset;
  wire reset_IBUF;
  wire [3:0]state;
  wire [3:0]state_OBUF;
  (* RTL_KEEP = "yes" *) wire [3:0]state__0;

  binary_counter DIVIDER
       (.AR(reset_IBUF),
        .CLK(clk),
        .clk_sel_IBUF(clk_sel_IBUF),
        .clk_src(clk_src_IBUF_BUFG));
  LUT1 #(
    .INIT(2'h1)) 
    \FSM_sequential_state[0]_i_1 
       (.I0(state__0[0]),
        .O(\FSM_sequential_state[0]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h691AA579)) 
    \FSM_sequential_state[1]_i_1 
       (.I0(M_IBUF),
        .I1(state__0[2]),
        .I2(state__0[0]),
        .I3(state__0[1]),
        .I4(state__0[3]),
        .O(\FSM_sequential_state[1]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h6B449D29)) 
    \FSM_sequential_state[2]_i_1 
       (.I0(M_IBUF),
        .I1(state__0[0]),
        .I2(state__0[3]),
        .I3(state__0[2]),
        .I4(state__0[1]),
        .O(\FSM_sequential_state[2]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h6BFD4009)) 
    \FSM_sequential_state[3]_i_1 
       (.I0(M_IBUF),
        .I1(state__0[0]),
        .I2(state__0[1]),
        .I3(state__0[2]),
        .I4(state__0[3]),
        .O(\FSM_sequential_state[3]_i_1_n_0 ));
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[0] 
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(\FSM_sequential_state[0]_i_1_n_0 ),
        .Q(state__0[0]));
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[1] 
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(\FSM_sequential_state[1]_i_1_n_0 ),
        .Q(state__0[1]));
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[2] 
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(\FSM_sequential_state[2]_i_1_n_0 ),
        .Q(state__0[2]));
  (* KEEP = "yes" *) 
  FDCE #(
    .INIT(1'b0)) 
    \FSM_sequential_state_reg[3] 
       (.C(clk),
        .CE(1'b1),
        .CLR(reset_IBUF),
        .D(\FSM_sequential_state[3]_i_1_n_0 ),
        .Q(state__0[3]));
  IBUF M_IBUF_inst
       (.I(M),
        .O(M_IBUF));
  IBUF \clk_sel_IBUF[0]_inst 
       (.I(clk_sel[0]),
        .O(clk_sel_IBUF[0]));
  IBUF \clk_sel_IBUF[1]_inst 
       (.I(clk_sel[1]),
        .O(clk_sel_IBUF[1]));
  IBUF \clk_sel_IBUF[2]_inst 
       (.I(clk_sel[2]),
        .O(clk_sel_IBUF[2]));
  IBUF \clk_sel_IBUF[3]_inst 
       (.I(clk_sel[3]),
        .O(clk_sel_IBUF[3]));
  IBUF \clk_sel_IBUF[4]_inst 
       (.I(clk_sel[4]),
        .O(clk_sel_IBUF[4]));
  BUFG clk_src_IBUF_BUFG_inst
       (.I(clk_src_IBUF),
        .O(clk_src_IBUF_BUFG));
  IBUF clk_src_IBUF_inst
       (.I(clk_src),
        .O(clk_src_IBUF));
  IBUF reset_IBUF_inst
       (.I(reset),
        .O(reset_IBUF));
  OBUF \state_OBUF[0]_inst 
       (.I(state_OBUF[0]),
        .O(state[0]));
  LUT4 #(
    .INIT(16'hCCB2)) 
    \state_OBUF[0]_inst_i_1 
       (.I0(state__0[2]),
        .I1(state__0[1]),
        .I2(state__0[3]),
        .I3(state__0[0]),
        .O(state_OBUF[0]));
  OBUF \state_OBUF[1]_inst 
       (.I(state_OBUF[1]),
        .O(state[1]));
  LUT4 #(
    .INIT(16'h33B2)) 
    \state_OBUF[1]_inst_i_1 
       (.I0(state__0[1]),
        .I1(state__0[2]),
        .I2(state__0[3]),
        .I3(state__0[0]),
        .O(state_OBUF[1]));
  OBUF \state_OBUF[2]_inst 
       (.I(state_OBUF[2]),
        .O(state[2]));
  LUT3 #(
    .INIT(8'h1E)) 
    \state_OBUF[2]_inst_i_1 
       (.I0(state__0[1]),
        .I1(state__0[2]),
        .I2(state__0[3]),
        .O(state_OBUF[2]));
  OBUF \state_OBUF[3]_inst 
       (.I(state_OBUF[3]),
        .O(state[3]));
  LUT3 #(
    .INIT(8'h78)) 
    \state_OBUF[3]_inst_i_1 
       (.I0(state__0[2]),
        .I1(state__0[1]),
        .I2(state__0[3]),
        .O(state_OBUF[3]));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (weak1, weak0) GSR = GSR_int;
    assign (weak1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

endmodule
`endif
