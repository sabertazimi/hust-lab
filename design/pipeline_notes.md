# Pipelined MIPS CPU

## Warnings

*   for all control signal: explict for zero if it's uneccessory
*   for all output: explict for zero if it's uneccessory

## Tips

*   PC，IR最好一直传递到最后一级，这样方便观测流水线运行的状况。
*   流水线各级是否产生气泡可以用LED指示灯显示，方便观察流水线运行状况

## Instructions

1. Data processing
2. PSR (Program Status Register) transfer
3. Multiply
4. Single data swap
5. Single data transfer
6. Branch Predictor
7. Block data transfer
8. Coprocessor register transfer
9. Coprocessor data transfer
10. Coprocessor data operation
11. Undefined Instruction
12. Software interrupt 

## Frameworks

### Controller

*   Instruction decoding
*   Pipeline Registers
*   FSM(branch predictor)
*   Interrupt handler

## Installation

```sh
$ sudo apt install logisim # install logisim platform
$ sudo apt install verilog # install icarus verilog simulatr
$ sudo apt install gtkwave # install waveform viewer comes with icarus verilog
$ sudo apt install yosys   # synthesize
$ sudo apt install geda    # graphic eda toolchains
```

## Tools

```sh
$ iverilog -o demo demo_tb.v demo.v # compiler
$ iverilog -o demo -c src.list      # src.list => demo.v demo_tb.v
$ iverilog -s main -o hello hello.v # set root module to `main`
$ iverilog -E -o preprocessed.v unpreprocessed.v # pre-process signal stage
$ iverilog -I/include               # for `include directive
$ iverilog -y/lib                   # add lib search path
$ vvp demo                          # simulation runtime engine
$ vvp -n demo -lxt2
$ gtkwave demo.lxt
$ gtkwave trace.vcd
```

### test bench

*   `$time/$finish/$display/$monitor`

*   `$value$plusargs`

```verilog
module main;

  reg clk, reset;
  reg [31:0] x;
  wire [15:0] y;
  wire        rdy;

  sqrt32 dut (clk, rdy, reset, x, y);

  always #10 clk = ~clk;

  initial begin
     clk = 0;
     reset = 1;

     if (! $value$plusargs("x=%d", x)) begin
        $display("ERROR: please specify +x=<value> to start.");
        $finish;
     end

     #35 reset = 0;

     wait (rdy) $display("y=%d", y);
     $finish;
  end // initial begin

endmodule // main
```

```sh
$ iverilog -osqrt_plusargs.vvp sqrt_plusargs.v sqrt.v
$ vvp sqrt_plusargs.vvp +x=81
  # => y = 9
```

*   $readmemh

```verilog
module main;

  reg clk, reset;
  reg [31:0] data[4:0];
  reg [31:0] x;
  wire [15:0] y;
  wire        rdy;

  sqrt32 dut (clk, rdy, reset, x, y);

  always #10 clk = ~clk;

  integer i;
  initial begin
     /* Load the data set from the hex file. */
     $readmemh("sqrt.hex", data);
     for (i = 0 ;  i <= 4 ;  i = i + 1) begin
       clk = 0;
       reset = 1;

       x = data[i];

       #35 reset = 0;

       wait (rdy) $display("y=%d", y);
     end
     $finish;
  end // initial begin

endmodule // main
```

```sh
  # sqrt.hex =>
  # 51
  # 19
  # 1a
  # 18
  # 1
$ iverilog -osqrt_readmem.vvp sqrt_readmem.vl sqrt.vl
$ vvp sqrt_readmem.vvp
  # y = 9
  # y = 5
  # y = 5
  # y = 4
  # y = 1
```

### GTKWave

In your .v file, specify:

```verilog
$dumpfile(“file.vcd”)
$dumpvars(level, vars_or_modules)
```

where level means 0 all or 1 listed only:

*   file.vcd is created when vvp is run
*   Visualize using: gtkwave file.vcd

```verilog
module trace;
    reg clk=0; reg[3:0]a=4'd0; reg b=0;
    always #1 clk=~clk;
    always @(posedge clk) begin
        a=a+1; b=a[2]; end
    initial begin
        $dumpfile(“trace.vcd”);
        $dumpvars(0, trace); // all vars
    end
endmodule
```

### yosys

## Notes

### ideal pipeline registers

#### IF/ID

*   pc
*   ir

#### ID/EX

*   pc
*   ir
 
*   RegWe(WB)
*   RAMtoReg(WB)
*   LOToReg(WB)
*   Syscall(WB)
*   RAMWe(MEM)
*   RAMByte(MEM)
*   RegDst(EX)
*   ALUOp(EX)
*   ALUSrc(EX)
*   ExtOp(EX)
*   ALUSham(EX)
*   Beq(EX)
*   Bne(EX)
*   Bgtz(EX)
*   Jmp(EX)
*   Jal(EX)
*   Jr(EX)
*   WriteToLO(EX)

*   rt(EX)
*   rd(EX)
*   sham(EX)
*   imm16(EX)
*   imm26(EX)
*   R1(EX/WB)
*   R2(EX/MEM)
*   RW#(WB)

#### EX/MEM

*   LOData(WB)

### hazards

@TODO: is it neccessory to detect rs or rt get read ?

### load use hazard


load use hazard when: id/ex r-instr(r-r-alu, r-imm-alu, load/store, branch) + mem load

```verilog
ID/EX.MemRead &&
    ((ID/EX.RegisterRt == IF/ID.RegisterRs) ||
    (ID/EX.RegisterRt == IF/ID.RegisterRt))
```

```verilog
assign lwstall = ((rsD == rtE) || (rtD == rtE)) and MemtoRegE
assign StallF = StallD = FlushE = lwstall
assign en_pipeline_register = !Stall_X
assign rst_pipeline_register = Flush_E
```

### hazard detection on forwarding

*   id/ex r-instr(r-r-alu, r-imm-alu, load/store, branch) + mem/wb r-r-alu: rd => rs/rt
*   id/ex r-instr(r-r-alu, r-imm-alu, load/store, branch) + mem/wb r-imm-alu: rd => rs/rt
*   id/ex r-instr(r-r-alu, r-imm-alu, load/store, branch) + wb load: rt => rs/rt
*   above reference: computer architecture: a quantitative approach. P322

*   decode stage

```verilog
assign ForwardAD = (rsD != 0) && (rsD == WriteRegM) && EnRegWriteM
assign ForwardBD = (rtD != 0) && (rtD == WriteRegM) && EnRegWriteM
```

*   execute stage

```verilog
if ((rsE != 0) && (rsE == WriteRegM) && EnRegWriteM) begin
    ForwardAE = 10 (from memory access stage)
end else if ((rsE != 0) && (rsE == WriteRegW) && EnRegWriteW) begin
    ForwardAE = 01 (from write back stage)
end else begin
    ForwardAE = 00 (no forwarding)
end
```

### how to stall the pipeline

*   Force control values in ID/EX register to 0
    *   EX, MEM and WB do nop (no-operation)
*   Prevent update of PC and IF/ID register
    *   Using instruction is decoded again
    *   Following instruction is fetched again
    *   1-cycle stall allows MEM to read data for lw
        *   Can subsequently forward to EX stage

if detected, stall and insert bubble

```verilog
// branch stall with branch predicting in decode stage
assign branchstall = (BranchD && RegWriteE && (WriteRegE == rsD || WriteRegE == rtD))
    || (BranchD && MemtoRegM && (WriteRegM == rsD || WriteRegM == rtD))
assign StallF = StallD = FlushE = (lwstall || branchstall)
```

### branch predict

*   always not taken
*   backward taken, forward not taken
*   **饱和计数预测器**(Saturating counter/2 bit predictor) algorithm state machine
*   神经分支预测器

#### 2 bit predictor

not taken(miss: should taken) -> not taken(miss: should taken) -> taken

*   get true outcome: just like signal in PC update logic = (zero && beq) || (!zero && bne)
*   Branch target register/buffer
*   [start in weak state(01/10)](https://www.youtube.com/watch?v=AWv8DCm_UYE)
*   对于 SPEC89 基准测试程序, 使用有 4096 个入口的转移预测缓存会获得 82%~99% 的准确率 亨尼西, 帕特森, 白跃彬译.计算机系统结构:量化研究方法, 北京: 电子工业出版社, 2007.8 P56-P57

### interrupts handler

#### Single-cycle

将 InstrRAM 分为 2 块, 11 位为 1 时存放中断处理例程

#### Pipeline

*   The interrupts(external) are acknowledged in the execute stage. Then this signal is propagated to the Write Back stage through Memory Access stage. 
*   if there are no separate registers to handle the interrupts, the handler has to move all the data in the general working registers to a stack memory and retrieve once it has been serviced. This takes many more clock cycles. To avoid this it’s better to use a limited number of special registers only for Interrupts.
*   stages before execute stage should have own reserve stack space, e.g ``fetch` stack space, `decode/reg_read` stack space


#### Registers

Coprocessor 0(cp0): defines up to 32 special-purpose registers

##### cp0 No.12: status register (32 bit)

*   Status寄存器是一个读/写寄存器，可以表示处理器的操作模式、中断使能以及诊断状态。该寄存器的区域联合作用，可以创建处理器的工作模式。
*   中断使能：当以下所有条件都成立时启用中断：IE = 1, EXL = 0, ERL = 0,  DM = 0
*   当这些条件都符合时，设置IM位和IE位可以使能中断。
*   SR[15:8] - IM[7:0] (interrupt mask)
*   为了默认开中断, 将 SR[IE] 功能反转: 1 关中断, 0 开中断
*   mtc0: 部分实现 - mtc0 $k0, <any register> 都是 mtc0 $k0, $12(status)
*   mfc0: 部分实现 - 只可取 cp0$12 cp0$13 cp0$14
*   eret: 未实现 (利用 jr 代替)

##### cp0 No.13: cause register (32 bit)

##### cp0 No.14: epc

```mips
mfc0 $t0, Cause # copy Cause register into $t0

mfc0 $k0, EPC
jr   $k0
```

#### different interrupts

*   hardware interrupt 0x00000000
*   system call 0x00000020
*   breakpoint/divide by 0 0x00000024
*   undefined instruction 0x00000028
*   arithmetic overflow 0x00000030

if the interrupt is for an invalid opcode (not applicable in this instruction-set, but
good for an example), it can be determined in the decode stage—and instructions in the execute,
memory, and writeback stages would be allowed to finish. If the interrupt is for something
like divide-by-zero (also not applicable here), it would be determined in the execute
stage, and only instructions in the memory and writeback stages would be allowed to commit.
Instructions in the fetch and decode stages would be turned into NOPs. If the data-memory
access uses an invalid address, only the instruction in the writeback stage would be allowed to
commit. In addition, the implementation would need logic to resolve multiple simultaneous
interrupts, giving priority to those further down the pipe. This also implies that the PC of the
instruction must be carried down the pipe until the latest stage in which it is possible to cause
an interrupt (e.g. up to and including the memory-access stage)

#### handler style

##### scheme one: acts upon exceptional conditions as soon as they are detected

*   send interrupts signal once possible to recognize
*   requires a bit more logic

##### scheme two: 
*   send interrupts signal until a specfic stage such as write back stage; once interrupts get recognized, set CPU state to ERROR, and holding error_state info(interrupt type) down to pipeline: MEM/WB pipeline register need a copy of PC

>   invalid opcode -> ID stage
>   divide-by-zero -> 

This means recognizing that an exceptional situation has occurred,
holding that information with the instruction state (i.e. in the pipeline registers), and acting on
it during the writeback stage—only in the writeback stage. Thus, in addition to extra fields in
the pipeline register to hold interrupt type, the MEM/WB register also needs a copy of the program
counter.

## Coding Style

*   信号/变量/模块小写, 常量大写
*   `_top` for top module
*   `_cs` for current state, `_ns` for next state
*   *clk_ -> rst_ -> en_ -> other signals -> address -> data*
*   `reg [31:0] data_mem [0: 2047]`
*   Use meaningful names for signals and variables
*   Don't mix level and edge sensitive elements in the same always block
*   Avoid mixing positive and negative edge-triggered flip-flops
*   Use parentheses to optimize logic structure
*   Use continuous assign statements for simple combo logic
*   Use nonblocking for sequential and blocking for combo logic
*   Don't mix blocking and nonblocking assignments in the same always block (even if Design compiler supports them!!).
*   Be careful with multiple assignments to the same variable
*   Define if-else or case statements explicitly

## Bug

*   error coding style(particularly in synthesize stage)
*   default type: unsigned ( compare )
*   {carry, sum} = srcA + srcB, {carry, diff} = srcA - srcB;

## Reference

*   [ARM core](http://www.iuma.ulpgc.es/~nunez/clases-micros-para-com/varios/dcisarch42.pdf)
*   [pipeline basis](https://www.cs.utexas.edu/~fussell/courses/cs352h/lectures/)
*   [pipeline basis part 1](https://www.cs.utexas.edu/~fussell/courses/cs352h/lectures/8-MIPS-Pipeline.pdf)
*   [pipeline basis part 2](https://www.cs.utexas.edu/~fussell/courses/cs352h/lectures/9-MIPS-Pipeline-Hazards.pdf)
*   [interrupts handler part 1](http://ijrti.org/papers/IJRTI1612013.pdf)
*   [interrupts handler part 2](https://www.ece.umd.edu/~blj/RiSC/RiSC-pipe.pdf)
*   [MIPS CP0 wiki](https://en.wikichip.org/wiki/mips/coprocessor_0)
*   [CMU Manual](https://www.cs.cmu.edu/afs/cs/academic/class/15740-f97/public/info/pipeline-slide.pdf)
*   [iverilog Wiki](http://iverilog.wikia.com/wiki/User_Guide)
*   See MIPS Run
*   computer organization and design
*   digital design and computer architecture(basis of pipelined CPU)
*   computer architecture: a quantitative approach
*   interrupts pdf

## Sample

*   http://user.engineering.uiowa.edu/~hpca/hw5/
*   https://github.com/trevor-m/mips-processor
