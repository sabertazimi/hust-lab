## BUGs

### 模块实例化时模块, 形参与实参位数不匹配

### 七段显示器 0/1 弄反, 0 误以为 暗, 1 误以为 亮

### case 未加 default 语句，遇到 infering latch 警告，导致 bitstream 生成失败

### multiple posedge bug

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

### Representation

*   计数
*   校时
*   整点报时
*   掉电清零
*   闹钟: 提醒功能，记忆功能(掉电不清零)
