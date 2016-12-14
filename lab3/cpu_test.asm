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

# spec for sub/or/ori/nor
sub $s0 ,$s1, $s2
or $s1, $s0, $s1
ori $s2, $s2, 0xff
nor $s0, $s1,$s2

# spec for lw/sw
sw $s1, 4($s0)
addi $s1, $zero, 8
sw $s2, 4($s1)
lw $s0, 4($s0)
lw $s1, 4($s1)

# spec for beq/bne
addi $s1, $zero, -100
addi $s2, $zero, -100
beq $s1, $s2, beq_test
addi $s1, $zero, 200          # test for branch hazard($s1 shouldn't get updated)
beq $zero, $zero, beq_next    # j beq_next
beq_test:
addi $s0, $zero, 233
beq_next:

addi $s1, $zero, -100
addi $s2, $zero, 100
bne $s1, $s2, bne_test
addi $s2, $zero, 300          # test for branch hazard($s2 shouldn't get updated)
beq $zero, $zero, bne_next    # j beq_next
bne_test:
addi $s1, $zero, 250
bne_next:
