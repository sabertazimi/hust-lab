module mips
#(parameter DATA_WIDTH = 32, CODE_FILE = "~/Work/Source/architecture/design/verilog/mips/benchmark.hex", IM_BUS_WIDTH = 10, DM_BUS_WIDTH = 10, CLK_HZ = 18)
(
    input raw_clk,
    input raw_rst,
    input raw_en,
    input switch_rst,
    input switch_stat,
    input switch_ram,
    input switch_correctprediction,
    input switch_misprediction,
    input [4:0] switch_addr,
    output [7:0] anodes,
    output [7:0] cnodes
);

`include "defines.vh"

    ///< wire declaration

    /// clock divider
    wire [DATA_WIDTH-1:0] clk_group;

    // clock halt unit
    wire latch_out, clk_count;
    wire clk;

    // pc update unit
    wire [DATA_WIDTH-1:0] IF_pc;
    wire [DATA_WIDTH-1:0] IF_pc_next;
    wire [DATA_WIDTH-1:0] IF_predict_addr;
    wire [DATA_WIDTH-1:0] IF_mispredict_fix_addr;
    wire [`BTB_PREDICT_SIZE-1:0] IF_taken;

    // instruction memory
    wire [DATA_WIDTH-1:0] IF_ir;

    /// IF/ID
    wire [DATA_WIDTH-1:0] ID_pc, ID_ir;
    wire ID_taken;

    // instruction decoder
    wire [5:0] ID_op;
    wire [4:0] ID_raw_rs;
    wire [4:0] ID_rt;
    wire [4:0] ID_rd;
    wire [4:0] ID_sham;
    wire [5:0] ID_funct;
    wire [15:0] ID_imm16;
    wire [25:0] ID_imm26;

    // control unit
    wire [3:0] ID_aluop;
    wire ID_alusrc;
    wire ID_alusham;
    wire ID_regdst;
    wire ID_regwe;
    wire ID_extop;
    wire ID_ramtoreg;
    wire ID_ramwe;
    wire ID_beq;
    wire ID_bne;
    wire ID_bgtz;
    wire ID_j;
    wire ID_jal;
    wire ID_jr;
    wire ID_syscall;
    wire ID_writetolo;
    wire ID_lotoreg;
    wire ID_rambyte;

    // regfile
    wire [DATA_WIDTH-1:0] ID_raw_r1;
    wire [DATA_WIDTH-1:0] ID_raw_r2;
    wire [DATA_WIDTH-1:0] v0_data;
    wire [DATA_WIDTH-1:0] a0_data;
    wire [4:0] ID_rs;
    
    // prediction handle
    wire ID_equal_address;
    wire ID_success_prediction;
    wire ID_misprediction;

    // forward in ID stage
    wire [DATA_WIDTH-1:0] ID_r1;
    wire [DATA_WIDTH-1:0] ID_r2;

    // branch judgement unit
    wire ID_jmp_imm, ID_jmp_reg, ID_jmp_branch, ID_jmp_need_reg;
    wire eq, less;
    wire signed [DATA_WIDTH-1:0] ID_signed_r1;
    wire signed [DATA_WIDTH-1:0] ID_signed_r2;

    // branch address calculation unit
    wire [DATA_WIDTH-1:0] ID_addr_imm;
    wire [DATA_WIDTH-1:0] ID_addr_reg;
    wire [DATA_WIDTH-1:0] ID_addr_branch;
    wire [DATA_WIDTH-1:0] ID_extshft_imm16;
    wire [DATA_WIDTH-1:0] ID_extshft_imm26;

    /// ID/EX
    wire [DATA_WIDTH-1:0] EX_pc;
    wire [DATA_WIDTH-1:0] EX_ir;
    wire EX_writetolo;
    wire EX_regwe;
    wire EX_ramtoreg;
    wire EX_lotoreg;
    wire EX_syscall;
    wire EX_ramwe;
    wire EX_rambyte;
    wire EX_regdst;
    wire [3:0] EX_aluop;
    wire EX_alusrc;
    wire EX_extop;
    wire EX_alusham;
    wire EX_jal;
    wire [4:0] EX_rs;
    wire [4:0] EX_rt;
    wire [4:0] EX_rd;
    wire [4:0] EX_sham;
    wire [15:0] EX_imm16;
    wire [DATA_WIDTH-1:0] EX_r1;
    wire [DATA_WIDTH-1:0] EX_r2;

    // EX stage
    wire [4:0] EX_RW;
    wire [DATA_WIDTH-1:0] EX_raw_aluX;
    wire [DATA_WIDTH-1:0] EX_raw_aluY;
    wire [DATA_WIDTH-1:0] EX_unsigned_imm32;
    wire [DATA_WIDTH-1:0] EX_signed_imm32;
    wire [DATA_WIDTH-1:0] EX_imm32;
    wire [DATA_WIDTH-1:0] EX_sham32;
    wire [DATA_WIDTH-1:0] EX_aluX;
    wire [DATA_WIDTH-1:0] EX_aluY;
    wire [DATA_WIDTH-1:0] EX_result;

    /// EX_MEM
    wire [DATA_WIDTH-1:0] MEM_pc;
    wire [DATA_WIDTH-1:0] MEM_ir;
    wire MEM_writetolo;
    wire MEM_regwe;
    wire MEM_ramtoreg;
    wire MEM_lotoreg;
    wire MEM_syscall;
    wire MEM_ramwe;
    wire MEM_rambyte;
    wire [4:0] MEM_rt;
    wire [DATA_WIDTH-1:0] MEM_result;
    wire [4:0] MEM_RW;
    wire [DATA_WIDTH-1:0] MEM_r2;

    // MEM stage
    wire [DATA_WIDTH-1:0] MEM_wdata;
    wire [DATA_WIDTH-1:0] MEM_raw_ramdata;
    wire [1:0] MEM_byteaddr;
    wire [7:0] MEM_bytedata8;
    wire [DATA_WIDTH-1:0] MEM_bytedata32;
    wire [DATA_WIDTH-1:0] MEM_ramdata;

    /// MEM/WB
    wire [DATA_WIDTH-1:0] WB_pc;
    wire [DATA_WIDTH-1:0] WB_ir;
    wire WB_writetolo;
    wire WB_regwe;
    wire WB_ramtoreg;
    wire WB_lotoreg;
    wire WB_syscall;
    wire [DATA_WIDTH-1:0] WB_ramdata;
    wire [DATA_WIDTH-1:0] WB_result;
    wire [4:0] WB_RW;
    
    // WB stage
    wire [DATA_WIDTH-1:0] WB_lodata;
    wire [DATA_WIDTH-1:0] WB_regdata;

    // forward unit
    wire [1:0] ID_forwardA;
    wire [1:0] ID_forwardB;
    wire [1:0] EX_forwardA;
    wire [1:0] EX_forwardB;
    wire MEM_forward;

    // bubble detection
    wire load_use_hazard;
    wire branch_flushD;
    wire branch_flushE;
    wire stall;
    wire flushD;
    wire flushE;

    // syscall unit
    wire equal_ten;
    wire halt;
    wire syscall_count;

    // led unit
    wire [DATA_WIDTH-1:0] led_data;
    
    // statistic unit
    wire [DATA_WIDTH-1:0] stat_count;
    wire [DATA_WIDTH-1:0] stat_misprediction;
    wire [DATA_WIDTH-1:0] stat_correctprediction;
    wire [DATA_WIDTH-1:0] stat_flushD;
    wire [DATA_WIDTH-1:0] stat_loaduse;
    wire [DATA_WIDTH-1:0] stat_branchstall;
    
    // memory direct output for led display
    wire [DATA_WIDTH-1:0] ram_data;
   
    ///> wire declaration

    /// clock divider
    tick_divider #(
        .DATA_WIDTH(DATA_WIDTH)
    ) clk_divider (
        .clk_src(raw_clk),
        .clk_group(clk_group)
    );

    ///< IF stage

    // clock halt unit
    latch_counter latch_counter (
        .clk(halt || switch_rst),
        .rst(raw_rst),
        .en(raw_en),
        .count(latch_out)
    );
    
    counter clk_counter (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(latch_out && raw_en),
        .count(clk_count)
    );
    
    assign clk = clk_group[CLK_HZ] && ~clk_count;
    
    // pc update unit
    assign IF_mispredict_fix_addr = ID_jmp_branch ? ID_addr_branch : (ID_pc + 4);
    assign IF_pc_next = ID_jmp_reg ? ID_addr_reg
                : ID_misprediction ? IF_mispredict_fix_addr
                : IF_predict_addr;
                
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) PC (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(stall && raw_en),
        .din(IF_pc_next),
        .dout(IF_pc)
    );
    
    // btb 
    wire IF_hit;
    wire IF_branch;
    wire [DATA_WIDTH-1:0] IF_predict_branch;
    wire [DATA_WIDTH-1:0] ID_true_branch;
    wire [`BTB_DATA_SIZE-1:0] btb_branch_addr;
    
    branch_target_buffer btb (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(stall && raw_en),
        .IF_branch(IF_branch),
        .ID_branch(ID_beq || ID_bne || ID_bgtz),
        .misprediction(ID_misprediction),
        .IF_branch_pc(IF_pc),
        .IF_predict_addr(IF_predict_branch),
        .ID_branch_pc(ID_pc),
        .ID_branch_addr(ID_true_branch),
        .taken(IF_taken),
        .IF_hit(IF_hit),
        .btb_branch_addr(btb_branch_addr)
    );
    
    branch_predictor #(
        .DATA_WIDTH(DATA_WIDTH)
    ) branch_predictor (
        .pc(IF_pc),
        .ir(IF_ir),
        .hit(IF_hit),
        .btb_branch_addr(btb_branch_addr),
        .IF_branch(IF_branch),
        .IF_predict_branch(IF_predict_branch),
        .predict_addr(IF_predict_addr)
    );

    // instruction memory
    imem  #(
        .DATA_WIDTH(DATA_WIDTH),
        .BUS_WIDTH(IM_BUS_WIDTH),
        .CODE_FILE(CODE_FILE)
    ) imem (
        .addr(IF_pc[11:2]),
        .rdata(IF_ir)
    );
    
    ///> IF stage
    
    /// IF/ID
    IF_ID #(
        .DATA_WIDTH(DATA_WIDTH)
    ) IF_ID (
        .clk(clk || switch_rst),
        .rst(flushD || raw_rst),
        .en(stall && raw_en),
        .IF_PC(IF_pc),
        .IF_IR(IF_ir),
        .IF_taken(IF_taken[1]),
        .ID_PC(ID_pc),
        .ID_IR(ID_ir),
        .ID_taken(ID_taken)
    );
    
    ///< ID stage
    
    // instruction decoder
    decoder decoder (
        .instruction(ID_ir),
        .op(ID_op),
        .rs(ID_raw_rs),
        .rt(ID_rt),
        .rd(ID_rd),
        .sham(ID_sham),
        .funct(ID_funct),
        .imm16(ID_imm16),
        .imm26(ID_imm26)
    );
    
    // control unit
    controller controller (
        .op(ID_op),
        .funct(ID_funct),
        .aluop(ID_aluop),
        .alusrc(ID_alusrc),
        .alusham(ID_alusham),
        .regdst(ID_regdst),
        .regwe(ID_regwe),
        .extop(ID_extop),
        .ramtoreg(ID_ramtoreg),
        .ramwe(ID_ramwe),
        .beq(ID_beq),
        .bne(ID_bne),
        .bgtz(ID_bgtz),
        .j(ID_j),
        .jal(ID_jal),
        .jr(ID_jr),
        .syscall(ID_syscall),
        .writetolo(ID_writetolo),
        .lotoreg(ID_lotoreg),
        .rambyte(ID_rambyte)
    );

    // regfile
    assign ID_rs = ID_alusham ? ID_rt : ID_raw_rs;

    regfile #(
        .DATA_WIDTH(DATA_WIDTH)
    ) regfile (
        .clk(clk || switch_rst),
        .we(WB_regwe && raw_en),
        .raddrA(ID_rs),
        .raddrB(ID_rt),
        .waddr(WB_RW),
        .wdata(WB_regdata),
        .regA(ID_raw_r1),
        .regB(ID_raw_r2),
        .v0_data(v0_data),
        .a0_data(a0_data)
    );
    
    // prediction handle
    assign ID_equal_address = (ID_jmp_branch == ID_taken);
    assign ID_success_prediction = ID_equal_address && (ID_beq || ID_bne || ID_bgtz);
    assign ID_misprediction = ~ID_equal_address && (ID_beq || ID_bne || ID_bgtz);
    
    // forward in ID stage
    assign ID_r1 = (ID_forwardA == 2'b10) ? MEM_result
                : (ID_forwardA == 2'b01) ? WB_regdata
                : ID_raw_r1;
    assign ID_r2 = (ID_forwardB == 2'b10) ? MEM_result
                : (ID_forwardB == 2'b01) ? WB_regdata
                : ID_raw_r2;
    
    // branch judgement unit
    assign ID_signed_r1 = $signed(ID_r1);
    assign ID_signed_r2 = $signed(ID_r2);
    assign eq = (ID_r1 == ID_r2);
    assign less = (ID_signed_r1 < ID_signed_r2);
    
    assign ID_jmp_imm =  ID_j || ID_jal;
    assign ID_jmp_reg = ID_jr;
    assign ID_jmp_branch = (ID_beq && eq) || (ID_bne && ~eq) || (ID_bgtz && ~eq && ~less);
    assign ID_jmp_need_reg = ID_beq || ID_bne || ID_bgtz || ID_jr;
    
    // branch address calculation unit
    assign ID_addr_reg = ID_r1;
    
    address_calculator #(
        .DATA_WIDTH(DATA_WIDTH)
    ) ID_address_calculator (
        .pc(ID_pc),
        .imm16(ID_imm16),
        .imm26(ID_imm26),
        .addr_imm(ID_addr_imm),
        .addr_branch(ID_addr_branch)
    );
    
    assign ID_true_branch = ID_jmp_reg ? ID_addr_branch : (ID_pc + 4);
    
    ///> ID stage
    
    /// ID/EX
    ID_EX #(
        .DATA_WIDTH(DATA_WIDTH)
    ) ID_EX (
        .clk(clk || switch_rst),
        .rst(flushE || raw_rst),
        .en(raw_en),
        .ID_PC(ID_pc),
        .ID_IR(ID_ir),
        .ID_writetolo(ID_writetolo),
        .ID_regwe(ID_regwe),
        .ID_ramtoreg(ID_ramtoreg),
        .ID_lotoreg(ID_lotoreg),
        .ID_syscall(ID_syscall),
        .ID_ramwe(ID_ramwe),
        .ID_rambyte(ID_rambyte),
        .ID_regdst(ID_regdst),
        .ID_aluop(ID_aluop),
        .ID_alusrc(ID_alusrc),
        .ID_extop(ID_extop),
        .ID_alusham(ID_alusham),
        .ID_jal(ID_jal),
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .ID_rd(ID_rd),
        .ID_sham(ID_sham),
        .ID_imm16(ID_imm16),
        .ID_r1(ID_r1),
        .ID_r2(ID_r2),
        .EX_PC(EX_pc),
        .EX_IR(EX_ir),
        .EX_writetolo(EX_writetolo),
        .EX_regwe(EX_regwe),
        .EX_ramtoreg(EX_ramtoreg),
        .EX_lotoreg(EX_lotoreg),
        .EX_syscall(EX_syscall),
        .EX_ramwe(EX_ramwe),
        .EX_rambyte(EX_rambyte),
        .EX_regdst(EX_regdst),
        .EX_aluop(EX_aluop),
        .EX_alusrc(EX_alusrc),
        .EX_extop(EX_extop),
        .EX_alusham(EX_alusham),
        .EX_jal(EX_jal),
        .EX_rs(EX_rs),
        .EX_rt(EX_rt),
        .EX_rd(EX_rd),
        .EX_sham(EX_sham),
        .EX_imm16(EX_imm16),
        .EX_r1(EX_r1),
        .EX_r2(EX_r2)
    );
    
    ///< EX stage
    
    assign EX_RW = EX_jal ? 5'h1f
                : EX_regdst ? EX_rd
                : EX_rt;
    assign EX_raw_aluX = (EX_forwardA == 2'b10) ? MEM_result
                        : (EX_forwardA == 2'b01) ? WB_regdata
                        : EX_r1;
    assign EX_raw_aluY = (EX_forwardB == 2'b10) ? MEM_result
                        : (EX_forwardB == 2'b01) ? WB_regdata
                        : EX_r2;
    assign EX_unsigned_imm32 = {{(DATA_WIDTH-16){1'b0}}, EX_imm16};
    assign EX_signed_imm32 = {{(DATA_WIDTH-16){EX_imm16[15]}}, EX_imm16};
    assign EX_imm32 = EX_extop ? EX_signed_imm32 : EX_unsigned_imm32;
    assign EX_sham32 = {{(DATA_WIDTH-5){1'b0}}, EX_sham};
    assign EX_aluX = EX_jal ? EX_pc : EX_raw_aluX;
    assign EX_aluY = EX_jal ? 32'h4
                    : EX_alusham ? EX_sham32
                    : EX_alusrc ? EX_imm32
                    : EX_raw_aluY;
    
    // alu
    alu #(
        .DATA_WIDTH(DATA_WIDTH)
    ) alu (
        .srcA(EX_aluX),
        .srcB(EX_aluY),
        .aluop(EX_aluop),
        .aluout(EX_result),
        .zero(),
        .of(),
        .uof()
    );
    
    ///> EX stage
    
    /// EX_MEM
    EX_MEM #(
        .DATA_WIDTH(DATA_WIDTH)
    ) EX_MEM (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(raw_en),
        .EX_PC(EX_pc),
        .EX_IR(EX_ir),
        .EX_writetolo(EX_writetolo),
        .EX_regwe(EX_regwe),
        .EX_ramtoreg(EX_ramtoreg),
        .EX_lotoreg(EX_lotoreg),
        .EX_syscall(EX_syscall),
        .EX_ramwe(EX_ramwe),
        .EX_rambyte(EX_rambyte),
        .EX_rt(EX_rt),
        .EX_result(EX_result),
        .EX_RW(EX_RW),
        .EX_r2(EX_r2),
        .MEM_PC(MEM_pc),
        .MEM_IR(MEM_ir),
        .MEM_writetolo(MEM_writetolo),
        .MEM_regwe(MEM_regwe),
        .MEM_ramtoreg(MEM_ramtoreg),
        .MEM_lotoreg(MEM_lotoreg),
        .MEM_syscall(MEM_syscall),
        .MEM_ramwe(MEM_ramwe),
        .MEM_rambyte(MEM_rambyte),
        .MEM_rt(MEM_rt),
        .MEM_result(MEM_result),
        .MEM_RW(MEM_RW),
        .MEM_r2(MEM_r2)
    );

    ///< MEM stage

    assign MEM_wdata = MEM_forward ? WB_regdata : MEM_r2;
    
    dmem #(
        .DATA_WIDTH(DATA_WIDTH),
        .BUS_WIDTH(DM_BUS_WIDTH)
    ) dmem (
        .clk(clk || switch_rst),
        .re(MEM_ramtoreg),
        .we(MEM_ramwe && ~halt && raw_en),
        .addr(MEM_result[25:2]),
        .wdata(MEM_wdata),
        .switch_addr(switch_addr),
        .rdata(MEM_raw_ramdata),
        .led_data(ram_data)
    );
    
    assign MEM_byteaddr = MEM_result[1:0];
    assign MEM_bytedata8 = (MEM_byteaddr == 2'b00) ? MEM_raw_ramdata[7:0]
                        : (MEM_byteaddr == 2'b01) ? MEM_raw_ramdata[15:8]
                        : (MEM_byteaddr == 2'b10) ? MEM_raw_ramdata[23:16]
                        : MEM_raw_ramdata[31:24];
    assign MEM_bytedata32 = {{(DATA_WIDTH-8){MEM_bytedata8[7]}}, MEM_bytedata8};
    assign MEM_ramdata = MEM_rambyte ? MEM_bytedata32 : MEM_raw_ramdata;
    
    ///> MEM stage
    
    /// MEM/WB
    MEM_WB #(
        .DATA_WIDTH(DATA_WIDTH)
    ) MEM_WB (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(raw_en),
        .MEM_PC(MEM_pc),
        .MEM_IR(MEM_ir),
        .MEM_writetolo(MEM_writetolo),
        .MEM_regwe(MEM_regwe),
        .MEM_ramtoreg(MEM_ramtoreg),
        .MEM_lotoreg(MEM_lotoreg),
        .MEM_syscall(MEM_syscall),
        .MEM_ramdata(MEM_ramdata),
        .MEM_result(MEM_result),
        .MEM_RW(MEM_RW),
        .WB_PC(WB_pc),
        .WB_IR(WB_ir),
        .WB_writetolo(WB_writetolo),
        .WB_regwe(WB_regwe),
        .WB_ramtoreg(WB_ramtoreg),
        .WB_lotoreg(WB_lotoreg),
        .WB_syscall(WB_syscall),
        .WB_ramdata(WB_ramdata),
        .WB_result(WB_result),
        .WB_RW(WB_RW)
    );
    
    ///< WB stage
  
    register #(
        .DATA_WIDTH(DATA_WIDTH)
    ) LO (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(WB_writetolo && raw_en),
        .din(MEM_result),
        .dout(WB_lodata)
    );
    
    assign WB_regdata = WB_lotoreg ? WB_lodata
                        : WB_ramtoreg ? WB_ramdata
                        : WB_result;
    
    ///> WB stage
    
    // forward unit
    forward_unit forward_unit (
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .EX_rs(EX_rs),
        .EX_rt(EX_rt),
        .MEM_rt(MEM_rt),
        .MEM_ramwe(MEM_ramwe),
        .MEM_regwe(MEM_regwe),
        .WB_regwe(WB_regwe),
        .MEM_RW(MEM_RW),
        .WB_RW(WB_RW),
        .ID_forwardA(ID_forwardA),
        .ID_forwardB(ID_forwardB),
        .EX_forwardA(EX_forwardA),
        .EX_forwardB(EX_forwardB),
        .MEM_forward(MEM_forward)
    );
    
    // bubble detection
    load_use_detector load_use_detector (
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .EX_rt(EX_rt),
        .EX_ramtoreg(EX_ramtoreg),
        .load_use_hazard(load_use_hazard)
    );
    
    branch_hazard_detector branch_hazard_detector (
        .ID_rs(ID_rs),
        .ID_rt(ID_rt),
        .EX_regwe(EX_regwe),
        .EX_RW(EX_RW),
        .MEM_ramtoreg(MEM_ramtoreg),
        .MEM_RW(MEM_RW),
        .ID_jmp_need_reg(ID_jmp_need_reg),
        .ID_jmp_reg(ID_jmp_reg),
        .ID_misprediction(ID_misprediction),
        .branch_flushD(branch_flushD),
        .branch_flushE(branch_flushE)
    );

    assign stall = ~(load_use_hazard || branch_flushE);
    assign flushD = branch_flushD;
    assign flushE = load_use_hazard || branch_flushE;
    
    // syscall unit
    assign equal_ten = (v0_data == 32'ha);
    assign halt = WB_syscall && equal_ten;
    
    register #(
        .DATA_WIDTH(1)
    ) syscall_register (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(~equal_ten && WB_syscall && raw_en),
        .din(1),
        .dout(syscall_count)
    );

    // statistic unit
    counter #(
        .DATA_WIDTH(DATA_WIDTH),
        .STEP(1)
    ) stat_counter (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(raw_en),
        .count(stat_count)
    );

    counter #(
        .DATA_WIDTH(DATA_WIDTH),
        .STEP(1)
    ) stat_mispredictor (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(stall && ID_misprediction && raw_en),
        .count(stat_misprediction)
    );

   counter #(
        .DATA_WIDTH(DATA_WIDTH),
        .STEP(1)
    ) stat_correctpredictor (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(stall && (ID_success_prediction || ID_j || ID_jal) && raw_en),
        .count(stat_correctprediction)
    );

    counter #(
        .DATA_WIDTH(DATA_WIDTH),
        .STEP(1)
    ) stat_flushDer (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(stall && flushD && raw_en),
        .count(stat_flushD)
    );

    counter #(
        .DATA_WIDTH(DATA_WIDTH),
        .STEP(1)
    ) stat_loaduser (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(load_use_hazard  && raw_en),
        .count(stat_loaduse)
    );

    counter #(
        .DATA_WIDTH(DATA_WIDTH),
        .STEP(1)
    ) stat_branchstaller (
        .clk(clk || switch_rst),
        .rst(raw_rst),
        .en(branch_flushE && raw_en),
        .count(stat_branchstall)
    );

    // led unit
    assign led_data = switch_stat ? stat_count
                    : switch_ram ? ram_data
                    : switch_correctprediction ? stat_correctprediction
                    : switch_misprediction ? stat_misprediction
                    : syscall_count ? a0_data
                    : 0;
    
    led_unit #(
        .DATA_WIDTH(DATA_WIDTH)
    ) led_unit (
        .clk_src(clk_group[15]),
        .led_data(led_data),
        .anodes(anodes),
        .cnodes(cnodes)
    );
    
endmodule // mips
