`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 08:26:12
// Design Name: 
// Module Name: Serial_in_parallel_out_enable_behavior_tb
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


module Serial_in_parallel_out_enable_behavior_tb(

    );
    
    reg Clk, ShiftIn, reset, ShiftEn;
    wire ShiftOut;
    wire [3:0] ParallelOut;
    
    Serial_in_parallel_out_enable_behavior DUT (.Clk(Clk), .ShiftIn(ShiftIn), .reset(reset), .ShiftEn(ShiftEn), .ShiftOut(ShiftOut), .ParallelOut(ParallelOut));
    
    initial begin
        #350 $finish;
    end
    
    initial begin
    Clk = 0; ShiftIn = 1; reset = 1; ShiftEn = 0;
    #10 Clk = 1;
    #10 Clk = 0; reset = 0;
    #10 Clk = 1;
    #10 Clk = 0;
    #10 Clk = 1; // 50ns
    #10 Clk = 0; ShiftEn = 1;
    #10 Clk = 1;
    #10 Clk = 0; ShiftEn = 0;
    #10 Clk = 1;
    #10 Clk = 0; ShiftEn = 1;// 100ns
    #10 Clk = 1; ShiftIn = 0;
    #10 Clk = 0;
    #10 Clk = 1;
    #10 Clk = 0; ShiftEn = 0;
    #10 Clk = 1; // 150ns
    #10 Clk = 0;
    #10 Clk = 1;
    #10 Clk = 0;
    #10 Clk = 1;
    #10 Clk = 0; ShiftEn = 1;// 200ns
    #10 Clk = 1;
    #10 Clk = 0; ShiftEn = 0;
    #10 Clk = 1;
    #10 Clk = 0;
    #10 Clk = 1; //250ns
    #10 Clk = 0;
    #10 Clk = 1;
    #5  ShiftEn = 1;
    #5 Clk = 0;
    #10 Clk = 1;
    #5 ShiftEn = 0;
    #5 Clk = 0; // 300ns
    end
endmodule
