/**
 * @module regfile
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief register files for MIPS CPU, contains 32 D flip-flop registers
 * @param DATA_WIDTH data width
 * @input clk clock signal
 * @input we write enable signal
 * @input raddrA read address (No.register) for A out port
 * @input raddrB read address (No.register) for B out port
 * @input waddr write address (No.register) for wdata (in port)
 * @input wdata data to write into regfile
 * @output regA A port output
 * @output regB B port output
 */
module regfile
#(parameter DATA_WIDTH = 32)
(
    input clk,
    input rst,
    input we,
    input [4:0] raddrA,
    input [4:0] raddrB,
    input [4:0] waddr,
    input [DATA_WIDTH-1:0] wdata,
    output [DATA_WIDTH-1:0] regA,
    output [DATA_WIDTH-1:0] regB,
    output [DATA_WIDTH-1:0] v0_data,
    output [DATA_WIDTH-1:0] a0_data
);

`include "defines.vh"

    reg [4:0] i;
    reg [DATA_WIDTH-1:0] regfile [0:31];    ///< three ported regfile contains 32 registers
    
    initial begin
        i <= 0;
    end
    
    always @ (posedge clk) begin
        if (rst) begin
            for (i = 0; i < 31; i = i + 1)
                begin
                    regfile[i] <= 0;
                end
        end else if (we && waddr != 0) begin
            regfile[waddr] <= wdata;
        end
    end

    assign regA = (raddrA != 0) ? regfile[raddrA] : 0;
    assign regB = (raddrB != 0) ? regfile[raddrB] : 0; 
    assign v0_data = regfile[`V0];
    assign a0_data = regfile[`A0];

endmodule // regfile
