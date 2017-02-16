addi $v0, $zero, 1

# spec for addx
addiu $s0 $0 2
add $a0, $s0, $zero
syscall
addiu $s1 $0 -1
add $a0, $s1, $zero
syscall
addu $s2 $s0 $s1
add $a0, $s2, $zero
syscall
addi $s1, $s2, 32
add $a0, $s1, $zero
syscall
addiu $s1, $s1, 32
add $a0, $s1, $zero
syscall
add $s0, $s1, $s2
add $a0, $s0, $zero
syscall
addu $s0, $s0, $s1
add $a0, $s0, $zero
syscall

# spec for andx
addi $s0, $s2, 31
add $a0, $s0, $zero
syscall
addi $s1, $s2, 15
add $a0, $s1, $zero
syscall
and $s0, $s0, $s1
add $a0, $s0, $zero
syscall
andi $s2, $s0, 8
add $a0, $s2, $zero
syscall

# spec for shift
sll $s2, $s1, 1
add $a0, $s2, $zero
syscall
srl $s1, $s1, 1
add $a0, $s1, $zero
syscall
addiu $s0, $zero, 0xff
add $a0, $s0, $zero
syscall
sra $s0, $s0, 4
add $a0, $s0, $zero
syscall

# spec for sub/or/ori/nor
sub $s0 ,$s1, $s2
add $a0, $s0, $zero
syscall
or $s1, $s0, $s1
add $a0, $s1, $zero
syscall
ori $s2, $s2, 0xff
add $a0, $s2, $zero
syscall
nor $s0, $s1,$s2
add $a0, $s0, $zero
syscall

# spec for slt/slti/sltu
slt $s3, $s1, $s2
add $a0, $s3, $zero
syscall
sw $s3, 16($zero)
slti $s4, $s0, 0x0f
add $a0, $s4, $zero
syscall
sw $s4, 20($zero)
addi $s0, $zero, 0x7fff
add $a0, $s0, $zero
syscall
sltu $s5, $s0, $s1
add $a0, $s5, $zero
syscall
sw $s5, 24($zero)

# spec for lw/sw
addi $s0, $zero, 0
add $a0, $s0, $zero
syscall
sw $s1, 4($s0)
addi $s1, $zero, 8
add $a0, $s1, $zero
syscall
sw $s2, 4($s1)
lw $s0, 4($s0)
add $a0, $s0, $zero
syscall
lw $s1, 4($s1)
add $a0, $s1, $zero
syscall

# spec for divu
addi $s0, $zero, -1
add $a0, $s0, $zero
syscall
addi $s1, $zero, 2
add $a0, $s1, $zero
syscall
divu $s0, $s1
add $a0, $s0, $zero
syscall

# spec for mflo
mflo $s1
add $a0, $s1, $zero
syscall

# spec for lb
addi $s1, $zero, 0xabc
add $a0, $s1, $zero
syscall
sw $s1, 0($zero)
addi $s0, $zero, 0	# reset
add $a0, $s0, $zero
syscall
lb $s0, 0($zero)
add $a0, $s0, $zero
syscall
lb $s0, 1($zero)
add $a0, $s0, $zero
syscall
lb $s0, 2($zero)
add $a0, $s0, $zero
syscall

exit:
# spec for exit syscall
addi $v0, $zero, 10
syscall

