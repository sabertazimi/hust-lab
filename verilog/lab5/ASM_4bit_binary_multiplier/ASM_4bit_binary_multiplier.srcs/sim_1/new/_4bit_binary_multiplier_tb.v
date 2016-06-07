`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/07 20:12:19
// Design Name: 
// Module Name: _4bit_binary_multiplier_tb
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


module _4bit_binary_multiplier_tb(

    );

            parameter COUNT = 250;
            parameter DELAY = 10;
            parameter TIME = (COUNT * DELAY);
            parameter WIDTH = 4;
            
            reg start, clk;
            reg [WIDTH:0] multiplier_address, multiplicand_address;
            wire [((WIDTH*2)-1):0] p;
            wire done;
            integer i, j, k;
            
            _4bit_binary_multiplier #(WIDTH) DUT (start, clk, multiplier_address, multiplicand_address, p, done);
     
            initial begin
                #TIME $finish;
            end
            
            initial begin
                clk = 0;
                for (i = 0; i < COUNT; i = i + 1) begin
                    #DELAY clk = ~clk;
                end
            end
            
            initial begin
                start = 0; 
                #DELAY;
                #(DELAY/2);
                for (j = 0; j < COUNT;j = j + 1) begin
                    #(19*DELAY) start = 1;
                    #DELAY start = 0;
                end
            end
            
            initial begin
                multiplier_address = 0; multiplicand_address = 16;
                for (k = 0; k < 16; k = k + 1) begin
                    #(20*DELAY) multiplier_address = k; multiplicand_address = k + 16;
                end
            end
        endmodule

