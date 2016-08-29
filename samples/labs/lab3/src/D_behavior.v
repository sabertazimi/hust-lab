`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 20:34:28
// Design Name: 
// Module Name: D_behavior
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


module D_behavior (input D, input Clk, output reg Qa, output reg Qb, output reg Qc);

    always @ (D or Clk) begin
        if(Clk)
            begin
                Qa <= D;
            end
    end

    always @ (posedge Clk) begin
        if(Clk)
            begin
                Qb <= D;
            end
    end
    
    always @ (negedge Clk) begin
        if(!Clk)
            begin
                Qc <= D;
            end
    end
endmodule
