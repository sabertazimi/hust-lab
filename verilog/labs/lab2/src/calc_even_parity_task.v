`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/05/24 15:28:54
// Design Name: 
// Module Name: calc_even_parity_task
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


module calc_even_parity_task(
    input [7:0] ain,
    output reg parity
    );
    
    task calc_even_parity;
        input [7:0] ain;
        output parity;
        
        reg [3:0] parity_4bit;
        reg [1:0] parity_2bit;
        
        begin
            parity_4bit = ain[7:4] ^ ain[3:0];
            parity_2bit = parity_4bit[3:2] ^ parity_4bit[1:0];
            parity = parity_2bit[1] ^ parity_2bit[0];
        end
    endtask
    
    always @(ain) begin
        calc_even_parity(ain, parity);
    end
endmodule
