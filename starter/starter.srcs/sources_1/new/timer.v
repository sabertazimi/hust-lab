`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/29 20:51:51
// Design Name: 
// Module Name: timer
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


module timer
#(parameter WIDTH = 8, RANGE = 10)
(
    input clk_src,
    input sig_en,
    output reg sig_start,
    output reg sig_end   
);

    reg [(WIDTH-1):0] count;
    
    initial begin
        count <= 0;
        sig_start <= 0;
        sig_end <= 0;
    end
    
    always @(posedge clk_src) begin
        if (sig_en) begin
            
            if (count == 0) begin
                sig_start = 1;
            end else begin
                sig_start = 0;
            end
            
            if (count == RANGE) begin
                sig_end = 1;
                count = 0;
            end else begin
                sig_end = 0;
            end
            
            count = count + 1;
                                
        end
    end

endmodule
