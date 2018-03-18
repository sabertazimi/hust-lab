       nop
       nop
       nop
        bne $s0 $s0 badness     #0
        nop
        nop
        nop
        beq $s0 $s0 start       #1
        nop
        nop
        nop
badness:
        addi $s0, $zero, 0xFF   #2
        nop
        nop
        nop
        beq $s0 $s0 badness     #3
        nop
        nop
        nop
label1:
        addiu $s0 $0 2          #4      s0 = 2
        nop
        nop
        nop
        bne $s0 $s1 label2      #5      2 != 1 
        nop
        nop
        nop

start:  addiu $s0 $0 1          #6      s0 = 1
nop
nop
nop
        beq $s0 $s1 label1      #7      1 != 0, s1 = 1; 1 = 1
        nop
        nop
        nop
        beq $s0 $s1 start       #8      1 = 1
        nop
        nop
        nop

label2: addiu $s0 $0 4          #9      s0 = 4
nop
nop
nop
end:    bne   $s2 $s0 truend       #10
nop
nop
nop
        ori $s2 $s0 0xFFFF      #11
truend:
nop
nop
nop
    addi $v0, $zero, 10
nop
nop
nop
    syscall

#lines in parentheses don't get executed.
#0, 1, (2), 6, 7, 8, (9), 6, 7, (8), 4, 5, (6), 9, 10, (11), 10, (11), ...
