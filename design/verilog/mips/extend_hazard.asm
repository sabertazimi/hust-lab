addi $s0, $zero, -1
addi $s1, $zero, 2
nop
nop
nop
divu $s0, $s1
mflo $s1
addi $v0, $zero, 10
nop
nop
nop
syscall