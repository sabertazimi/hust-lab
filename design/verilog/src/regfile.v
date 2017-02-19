/**
 * @module regfile
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
(
    input clk,
    input we,
    input [4:0] raddrA,
    input [4:0] raddrB,
    input [4:0] waddr,
    input [DATA_WIDTH-1:0] wdata,
    output [DATA_WIDTH-1:0] regA,
    output [DATA_WIDTH-1:0] regB
    output [DATA_WIDTH-1:0] $v0,
    output [DATA_WIDTH-1:0] $a0
);

    `include defines.vh

    reg [DATA_WIDTH-1:0] regfile [31:0];    ///< three ported regfile contains 32 registers
    
    initial begin
        if (`DEBUG_REGFILE) begin
            $display("     $v0,    $a0");
            $monitor("%x, %x",
                regfile[`$V0][31:0],	/* $v0 */
                regfile[`$A0][31:0],	/* $a0 */
            );
        end
    end

    always @ (posedge clk) begin
        if (we && waddr != 0) begin
            regfile[waddr] <= wdata;
        end
    end

    assign regA = (raddrA != 0) ? regfile[raddrA] : 0;
    assign regB = (raddrB != 0) ? regfile[raddrB] : 0; 
    assign $v0 = regfile[`$V0];
    assign $a0 = regfile[`$A0];

endmodule // regfile
