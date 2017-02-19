/**
 * @module imem
 * @brief instruction cache memory (ROM)
 * @param DATA_WIDTH data width
 * @param BUS_WIDTH bus width
 * @input addr memory address
 * @output rdata instruction read out from memory
 */
module imem
#(parameter DATA_WIDTH = 32, BUS_WIDTH = 10)
(
    input [BUS_WIDTH-1:0] addr,
    output [DATA_WIDTH-1:0] rdata,
);

    reg [DATA_WIDTH-1:0] ROM [0:(2**BUS_WIDTH)-1];

    initial begin
        $readmemh("benchmark.asm", ROM, 0, (2**BUS_WIDTH)-1));
    end
    
    assign rdata = ROM[addr];

endmodule // imem
