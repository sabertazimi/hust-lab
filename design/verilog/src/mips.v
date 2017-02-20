module mips
#(parameter DATA_WIDTH = 32, CODE_FILE = "mips/benchmark.hex", IM_BUS_WIDTH = 10, DM_BUS_WIDTH = 24)
(
    input raw_clk,
    input raw_rst,
    input raw_en,
    output [DATA_WIDTH-1:0] a0_data
);

    // IF stage

    // clock halt unit
    wire latch_out, clk_count;
    wire clk;
    
    latch_register latch_register (
        .clk(halt),
        .rst(raw_rst),
        .en(raw_en),
        .count(latch_out)
    );
    
    couter clk_counter (
        .clk(clk),
        .rst(raw_rst),
        .en(latch_out),
        .count(clk_count)
    );
    
    assign clk = raw_clk && ~clk_count;
    
    // pc update unit
    wire [DATA_WIDTH-1:0] IF_pc, IF_pc_next;
    
    assign IF_pc_next = ID_jmp_reg ? ID_addr_reg
                : ID_jmp_imm ? ID_addr_imm
                : ID_jmp_branch ? ID_addr_branch
                : (IF_pc + 4);
                
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) PC (
        .clk(clk),
        .rst(raw_rst),
        .en(stall),
        .din(IF_pc_next),
        .dout(IF_pc)
    );
    
    // instruction memory
    wire [DATA_WIDTH-1:0] IF_ir;
    
    imem  #(
        .DATA_WIDTH(DATA_WIDTH),
        .BUS_WIDTH(IM_BUS_WIDTH),
        .CODE_FILE(CODE_FILE)
    ) imem (
        .addr(IF_pc[11:2]),
        .rdata(IF_ir)
    );
    
    // IF stage
    
    // IF/ID
    wire [DATA_WIDTH-1:0] ID_pc, ID_ir;
    
    IF_ID #(
        .DATA_WIDTH(DATA_WIDTH)
    ) IF_ID (
        .clk(clk),
        .rst(flushD),
        .en(stall),
        .IF_PC(IF_pc),
        .IF_IR(IF_ir),
        .ID_PC(ID_pc),
        .ID_IR(ID_ir)
    );
    // IF/ID
    
    // ID stage
    
    
    
    // ID stage
    
endmodule // mips