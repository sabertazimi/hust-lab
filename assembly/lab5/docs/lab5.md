## Bugs

### xor

使用寄存器前未清零导致，逻辑错误

```asm
xor eax, eax
xor ebx, ebx
xor ecx, ecx
```

明白了编写上下文无关的代码的重要性

### 取值

从内存单元取值,误多取多个字节

```asm
mov edx, [esi + m_table]
```

->

```asm
mov dl, [esi + m_table]
```

### cmp

误与内存单元多个字节比较，导致比较到了无效数据，造成逻辑错误

```asm
cmp ecx, [ebx]
```

->

```asm
cmp cl, [ebx]
```

### m_num

添加学生后,忘记 m_num++,造成逻辑错误

```asm
inc m_num
```

### do_while while_do

应使用 while_do 的地方误用 do_while,造成逻辑错误.若学生成绩表无信息时,用户调用以下功能会造成程序进入死循环

-   `c_cal`
-   `c_sort`
-   `c_print`

故将所有 do_while 改正至 while_do.
