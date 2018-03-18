nop
nop
nop
addi $s0,$zero,1
nop
nop
nop
sll $s3, $s0, 31      # $s3=0x80000000
nop
nop
nop
sra $s3, $s3, 31      # $s3=0xFFFFFFFF
nop
nop
nop
addu $s0,$zero,$zero   # $s0=0
nop
nop
nop
addi $s2,$zero,12 
nop
nop
nop

addiu $s6,$0,3
zmd_loop:
nop
nop
nop

addiu $s0, $s0, 1
nop
nop
nop
andi $s0, $s0, 15  

#######################################
nop
nop
nop
addi $t0,$0,8    
nop
nop
nop
addi $t1,$0,1
left:

nop
nop
nop
sll $s3, $s3, 4
nop
nop
nop
or $s3, $s3, $s0

nop
nop
nop
add    $a0,$0,$s3       # display $s3
nop
nop
nop
addi   $v0,$0,34         # system call for LED display 
nop
nop
nop
syscall                 # display 

nop
nop
nop
sub $t0,$t0,$t1
nop
nop
nop
nop
nop
nop
nop
bne $t0,$0,left
#######################################

nop
nop
nop
addi $s0, $s0, 1
nop
nop
nop
addi $t8,$0,15
nop
nop
nop
and $s0, $s0, $t8
nop
nop
nop
sll $s0, $s0, 28     

nop
nop
nop
addi $t0,$0,8
nop
nop
nop
addi $t1,$0,1

zmd_right:

nop
nop
nop
srl $s3, $s3, 4
nop
nop
nop
or $s3, $s3, $s0

nop
nop
nop
addu    $a0,$0,$s3       # display $s3
nop
nop
nop
addi   $v0,$0,34         # system call for LED display 
nop
nop
nop
syscall                 # display 

nop
nop
nop
sub $t0,$t0,$t1
nop
nop
nop
bne $t0,$0,zmd_right
nop
nop
nop
srl $s0, $s0, 28  
#######################################

nop
nop
nop
sub $s6,$s6,$t1
nop
nop
nop
beq $s6,$0, exit
nop
nop
nop
j zmd_loop

exit:

nop
nop
nop
add $t0,$0,$0
nop
nop
nop
nor $t0,$t0,$t0      #test nor  ori
nop
nop
nop
sll $t0,$t0,16
nop
nop
nop
ori $t0,$t0,0xffff

nop
nop
nop
addu   $a0,$0,$t0       # display $t0
nop
nop
nop
addi   $v0,$0,34         # system call for LED display 
nop
nop
nop
syscall                 # display 

nop
nop
nop
addi   $v0,$zero,10         # system call for exit
nop
nop
nop
syscall                  # we are out of here. 

