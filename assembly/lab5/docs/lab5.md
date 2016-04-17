## Tips

### Array

```c
/*
 * length: 
 * type  : 单个元素大小
 * size  : = type * length
 */ 
__asm  mov  iArray[2 * type int], 0

```

### Struct

```c
__asm {
    mov  gVar.age, 10 
    mov  lVar.age, 20
}
```

### Function

#### Reservation

Caller Reservation - eax, ecx, edx

#### Call

```c
__asm {
    push  offset  szWorld 
    push  offset  szHello 
    push  offset  szFormat 
    call  printf 
    add   esp, 12 ; 栈顶指针恢复到压入参数前的位置
} 
```

## Bugs

数组汇编访存时,出现错误

### 下标

由于对齐 26->28

```asm
add ebx, 28
```

### 传参

```c
cal/sort(table, num); -> cal/sort(&table[0], num);
```

```asm
table[esi/edi + EA] -> mov edi, table ss:[edi + esi + EA]
```
