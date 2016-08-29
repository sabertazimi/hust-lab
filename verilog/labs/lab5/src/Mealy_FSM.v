`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2016/05/30 20:05:27
// Design Name:
// Module Name: Mealy_FSM
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


module Mealy_FSM(
    input Clk,
    input reset,
    input ain,
    output reg [3:0] count,
    output reg yout
    );

    reg [1:0] state, nextState;
    parameter s0 = 0, s1 = 1, s2 = 2, s3 = 3;

    // update state
    always @(posedge Clk) begin
        if(reset) begin
            state <= s0;
            count <= 0;
        end
        else begin
            state <= nextState;
            if (nextState != state) count <= count + 1;
        end
    end

    // compute nextState and yout
    always @(ain or state or reset) begin
        yout = 0;
        case(state)
            s0: begin
                if (ain) begin
                    nextState <= s1;
                end
                else begin
                    nextState <= s0;
                    if (~reset) yout <= 1;
                end
            end
            s1: begin
                if (ain) beg
                    nextState <= s2;
                end
                else begin
                    nextState <= s1;
                end
            end
            s2: begin
                if (ain) begin
                    nextState <= s3;
                end
                else begin
                    nextState <= s2;
                end
            end
            s3: begin
                if (ain) begin
                    nextState <= s1;
                    yout <= 1;
                end
                else begin
                    nextState <= s3;
                end
            end
        endcase
    end
endmodule
