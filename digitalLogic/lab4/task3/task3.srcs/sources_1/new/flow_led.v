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
    
    parameter l0 = 0,                           // // state enums
              l1 = 1,
              l2 = 3,
              l3 = 2,
              l4 = 6,
              l5 = 7,
              l6 = 5,
              l7 = 4,
              l8 = 12,
              l9 = 13,
              l10 = 15,
              l11 = 14,
              l12 = 10,
              l13 = 11,
              l14 = 9,
              l15 = 8;   
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
            l3: if (!M) nextState = l4;
                else nextState = l2;
            l4: if (!M) nextState = l5;
                else nextState = l3;
            l5: if (!M) nextState = l6;
                else nextState = l4;
            l6: if (!M) nextState = l7;
                else nextState = l5;
            l7: if (!M) nextState = l8;
                else nextState = l6;
            l8: if (!M) nextState = l9;
                else nextState = l7;
            l9: if (!M) nextState = l10;
                else nextState = l8;
            l10: if (!M) nextState = l11;
                else nextState = l9;
            l11: if (!M) nextState = l12;
                else nextState = l10;
            l12: if (!M) nextState = l13;
                else nextState = l11;
            l13: if (!M) nextState = l14;
                else nextState = l12;
            l14: if (!M) nextState = l15;
                else nextState = l13;
            l15: if (!M) nextState = l0;
                else nextState = l14;
        endcase
    end
endmodule
