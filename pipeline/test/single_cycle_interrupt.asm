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
sw $s4, ($fp)
addi $sp, $sp, 4
addi $fp, $fp, 4
sw $s5, ($fp)
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
andi $k0, $k0, 0xf9ff   # set IM to 001
ori $k0, $k0, 0x0100    # set IM to 001
mtc0 $k0, $12
bne $k1, $zero, endim	# jump to endim

int2:
addi $k1, $zero, 2
bne $k0, $k1, int3
mfc0 $k0, $12
andi $k0, $k0, 0xfbff   # set IM to 011
ori $k0, $k0, 0x0300    # set IM to 011
mtc0 $k0, $12
bne $k1, $zero, endim	# jump to endim

int3:
addi $k1, $zero, 3
bne $k0, $k1, endim
mfc0 $k0, $12
ori $k0, $k0, 0x0700    # set IM to 111
mtc0 $k0, $12

endim:

# enable interrupts
mfc0 $k0, $12
andi $k0, $k0, 0xfffe
mtc0 $k0, $12

### start of waterfall lamp

startisr:
addi $v0, $zero, 1

isr3:
addi $s2, $zero, 3
bne $s2, $s3, isr1or2

# spec for extend instructions
addi $s1, $zero, 0xabc
sw $s1, 0($zero)

addi $s1, $zero, 2              # outer loop counter
int_loop1:
lb $s0, 0($zero)
addi $s2, $zero, 16             # inner loop counter
int_shift1:
add $a0, $zero, $s0             # display $s0
addi $v0, $zero, 1
syscall
sub $s2, $s2, $v0               # $v0 = 1
addi $s4, $zero, 8              # constant: 8
sub $s5, $s2, $s4		# $s2 - 8
bgtz $s5, int_left_shift1	# $s2 > 8
addi $s4, $zero, 16             # constant: 16
divu $s0, $s4
mflo $s0                        # right shift
bne $s4, $zero, int_next1        # j int_next
int_left_shift1:
sll $s0, $s0, 4			# left shift
int_next1:
bne $s2, $zero, int_shift1
sub $s1, $s1, $v0               # $v0 = 1
bne $s1, $zero, int_loop1

addi $s1, $zero, 2              # outer loop counter
int_loop2:
lb $s0, 1($zero)
addi $s2, $zero, 16             # inner loop counter
int_shift2:
add $a0, $zero, $s0             # display $s0
addi $v0, $zero, 1
syscall
sub $s2, $s2, $v0               # $v0 = 1
addi $s4, $zero, 8              # constant: 8
sub $s5, $s2, $s4		# $s2 - 8
bgtz $s5, int_left_shift2	# $s2 > 8
addi $s4, $zero, 16             # constant: 16
divu $s0, $s4
mflo $s0                        # right shift
bne $s4, $zero, int_next2        # j int_next
int_left_shift2:
sll $s0, $s0, 4			# left shift
int_next2:
bne $s2, $zero, int_shift2
sub $s1, $s1, $v0               # $v0 = 1
bne $s1, $zero, int_loop2

addi $s2, $zero, 1
bne $s2, $zero, endisr

isr1or2:

addi $s1, $zero, 6              # outer loop counter

int_loop:
add $s0, $zero, $s3
addi $s2, $zero, 16             # inner loop counter

int_shift:
add $a0, $zero, $s0             # display $s0
syscall
sub $s2, $s2, $v0               # $v0 = 1
addi $s4, $zero, 8              # constant: 8
sub $s5, $s2, $s4		# $s2 - 8
bgtz $s5, int_left_shift	# $s2 > 8
addi $s4, $zero, 16             # constant: 16
divu $s0, $s4
mflo $s0                        # right shift
bne $s4, $zero, int_next        # j int_next
int_left_shift:
sll $s0, $s0, 4			# left shift
int_next:
bne $s2, $zero, int_shift
sub $s1, $s1, $v0               # $v0 = 1
bne $s1, $zero, int_loop

endisr:
### end of waterfall lamp

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
lw $s5, ($fp)
addi $fp, $fp, -4
addi $sp, $sp, -4
lw $s4, ($fp)
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
lw $k0, ($fp)
mtc0 $k0, $14

# enable interrupts
mfc0 $k0, $12
andi $k0, $k0, 0xfffe
mtc0 $k0, $12

nop
nop
nop
nop
nop
nop
nop
eret
