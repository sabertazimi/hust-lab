`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2016/06/03 11:34:51
// Design Name: 
// Module Name: full_adder
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


module full_adder (Ai,Bi,Ci_1,F,Si,Ci);
    input Ai,Bi,Ci_1;
    output F, Si,Ci;
    wire s,t1,t2;
    xor #2
        ax1(s,Ai,Bi),
        
        ax2(Si,s,Ci_1);
    and #2
        aa1(t2,Ci_1,s),
        aa2(t1,Ai,Bi);
    or #2
        ao1(Ci,t2,t1);
    xnor #2
        an1(F,Si,Ci);
endmodule
