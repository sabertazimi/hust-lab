# Lab Notes for Reporting

## Lab1 ALU Notes

### Grade

Owing to casual, get NOR mistakely to NAND.

### Analysis

*   时间延迟(1+2+2+2) 优势劣势比较
*   优势 速度较快
*   劣势 电路过于复杂

## Lab2 Notes

### Regfile Notes

#### Instruction

*   NOT write to $0, even if an instruction should try
*   Zero Register should ALWAYS have the value 0x0
*   NOT gate the clock at any point: the clock signal should ALWAYS connect directly to the clock input of the registers without passing through ANY combinational logic

### Auto Adder Notes

#### Workflow

*   first up: load data to $s0(time to set str of ram to zero)
*   first down: send sum to din of ram, change ain of ram to higher
*   second up: write sum into ram(time to set str of ram to zero), send sum from sumreg to $s1(bypass)
*   second down: change ain of ram to lower

#### Tips

*   分频器: 时钟源 + 计数器
*   下降沿计数至 32 * 2 = 64, 所有使能端置 0
*   上升沿读数，下降沿切换地址
*   计数器+加法器+MUX: 实现地址不断切换, 模拟指令集(也可以事先将地址存至ROM)
*   MUX 实现地址线(16 17 切换)与数据(旁路)随时钟变化选择
*   由于寄存器文件与RAM都为上升沿有效, 故必须将2个时钟周期作为1个时钟节拍, 第一个周期读取加数, 第二个周期读取累加和(旁路)与回写累加和(旁路使得 3 周期降为 2 周期)

```md
读加数, 回写累加和, 读累加和, 读加数, 回写累加和, ... => 读加数, 回写累加和/读累加和
```

## Lab3 Notes

### Harzards (in beq/bneq/j/jr/jal)

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

### Design

*   分析指令, 设计数据通路
*   选取数据通路所需元件
*   连接数据通路
*   分析数据通路所需控制信号
*   集成控制信号

### Implementation

*   generate instructions bool signals with and expressions(op + functy)(figure out what instruction it is)
*   generate control signals with or expressions(instructions bool signals)

When implement a general type instruction, it occurs to me that implementing the same type of instructions becomes smoothly.

e.g if implemented add and addi, then it's uncomplicated to implement and, andi, or, ori etc.

### Tips

*   Mux: 在原有功能的基础上, 不断利用 mux + control signal 添加新功能
*   原有功能尽量置于 mux 0 输入端
*   one by one: 一个个指令进行实现

### Awesome

*  jal => rd($ra) = 0 + imm26
*  jr  => rd(not write) = rs + imm16(0)
*  lw => R = (rs) + imm16 => addr of ram, dataRe of ram => datain of regfile: signal, RAMtoReg 1, RAMWe 0
*  sw => R = (rs) + imm16 => addr of ram, rt => R2 => dataWr of ram: signal, RAMtoReg 0, RAMWe 1
*  beq/bne: PC = PC + 4 + signExt(imm16 << 2)

### BUGs

#### PC

pc 为 30xx/31xx, 由于地址线只有 10 位,故最高位110000xxxxxxxx/110001xxxxxxxx 1100 不影响正常取指

#### Shift

wtf: shift : op + 00000 + rt + rd + sham + functy

#### ExtOp

*  addiu: 0 -> 1(zeroExt -> signExt)
*  andi/ori: 1 -> 0(signExt -> zeroExt)

#### `MIPS_ISA.pdf`

*   pdf 上关于 beq/bne PC 更新逻辑有误, 在 Mars 里运行代码可以看出 PC = PC + signExt(offset||00) + 4, 而不是 PC = PC + signExt(offset||00)
