/**
 * @module dmem
 * @brief data cache memory (RAM)
 * @param DATA_WIDTH data width
 * @param BUS_WIDTH bus width
 * @input clk clock signal
 * @input we write enable signal
 * @input addr memory address
 * @input wdata data write into memory
 * @output rdata data read out from memory
 */
module dmem
#(parameter DATA_WIDTH = 32, BUS_WIDTH = 6)
(
    input clk,
    input we,
    input [BUS_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] wdata,
    output [DATA_WIDTH-1:0] rdata,
);

    reg [DATA_WIDTH-1:0] RAM [(2**BUS_WIDTH)-1:0];

    assign rdata = RAM[addr];

    always @ (posedge clk) begin
        if (we) begin
            RAM[addr[DATA_WIDTH-1:2]] <= wdata;
        end
    end
    
endmodule // dmem
