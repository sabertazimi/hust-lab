# Pipelined MIPS CPU

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

## Development

```sh
$ iverilog -o demo demo_tb.v demo.v # compiler
$ iverilog -o demo -c src.list      # src.list => demo.v demo_tb.v
$ iverilog -s main -o hello hello.v # set root module to `main`
$ vvp demo                          # simulation runtime engine
$ vvp -n demo -lxt2
$ gtkwave demo.lxt
$ gtkwave trace.vcd
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

### hazards

### load use hazard

load use hazard when

```verilog
ID/EX.MemRead &&
    ((ID/EX.RegisterRt == IF/ID.RegisterRs) ||
    (ID/EX.RegisterRt == IF/ID.RegisterRt))
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

### branch predict

*   always not taken
*   backward taken, forward not taken
*   **饱和计数预测器**(Saturating counter/2 bit predictor) algorithm state machine
*   神经分支预测器

#### 2 bit predictor

not taken(miss: should taken) -> not taken(miss: should taken) -> taken

*   get true outcome: just like signal in PC update logic = (zero && beq) || (!zero && bne)
*   Branch target register/buffer

### interrupts handler

*   The interrupts(external) are acknowledged in the execute stage. Then this signal is propagated to the Write Back stage through Memory Access stage. 
*   if there are no separate registers to handle the interrupts, the handler has to move all the data in the general working registers to a stack memory and retrieve once it has been serviced. This takes many more clock cycles. To avoid this it’s better to use a limited number of special registers only for Interrupts.
*   stages before execute stage should have own reserve stack space, e.g ``fetch` stack space, `decode/reg_read` stack space

#### different interrupts

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

## Code Style

*   Use meaningful names for signals and variables
*   Don't mix level and edge sensitive elements in the same always block
*   Avoid mixing positive and negative edge-triggered flip-flops
*   Use parentheses to optimize logic structure
*   Use continuous assign statements for simple combo logic
*   Use nonblocking for sequential and blocking for combo logic
*   Don't mix blocking and nonblocking assignments in the same always block (even if Design compiler supports them!!).
*   Be careful with multiple assignments to the same variable
*   Define if-else or case statements explicitly

## Reference

*   [pipeline basis](https://www.cs.utexas.edu/~fussell/courses/cs352h/lectures/)
*   [pipeline basis part 1](https://www.cs.utexas.edu/~fussell/courses/cs352h/lectures/8-MIPS-Pipeline.pdf)
*   [pipeline basis part 2](https://www.cs.utexas.edu/~fussell/courses/cs352h/lectures/9-MIPS-Pipeline-Hazards.pdf)
*   [interrupts handler part 1](http://ijrti.org/papers/IJRTI1612013.pdf)
*   [interrupts handler part 2](https://www.ece.umd.edu/~blj/RiSC/RiSC-pipe.pdf)
*   [ARM core](http://www.iuma.ulpgc.es/~nunez/clases-micros-para-com/varios/dcisarch42.pdf)
*   http://iverilog.wikia.com/wiki/User_Guide
