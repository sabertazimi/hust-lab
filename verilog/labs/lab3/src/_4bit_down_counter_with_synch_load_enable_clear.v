`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/25 10:03:43
// Design Name: 
// Module Name: _4bit_down_counter_with_synch_load_enable_clear
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


module _4bit_down_counter_with_synch_load_enable_clear(
    input Clock,
    input Clear,
    input Enable,
    input Load,
    output [3:0] Q
    );
    
    reg [3:0] count;
    wire cnt_done;  // mod flag
    
    assign cnt_done = ~|count;   // reduce nor
    assign Q = count;
    
    always @(posedge Clock) begin
        if (Clear) count <= 4'b0000;
        else if (Enable)
            if (Load | cnt_done) count <= 4'b1010;
            else count <= count - 1;
    end
endmodule
