# Lab 3 Notes

## BUG

### '0' -> 0

数据段赋值时，误将'0'补至学生姓名之后,使得字符串比较异常

解决办法: 

-   'lancer0000' -> 'lancer', 4 DUP(0)
-   'saber00000' -> 'saber', 5 DUP(0)

### 意外 - 取出目标学生平均成绩

```asm
mov bx, num
sub bx, cx
imul bx, 14
add bx, 10
mov al, [bx + 3]
```

```asm
mov bx, num
sub bx, cx
imul bx, 14
add bx, 13
mov al, [bx + 3]
```

```asm
mov bx, num
sub bx, cx
imul bx, 14
add bx, 13
mov al, [bx]
```

自做聪明将`add bx, 10`改为`add bx, 13`,结果忽视了`mov al, [bx+3]`,将原来正确的代码改出了bug

解决办法： 一不做，二不休，将`mov al, [bx + 3]`改为`mov al, [bx]`
