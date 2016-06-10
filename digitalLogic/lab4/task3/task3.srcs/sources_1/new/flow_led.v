`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/05 22:46:48
// Design Name: 
// Module Name: flow_led
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


module flow_led(
    input clk_src,
    input reset,
    input [4:0] clk_sel,                        // select switch for clock signal
    input M,
    output reg [3:0] state
    );
    
    parameter LEN = 32;                         // length of binary counter(different types of clock signal)
    
    parameter l0 = 1, l1 = 2, l2 = 4, l3 = 8;   // state enums
    reg [3:0] nextState;
    
    wire clk;                                   // truly clock signal
    wire [(LEN-1):0] clk_group;                 // divided clock signal from clk, by binary counter

    assign clk = clk_group[clk_sel];

    binary_counter DIVIDER (.clk_src(clk_src), .reset(reset), .clk_group(clk_group));
    
    always @(posedge clk or posedge reset) begin
        if (reset) state <= l0;
        else state <= nextState;
    end
    
    always @(M or state) begin
        case (state)
            l0: if (!M) nextState = l1;
                else nextState = l3;
            l1: if (!M) nextState = l2;
                else nextState = l0;
            l2: if (!M) nextState = l3;
                else nextState = l1;
            l3: if (!M) nextState = l0;
                else nextState = l2;
        endcase
    end
endmodule
