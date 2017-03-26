lw $s1, ($s0)
addi $s0, $zero, 233
bne $s0, $s1, label
label:
addi $v0, $zero, 10
syscall
