# spec for mtc0
addi $s0, $zero, 233
mtc0 $s0, $12
addi $s0, $zero, 234
mtc0 $s0, $13
addi $s0, $zero, 235
mtc0 $s0, $14

# spec for mfc0
addi $s0, $zero, 0
mfc0 $s0, $12
mfc0 $s0, $13
mfc0 $s0, $14
