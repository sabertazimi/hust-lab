# Pipelined MIPS CPU

## Installation

```sh
$ sudo apt install logisim # install logisim platform
$ sudo apt install verilog # install icarus verilog simulatr
$ sudo apt install gtkwave # install waveform viewer
```

## Development

```sh
$ iverilog -o demo demo.v demo_tb.v
```

## Notes

### branch predict

*   always not taken
*   backward taken, forward not taken
*   **饱和计数预测器**(Saturating counter/2 bit predictor) algorithm state machine
*   神经分支预测器

#### 2 bit predictor

not taken(miss: should taken) -> not taken(miss: should taken) -> taken

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

## Reference

*   [interrupts handler part1](http://ijrti.org/papers/IJRTI1612013.pdf)
*   [interrupts handler part2](https://www.ece.umd.edu/~blj/RiSC/RiSC-pipe.pdf)
*   [pipeline basis](https://www.cs.utexas.edu/~fussell/courses/cs352h/lectures/)
