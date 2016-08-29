`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 10:33:24
// Design Name: 
// Module Name: _2bit_up_counter_with_synch_load_enable_clear_tb
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


module _2bit_up_counter_with_synch_load_enable_clear_tb(
    );
    
reg Clock, Clear, Enable, Load;
wire [1:0] Q;

_2bit_up_counter_with_synch_load_enable_clear DUT (.Clock(Clock), .Clear(Clear), .Enable(Enable), .Load(Load), .Q(Q));

initial begin
    #300 $finish;
end

initial begin
    Clock = 0; Clear = 0; Enable = 0; Load = 0;
    #5 Clock = 1;
    #5 Clock = 0; // 10ns
    #5 Clock = 1;
    #5 Clock = 0; Enable = 1;
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0; Clear = 1;
    #5 Clock = 1;
    #5 Clock = 0; // 50ns
    #5 Clock = 1;
    #5 Clock = 0; Clear = 0;
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0; Load = 1;
    #5 Clock = 1;
    #5 Clock = 0; Load = 0; // 90ns
    #5 Clock = 1;
    #5 Clock = 0; // 100ns
    #5 Clock = 1;
    #5 Clock = 0; // 110ns
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0; // 150ns
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0; Enable = 0;
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0; // 190ns
    #5 Clock = 1;
    #5 Clock = 0; // 200ns
    #5 Clock = 1;
    #5 Clock = 0; Enable = 1; // 210ns
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0; // 250ns
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0;
    #5 Clock = 1;
    #5 Clock = 0; // 290ns
    #5 Clock = 1;
    #5 Clock = 0; // 300ns
end
endmodule