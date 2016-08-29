`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/07 15:02:45
// Design Name: 
// Module Name: full_adder_tb
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


module full_adder_tb(

    );
    
    parameter COUNT = 70;
    parameter DELAY = 10;
    parameter TIME = (COUNT * DELAY);
    parameter WIDTH = 3;
    
    reg add, start;
    reg [(WIDTH-1):0] a, b;
    wire cout;
    wire [(WIDTH-1):0] s;
    integer i, j;
    
    full_adder #(WIDTH) DUT (start, add, a, b, s, cout);
    
    initial begin
        #TIME $finish;
    end
    
    initial begin
        start = 0;
        #DELAY start = 1;
        #DELAY start = 0;
    end
    
    initial begin
        add = 0;
        #(TIME/4) add = 1;
    end
    
    initial begin
        a = 0; b = 0;
        for (i = 0; i < (2**WIDTH); i = i + 1) begin
            #DELAY a = i;
            for (j = 0; j < (2**WIDTH); j = j + 1) begin
                #DELAY b = j;
            end
        end
    end
endmodule
