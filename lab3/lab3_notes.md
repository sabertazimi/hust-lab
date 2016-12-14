## Harzards (in beq/bneq/j/jr/jal)

Instruction kills for this project should be accomplished by
MUXing a nop into the instruction stream
and sending it into the Execute stage
instead of the fetched instruction.
Notice that 0x00000000 is a nop instruction;
please use this, as it will simplify grading and testing

*   if branch is taken, kill the next instruction
*   j/jr/jal, kill the next instruction

Muxing a nop in IFU(instructions fetch unit):

*   according to zero input for IFU, judge branch whether is taken or not
*   decode in IFU(control signal part 1 e.g rtype = ~op0 & ~op1 & ... & ~op5, add = rtype & fn0 & ~fn1 & ... & ~fn4)

## Design

*   分析指令, 设计数据通路
*   选取数据通路所需元件
*   连接数据通路
*   分析数据通路所需控制信号
*   集成控制信号

## Implementation

*   generate instructions bool signals with and expressions(op + functy)(figure out what instruction it is)
*   generate control signals with or expressions(instructions bool signals)

When implement a general type instruction, it occurs to me that implementing the same type of instructions becomes smoothly.

e.g if implemented add and addi, then it's uncomplicated to implement and, andi, or, ori etc.

## Tips

*   Mux: 在原有功能的基础上, 不断利用 mux + control signal 添加新功能
*   原有功能尽量置于 mux 0 输入端
*   one by one: 一个个指令进行实现

## Awesome

*  jal => rd($ra) = 0 + imm26
*  jr  => rd(not write) = rs + imm16(0)
*  lw => R = (rs) + imm16 => addr of ram, dataRe of ram => datain of regfile: signal, RAMtoReg 1, RAMWe 0
*  sw => R = (rs) + imm16 => addr of ram, rt => R2 => dataWr of ram: signal, RAMtoReg 0, RAMWe 1
*  beq/bne: PC = PC + 4 + signExt(imm16 << 2)

## BUGs

### Shift

wtf: shift : op + 00000 + rt + rd + sham + functy
