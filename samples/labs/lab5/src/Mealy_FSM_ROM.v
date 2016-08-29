`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/06 20:23:23
// Design Name: 
// Module Name: Mealy_FSM_ROM
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


module Mealy_FSM_ROM(
    input clk,
    input reset,
    input x,
    output reg [2:0] count
    );
    
    reg [2:0] state, nextState;
    reg [5:0] ROM [0:11];
    
    parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3, s4 = 4, s5 = 5;
    
    // set up ROM
    initial begin
        $readmemb("/home/sabertazimi/gitrepo/hust-lab/verilog/lab5/Mealy_FSM_ROM/Mealy_FSM_ROM.srcs/sources_1/new/Mealy_FSM_ROM.dat", ROM, 0, 11);
    end
    
    // update state
    always @(posedge clk or posedge reset) begin
        if (reset) state <= s1;
        else state <= nextState;
    end
    
    /* 
     * compute nextState and output(count) with ROM
     */
     
    /*
     * address = (state * 2 + x + (!clk & !reset)) % 12
     * !clk & !reset : handle little bug
     * mod 12 : handle address overflow
     *
     * data = {nextState, count}
     *
     * ROM[(state * 2 + x + (!clk & !reset)) % 12] = {nextState, count}
     */
    
    /*
     * s0 x = 0: 000010                                                                                                                              
     * s0 x = 1: 001000
     * s1 x = 0: 001000
     * s1 x = 0: 010001
     * s2 x = 0: 010001
     * s2 x = 0: 011011
     * s3 x = 0: 011011
     * s3 x = 0: 100101
     * s4 x = 0: 100101
     * s4 x = 0: 101111
     * s5 x = 0: 101111
     * s5 x = 0: 000010
     */
    always @(x or state) begin
        {nextState, count} <= ROM[(state * 2 + x + (!clk & !reset)) % 12];
    end           
endmodule
