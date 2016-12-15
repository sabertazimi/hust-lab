 .text
sort_init:
 addi $s0,$0,-1
 addi $s1,$0,0

 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
  sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
  sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
 sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
  sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
  sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
  sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
  sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4
    sw $s0,0($s1)
 addi $s0,$s0,1
 addi $s1,$s1,4

 addi $s0,$s0,1

 add $s0,$zero,$zero        # init: lowest index
 addi $s1,$zero,60          # init: highest index

sort_loop:
 lw $s3,0($s0)              # arr[low]
 lw $s4,0($s1)              # arr[high]
 slt $t0,$s3,$s4            # $t0 = arr[low] < arr[high]
 beq $t0,$0,sort_next       # if $t0 = 1(arr[low] < arr[high])
 sw $s3, 0($s1)             # swap(arr[low], arr[high])
 sw $s4, 0($s0)             # swap(arr[low], arr[high])
sort_next:
 addi $s1, $s1, -4          # high--
 bne $s0, $s1, sort_loop    # if low != high, continue loop

 addi $s0,$s0,4             # low++(index <= low: sorted elements)
 addi $s1,$zero,60          # reset high to highest
 bne $s0, $s1, sort_loop    # all elements get sorted

 addi   $v0,$zero,10        # system call for exit
 syscall
