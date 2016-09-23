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

## multiple posedge bug

Multiple(three or more) clock on single always event block would lead to tons of error prone.

```verilog
always @(posedge clk_src or posedge sig_up_time or posedge sig_reset)

=>
wire clock;
wire [2:0] signal;
assgin clock = sig_reset || sig_up_time || clk_src;
assgin signal = {switch_en, sig_reset, sig_up_time};
always @(posedge clock) begin
    case (signal)
        3'b100: count = (count + 1) % RANGE; sig_end_judgement;
        3'b01x: count = 0;
        3'b001: count = (count + 1) % RANGE;
        default: nothing;
    endcase
end
```

## 模块实例化时模块, 形参与实参位数不匹配

## 在多个 always/module 中, 修改同一变量

## 未初始化

## 七段显示器 0/1 弄反, 0 误以为 暗, 1 误以为 亮

## case 未加 default 语句，遇到 infering latch 警告，导致 bitstream 生成失败
