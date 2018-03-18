/**
 * @module IF_ID
 * @author sabertazimi
 * @email sabertazimi@gmail.com
 * @brief IF_ID pipeline register
 * @input clk clock signal
 * @input rst reset signal
 * @input en load enable signal
 * @input IF_PC PC value in IF stage
 * @input IF_IR instruction value in IF stage
 * @output ID_PC PC value in ID stage
 * @output ID_IR instruction value in ID stage
 */
module IF_ID
#(parameter DATA_WIDTH = 32)
(
    input clk,
    input rst,
    input en,
    input [DATA_WIDTH-1:0] IF_PC,
    input [DATA_WIDTH-1:0] IF_IR,
    input IF_taken,
    output [DATA_WIDTH-1:0] ID_PC,
    output [DATA_WIDTH-1:0] ID_IR,
    output ID_taken
);

    wire real_rst = rst && en;
    
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) PC (
        .clk(clk),
        .rst(real_rst),
        .en(en),
        .din(IF_PC),
        .dout(ID_PC)
    );
    
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) IR (
        .clk(clk),
        .rst(real_rst),
        .en(en),
        .din(IF_IR),
        .dout(ID_IR)
    );
    
    register #(
        .DATA_WIDTH(1)
    ) taken (
        .clk(clk),
        .rst(real_rst),
        .en(en),
        .din(IF_taken),
        .dout(ID_taken)
    );
    
endmodule // IF_ID
