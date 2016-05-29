`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/29 20:41:43
// Design Name: 
// Module Name: _4bit_binary_counter
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

module _4bit_binary_counter(
    input CP,
    input M,
    input [3:0] D,
    input LD_n,
    input CLR_n,
    output reg [3:0] Q,
    output reg  Qcc_n
    );
    
    always @(negedge CLR_n or negedge LD_n  or posedge CP) begin
        if (!CLR_n) {Qcc_n, Q} <= 5'b10000;
        else if (!LD_n) {Qcc_n, Q} <= {1'b1, D};
        else if (CP) begin
            if (M) begin
                {Qcc_n, Q} <= {Qcc_n,Q} + 1;
                #10 Qcc_n <= 1;
            end
            else begin
                {Qcc_n, Q} <= {Qcc_n,Q} - 1;
                #10 Qcc_n <= 1;
            end
        end
    end
endmodule