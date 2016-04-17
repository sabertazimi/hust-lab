
main.exe：     文件格式 elf64-x86-64


Disassembly of section .init:

00000000004003e0 <_init>:
  4003e0:	48 83 ec 08          	sub    $0x8,%rsp
  4003e4:	48 8b 05 0d 0c 20 00 	mov    0x200c0d(%rip),%rax        # 600ff8 <_DYNAMIC+0x1d0>
  4003eb:	48 85 c0             	test   %rax,%rax
  4003ee:	74 05                	je     4003f5 <_init+0x15>
  4003f0:	e8 3b 00 00 00       	callq  400430 <__gmon_start__@plt>
  4003f5:	48 83 c4 08          	add    $0x8,%rsp
  4003f9:	c3                   	retq   

Disassembly of section .plt:

0000000000400400 <printf@plt-0x10>:
  400400:	ff 35 02 0c 20 00    	pushq  0x200c02(%rip)        # 601008 <_GLOBAL_OFFSET_TABLE_+0x8>
  400406:	ff 25 04 0c 20 00    	jmpq   *0x200c04(%rip)        # 601010 <_GLOBAL_OFFSET_TABLE_+0x10>
  40040c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400410 <printf@plt>:
  400410:	ff 25 02 0c 20 00    	jmpq   *0x200c02(%rip)        # 601018 <_GLOBAL_OFFSET_TABLE_+0x18>
  400416:	68 00 00 00 00       	pushq  $0x0
  40041b:	e9 e0 ff ff ff       	jmpq   400400 <_init+0x20>

0000000000400420 <__libc_start_main@plt>:
  400420:	ff 25 fa 0b 20 00    	jmpq   *0x200bfa(%rip)        # 601020 <_GLOBAL_OFFSET_TABLE_+0x20>
  400426:	68 01 00 00 00       	pushq  $0x1
  40042b:	e9 d0 ff ff ff       	jmpq   400400 <_init+0x20>

0000000000400430 <__gmon_start__@plt>:
  400430:	ff 25 f2 0b 20 00    	jmpq   *0x200bf2(%rip)        # 601028 <_GLOBAL_OFFSET_TABLE_+0x28>
  400436:	68 02 00 00 00       	pushq  $0x2
  40043b:	e9 c0 ff ff ff       	jmpq   400400 <_init+0x20>

Disassembly of section .text:

0000000000400440 <_start>:
  400440:	31 ed                	xor    %ebp,%ebp
  400442:	49 89 d1             	mov    %rdx,%r9
  400445:	5e                   	pop    %rsi
  400446:	48 89 e2             	mov    %rsp,%rdx
  400449:	48 83 e4 f0          	and    $0xfffffffffffffff0,%rsp
  40044d:	50                   	push   %rax
  40044e:	54                   	push   %rsp
  40044f:	49 c7 c0 f0 05 40 00 	mov    $0x4005f0,%r8
  400456:	48 c7 c1 80 05 40 00 	mov    $0x400580,%rcx
  40045d:	48 c7 c7 36 05 40 00 	mov    $0x400536,%rdi
  400464:	e8 b7 ff ff ff       	callq  400420 <__libc_start_main@plt>
  400469:	f4                   	hlt    
  40046a:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

0000000000400470 <deregister_tm_clones>:
  400470:	b8 47 10 60 00       	mov    $0x601047,%eax
  400475:	55                   	push   %rbp
  400476:	48 2d 40 10 60 00    	sub    $0x601040,%rax
  40047c:	48 83 f8 0e          	cmp    $0xe,%rax
  400480:	48 89 e5             	mov    %rsp,%rbp
  400483:	76 1b                	jbe    4004a0 <deregister_tm_clones+0x30>
  400485:	b8 00 00 00 00       	mov    $0x0,%eax
  40048a:	48 85 c0             	test   %rax,%rax
  40048d:	74 11                	je     4004a0 <deregister_tm_clones+0x30>
  40048f:	5d                   	pop    %rbp
  400490:	bf 40 10 60 00       	mov    $0x601040,%edi
  400495:	ff e0                	jmpq   *%rax
  400497:	66 0f 1f 84 00 00 00 	nopw   0x0(%rax,%rax,1)
  40049e:	00 00 
  4004a0:	5d                   	pop    %rbp
  4004a1:	c3                   	retq   
  4004a2:	0f 1f 40 00          	nopl   0x0(%rax)
  4004a6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  4004ad:	00 00 00 

00000000004004b0 <register_tm_clones>:
  4004b0:	be 40 10 60 00       	mov    $0x601040,%esi
  4004b5:	55                   	push   %rbp
  4004b6:	48 81 ee 40 10 60 00 	sub    $0x601040,%rsi
  4004bd:	48 c1 fe 03          	sar    $0x3,%rsi
  4004c1:	48 89 e5             	mov    %rsp,%rbp
  4004c4:	48 89 f0             	mov    %rsi,%rax
  4004c7:	48 c1 e8 3f          	shr    $0x3f,%rax
  4004cb:	48 01 c6             	add    %rax,%rsi
  4004ce:	48 d1 fe             	sar    %rsi
  4004d1:	74 15                	je     4004e8 <register_tm_clones+0x38>
  4004d3:	b8 00 00 00 00       	mov    $0x0,%eax
  4004d8:	48 85 c0             	test   %rax,%rax
  4004db:	74 0b                	je     4004e8 <register_tm_clones+0x38>
  4004dd:	5d                   	pop    %rbp
  4004de:	bf 40 10 60 00       	mov    $0x601040,%edi
  4004e3:	ff e0                	jmpq   *%rax
  4004e5:	0f 1f 00             	nopl   (%rax)
  4004e8:	5d                   	pop    %rbp
  4004e9:	c3                   	retq   
  4004ea:	66 0f 1f 44 00 00    	nopw   0x0(%rax,%rax,1)

00000000004004f0 <__do_global_dtors_aux>:
  4004f0:	80 3d 49 0b 20 00 00 	cmpb   $0x0,0x200b49(%rip)        # 601040 <__TMC_END__>
  4004f7:	75 11                	jne    40050a <__do_global_dtors_aux+0x1a>
  4004f9:	55                   	push   %rbp
  4004fa:	48 89 e5             	mov    %rsp,%rbp
  4004fd:	e8 6e ff ff ff       	callq  400470 <deregister_tm_clones>
  400502:	5d                   	pop    %rbp
  400503:	c6 05 36 0b 20 00 01 	movb   $0x1,0x200b36(%rip)        # 601040 <__TMC_END__>
  40050a:	f3 c3                	repz retq 
  40050c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400510 <frame_dummy>:
  400510:	bf 20 0e 60 00       	mov    $0x600e20,%edi
  400515:	48 83 3f 00          	cmpq   $0x0,(%rdi)
  400519:	75 05                	jne    400520 <frame_dummy+0x10>
  40051b:	eb 93                	jmp    4004b0 <register_tm_clones>
  40051d:	0f 1f 00             	nopl   (%rax)
  400520:	b8 00 00 00 00       	mov    $0x0,%eax
  400525:	48 85 c0             	test   %rax,%rax
  400528:	74 f1                	je     40051b <frame_dummy+0xb>
  40052a:	55                   	push   %rbp
  40052b:	48 89 e5             	mov    %rsp,%rbp
  40052e:	ff d0                	callq  *%rax
  400530:	5d                   	pop    %rbp
  400531:	e9 7a ff ff ff       	jmpq   4004b0 <register_tm_clones>

0000000000400536 <main>:
  400536:	55                   	push   %rbp
  400537:	48 89 e5             	mov    %rsp,%rbp
  40053a:	e8 07 00 00 00       	callq  400546 <p1>
  40053f:	b8 00 00 00 00       	mov    $0x0,%eax
  400544:	5d                   	pop    %rbp
  400545:	c3                   	retq   

0000000000400546 <p1>:
  400546:	55                   	push   %rbp
  400547:	48 89 e5             	mov    %rsp,%rbp
  40054a:	0f b6 05 e6 ff ff ff 	movzbl -0x1a(%rip),%eax        # 400537 <main+0x1>
  400551:	0f be d0             	movsbl %al,%edx
  400554:	0f b6 05 db ff ff ff 	movzbl -0x25(%rip),%eax        # 400536 <main>
  40055b:	0f be c0             	movsbl %al,%eax
  40055e:	89 c6                	mov    %eax,%esi
  400560:	bf 04 06 40 00       	mov    $0x400604,%edi
  400565:	b8 00 00 00 00       	mov    $0x0,%eax
  40056a:	e8 a1 fe ff ff       	callq  400410 <printf@plt>
  40056f:	90                   	nop
  400570:	5d                   	pop    %rbp
  400571:	c3                   	retq   
  400572:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  400579:	00 00 00 
  40057c:	0f 1f 40 00          	nopl   0x0(%rax)

0000000000400580 <__libc_csu_init>:
  400580:	41 57                	push   %r15
  400582:	41 56                	push   %r14
  400584:	41 89 ff             	mov    %edi,%r15d
  400587:	41 55                	push   %r13
  400589:	41 54                	push   %r12
  40058b:	4c 8d 25 7e 08 20 00 	lea    0x20087e(%rip),%r12        # 600e10 <__frame_dummy_init_array_entry>
  400592:	55                   	push   %rbp
  400593:	48 8d 2d 7e 08 20 00 	lea    0x20087e(%rip),%rbp        # 600e18 <__init_array_end>
  40059a:	53                   	push   %rbx
  40059b:	49 89 f6             	mov    %rsi,%r14
  40059e:	49 89 d5             	mov    %rdx,%r13
  4005a1:	31 db                	xor    %ebx,%ebx
  4005a3:	4c 29 e5             	sub    %r12,%rbp
  4005a6:	48 83 ec 08          	sub    $0x8,%rsp
  4005aa:	48 c1 fd 03          	sar    $0x3,%rbp
  4005ae:	e8 2d fe ff ff       	callq  4003e0 <_init>
  4005b3:	48 85 ed             	test   %rbp,%rbp
  4005b6:	74 1e                	je     4005d6 <__libc_csu_init+0x56>
  4005b8:	0f 1f 84 00 00 00 00 	nopl   0x0(%rax,%rax,1)
  4005bf:	00 
  4005c0:	4c 89 ea             	mov    %r13,%rdx
  4005c3:	4c 89 f6             	mov    %r14,%rsi
  4005c6:	44 89 ff             	mov    %r15d,%edi
  4005c9:	41 ff 14 dc          	callq  *(%r12,%rbx,8)
  4005cd:	48 83 c3 01          	add    $0x1,%rbx
  4005d1:	48 39 eb             	cmp    %rbp,%rbx
  4005d4:	75 ea                	jne    4005c0 <__libc_csu_init+0x40>
  4005d6:	48 83 c4 08          	add    $0x8,%rsp
  4005da:	5b                   	pop    %rbx
  4005db:	5d                   	pop    %rbp
  4005dc:	41 5c                	pop    %r12
  4005de:	41 5d                	pop    %r13
  4005e0:	41 5e                	pop    %r14
  4005e2:	41 5f                	pop    %r15
  4005e4:	c3                   	retq   
  4005e5:	90                   	nop
  4005e6:	66 2e 0f 1f 84 00 00 	nopw   %cs:0x0(%rax,%rax,1)
  4005ed:	00 00 00 

00000000004005f0 <__libc_csu_fini>:
  4005f0:	f3 c3                	repz retq 

Disassembly of section .fini:

00000000004005f4 <_fini>:
  4005f4:	48 83 ec 08          	sub    $0x8,%rsp
  4005f8:	48 83 c4 08          	add    $0x8,%rsp
  4005fc:	c3                   	retq   
