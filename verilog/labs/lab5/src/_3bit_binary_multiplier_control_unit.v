`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/07 13:20:30
// Design Name: 
// Module Name: _3bit_binary_multiplier_control_unit
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


module _3bit_binary_multiplier_control_unit
(
    input start,
    input clk,
    input cnt_done,
    input lsb,
    output start_process,
    output reg add,
    output reg shift,
    output reg count_up,
    output reg done
    // ,output state   
);

    reg [2:0] state, nextState;
    parameter off = 0, on = 1, process = 2, finish = 3;
    
    assign start_process = start;
    
    initial begin
        state = off;
    end
    
    // update state
    always @(posedge clk) begin
        state <= nextState;
    end
    
    //compute mealy output and state
    always @(start or lsb or cnt_done or state) begin
        add = 0;
        case (state)
            off: begin
                if (start) nextState = on;
                else nextState = off;
            end
            on: begin
                if (lsb) begin
                    nextState = process;
                    add = 1;
                end
                else begin
                    nextState = process;
                end
            end
            process: begin
                if (cnt_done) nextState = finish;
                else nextState = on;
            end
            finish: begin
                nextState = off;
            end
            default: begin
                nextState = off;
            end
        endcase
    end
    
    // compute Moore output
    always @(state) begin
        shift = 0;
        count_up = 0;
        done = 0;
        case (state)
            process: begin
                shift = 1;
                count_up = 1;
            end
            finish: begin
                done = 1;
            end
            default: begin
                shift = 0;
                count_up = 0;
                done = 0;
            end
        endcase
    end
endmodule
