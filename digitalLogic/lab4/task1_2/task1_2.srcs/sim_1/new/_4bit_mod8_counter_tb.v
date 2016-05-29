`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/29 20:46:17
// Design Name: 
// Module Name: _4bit_mod8_counter_tb
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


module _4bit_mod8_counter_tb(
    
    );

    reg CP, LD_n;
    reg [3:0] D;
    wire [3:0] Q;
    wire Qcc_n;
    integer i;

    _4bit_mod8_counter DUT (.CP(CP), .D(D), .LD_n(LD_n), .Q(Q), .Qcc_n(Qcc_n));
    
    initial begin
        #500 $finish;
    end

    initial begin
        CP = 0;
        for (i = 0; i < 50; i = i + 1) begin
            #10 CP = ~CP;
        end
    end

    initial begin
        LD_n = 1;D = 4'b0010;
        #10 LD_n = 0;
        #10 LD_n = 1;
    end
endmodule