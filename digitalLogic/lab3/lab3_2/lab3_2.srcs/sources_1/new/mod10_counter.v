`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/03 12:06:32
// Design Name: 
// Module Name: mod10_counter
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


module mod10_counter(reset,X,Z,Q1,Q2,Q3,Q4);
    input X,reset;
    output Z,Q1,Q2,Q3,Q4;
    wire s=1;
    wire t1,t2,t3,t4, s5;
    assign Q = {Q4,Q3,Q2,Q1};
    JK_ff DUT1 (.J(s), .K(s), .cp(X), .Q(Q1), .Qbar(t1), .reset(reset));
    JK_ff DUT2 (.J(t4), .K(s), .cp(Q1), .Q(Q2), .Qbar(t2), .reset(reset));
    JK_ff DUT3 (.J(s), .K(s), .cp(Q2), .Q(Q3), .Qbar(t3), .reset(reset));
    JK_ff DUT4 (.J(s5), .K(s), .cp(Q1), .Q(Q4), .Qbar(t4), .reset(reset));
    assign s5=Q2&Q3;
    assign Z=Q4&Q1&X;
endmodule