# Lab2 Notes

## Regfile Notes

### Instruction

*   NOT write to $0, even if an instruction should try
*   Zero Register should ALWAYS have the value 0x0
*   NOT gate the clock at any point: the clock signal should ALWAYS connect directly to the clock input of the registers without passing through ANY combinational logic

## Auto Adder Notes

### Workflow

*   first up: load data to $s0(time to set str of ram to zero)
*   first down: send sum to din of ram, change ain of ram to higher
*   second up: write sum into ram(time to set str of ram to zero), send sum from sumreg to $s1(bypass)
*   second down: change ain of ram to lower

### Tips

*   分频器: 时钟源 + 计数器
*   下降沿计数至 32 * 2 = 64, 所有使能端置 0
*   上升沿读数，下降沿切换地址
*   计数器+加法器+MUX: 实现地址不断切换, 模拟指令集(也可以事先将地址存至ROM)
*   MUX 实现地址线(16 17 切换)与数据(旁路)随时钟变化选择
*   由于寄存器文件与RAM都为上升沿有效, 故必须将2个时钟周期作为1个时钟节拍, 第一个周期读取加数, 第二个周期读取累加和(旁路)与回写累加和(旁路使得 3 周期降为 2 周期)

```md
读加数, 回写累加和, 读累加和, 读加数, 回写累加和, ... => 读加数, 回写累加和/读累加和
```
