lw $s0, ($s1)
addi $s1, $zero, 233
bne $s0, $s1, end
end:
addi $v0, $zero, 10
syscall