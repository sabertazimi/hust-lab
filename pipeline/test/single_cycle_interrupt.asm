# diable interrupts
mfc0 $k0, $12
ori $k0, $k0, 1
mtc0 $k0, $12

# set up stack
addi $gp, $zero, 0x4000
add $fp, $gp, $sp

# store EPC value
mfc0 $k0, $14
sw $k0, ($fp)
addi $fp, $fp, 4
addi $sp, $sp, 4

# store status register value
mfc0 $k0, $12
andi $k0, $k0, 0xfffe
sw $k0, ($fp)
addi $fp, $fp, 4
addi $sp, $sp, 4

# protect environment
sw $s0, ($fp)
addi $sp, $sp, 4
addi $fp, $fp, 4
sw $s1, ($fp)
addi $sp, $sp, 4
addi $fp, $fp, 4
sw $s2, ($fp)
addi $sp, $sp, 4
addi $fp, $fp, 4
sw $s3, ($fp)
addi $sp, $sp, 4
addi $fp, $fp, 4
sw $a0, ($fp)
addi $sp, $sp, 4
addi $fp, $fp, 4
sw $v0, ($fp)
addi $sp, $sp, 4
addi $fp, $fp, 4

# get cause number
mfc0 $k0, $13
add $s3, $zero, $k0

# set up IM code (interrupt mask)
startim:
addi $k1, $zero, 1
bne $k0, $k1, int2
mfc0 $k0, $12
andi $k0, $k0, 0xf8ff   # set IM to 000
mtc0 $k0, $12
bne $k1, $zero, endim	# jump to endim

int2:
addi $k1, $zero, 2
bne $k0, $k1, int3
mfc0 $k0, $12
andi $k0, $k0, 0xf9ff   # set IM to 001
ori $k0, $k0, 0x0100    # set IM to 001
mtc0 $k0, $12
bne $k1, $zero, endim	# jump to endim

int3:
addi $k1, $zero, 3
bne $k0, $k1, endim
mfc0 $k0, $12
andi $k0, $k0, 0xfbff   # set IM to 011
ori $k0, $k0, 0x0300    # set IM to 011
mtc0 $k0, $12

endim:

# enable interrupts
mfc0 $k0, $12
andi $k0, $k0, 0xfffe
mtc0 $k0, $12

# start of waterfall lamp
addi $s1, $zero, 5 	# loop counter
addi $s2, $zero, 1 	# step

IntLoop:
add $s0, $zero, $s3

IntLeftShift:
add $a0, $zero, $s0     # display $s0
addi $v0, $zero, 1
syscall
sll $s0, $s0, 4
bne $s0, $zero, IntLeftShift
sub $s1, $s1, $s2
bne $s1, $zero, IntLoop
# end of waterfall lamp

# disable interrupts
mfc0 $k0, $12
ori $k0, $k0, 1
mtc0 $k0, $12

# restore environment
addi $fp, $fp, -4
addi $sp, $sp, -4
lw $v0, ($fp)
addi $fp, $fp, -4
addi $sp, $sp, -4
lw $a0, ($fp)
addi $fp, $fp, -4
addi $sp, $sp, -4
lw $s3, ($fp)
addi $fp, $fp, -4
addi $sp, $sp, -4
lw $s2, ($fp)
addi $fp, $fp, -4
addi $sp, $sp, -4
lw $s1, ($fp)
addi $fp, $fp, -4
addi $sp, $sp, -4
lw $s0, ($fp)

# restore status register value
addi $fp, $fp, -4
addi $sp, $sp, -4
lw $k0, ($fp)
mtc0 $k0, $12

# restore EPC value
addi $fp, $fp, -4
addi $sp, $sp, -4
lw $t0, ($fp)

# enable interrupts
mfc0 $k0, $12
andi $k0, $k0, 0xfffe
mtc0 $k0, $12

jr $t0
