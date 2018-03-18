.text
nop
nop
 addi $s1,$zero, 1   #����j,jal,jrָ�����Ҫ�ɷֿ����ԣ�ִ������Ӧ����15������
 nop
 nop
 j jmp_next1
 nop
 nop
 addi $s1,$zero, 1
 nop
 nop
 addi $s2,$zero, 2
 nop
 nop
 addi $s3,$zero, 3
 nop
 nop
jmp_next1:
nop
nop
 j jmp_next2
 nop
 nop
 addi $s1,$zero, 1
 nop
 nop
 addi $s2,$zero, 2
 nop
 nop
 addi $s3,$zero, 3
 nop
 nop
jmp_next2:
nop
nop
 j jmp_next3
 nop
 nop
 addi $s1,$zero, 1
 nop
 nop
 addi $s2,$zero, 2
 nop
 nop
 addi $s3,$zero, 3
 nop
 nop
jmp_next3:
nop
nop
 j jmp_next4
 nop
 nop
 addi $s1,$zero, 1
 nop
 nop
 addi $s2,$zero, 2
 nop
 nop
 addi $s3,$zero, 3
 nop
 nop
jmp_next4:jal jmp_count
######################################

#��λ����  ��Ҫ֧�ֳ�addi,sll,add,syscall,srl,sll,sra,beq,j,syscall    revise date:2015/12/16 tiger
.text
nop
nop
addi $s0,$zero,1     #����λ��ѭ�����ԣ�0��������ʾ���ǳ�ʼֵ1����1λ�ظ�15�ε�ֵ��1���������ۼ�ֵ
nop
nop
addi $s1,$zero,1  
nop
nop
sll $s1, $s1, 31   #�߼�����31λ $s1=0x80000000
nop
nop
LogicalRightShift:            #�߼����Ʋ��ԣ������λ1��λ��������ֱ�����Ϊ��
nop
nop
add    $a0,$0,$s1       #display $s1    #�߼����Ʋ��ԣ������λ1��λ��������ֱ�����Ϊ��
nop
nop
addi   $v0,$0,34        # display hex
nop
nop
syscall                 # we are out of here.  
nop
nop
srl $s1, $s1, 2   
nop
nop
beq $s1, $zero, shift_next1
nop
nop
j LogicalRightShift
nop
nop
shift_next1:
nop
nop
add    $a0,$0,$s1       #display $s1
nop
nop
addi   $v0,$0,34         # display hex
nop
nop
syscall                 # we are out of here.  
nop
nop
addi $s1,$zero, 1        #                �߼����Ʋ��� 
nop
nop
LogicalLeftShift:         #�߼����Ʋ��ԣ������λ1��λ������ֱ�����Ϊ��
nop
nop
sll $s1, $s1, 2  
nop
nop
add    $a0,$0,$s1       #display $s1
nop
nop
addi   $v0,$0,34         # display hex
nop
nop
syscall                 # we are out of here.  
nop
nop
beq $s1, $zero, ArithRightShift
nop
nop
j LogicalLeftShift
nop
nop
ArithRightShift:          #�������Ʋ��ԣ�#������λ���ԣ�80000000�������ƣ�������ʾΪF0000000,FF000000,FFF00000,FFFF0000ֱ��FFFFFFFF
nop
nop
addi $s1,$zero,1     #                �������Ʋ��� 
nop
nop
sll $s1, $s1, 31   #�߼�����31λ $s1=0x80000000
nop
nop
add    $a0,$0,$s1       #display $s1
nop
nop
addi   $v0,$0,34         # display hex
nop
nop
syscall                 # we are out of here.  
nop
nop
sra $s1, $s1, 3    #$s1=0X80000000-->0XF0000000
nop
nop
add    $a0,$0,$s1       #display $s1
nop
nop
addi   $v0,$0,34         # display hex
nop
nop
syscall                 # we are out of here.  
nop
nop
sra $s1, $s1, 4    #0XF0000000-->0XFF000000
nop
nop
add    $a0,$0,$s1       #display $s1
nop
nop
addi   $v0,$0,34         # display hex
nop
nop
syscall                 # we are out of here.  
nop
nop

sra $s1, $s1, 4    #0XFF000000-->0XFFF00000
nop
nop

add    $a0,$0,$s1       #display $s1
nop
nop
addi   $v0,$0,34         # display hex
nop
nop
syscall                 # we are out of here.  
nop
nop

sra $s1, $s1, 4    
nop
nop

add    $a0,$0,$s1       #display $s1
nop
nop
addi   $v0,$0,34         # display hex
nop
nop
syscall                 # we are out of here.  
nop
nop

nop
nop
sra $s1, $s1, 4    
nop
nop

nop
nop
add    $a0,$0,$s1       #display $s1
nop
nop
addi   $v0,$0,34         # display hex
nop
nop
syscall                 # we are out of here.  
nop
nop

nop
nop

nop
nop
sra $s1, $s1, 4    
nop
nop

nop
nop
add    $a0,$0,$s1       #display $s1
nop
nop
addi   $v0,$0,34         # display hex
nop
nop
syscall                 # we are out of here.  
nop
nop

nop
nop

nop
nop
sra $s1, $s1, 4    
nop
nop

nop
nop
add    $a0,$0,$s1       #display $s1
nop
nop
addi   $v0,$0,34         # display hex
nop
nop
syscall                 # we are out of here.  
nop
nop

nop
nop

nop
nop
sra $s1, $s1, 4    
nop
nop

nop
nop

nop
nop
add    $a0,$0,$s1       #display $s1
nop
nop
addi   $v0,$0,34         # display hex
nop
nop
syscall                 # we are out of here.  
nop
nop

nop
nop
#############################################################
nop
nop
#����Ʋ���,����addi,andi,sll,srl,sra,or,ori,nor,syscall  LED������Ʒ�ʽ������ʾ����
nop
nop
#############################################################
nop
nop

nop
nop
.text
nop
nop
addi $s0,$zero,1 
nop
nop
sll $s3, $s0, 31      # $s3=0x80000000
nop
nop
sra $s3, $s3, 31      # $s3=0xFFFFFFFF   
nop
nop
addu $s0,$zero,$zero   # $s0=0         
nop
nop
addi $s2,$zero,12 
nop
nop

nop
nop
addiu $s6,$0,3  #����Ƽ���
nop
nop
zmd_loop:
nop
nop

nop
nop
addiu $s0, $s0, 1    #������һ������Ƶ�����
nop
nop
andi $s0, $s0, 15  
nop
nop

nop
nop
#######################################
nop
nop
addi $t0,$0,8    
nop
nop
addi $t1,$0,1
nop
nop
left:
nop
nop

nop
nop
sll $s3, $s3, 4   #���������
nop
nop
or $s3, $s3, $s0
nop
nop

nop
nop
add    $a0,$0,$s3       # display $s3
nop
nop
addi   $v0,$0,34         # system call for LED display 
nop
nop
syscall                 # display 
nop
nop

nop
nop
sub $t0,$t0,$t1
nop
nop
bne $t0,$0,left
nop
nop
#######################################
nop
nop

nop
nop
addi $s0, $s0, 1   #������һ������Ƶ�����
nop
nop
addi $t8,$0,15
nop
nop
and $s0, $s0, $t8
nop
nop
sll $s0, $s0, 28     
nop
nop

nop
nop
addi $t0,$0,8
nop
nop
addi $t1,$0,1
nop
nop

nop
nop
zmd_right:
nop
nop

nop
nop
srl $s3, $s3, 4  #���������
nop
nop
or $s3, $s3, $s0
nop
nop

nop
nop
addu    $a0,$0,$s3       # display $s3
nop
nop
addi   $v0,$0,34         # system call for LED display 
nop
nop
syscall                 # display 
nop
nop

nop
nop
sub $t0,$t0,$t1
nop
nop
bne $t0,$0,zmd_right
nop
nop
srl $s0, $s0, 28  
nop
nop
#######################################
nop
nop

nop
nop
sub $s6,$s6,$t1
nop
nop
beq $s6,$0, exit
nop
nop
j zmd_loop
nop
nop

nop
nop
exit:
nop
nop

nop
nop
add $t0,$0,$0
nop
nop
nor $t0,$t0,$t0      #test nor  ori
nop
nop
sll $t0,$t0,16
nop
nop
ori $t0,$t0,0xffff
nop
nop

nop
nop
addu   $a0,$0,$t0       # display $t0
nop
nop
addi   $v0,$0,34         # system call for LED display 
nop
nop
syscall                 # display 
nop
nop
#################################################################################
nop
nop
#������ʵ��0-15���ֵ�Ԫ�Ľ�������,�˳������mars mips������������
nop
nop
#����ʱ�뽫Mars Setting�е�Memory Configuration����ΪCompact��data at address 0
nop
nop
#
nop
nop
#################################################################################
nop
nop
 .text
 nop
 nop
sort_init:
nop
nop
 addi $s0,$0,-1
 nop
 nop
 addi $s1,$0,0
 nop
 nop
 
 nop
 nop
 sw $s0,0($s1)
 nop
 nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
 sw $s0,0($s1)
 nop
 nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
 sw $s0,0($s1)
 nop
 nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
 sw $s0,0($s1)
 nop
 nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
 sw $s0,0($s1)
 nop
 nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
 sw $s0,0($s1)
 nop
 nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
 sw $s0,0($s1)
 nop
 nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
 sw $s0,0($s1)
 nop
 nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
  sw $s0,0($s1)
  nop
  nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
  sw $s0,0($s1)
  nop
  nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
 sw $s0,0($s1)
 nop
 nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
  sw $s0,0($s1)
  nop
  nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
  sw $s0,0($s1)
  nop
  nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
  sw $s0,0($s1)
  nop
  nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
  sw $s0,0($s1)
  nop
  nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
    sw $s0,0($s1)
    nop
    nop
 addi $s0,$s0,1
 nop
 nop
 addi $s1,$s1,4
 nop
 nop
   
   nop
   nop
 addi $s0,$s0,1
 nop
 nop
 
 nop
 nop
 add $s0,$zero,$zero   
 nop
 nop
 addi $s1,$zero,60   #��������
 nop
 nop
sort_loop:
nop
nop
 lw $s3,0($s0)     
 nop
 nop
 lw $s4,0($s1)
 nop
 nop
 slt $t0,$s3,$s4
 nop
 nop
 beq $t0,$0,sort_next   #��������
 nop
 nop
 sw $s3, 0($s1)
 nop
 nop
 sw $s4, 0($s0)   
 nop
 nop
sort_next:
nop
nop
 addi $s1, $s1, -4   
 nop
 nop
 bne $s0, $s1, sort_loop  
 nop
 nop
 
 nop
 nop
 add    $a0,$0,$s0       #display $s0
 nop
 nop
 addi   $v0,$0,34         # display hex
 nop
 nop
 syscall                 # we are out of here.  DISP: disp $r0, 0
 nop
 nop
 
 nop
 nop
 addi $s0,$s0,4
 nop
 nop
 addi $s1,$zero,60
 nop
 nop
 bne $s0, $s1, sort_loop
 nop
 nop

nop
nop
 addi   $v0,$zero,10         # system call for exit
 nop
 nop
 syscall                  # we are out of here.   
 nop
 nop
 #MIPS������ʵ��������ͣ��ָ��ʵ��syscall
 nop
 nop

nop
nop
jmp_count: addi $s0,$zero, 0
nop
nop
       addi $s0,$s0, 1
       nop
       nop
       add    $a0,$0,$s0      
       nop
       nop
       addi   $v0,$0,34         # display hex
       nop
       nop
       syscall                 # we are out of here.  
       nop
       nop
       
       nop
       nop
       addi $s0,$s0, 2
       nop
       nop
       add    $a0,$0,$s0      
       nop
       nop
       addi   $v0,$0,34         # display hex
       nop
       nop
       syscall                 # we are out of here.  
       nop
       nop
       
       nop
       nop
       addi $s0,$s0, 3
       nop
       nop
       add    $a0,$0,$s0      
       nop
       nop
       addi   $v0,$0,34         # display hex
       nop
       nop
       syscall                 # we are out of here.  
       nop
       nop
       
       nop
       nop
       addi $s0,$s0, 4       
       nop
       nop
       add    $a0,$0,$s0      
       nop
       nop
       addi   $v0,$0,34         # display hex
       nop
       nop
       syscall                 # we are out of here.  
       nop
       nop
       
       nop
       nop
       addi $s0,$s0, 5              
       nop
       nop
       add    $a0,$0,$s0      
       nop
       nop
       addi   $v0,$0,34         # display hex
       nop
       nop
       syscall                 # we are out of here.  
       nop
       nop
       
       nop
       nop
       addi $s0,$s0, 6              
       nop
       nop
       add    $a0,$0,$s0      
       nop
       nop
       addi   $v0,$0,34         # display hex
       nop
       nop
       syscall                 # we are out of here.  
       nop
       nop

nop
nop
       addi $s0,$s0, 7              
       nop
       nop
       add    $a0,$0,$s0      
       nop
       nop
       addi   $v0,$0,34         # display hex
       nop
       nop
       syscall                 # we are out of here.  
       nop
       nop
       addi $s0,$s0, 8              
       nop
       nop
       add    $a0,$0,$s0      
       nop
       nop
       addi   $v0,$0,34         # display hex
       nop
       nop
       addi   $v0,$0,34         # display hex       
       nop
       nop
       syscall                 # we are out of here.  
       nop
       nop
       jr $31
