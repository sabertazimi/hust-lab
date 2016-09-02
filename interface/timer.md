```verilog
timer(
    input clk_src,
    input switch_power,
    input switch_en,
    input count_start_flag,
    output count_end_flag,
    output reg [(WIDTH-1):0] count,
);
```
