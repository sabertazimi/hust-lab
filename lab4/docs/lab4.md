## Bugs

### xor

使用寄存器前未清零导致，逻辑错误

`xor eax, eax`

明白了编写上下文无关的代码的重要性

### cmp

`cmp ecx, [ebx]` -> `cmp cl, [ebx]`

## Defects

-   未做输入检查
    -   输入学生成绩 < 100
    -   输入学生姓名为有效字符
