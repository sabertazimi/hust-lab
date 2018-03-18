/**
 * @module dmem
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief data cache memory (RAM)
 * @param DATA_WIDTH data width
 * @param BUS_WIDTH bus width
 * @input clk clock signal
 * @input re read enable signal
 * @input we write enable signal
 * @input addr memory address
 * @input wdata data write into memory
 * @output rdata data read out from memory
 */
module dmem
#(parameter DATA_WIDTH = 32, BUS_WIDTH = 10)
(
    input clk,
    input re,
    input we,
    input [BUS_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] wdata,
    input [4:0] switch_addr,
    output [DATA_WIDTH-1:0] rdata,
    output [DATA_WIDTH-1:0] led_data
);

    reg [DATA_WIDTH-1:0] RAM [0:(2**BUS_WIDTH)-1];

    always @ (posedge clk) begin
        if (we) begin
            RAM[addr] <= wdata;
        end
    end
    
    assign rdata = re ? RAM[addr] : {(DATA_WIDTH-1){1'bx}};
    assign led_data = RAM[switch_addr];
    
endmodule // dmem
