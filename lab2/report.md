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
