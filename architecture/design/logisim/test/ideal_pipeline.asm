addi $v0, $zero, 1

# spec for addx
nop
addiu $s0, $0, 2
nop
add $a0, $s0, $zero
nop
syscall
nop
addiu $s1, $0, -1
nop
add $a0, $s1, $zero
nop
syscall
nop
addu $s2, $s0, $s1
nop
add $a0, $s2, $zero
nop
syscall
nop
addi $s1, $s2, 32
nop
add $a0, $s1, $zero
nop
syscall
nop
addiu $s1, $s1, 32
nop
add $a0, $s1, $zero
nop
syscall
nop
add $s0, $s1, $s2
nop
add $a0, $s0, $zero
nop
syscall
nop
addu $s0, $s0, $s1
nop
add $a0, $s0, $zero
nop
syscall

# spec for andx
nop
addi $s0, $s2, 31
nop
add $a0, $s0, $zero
nop
syscall
nop
addi $s1, $s2, 15
nop
add $a0, $s1, $zero
nop
syscall
nop
and $s0, $s0, $s1
nop
add $a0, $s0, $zero
nop
syscall
nop
andi $s2, $s0, 8
nop
add $a0, $s2, $zero
nop
syscall

# spec for shift
nop
sll $s2, $s1, 1
nop
add $a0, $s2, $zero
nop
syscall
nop
srl $s1, $s1, 1
nop
add $a0, $s1, $zero
nop
syscall
nop
addiu $s0, $zero, 0xff
nop
add $a0, $s0, $zero
nop
syscall
nop
sra $s0, $s0, 4
nop
add $a0, $s0, $zero
nop
syscall

# spec for sub/or/ori/nor
nop
sub $s0 ,$s1, $s2
nop
add $a0, $s0, $zero
nop
syscall
nop
or $s1, $s0, $s1
nop
add $a0, $s1, $zero
nop
syscall
nop
ori $s2, $s2, 0xff
nop
add $a0, $s2, $zero
nop
syscall
nop
nor $s0, $s1,$s2
nop
add $a0, $s0, $zero
nop
syscall

# spec for slt/slti/sltu
nop
slt $s3, $s1, $s2
nop
add $a0, $s3, $zero
nop
syscall
nop
sw $s3, 16($zero)
nop
slti $s4, $s0, 0x0f
nop
add $a0, $s4, $zero
nop
syscall
nop
sw $s4, 20($zero)
nop
addi $s0, $zero, 0x7fff
nop
add $a0, $s0, $zero
nop
syscall
nop
sltu $s5, $s0, $s1
nop
add $a0, $s5, $zero
nop
syscall
nop
sw $s5, 24($zero)

# spec for lw/sw
nop
addi $s0, $zero, 0
nop
add $a0, $s0, $zero
nop
syscall
nop
sw $s1, 4($s0)
nop
addi $s1, $zero, 8
nop
add $a0, $s1, $zero
nop
syscall
nop
sw $s2, 4($s1)
nop
lw $s0, 4($s0)
nop
add $a0, $s0, $zero
nop
syscall
nop
lw $s1, 4($s1)
nop
add $a0, $s1, $zero
nop
syscall

# spec for divu
nop
addi $s0, $zero, -1
nop
add $a0, $s0, $zero
nop
syscall
nop
addi $s1, $zero, 2
nop
add $a0, $s1, $zero
nop
syscall
nop
divu $s0, $s1
nop
add $a0, $s0, $zero
nop
syscall

# spec for mflo
nop
mflo $s1
nop
add $a0, $s1, $zero
nop
syscall

# spec for lb
nop
addi $s1, $zero, 0xabc
nop
add $a0, $s1, $zero
nop
syscall
nop
sw $s1, 0($zero)
nop
addi $s0, $zero, 0	# reset
nop
add $a0, $s0, $zero
nop
syscall
nop
lb $s0, 0($zero)
nop
add $a0, $s0, $zero
nop
syscall
nop
lb $s0, 1($zero)
nop
add $a0, $s0, $zero
nop
syscall
nop
lb $s0, 2($zero)
nop
add $a0, $s0, $zero
nop
syscall
nop

exit:
# spec for exit syscall
nop
addi $v0, $zero, 10
nop
syscall

