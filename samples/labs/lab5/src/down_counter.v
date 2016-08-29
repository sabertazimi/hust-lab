`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/07 13:25:52
// Design Name: 
// Module Name: down_counter
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


module down_counter
#(parameter COUNT = 3, STEP = 1)
(
    input start,
    input clk,
    output reg cnt_done
);

    reg [(COUNT-1):0] count;
    
    always @(posedge start or posedge clk) begin
        if (start) begin
            count <= COUNT;
            cnt_done <= 0;
        end
        else if (!cnt_done) begin
            count = count - 1;
            if (!count) begin
                cnt_done <= 1;
            end
            else begin
                cnt_done <= 0;
            end
        end
    end
    
endmodule
