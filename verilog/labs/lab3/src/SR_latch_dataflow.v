`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 19:22:34
// Design Name: 
// Module Name: SR_latch_dataflow
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


module SR_latch_dataflow(
    input R,
    input S,
    output Q,
    output Qbar
    );
    
    // assign #2 Q_i = Q;
    // assign #2 Qbar_i = Qbar;
    assign #2 Q = ~ (R | Qbar);
    assign #2 Qbar = ~ (S | Q);
endmodule
