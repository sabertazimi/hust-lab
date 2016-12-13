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
