addi $s0,$zero, 0
addi $s1,$zero, 0
addi $s2,$zero, 0
addi $s3,$zero, 0
ori $s0,$s0, 0
ori $s1,$s1, 1
ori $s2,$s2, 2
ori $s3,$s3, 3
sw $s0, 0($s0)
sw $s1, 4($s0)
sw $s2, 8($s0)
sw $s3, 12($s0)
addi $v0,$zero,10         # system call for exit
addi $s1,$zero, 0
addi $s2,$zero, 0
addi $s3,$zero, 0
syscall                   # we are out of here.   
