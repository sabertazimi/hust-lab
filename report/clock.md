## divider module

```js
// 100MHz -> 1Hz
(100000000).toString(2) == '101111101011110000100000000'
// true
```

## set and reset module

goes wrong

## posedge of sig_reset or sig_up_time

干扰 switch_en 下 count++, 使得额外地计数

```verilog
if (switch_en) => if (switch_en && !sig_reset && !sig_up_time)
```

## posedge of sig_up_time and clk_src

clk_src 干扰 sig_up_time 修改当前时间, 使得额外地计数

```verilog
sig_up_time 0->1 , then clk_src 0->1 , count+=2
```
