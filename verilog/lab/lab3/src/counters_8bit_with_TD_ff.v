`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 09:40:43
// Design Name: 
// Module Name: counters_8bit_with_TD_ff
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module counters_8bit_with_TD_ff(
    input Clk,
    input Enable,
    input Clear,
    output [7:0] Q
);

    T_ff_with_D_ff SR0 (.Clk(Clk), .T(Enable), .reset_n(Clear), .Q(Q[0]));
    T_ff_with_D_ff SR1 (.Clk(Clk), .T(Enable & Q[0]), .reset_n(Clear), .Q(Q[1]));
    T_ff_with_D_ff SR2 (.Clk(Clk), .T(Enable & Q[0] & Q[1]), .reset_n(Clear), .Q(Q[2]));
    T_ff_with_D_ff SR3 (.Clk(Clk), .T(Enable & Q[0] & Q[1] & Q[2]), .reset_n(Clear), .Q(Q[3]));
    T_ff_with_D_ff SR4 (.Clk(Clk), .T(Enable & Q[0] & Q[1] & Q[2] & Q[3]), .reset_n(Clear), .Q(Q[4]));
    T_ff_with_D_ff SR5 (.Clk(Clk), .T(Enable & Q[0] & Q[1] & Q[2] & Q[3] & Q[4]), .reset_n(Clear), .Q(Q[5]));
    T_ff_with_D_ff SR6 (.Clk(Clk), .T(Enable & Q[0] & Q[1] & Q[2] & Q[3] & Q[4] & Q[5]), .reset_n(Clear), .Q(Q[6]));
    T_ff_with_D_ff SR7 (.Clk(Clk), .T(Enable & Q[0] & Q[1] & Q[2] & Q[3] & Q[4] & Q[5] & Q[6]), .reset_n(Clear), .Q(Q[7]));
endmodule

