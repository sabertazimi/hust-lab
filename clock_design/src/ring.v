`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/08/30 09:22:52
// Design Name: 
// Module Name: ring
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

// input
// sig_ring: signal for starting alarm
// sig_step: signal for control alarm time range
// output
// alarm: alarm ring signal
module ring
#(parameter LEN = 5)
(
    input sig_ring,
    input sig_step,
    output reg alarm
);

    reg [31:0] count;

    initial begin
        alarm <= 0;
        count <= 0;
    end

    always @(posedge sig_step) begin
        if (sig_ring) begin
            alarm = 1;
        end else begin
            if (alarm == 1) begin
                count = count + 1;
            end
            if (count == LEN) begin
                count = 0;
                alarm = 0;
            end
        end
    end

endmodule
