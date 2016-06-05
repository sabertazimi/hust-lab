// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2016.1 (lin64) Build 1538259 Fri Apr  8 15:45:23 MDT 2016
// Date        : Sun Jun  5 21:29:07 2016
// Host        : avalon running 64-bit Ubuntu 16.04 LTS
// Command     : write_verilog -mode funcsim -nolib -force -file
//               /home/sabertazimi/gitrepo/hust-lab/digitalLogic/lab4/task1/task1.sim/sim_1/synth/func/_4bit_binary_counter_tb_func_synth.v
// Design      : _4bit_binary_counter
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* NotValidForBitStream *)
module _4bit_binary_counter
   (CP,
    M,
    D,
    LD_n,
    CLR_n,
    Q,
    Qcc_n);
  input CP;
  input M;
  input [3:0]D;
  input LD_n;
  input CLR_n;
  output [3:0]Q;
  output Qcc_n;

  wire CLR_n;
  wire CLR_n_IBUF;
  wire CP;
  wire CP_IBUF;
  wire CP_IBUF_BUFG;
  wire [3:0]D;
  wire [3:0]D_IBUF;
  wire LD_n;
  wire LD_n_IBUF;
  wire LD_n_IBUF_BUFG;
  wire M;
  wire M_IBUF;
  wire [3:0]Q;
  wire \Q[0]__0_i_1_n_0 ;
  wire \Q[1]__0_i_1_n_0 ;
  wire \Q[2]__0_i_1_n_0 ;
  wire \Q[3]__0_i_1_n_0 ;
  wire \Q[3]__0_i_2_n_0 ;
  wire [3:0]Q_OBUF;
  wire \Q_reg[3]_i_2_n_0 ;
  wire Qcc_n;

  IBUF CLR_n_IBUF_inst
       (.I(CLR_n),
        .O(CLR_n_IBUF));
  BUFG CP_IBUF_BUFG_inst
       (.I(CP_IBUF),
        .O(CP_IBUF_BUFG));
  IBUF CP_IBUF_inst
       (.I(CP),
        .O(CP_IBUF));
  IBUF \D_IBUF[0]_inst 
       (.I(D[0]),
        .O(D_IBUF[0]));
  IBUF \D_IBUF[1]_inst 
       (.I(D[1]),
        .O(D_IBUF[1]));
  IBUF \D_IBUF[2]_inst 
       (.I(D[2]),
        .O(D_IBUF[2]));
  IBUF \D_IBUF[3]_inst 
       (.I(D[3]),
        .O(D_IBUF[3]));
  BUFG LD_n_IBUF_BUFG_inst
       (.I(LD_n_IBUF),
        .O(LD_n_IBUF_BUFG));
  IBUF LD_n_IBUF_inst
       (.I(LD_n),
        .O(LD_n_IBUF));
  IBUF M_IBUF_inst
       (.I(M),
        .O(M_IBUF));
  LUT3 #(
    .INIT(8'h5C)) 
    \Q[0]__0_i_1 
       (.I0(Q_OBUF[0]),
        .I1(D_IBUF[0]),
        .I2(LD_n_IBUF),
        .O(\Q[0]__0_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h6969FF00)) 
    \Q[1]__0_i_1 
       (.I0(Q_OBUF[0]),
        .I1(M_IBUF),
        .I2(Q_OBUF[1]),
        .I3(D_IBUF[1]),
        .I4(LD_n_IBUF),
        .O(\Q[1]__0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h78E178E1FFFF0000)) 
    \Q[2]__0_i_1 
       (.I0(Q_OBUF[0]),
        .I1(M_IBUF),
        .I2(Q_OBUF[2]),
        .I3(Q_OBUF[1]),
        .I4(D_IBUF[2]),
        .I5(LD_n_IBUF),
        .O(\Q[2]__0_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h78E178E1FFFF0000)) 
    \Q[3]__0_i_1 
       (.I0(\Q[3]__0_i_2_n_0 ),
        .I1(Q_OBUF[1]),
        .I2(Q_OBUF[3]),
        .I3(Q_OBUF[2]),
        .I4(D_IBUF[3]),
        .I5(LD_n_IBUF),
        .O(\Q[3]__0_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hD4)) 
    \Q[3]__0_i_2 
       (.I0(Q_OBUF[1]),
        .I1(M_IBUF),
        .I2(Q_OBUF[0]),
        .O(\Q[3]__0_i_2_n_0 ));
  OBUF \Q_OBUF[0]_inst 
       (.I(Q_OBUF[0]),
        .O(Q[0]));
  OBUF \Q_OBUF[1]_inst 
       (.I(Q_OBUF[1]),
        .O(Q[1]));
  OBUF \Q_OBUF[2]_inst 
       (.I(Q_OBUF[2]),
        .O(Q[2]));
  OBUF \Q_OBUF[3]_inst 
       (.I(Q_OBUF[3]),
        .O(Q[3]));
  (* XILINX_LEGACY_PRIM = "LDC" *) 
  LDCE #(
    .INIT(1'b0),
    .IS_G_INVERTED(1'b1)) 
    \Q_reg[0] 
       (.CLR(\Q_reg[3]_i_2_n_0 ),
        .D(D_IBUF[0]),
        .G(LD_n_IBUF),
        .GE(1'b1),
        .Q(Q_OBUF[0]));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[0]__0 
       (.C(CP_IBUF_BUFG),
        .CE(1'b1),
        .D(\Q[0]__0_i_1_n_0 ),
        .Q(Q_OBUF[0]),
        .R(\Q_reg[3]_i_2_n_0 ));
  (* XILINX_LEGACY_PRIM = "LDC" *) 
  LDCE #(
    .INIT(1'b0),
    .IS_G_INVERTED(1'b1)) 
    \Q_reg[1] 
       (.CLR(\Q_reg[3]_i_2_n_0 ),
        .D(D_IBUF[1]),
        .G(LD_n_IBUF),
        .GE(1'b1),
        .Q(Q_OBUF[1]));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[1]__0 
       (.C(CP_IBUF_BUFG),
        .CE(1'b1),
        .D(\Q[1]__0_i_1_n_0 ),
        .Q(Q_OBUF[1]),
        .R(\Q_reg[3]_i_2_n_0 ));
  (* XILINX_LEGACY_PRIM = "LDC" *) 
  LDCE #(
    .INIT(1'b0),
    .IS_G_INVERTED(1'b1)) 
    \Q_reg[2] 
       (.CLR(\Q_reg[3]_i_2_n_0 ),
        .D(D_IBUF[2]),
        .G(LD_n_IBUF),
        .GE(1'b1),
        .Q(Q_OBUF[2]));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[2]__0 
       (.C(CP_IBUF_BUFG),
        .CE(1'b1),
        .D(\Q[2]__0_i_1_n_0 ),
        .Q(Q_OBUF[2]),
        .R(\Q_reg[3]_i_2_n_0 ));
  (* XILINX_LEGACY_PRIM = "LDC" *) 
  LDCE #(
    .INIT(1'b0),
    .IS_G_INVERTED(1'b1)) 
    \Q_reg[3] 
       (.CLR(\Q_reg[3]_i_2_n_0 ),
        .D(D_IBUF[3]),
        .G(LD_n_IBUF),
        .GE(1'b1),
        .Q(Q_OBUF[3]));
  FDRE #(
    .INIT(1'b0)) 
    \Q_reg[3]__0 
       (.C(CP_IBUF_BUFG),
        .CE(1'b1),
        .D(\Q[3]__0_i_1_n_0 ),
        .Q(Q_OBUF[3]),
        .R(\Q_reg[3]_i_2_n_0 ));
  LUT1 #(
    .INIT(2'h1)) 
    \Q_reg[3]_i_2 
       (.I0(CLR_n_IBUF),
        .O(\Q_reg[3]_i_2_n_0 ));
  OBUF Qcc_n_OBUF_inst
       (.I(1'b1),
        .O(Qcc_n));
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
