# spec for divu
addi $s0, $zero, -1
addi $s1, $zero, 2
divu $s0, $s1

# spec for mflo
mflo $s1

# spec for lb
addi $s1, $zero, 0xabc
sw $s1, 0($zero)
addi $s0, $zero, 0	# reset
lb $s0, 0($zero)
lb $s0, 1($zero)
lb $s0, 2($zero)

# spec for bgtz
addi $s0, $zero, 0	# reset
addi $s1, $zero, -20
bgtz $s1, not_jmp
addi $s1, $zero, 20
bgtz $s1, will_jmp
not_jmp:
addi $s0, $zero, 233
will_jmp:
addi $s0, $zero, 250
addi $s1, $zero, 0
bgtz $s1, not_jmp
