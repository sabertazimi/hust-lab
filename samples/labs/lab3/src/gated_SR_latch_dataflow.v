`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 19:34:28
// Design Name: 
// Module Name: gated_SR_latch_dataflow
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


module gated_SR_latch_dataflow(
    input R,
    input S,
    input Enable,
    output Q,
    output Qbar
    );
    
    wire R_i, S_i;
    
    assign #2 R_i = Enable & R;
    assign #2 S_i = Enable & S;
    assign #2 Q = ~ (R_i | Qbar);
    assign #2 Qbar = ~ (S_i | Q);
endmodule
