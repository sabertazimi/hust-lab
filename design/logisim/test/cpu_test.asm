.text
# spec for addx
addiu $s0 $0 2
addiu $s1 $0 -1
addu $s2 $s0 $s1
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

# spec for slt/slti/sltu
slt $s3, $s1, $s2
sw $s3, 16($zero)
slti $s4, $s0, 0x0f
sw $s4, 20($zero)
addi $s0, $zero, 0x7fff
sltu $s5, $s0, $s1
sw $s5, 24($zero)

# spec for lw/sw
addi $s0, $zero, 0
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

# spec for j/jal/jr
addi $s0, $zero, 400
j j_test
addi $s0, $zero, 401
addi $s0, $zero, 402
addi $s0, $zero, 403
addi $s0, $zero, 40４
addi $s0, $zero, 40５
j_test:
addi $s1, $zero, 500
jal jal_test
addi $s1, $zero, 501
addi $s1, $zero, 502
addi $s1, $zero, 503
addi $s1, $zero, 504
addi $s1, $zero, 505
j exit
jal_test:
addi $s2, $zero, 600
jr $ra

exit:
#spec for led syscall
addi $v0, $zero, 0
addi $a0, $zero, 0x7f
# manually add: syscall 0000000c
addi $a0, $zero, 0x3f
# manually add: syscall 0000000c

# spec for exit syscall
addi $v0, $zero, 10
syscall

# ignore
addi $s0, $zero, 100
addi $s1, $zero, 200
addi $s2, $zero, 300
