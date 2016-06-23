`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 22:19:13
// Design Name: 
// Module Name: Register_with_synch_reset_set_load_behavior_tb
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


module Register_with_synch_reset_set_load_behavior_tb(

    );
    
    reg [3:0] D;
    reg Clk, reset, set, load;
    wire [3:0] Q;
    
    Register_with_synch_reset_set_load_behavior DUT (.D(D), .Clk(Clk), .reset(reset), .set(set), .load(load), .Q(Q));
    
    initial begin
        #300 $finish;
    end
    
    initial begin
    D = 4'b0000; Clk = 0; reset = 0; set = 0; load = 0;
    #10 Clk = 1;
    #10 Clk = 0; D = 4'b0101;
    #10 Clk = 1;
    #10 Clk = 0;
    #10 Clk = 1;
    #10 Clk = 0; load = 1;
    #10 Clk = 1;
    #10 Clk = 0; D = 4'b1001; load = 0;
    #10 Clk = 1;
    #10 Clk = 0; // 100ns
    #10 Clk = 1;
    #10 Clk = 0; load = 1;
    #10 Clk = 1;
    #10 Clk = 0; load = 0;
    #10 Clk = 1;
    #5 reset = 1;
    #5 Clk = 0; 
    #10 Clk = 1; set = 1; 
    #10 Clk = 0;
    #10 Clk = 1; set = 0;
    #5 load = 1;
    #5 Clk = 0; // 200ns
    #10 Clk = 1;
    #5 load = 0;
    #5 Clk = 0;
    #10 Clk = 1;
    #10 Clk = 0; reset = 0;
    #10 Clk = 1; set = 1;
    #10 Clk = 0;
    #10 Clk = 1; set = 0;
    #10 Clk = 0; load = 1;
    #10 Clk = 1;
    #10 Clk = 0; load = 0;// 300ns
    end
endmodule
