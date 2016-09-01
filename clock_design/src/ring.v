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
// sig_ring: signal for starting bell
// sig_step: signal for control bell time range
// output
// bell: bell ring signal
module ring
#(parameter LEN = 5)
(
    input sig_ring,
    input sig_step,
    output reg bell
);

    reg [31:0] count;

    initial begin
        bell <= 0;
        count <= 0;
    end

    always @(posedge sig_step) begin
        if (sig_ring) begin
            bell = 1;
        end else begin
            if (bell == 1) begin
                count = count + 1;
            end
            if (count == LEN) begin
                count = 0;
                bell = 0;
            end
        end
    end

endmodule
