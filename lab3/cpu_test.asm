.text
# spec for addx
addi $s1, $s2, 32
addiu $s1, $s1, 32
add $s0, $s1, $s2
addu $s0, $s0, $s1

# spec for andx
add $s0, $s2, 31
add $s1, $s2, 15
and $s0, $s0, $s1
andi $s2, $s0, 8

# spec for shift
sll $s2, $s1, 1
srl $s1, $s1, 1
addiu $s0, $zero, 0xff
sra $s0, $s0, 4

beq $s0, $s1, sort_loop

# spec for sub/or/ori/nor
sub $s0 ,$s1, $s2
or $s1, $s0, $s1
ori $s2, $s2, 0xff
nor $s0, $s1,$s2

sort_loop:

# spec for lw/sw
sw $s1, 4($s0)
addi $s1, $zero, 8
sw $s2, 4($s1)
lw $s0, 4($s0)
lw $s1, 4($s1)