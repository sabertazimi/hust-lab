        bne $s0 $s0 badness     #0
        beq $s0 $s0 start       #1
badness:
        lui $s0 0xFF            #2
        beq $s0 $s0 badness     #3
label1:
        addiu $s0 $0 2          #4      s0 = 2
        bne $s0 $s1 label2      #5      2 != 1 

start:  addiu $s0 $0 1          #6      s0 = 1
        beqinc $s0 $s1 label1   #7      1 != 0, s1 = 1; 1 = 1
        beq $s0 $s1 start       #8      1 = 1

label2: addiu $s0 $0 4          #9      s0 = 4
end:    bne   $s2 $s0 end       #10
        ori $s2 $s0 0xFFFF      #11

#0, 1, 6, 7, 8, 6, 7, 4, 5, 9, 10, 10, 10...
#with pipelining and stalls, you move through the instructions as follows:
#lines in parentheses don't get executed.
#0, 1, (2), 6, 7, 8, (9), 6, 7, (8), 4, 5, (6), 9, 10, (11), 10, (11), ...
