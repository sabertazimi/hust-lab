`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/27 23:40:05
// Design Name: 
// Module Name: memory_tb
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


module memory_tb(

    );
    
    reg [7:0] address;
    wire [7:0] data;
    integer i;
    
    memory DUT (.address(address), .data(data));
    
    initial begin
        #2600 $finish;
    end
    
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            #10 address = i;
        end        
    end
endmodule
