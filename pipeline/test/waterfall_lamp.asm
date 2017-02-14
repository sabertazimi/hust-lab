# mfc0 $t0, $12
# mfc0 $t1, $13
# mfc0 $k0, $14
# jr $k0

# get Int NO
addi $s6, $zero, 2

# start of program
addi $s4, $zero, 5
addi $s5, $zero, 1

IntLoop:
add $s0, $zero, $s6

IntLeftShift:
add    $a0, $zero, $s0       # display $s0
addi   $v0, $zero, 34        # display hex
syscall                 # we are out of here.
sll $s0, $s0, 4
bne $s0, $zero, IntLeftShift
sub $s4, $s4, $s5
bne $s4, $zero, IntLoop

