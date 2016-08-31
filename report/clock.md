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
