## `objdump -d bomb`

```asm
bomb：     文件格式 elf32-i386


Disassembly of section .init:

08048748 <_init>:
 8048748:	55                   	push   %ebp
 8048749:	89 e5                	mov    %esp,%ebp
 804874b:	53                   	push   %ebx
 804874c:	83 ec 04             	sub    $0x4,%esp
 804874f:	e8 00 00 00 00       	call   8048754 <_init+0xc>
 8048754:	5b                   	pop    %ebx
 8048755:	81 c3 ac 29 00 00    	add    $0x29ac,%ebx
 804875b:	8b 93 fc ff ff ff    	mov    -0x4(%ebx),%edx
 8048761:	85 d2                	test   %edx,%edx
 8048763:	74 05                	je     804876a <_init+0x22>
 8048765:	e8 d6 00 00 00       	call   8048840 <__gmon_start__@plt>
 804876a:	58                   	pop    %eax
 804876b:	5b                   	pop    %ebx
 804876c:	c9                   	leave  
 804876d:	c3                   	ret    

Disassembly of section .plt:

08048770 <read@plt-0x10>:
 8048770:	ff 35 04 b1 04 08    	pushl  0x804b104
 8048776:	ff 25 08 b1 04 08    	jmp    *0x804b108
 804877c:	00 00                	add    %al,(%eax)
	...

08048780 <read@plt>:
 8048780:	ff 25 0c b1 04 08    	jmp    *0x804b10c
 8048786:	68 00 00 00 00       	push   $0x0
 804878b:	e9 e0 ff ff ff       	jmp    8048770 <_init+0x28>

08048790 <printf@plt>:
 8048790:	ff 25 10 b1 04 08    	jmp    *0x804b110
 8048796:	68 08 00 00 00       	push   $0x8
 804879b:	e9 d0 ff ff ff       	jmp    8048770 <_init+0x28>

080487a0 <fflush@plt>:
 80487a0:	ff 25 14 b1 04 08    	jmp    *0x804b114
 80487a6:	68 10 00 00 00       	push   $0x10
 80487ab:	e9 c0 ff ff ff       	jmp    8048770 <_init+0x28>

080487b0 <memcpy@plt>:
 80487b0:	ff 25 18 b1 04 08    	jmp    *0x804b118
 80487b6:	68 18 00 00 00       	push   $0x18
 80487bb:	e9 b0 ff ff ff       	jmp    8048770 <_init+0x28>

080487c0 <fgets@plt>:
 80487c0:	ff 25 1c b1 04 08    	jmp    *0x804b11c
 80487c6:	68 20 00 00 00       	push   $0x20
 80487cb:	e9 a0 ff ff ff       	jmp    8048770 <_init+0x28>

080487d0 <signal@plt>:
 80487d0:	ff 25 20 b1 04 08    	jmp    *0x804b120
 80487d6:	68 28 00 00 00       	push   $0x28
 80487db:	e9 90 ff ff ff       	jmp    8048770 <_init+0x28>

080487e0 <sleep@plt>:
 80487e0:	ff 25 24 b1 04 08    	jmp    *0x804b124
 80487e6:	68 30 00 00 00       	push   $0x30
 80487eb:	e9 80 ff ff ff       	jmp    8048770 <_init+0x28>

080487f0 <alarm@plt>:
 80487f0:	ff 25 28 b1 04 08    	jmp    *0x804b128
 80487f6:	68 38 00 00 00       	push   $0x38
 80487fb:	e9 70 ff ff ff       	jmp    8048770 <_init+0x28>

08048800 <bcopy@plt>:
 8048800:	ff 25 2c b1 04 08    	jmp    *0x804b12c
 8048806:	68 40 00 00 00       	push   $0x40
 804880b:	e9 60 ff ff ff       	jmp    8048770 <_init+0x28>

08048810 <strcpy@plt>:
 8048810:	ff 25 30 b1 04 08    	jmp    *0x804b130
 8048816:	68 48 00 00 00       	push   $0x48
 804881b:	e9 50 ff ff ff       	jmp    8048770 <_init+0x28>

08048820 <getenv@plt>:
 8048820:	ff 25 34 b1 04 08    	jmp    *0x804b134
 8048826:	68 50 00 00 00       	push   $0x50
 804882b:	e9 40 ff ff ff       	jmp    8048770 <_init+0x28>

08048830 <puts@plt>:
 8048830:	ff 25 38 b1 04 08    	jmp    *0x804b138
 8048836:	68 58 00 00 00       	push   $0x58
 804883b:	e9 30 ff ff ff       	jmp    8048770 <_init+0x28>

08048840 <__gmon_start__@plt>:
 8048840:	ff 25 3c b1 04 08    	jmp    *0x804b13c
 8048846:	68 60 00 00 00       	push   $0x60
 804884b:	e9 20 ff ff ff       	jmp    8048770 <_init+0x28>

08048850 <exit@plt>:
 8048850:	ff 25 40 b1 04 08    	jmp    *0x804b140
 8048856:	68 68 00 00 00       	push   $0x68
 804885b:	e9 10 ff ff ff       	jmp    8048770 <_init+0x28>

08048860 <__libc_start_main@plt>:
 8048860:	ff 25 44 b1 04 08    	jmp    *0x804b144
 8048866:	68 70 00 00 00       	push   $0x70
 804886b:	e9 00 ff ff ff       	jmp    8048770 <_init+0x28>

08048870 <fprintf@plt>:
 8048870:	ff 25 48 b1 04 08    	jmp    *0x804b148
 8048876:	68 78 00 00 00       	push   $0x78
 804887b:	e9 f0 fe ff ff       	jmp    8048770 <_init+0x28>

08048880 <write@plt>:
 8048880:	ff 25 4c b1 04 08    	jmp    *0x804b14c
 8048886:	68 80 00 00 00       	push   $0x80
 804888b:	e9 e0 fe ff ff       	jmp    8048770 <_init+0x28>

08048890 <__isoc99_sscanf@plt>:
 8048890:	ff 25 50 b1 04 08    	jmp    *0x804b150
 8048896:	68 88 00 00 00       	push   $0x88
 804889b:	e9 d0 fe ff ff       	jmp    8048770 <_init+0x28>

080488a0 <fopen@plt>:
 80488a0:	ff 25 54 b1 04 08    	jmp    *0x804b154
 80488a6:	68 90 00 00 00       	push   $0x90
 80488ab:	e9 c0 fe ff ff       	jmp    8048770 <_init+0x28>

080488b0 <__errno_location@plt>:
 80488b0:	ff 25 58 b1 04 08    	jmp    *0x804b158
 80488b6:	68 98 00 00 00       	push   $0x98
 80488bb:	e9 b0 fe ff ff       	jmp    8048770 <_init+0x28>

080488c0 <sprintf@plt>:
 80488c0:	ff 25 5c b1 04 08    	jmp    *0x804b15c
 80488c6:	68 a0 00 00 00       	push   $0xa0
 80488cb:	e9 a0 fe ff ff       	jmp    8048770 <_init+0x28>

080488d0 <socket@plt>:
 80488d0:	ff 25 60 b1 04 08    	jmp    *0x804b160
 80488d6:	68 a8 00 00 00       	push   $0xa8
 80488db:	e9 90 fe ff ff       	jmp    8048770 <_init+0x28>

080488e0 <gethostbyname@plt>:
 80488e0:	ff 25 64 b1 04 08    	jmp    *0x804b164
 80488e6:	68 b0 00 00 00       	push   $0xb0
 80488eb:	e9 80 fe ff ff       	jmp    8048770 <_init+0x28>

080488f0 <strtol@plt>:
 80488f0:	ff 25 68 b1 04 08    	jmp    *0x804b168
 80488f6:	68 b8 00 00 00       	push   $0xb8
 80488fb:	e9 70 fe ff ff       	jmp    8048770 <_init+0x28>

08048900 <connect@plt>:
 8048900:	ff 25 6c b1 04 08    	jmp    *0x804b16c
 8048906:	68 c0 00 00 00       	push   $0xc0
 804890b:	e9 60 fe ff ff       	jmp    8048770 <_init+0x28>

08048910 <close@plt>:
 8048910:	ff 25 70 b1 04 08    	jmp    *0x804b170
 8048916:	68 c8 00 00 00       	push   $0xc8
 804891b:	e9 50 fe ff ff       	jmp    8048770 <_init+0x28>

08048920 <__ctype_b_loc@plt>:
 8048920:	ff 25 74 b1 04 08    	jmp    *0x804b174
 8048926:	68 d0 00 00 00       	push   $0xd0
 804892b:	e9 40 fe ff ff       	jmp    8048770 <_init+0x28>

Disassembly of section .text:

08048930 <_start>:
 8048930:	31 ed                	xor    %ebp,%ebp
 8048932:	5e                   	pop    %esi
 8048933:	89 e1                	mov    %esp,%ecx
 8048935:	83 e4 f0             	and    $0xfffffff0,%esp
 8048938:	50                   	push   %eax
 8048939:	54                   	push   %esp
 804893a:	52                   	push   %edx
 804893b:	68 d0 9e 04 08       	push   $0x8049ed0
 8048940:	68 e0 9e 04 08       	push   $0x8049ee0
 8048945:	51                   	push   %ecx
 8048946:	56                   	push   %esi
 8048947:	68 1c 8a 04 08       	push   $0x8048a1c
 804894c:	e8 0f ff ff ff       	call   8048860 <__libc_start_main@plt>
 8048951:	f4                   	hlt    
 8048952:	90                   	nop
 8048953:	90                   	nop
 8048954:	90                   	nop
 8048955:	90                   	nop
 8048956:	90                   	nop
 8048957:	90                   	nop
 8048958:	90                   	nop
 8048959:	90                   	nop
 804895a:	90                   	nop
 804895b:	90                   	nop
 804895c:	90                   	nop
 804895d:	90                   	nop
 804895e:	90                   	nop
 804895f:	90                   	nop

08048960 <deregister_tm_clones>:
 8048960:	b8 a3 b4 04 08       	mov    $0x804b4a3,%eax
 8048965:	2d a0 b4 04 08       	sub    $0x804b4a0,%eax
 804896a:	83 f8 06             	cmp    $0x6,%eax
 804896d:	77 02                	ja     8048971 <deregister_tm_clones+0x11>
 804896f:	f3 c3                	repz ret 
 8048971:	b8 00 00 00 00       	mov    $0x0,%eax
 8048976:	85 c0                	test   %eax,%eax
 8048978:	74 f5                	je     804896f <deregister_tm_clones+0xf>
 804897a:	55                   	push   %ebp
 804897b:	89 e5                	mov    %esp,%ebp
 804897d:	83 ec 18             	sub    $0x18,%esp
 8048980:	c7 04 24 a0 b4 04 08 	movl   $0x804b4a0,(%esp)
 8048987:	ff d0                	call   *%eax
 8048989:	c9                   	leave  
 804898a:	c3                   	ret    
 804898b:	90                   	nop
 804898c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

08048990 <register_tm_clones>:
 8048990:	b8 a0 b4 04 08       	mov    $0x804b4a0,%eax
 8048995:	2d a0 b4 04 08       	sub    $0x804b4a0,%eax
 804899a:	c1 f8 02             	sar    $0x2,%eax
 804899d:	89 c2                	mov    %eax,%edx
 804899f:	c1 ea 1f             	shr    $0x1f,%edx
 80489a2:	01 d0                	add    %edx,%eax
 80489a4:	d1 f8                	sar    %eax
 80489a6:	75 02                	jne    80489aa <register_tm_clones+0x1a>
 80489a8:	f3 c3                	repz ret 
 80489aa:	ba 00 00 00 00       	mov    $0x0,%edx
 80489af:	85 d2                	test   %edx,%edx
 80489b1:	74 f5                	je     80489a8 <register_tm_clones+0x18>
 80489b3:	55                   	push   %ebp
 80489b4:	89 e5                	mov    %esp,%ebp
 80489b6:	83 ec 18             	sub    $0x18,%esp
 80489b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 80489bd:	c7 04 24 a0 b4 04 08 	movl   $0x804b4a0,(%esp)
 80489c4:	ff d2                	call   *%edx
 80489c6:	c9                   	leave  
 80489c7:	c3                   	ret    
 80489c8:	90                   	nop
 80489c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

080489d0 <__do_global_dtors_aux>:
 80489d0:	80 3d c4 b4 04 08 00 	cmpb   $0x0,0x804b4c4
 80489d7:	75 13                	jne    80489ec <__do_global_dtors_aux+0x1c>
 80489d9:	55                   	push   %ebp
 80489da:	89 e5                	mov    %esp,%ebp
 80489dc:	83 ec 08             	sub    $0x8,%esp
 80489df:	e8 7c ff ff ff       	call   8048960 <deregister_tm_clones>
 80489e4:	c6 05 c4 b4 04 08 01 	movb   $0x1,0x804b4c4
 80489eb:	c9                   	leave  
 80489ec:	f3 c3                	repz ret 
 80489ee:	66 90                	xchg   %ax,%ax

080489f0 <frame_dummy>:
 80489f0:	a1 08 b0 04 08       	mov    0x804b008,%eax
 80489f5:	85 c0                	test   %eax,%eax
 80489f7:	74 1e                	je     8048a17 <frame_dummy+0x27>
 80489f9:	b8 00 00 00 00       	mov    $0x0,%eax
 80489fe:	85 c0                	test   %eax,%eax
 8048a00:	74 15                	je     8048a17 <frame_dummy+0x27>
 8048a02:	55                   	push   %ebp
 8048a03:	89 e5                	mov    %esp,%ebp
 8048a05:	83 ec 18             	sub    $0x18,%esp
 8048a08:	c7 04 24 08 b0 04 08 	movl   $0x804b008,(%esp)
 8048a0f:	ff d0                	call   *%eax
 8048a11:	c9                   	leave  
 8048a12:	e9 79 ff ff ff       	jmp    8048990 <register_tm_clones>
 8048a17:	e9 74 ff ff ff       	jmp    8048990 <register_tm_clones>

08048a1c <main>:
 8048a1c:	55                   	push   %ebp
 8048a1d:	89 e5                	mov    %esp,%ebp
 8048a1f:	53                   	push   %ebx
 8048a20:	83 e4 f0             	and    $0xfffffff0,%esp
 8048a23:	83 ec 10             	sub    $0x10,%esp
 8048a26:	8b 45 08             	mov    0x8(%ebp),%eax
 8048a29:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 8048a2c:	83 f8 01             	cmp    $0x1,%eax
 8048a2f:	75 0c                	jne    8048a3d <main+0x21>
 8048a31:	a1 a4 b4 04 08       	mov    0x804b4a4,%eax
 8048a36:	a3 cc b4 04 08       	mov    %eax,0x804b4cc
 8048a3b:	eb 64                	jmp    8048aa1 <main+0x85>
 8048a3d:	83 f8 02             	cmp    $0x2,%eax
 8048a40:	75 41                	jne    8048a83 <main+0x67>
 8048a42:	c7 44 24 04 60 9f 04 	movl   $0x8049f60,0x4(%esp)
 8048a49:	08 
 8048a4a:	8b 43 04             	mov    0x4(%ebx),%eax
 8048a4d:	89 04 24             	mov    %eax,(%esp)
 8048a50:	e8 4b fe ff ff       	call   80488a0 <fopen@plt>
 8048a55:	a3 cc b4 04 08       	mov    %eax,0x804b4cc
 8048a5a:	85 c0                	test   %eax,%eax
 8048a5c:	75 43                	jne    8048aa1 <main+0x85>
 8048a5e:	8b 43 04             	mov    0x4(%ebx),%eax
 8048a61:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048a65:	8b 03                	mov    (%ebx),%eax
 8048a67:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048a6b:	c7 04 24 62 9f 04 08 	movl   $0x8049f62,(%esp)
 8048a72:	e8 19 fd ff ff       	call   8048790 <printf@plt>
 8048a77:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8048a7e:	e8 cd fd ff ff       	call   8048850 <exit@plt>
 8048a83:	8b 03                	mov    (%ebx),%eax
 8048a85:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048a89:	c7 04 24 7f 9f 04 08 	movl   $0x8049f7f,(%esp)
 8048a90:	e8 fb fc ff ff       	call   8048790 <printf@plt>
 8048a95:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8048a9c:	e8 af fd ff ff       	call   8048850 <exit@plt>
 8048aa1:	e8 b2 05 00 00       	call   8049058 <initialize_bomb>
 8048aa6:	c7 04 24 e4 9f 04 08 	movl   $0x8049fe4,(%esp)
 8048aad:	e8 7e fd ff ff       	call   8048830 <puts@plt>
 8048ab2:	c7 04 24 20 a0 04 08 	movl   $0x804a020,(%esp)
 8048ab9:	e8 72 fd ff ff       	call   8048830 <puts@plt>
 8048abe:	e8 5b 06 00 00       	call   804911e <read_line>
 8048ac3:	89 04 24             	mov    %eax,(%esp)
 8048ac6:	e8 a5 00 00 00       	call   8048b70 <phase_1>
 8048acb:	e8 aa 07 00 00       	call   804927a <phase_defused>
 8048ad0:	c7 04 24 4c a0 04 08 	movl   $0x804a04c,(%esp)
 8048ad7:	e8 54 fd ff ff       	call   8048830 <puts@plt>
 8048adc:	e8 3d 06 00 00       	call   804911e <read_line>
 8048ae1:	89 04 24             	mov    %eax,(%esp)
 8048ae4:	e8 ab 00 00 00       	call   8048b94 <phase_2>
 8048ae9:	e8 8c 07 00 00       	call   804927a <phase_defused>
 8048aee:	c7 04 24 99 9f 04 08 	movl   $0x8049f99,(%esp)
 8048af5:	e8 36 fd ff ff       	call   8048830 <puts@plt>
 8048afa:	e8 1f 06 00 00       	call   804911e <read_line>
 8048aff:	89 04 24             	mov    %eax,(%esp)
 8048b02:	e8 da 00 00 00       	call   8048be1 <phase_3>
 8048b07:	e8 6e 07 00 00       	call   804927a <phase_defused>
 8048b0c:	c7 04 24 b7 9f 04 08 	movl   $0x8049fb7,(%esp)
 8048b13:	e8 18 fd ff ff       	call   8048830 <puts@plt>
 8048b18:	e8 01 06 00 00       	call   804911e <read_line>
 8048b1d:	89 04 24             	mov    %eax,(%esp)
 8048b20:	e8 bd 01 00 00       	call   8048ce2 <phase_4>
 8048b25:	e8 50 07 00 00       	call   804927a <phase_defused>
 8048b2a:	c7 04 24 78 a0 04 08 	movl   $0x804a078,(%esp)
 8048b31:	e8 fa fc ff ff       	call   8048830 <puts@plt>
 8048b36:	e8 e3 05 00 00       	call   804911e <read_line>
 8048b3b:	89 04 24             	mov    %eax,(%esp)
 8048b3e:	e8 0e 02 00 00       	call   8048d51 <phase_5>
 8048b43:	e8 32 07 00 00       	call   804927a <phase_defused>
 8048b48:	c7 04 24 c6 9f 04 08 	movl   $0x8049fc6,(%esp)
 8048b4f:	e8 dc fc ff ff       	call   8048830 <puts@plt>
 8048b54:	e8 c5 05 00 00       	call   804911e <read_line>
 8048b59:	89 04 24             	mov    %eax,(%esp)
 8048b5c:	e8 5d 02 00 00       	call   8048dbe <phase_6>
 8048b61:	e8 14 07 00 00       	call   804927a <phase_defused>
 8048b66:	b8 00 00 00 00       	mov    $0x0,%eax
 8048b6b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048b6e:	c9                   	leave  
 8048b6f:	c3                   	ret    

08048b70 <phase_1>:
 8048b70:	83 ec 1c             	sub    $0x1c,%esp
 8048b73:	c7 44 24 04 9c a0 04 	movl   $0x804a09c,0x4(%esp)
 8048b7a:	08 
 8048b7b:	8b 44 24 20          	mov    0x20(%esp),%eax
 8048b7f:	89 04 24             	mov    %eax,(%esp)
 8048b82:	e8 63 04 00 00       	call   8048fea <strings_not_equal>
 8048b87:	85 c0                	test   %eax,%eax
 8048b89:	74 05                	je     8048b90 <phase_1+0x20>
 8048b8b:	e8 67 05 00 00       	call   80490f7 <explode_bomb>
 8048b90:	83 c4 1c             	add    $0x1c,%esp
 8048b93:	c3                   	ret    

08048b94 <phase_2>:
 8048b94:	53                   	push   %ebx
 8048b95:	83 ec 38             	sub    $0x38,%esp
 8048b98:	8d 44 24 18          	lea    0x18(%esp),%eax
 8048b9c:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048ba0:	8b 44 24 40          	mov    0x40(%esp),%eax
 8048ba4:	89 04 24             	mov    %eax,(%esp)
 8048ba7:	e8 7e 06 00 00       	call   804922a <read_six_numbers>
 8048bac:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 8048bb1:	79 22                	jns    8048bd5 <phase_2+0x41>
 8048bb3:	e8 3f 05 00 00       	call   80490f7 <explode_bomb>
 8048bb8:	eb 1b                	jmp    8048bd5 <phase_2+0x41>
 8048bba:	89 d8                	mov    %ebx,%eax
 8048bbc:	03 44 9c 14          	add    0x14(%esp,%ebx,4),%eax
 8048bc0:	39 44 9c 18          	cmp    %eax,0x18(%esp,%ebx,4)
 8048bc4:	74 05                	je     8048bcb <phase_2+0x37>
 8048bc6:	e8 2c 05 00 00       	call   80490f7 <explode_bomb>
 8048bcb:	83 c3 01             	add    $0x1,%ebx
 8048bce:	83 fb 06             	cmp    $0x6,%ebx
 8048bd1:	75 e7                	jne    8048bba <phase_2+0x26>
 8048bd3:	eb 07                	jmp    8048bdc <phase_2+0x48>
 8048bd5:	bb 01 00 00 00       	mov    $0x1,%ebx
 8048bda:	eb de                	jmp    8048bba <phase_2+0x26>
 8048bdc:	83 c4 38             	add    $0x38,%esp
 8048bdf:	5b                   	pop    %ebx
 8048be0:	c3                   	ret    

08048be1 <phase_3>:
 8048be1:	83 ec 2c             	sub    $0x2c,%esp
 8048be4:	8d 44 24 18          	lea    0x18(%esp),%eax
 8048be8:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048bec:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 8048bf0:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048bf4:	c7 44 24 04 83 a2 04 	movl   $0x804a283,0x4(%esp)
 8048bfb:	08 
 8048bfc:	8b 44 24 30          	mov    0x30(%esp),%eax
 8048c00:	89 04 24             	mov    %eax,(%esp)
 8048c03:	e8 88 fc ff ff       	call   8048890 <__isoc99_sscanf@plt>
 8048c08:	83 f8 01             	cmp    $0x1,%eax
 8048c0b:	7f 05                	jg     8048c12 <phase_3+0x31>
 8048c0d:	e8 e5 04 00 00       	call   80490f7 <explode_bomb>
 8048c12:	83 7c 24 1c 07       	cmpl   $0x7,0x1c(%esp)
 8048c17:	77 3c                	ja     8048c55 <phase_3+0x74>
 8048c19:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 8048c1d:	ff 24 85 f0 a0 04 08 	jmp    *0x804a0f0(,%eax,4)
 8048c24:	b8 2f 03 00 00       	mov    $0x32f,%eax
 8048c29:	eb 3b                	jmp    8048c66 <phase_3+0x85>
 8048c2b:	b8 84 01 00 00       	mov    $0x184,%eax
 8048c30:	eb 34                	jmp    8048c66 <phase_3+0x85>
 8048c32:	b8 8e 02 00 00       	mov    $0x28e,%eax
 8048c37:	eb 2d                	jmp    8048c66 <phase_3+0x85>
 8048c39:	b8 1c 01 00 00       	mov    $0x11c,%eax
 8048c3e:	eb 26                	jmp    8048c66 <phase_3+0x85>
 8048c40:	b8 01 02 00 00       	mov    $0x201,%eax
 8048c45:	eb 1f                	jmp    8048c66 <phase_3+0x85>
 8048c47:	b8 a9 01 00 00       	mov    $0x1a9,%eax
 8048c4c:	eb 18                	jmp    8048c66 <phase_3+0x85>
 8048c4e:	b8 74 03 00 00       	mov    $0x374,%eax
 8048c53:	eb 11                	jmp    8048c66 <phase_3+0x85>
 8048c55:	e8 9d 04 00 00       	call   80490f7 <explode_bomb>
 8048c5a:	b8 00 00 00 00       	mov    $0x0,%eax
 8048c5f:	eb 05                	jmp    8048c66 <phase_3+0x85>
 8048c61:	b8 30 01 00 00       	mov    $0x130,%eax
 8048c66:	3b 44 24 18          	cmp    0x18(%esp),%eax
 8048c6a:	74 05                	je     8048c71 <phase_3+0x90>
 8048c6c:	e8 86 04 00 00       	call   80490f7 <explode_bomb>
 8048c71:	83 c4 2c             	add    $0x2c,%esp
 8048c74:	c3                   	ret    

08048c75 <func4>:
 8048c75:	83 ec 1c             	sub    $0x1c,%esp
 8048c78:	89 5c 24 14          	mov    %ebx,0x14(%esp)
 8048c7c:	89 74 24 18          	mov    %esi,0x18(%esp)
 8048c80:	8b 54 24 20          	mov    0x20(%esp),%edx
 8048c84:	8b 44 24 24          	mov    0x24(%esp),%eax
 8048c88:	8b 5c 24 28          	mov    0x28(%esp),%ebx
 8048c8c:	89 d9                	mov    %ebx,%ecx
 8048c8e:	29 c1                	sub    %eax,%ecx
 8048c90:	89 ce                	mov    %ecx,%esi
 8048c92:	c1 ee 1f             	shr    $0x1f,%esi
 8048c95:	01 f1                	add    %esi,%ecx
 8048c97:	d1 f9                	sar    %ecx
 8048c99:	01 c1                	add    %eax,%ecx
 8048c9b:	39 d1                	cmp    %edx,%ecx
 8048c9d:	7e 17                	jle    8048cb6 <func4+0x41>
 8048c9f:	83 e9 01             	sub    $0x1,%ecx
 8048ca2:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 8048ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048caa:	89 14 24             	mov    %edx,(%esp)
 8048cad:	e8 c3 ff ff ff       	call   8048c75 <func4>
 8048cb2:	01 c0                	add    %eax,%eax
 8048cb4:	eb 20                	jmp    8048cd6 <func4+0x61>
 8048cb6:	b8 00 00 00 00       	mov    $0x0,%eax
 8048cbb:	39 d1                	cmp    %edx,%ecx
 8048cbd:	7d 17                	jge    8048cd6 <func4+0x61>
 8048cbf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 8048cc3:	83 c1 01             	add    $0x1,%ecx
 8048cc6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 8048cca:	89 14 24             	mov    %edx,(%esp)
 8048ccd:	e8 a3 ff ff ff       	call   8048c75 <func4>
 8048cd2:	8d 44 00 01          	lea    0x1(%eax,%eax,1),%eax
 8048cd6:	8b 5c 24 14          	mov    0x14(%esp),%ebx
 8048cda:	8b 74 24 18          	mov    0x18(%esp),%esi
 8048cde:	83 c4 1c             	add    $0x1c,%esp
 8048ce1:	c3                   	ret    

08048ce2 <phase_4>:
 8048ce2:	83 ec 2c             	sub    $0x2c,%esp
 8048ce5:	8d 44 24 18          	lea    0x18(%esp),%eax
 8048ce9:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048ced:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 8048cf1:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048cf5:	c7 44 24 04 83 a2 04 	movl   $0x804a283,0x4(%esp)
 8048cfc:	08 
 8048cfd:	8b 44 24 30          	mov    0x30(%esp),%eax
 8048d01:	89 04 24             	mov    %eax,(%esp)
 8048d04:	e8 87 fb ff ff       	call   8048890 <__isoc99_sscanf@plt>
 8048d09:	83 f8 02             	cmp    $0x2,%eax
 8048d0c:	75 0d                	jne    8048d1b <phase_4+0x39>
 8048d0e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 8048d12:	85 c0                	test   %eax,%eax
 8048d14:	78 05                	js     8048d1b <phase_4+0x39>
 8048d16:	83 f8 0e             	cmp    $0xe,%eax
 8048d19:	7e 05                	jle    8048d20 <phase_4+0x3e>
 8048d1b:	e8 d7 03 00 00       	call   80490f7 <explode_bomb>
 8048d20:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 8048d27:	00 
 8048d28:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8048d2f:	00 
 8048d30:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 8048d34:	89 04 24             	mov    %eax,(%esp)
 8048d37:	e8 39 ff ff ff       	call   8048c75 <func4>
 8048d3c:	83 f8 07             	cmp    $0x7,%eax
 8048d3f:	75 07                	jne    8048d48 <phase_4+0x66>
 8048d41:	83 7c 24 18 07       	cmpl   $0x7,0x18(%esp)
 8048d46:	74 05                	je     8048d4d <phase_4+0x6b>
 8048d48:	e8 aa 03 00 00       	call   80490f7 <explode_bomb>
 8048d4d:	83 c4 2c             	add    $0x2c,%esp
 8048d50:	c3                   	ret    

08048d51 <phase_5>:
 8048d51:	53                   	push   %ebx
 8048d52:	83 ec 28             	sub    $0x28,%esp
 8048d55:	8b 5c 24 30          	mov    0x30(%esp),%ebx
 8048d59:	89 1c 24             	mov    %ebx,(%esp)
 8048d5c:	e8 6a 02 00 00       	call   8048fcb <string_length>
 8048d61:	83 f8 06             	cmp    $0x6,%eax
 8048d64:	74 4c                	je     8048db2 <phase_5+0x61>
 8048d66:	e8 8c 03 00 00       	call   80490f7 <explode_bomb>
 8048d6b:	90                   	nop
 8048d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8048d70:	eb 40                	jmp    8048db2 <phase_5+0x61>
 8048d72:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 8048d76:	83 e2 0f             	and    $0xf,%edx
 8048d79:	0f b6 92 10 a1 04 08 	movzbl 0x804a110(%edx),%edx
 8048d80:	88 54 04 19          	mov    %dl,0x19(%esp,%eax,1)
 8048d84:	83 c0 01             	add    $0x1,%eax
 8048d87:	83 f8 06             	cmp    $0x6,%eax
 8048d8a:	75 e6                	jne    8048d72 <phase_5+0x21>
 8048d8c:	c6 44 24 1f 00       	movb   $0x0,0x1f(%esp)
 8048d91:	c7 44 24 04 e6 a0 04 	movl   $0x804a0e6,0x4(%esp)
 8048d98:	08 
 8048d99:	8d 44 24 19          	lea    0x19(%esp),%eax
 8048d9d:	89 04 24             	mov    %eax,(%esp)
 8048da0:	e8 45 02 00 00       	call   8048fea <strings_not_equal>
 8048da5:	85 c0                	test   %eax,%eax
 8048da7:	74 10                	je     8048db9 <phase_5+0x68>
 8048da9:	e8 49 03 00 00       	call   80490f7 <explode_bomb>
 8048dae:	66 90                	xchg   %ax,%ax
 8048db0:	eb 07                	jmp    8048db9 <phase_5+0x68>
 8048db2:	b8 00 00 00 00       	mov    $0x0,%eax
 8048db7:	eb b9                	jmp    8048d72 <phase_5+0x21>
 8048db9:	83 c4 28             	add    $0x28,%esp
 8048dbc:	5b                   	pop    %ebx
 8048dbd:	c3                   	ret    

08048dbe <phase_6>:
 8048dbe:	57                   	push   %edi
 8048dbf:	56                   	push   %esi
 8048dc0:	53                   	push   %ebx
 8048dc1:	83 ec 40             	sub    $0x40,%esp
 8048dc4:	8d 44 24 28          	lea    0x28(%esp),%eax
 8048dc8:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048dcc:	8b 44 24 50          	mov    0x50(%esp),%eax
 8048dd0:	89 04 24             	mov    %eax,(%esp)
 8048dd3:	e8 52 04 00 00       	call   804922a <read_six_numbers>
 8048dd8:	bf 00 00 00 00       	mov    $0x0,%edi
 8048ddd:	8b 44 bc 28          	mov    0x28(%esp,%edi,4),%eax
 8048de1:	83 e8 01             	sub    $0x1,%eax
 8048de4:	83 f8 05             	cmp    $0x5,%eax
 8048de7:	76 05                	jbe    8048dee <phase_6+0x30>
 8048de9:	e8 09 03 00 00       	call   80490f7 <explode_bomb>
 8048dee:	8d 77 01             	lea    0x1(%edi),%esi
 8048df1:	83 fe 06             	cmp    $0x6,%esi
 8048df4:	74 35                	je     8048e2b <phase_6+0x6d>
 8048df6:	89 f3                	mov    %esi,%ebx
 8048df8:	8b 44 9c 28          	mov    0x28(%esp,%ebx,4),%eax
 8048dfc:	39 44 b4 24          	cmp    %eax,0x24(%esp,%esi,4)
 8048e00:	75 05                	jne    8048e07 <phase_6+0x49>
 8048e02:	e8 f0 02 00 00       	call   80490f7 <explode_bomb>
 8048e07:	83 c3 01             	add    $0x1,%ebx
 8048e0a:	89 f7                	mov    %esi,%edi
 8048e0c:	83 fb 05             	cmp    $0x5,%ebx
 8048e0f:	7e e7                	jle    8048df8 <phase_6+0x3a>
 8048e11:	eb ca                	jmp    8048ddd <phase_6+0x1f>
 8048e13:	8b 52 08             	mov    0x8(%edx),%edx
 8048e16:	83 c0 01             	add    $0x1,%eax
 8048e19:	39 c8                	cmp    %ecx,%eax
 8048e1b:	75 f6                	jne    8048e13 <phase_6+0x55>
 8048e1d:	89 54 b4 10          	mov    %edx,0x10(%esp,%esi,4)
 8048e21:	83 c3 01             	add    $0x1,%ebx
 8048e24:	83 fb 06             	cmp    $0x6,%ebx
 8048e27:	75 07                	jne    8048e30 <phase_6+0x72>
 8048e29:	eb 1c                	jmp    8048e47 <phase_6+0x89>
 8048e2b:	bb 00 00 00 00       	mov    $0x0,%ebx
 8048e30:	89 de                	mov    %ebx,%esi
 8048e32:	8b 4c 9c 28          	mov    0x28(%esp,%ebx,4),%ecx
 8048e36:	b8 01 00 00 00       	mov    $0x1,%eax
 8048e3b:	ba 3c b2 04 08       	mov    $0x804b23c,%edx
 8048e40:	83 f9 01             	cmp    $0x1,%ecx
 8048e43:	7f ce                	jg     8048e13 <phase_6+0x55>
 8048e45:	eb d6                	jmp    8048e1d <phase_6+0x5f>
 8048e47:	8b 5c 24 10          	mov    0x10(%esp),%ebx
 8048e4b:	8b 44 24 14          	mov    0x14(%esp),%eax
 8048e4f:	89 43 08             	mov    %eax,0x8(%ebx)
 8048e52:	8b 54 24 18          	mov    0x18(%esp),%edx
 8048e56:	89 50 08             	mov    %edx,0x8(%eax)
 8048e59:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 8048e5d:	89 42 08             	mov    %eax,0x8(%edx)
 8048e60:	8b 54 24 20          	mov    0x20(%esp),%edx
 8048e64:	89 50 08             	mov    %edx,0x8(%eax)
 8048e67:	8b 44 24 24          	mov    0x24(%esp),%eax
 8048e6b:	89 42 08             	mov    %eax,0x8(%edx)
 8048e6e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
 8048e75:	be 05 00 00 00       	mov    $0x5,%esi
 8048e7a:	8b 43 08             	mov    0x8(%ebx),%eax
 8048e7d:	8b 10                	mov    (%eax),%edx
 8048e7f:	39 13                	cmp    %edx,(%ebx)
 8048e81:	7d 05                	jge    8048e88 <phase_6+0xca>
 8048e83:	e8 6f 02 00 00       	call   80490f7 <explode_bomb>
 8048e88:	8b 5b 08             	mov    0x8(%ebx),%ebx
 8048e8b:	83 ee 01             	sub    $0x1,%esi
 8048e8e:	75 ea                	jne    8048e7a <phase_6+0xbc>
 8048e90:	83 c4 40             	add    $0x40,%esp
 8048e93:	5b                   	pop    %ebx
 8048e94:	5e                   	pop    %esi
 8048e95:	5f                   	pop    %edi
 8048e96:	c3                   	ret    

08048e97 <fun7>:
 8048e97:	53                   	push   %ebx
 8048e98:	83 ec 18             	sub    $0x18,%esp
 8048e9b:	8b 54 24 20          	mov    0x20(%esp),%edx
 8048e9f:	8b 4c 24 24          	mov    0x24(%esp),%ecx
 8048ea3:	85 d2                	test   %edx,%edx
 8048ea5:	74 37                	je     8048ede <fun7+0x47>
 8048ea7:	8b 1a                	mov    (%edx),%ebx
 8048ea9:	39 cb                	cmp    %ecx,%ebx
 8048eab:	7e 13                	jle    8048ec0 <fun7+0x29>
 8048ead:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 8048eb1:	8b 42 04             	mov    0x4(%edx),%eax
 8048eb4:	89 04 24             	mov    %eax,(%esp)
 8048eb7:	e8 db ff ff ff       	call   8048e97 <fun7>
 8048ebc:	01 c0                	add    %eax,%eax
 8048ebe:	eb 23                	jmp    8048ee3 <fun7+0x4c>
 8048ec0:	b8 00 00 00 00       	mov    $0x0,%eax
 8048ec5:	39 cb                	cmp    %ecx,%ebx
 8048ec7:	74 1a                	je     8048ee3 <fun7+0x4c>
 8048ec9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 8048ecd:	8b 42 08             	mov    0x8(%edx),%eax
 8048ed0:	89 04 24             	mov    %eax,(%esp)
 8048ed3:	e8 bf ff ff ff       	call   8048e97 <fun7>
 8048ed8:	8d 44 00 01          	lea    0x1(%eax,%eax,1),%eax
 8048edc:	eb 05                	jmp    8048ee3 <fun7+0x4c>
 8048ede:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8048ee3:	83 c4 18             	add    $0x18,%esp
 8048ee6:	5b                   	pop    %ebx
 8048ee7:	c3                   	ret    

08048ee8 <secret_phase>:
 8048ee8:	53                   	push   %ebx
 8048ee9:	83 ec 18             	sub    $0x18,%esp
 8048eec:	e8 2d 02 00 00       	call   804911e <read_line>
 8048ef1:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8048ef8:	00 
 8048ef9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8048f00:	00 
 8048f01:	89 04 24             	mov    %eax,(%esp)
 8048f04:	e8 e7 f9 ff ff       	call   80488f0 <strtol@plt>
 8048f09:	89 c3                	mov    %eax,%ebx
 8048f0b:	8d 40 ff             	lea    -0x1(%eax),%eax
 8048f0e:	3d e8 03 00 00       	cmp    $0x3e8,%eax
 8048f13:	76 05                	jbe    8048f1a <secret_phase+0x32>
 8048f15:	e8 dd 01 00 00       	call   80490f7 <explode_bomb>
 8048f1a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 8048f1e:	c7 04 24 88 b1 04 08 	movl   $0x804b188,(%esp)
 8048f25:	e8 6d ff ff ff       	call   8048e97 <fun7>
 8048f2a:	83 f8 01             	cmp    $0x1,%eax
 8048f2d:	74 05                	je     8048f34 <secret_phase+0x4c>
 8048f2f:	e8 c3 01 00 00       	call   80490f7 <explode_bomb>
 8048f34:	c7 04 24 c0 a0 04 08 	movl   $0x804a0c0,(%esp)
 8048f3b:	e8 f0 f8 ff ff       	call   8048830 <puts@plt>
 8048f40:	e8 35 03 00 00       	call   804927a <phase_defused>
 8048f45:	83 c4 18             	add    $0x18,%esp
 8048f48:	5b                   	pop    %ebx
 8048f49:	c3                   	ret    
 8048f4a:	90                   	nop
 8048f4b:	90                   	nop
 8048f4c:	90                   	nop
 8048f4d:	90                   	nop
 8048f4e:	90                   	nop
 8048f4f:	90                   	nop

08048f50 <sig_handler>:
 8048f50:	83 ec 1c             	sub    $0x1c,%esp
 8048f53:	c7 04 24 20 a1 04 08 	movl   $0x804a120,(%esp)
 8048f5a:	e8 d1 f8 ff ff       	call   8048830 <puts@plt>
 8048f5f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
 8048f66:	e8 75 f8 ff ff       	call   80487e0 <sleep@plt>
 8048f6b:	c7 04 24 e2 a1 04 08 	movl   $0x804a1e2,(%esp)
 8048f72:	e8 19 f8 ff ff       	call   8048790 <printf@plt>
 8048f77:	a1 c0 b4 04 08       	mov    0x804b4c0,%eax
 8048f7c:	89 04 24             	mov    %eax,(%esp)
 8048f7f:	e8 1c f8 ff ff       	call   80487a0 <fflush@plt>
 8048f84:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8048f8b:	e8 50 f8 ff ff       	call   80487e0 <sleep@plt>
 8048f90:	c7 04 24 ea a1 04 08 	movl   $0x804a1ea,(%esp)
 8048f97:	e8 94 f8 ff ff       	call   8048830 <puts@plt>
 8048f9c:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
 8048fa3:	e8 a8 f8 ff ff       	call   8048850 <exit@plt>

08048fa8 <invalid_phase>:
 8048fa8:	83 ec 1c             	sub    $0x1c,%esp
 8048fab:	8b 44 24 20          	mov    0x20(%esp),%eax
 8048faf:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048fb3:	c7 04 24 f2 a1 04 08 	movl   $0x804a1f2,(%esp)
 8048fba:	e8 d1 f7 ff ff       	call   8048790 <printf@plt>
 8048fbf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8048fc6:	e8 85 f8 ff ff       	call   8048850 <exit@plt>

08048fcb <string_length>:
 8048fcb:	8b 54 24 04          	mov    0x4(%esp),%edx
 8048fcf:	80 3a 00             	cmpb   $0x0,(%edx)
 8048fd2:	74 10                	je     8048fe4 <string_length+0x19>
 8048fd4:	b8 00 00 00 00       	mov    $0x0,%eax
 8048fd9:	83 c0 01             	add    $0x1,%eax
 8048fdc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 8048fe0:	75 f7                	jne    8048fd9 <string_length+0xe>
 8048fe2:	f3 c3                	repz ret 
 8048fe4:	b8 00 00 00 00       	mov    $0x0,%eax
 8048fe9:	c3                   	ret    

08048fea <strings_not_equal>:
 8048fea:	57                   	push   %edi
 8048feb:	56                   	push   %esi
 8048fec:	53                   	push   %ebx
 8048fed:	83 ec 04             	sub    $0x4,%esp
 8048ff0:	8b 5c 24 14          	mov    0x14(%esp),%ebx
 8048ff4:	8b 74 24 18          	mov    0x18(%esp),%esi
 8048ff8:	89 1c 24             	mov    %ebx,(%esp)
 8048ffb:	e8 cb ff ff ff       	call   8048fcb <string_length>
 8049000:	89 c7                	mov    %eax,%edi
 8049002:	89 34 24             	mov    %esi,(%esp)
 8049005:	e8 c1 ff ff ff       	call   8048fcb <string_length>
 804900a:	ba 01 00 00 00       	mov    $0x1,%edx
 804900f:	39 c7                	cmp    %eax,%edi
 8049011:	75 3c                	jne    804904f <strings_not_equal+0x65>
 8049013:	0f b6 03             	movzbl (%ebx),%eax
 8049016:	84 c0                	test   %al,%al
 8049018:	74 22                	je     804903c <strings_not_equal+0x52>
 804901a:	3a 06                	cmp    (%esi),%al
 804901c:	75 25                	jne    8049043 <strings_not_equal+0x59>
 804901e:	89 f2                	mov    %esi,%edx
 8049020:	89 d8                	mov    %ebx,%eax
 8049022:	eb 04                	jmp    8049028 <strings_not_equal+0x3e>
 8049024:	3a 0a                	cmp    (%edx),%cl
 8049026:	75 22                	jne    804904a <strings_not_equal+0x60>
 8049028:	83 c0 01             	add    $0x1,%eax
 804902b:	83 c2 01             	add    $0x1,%edx
 804902e:	0f b6 08             	movzbl (%eax),%ecx
 8049031:	84 c9                	test   %cl,%cl
 8049033:	75 ef                	jne    8049024 <strings_not_equal+0x3a>
 8049035:	ba 00 00 00 00       	mov    $0x0,%edx
 804903a:	eb 13                	jmp    804904f <strings_not_equal+0x65>
 804903c:	ba 00 00 00 00       	mov    $0x0,%edx
 8049041:	eb 0c                	jmp    804904f <strings_not_equal+0x65>
 8049043:	ba 01 00 00 00       	mov    $0x1,%edx
 8049048:	eb 05                	jmp    804904f <strings_not_equal+0x65>
 804904a:	ba 01 00 00 00       	mov    $0x1,%edx
 804904f:	89 d0                	mov    %edx,%eax
 8049051:	83 c4 04             	add    $0x4,%esp
 8049054:	5b                   	pop    %ebx
 8049055:	5e                   	pop    %esi
 8049056:	5f                   	pop    %edi
 8049057:	c3                   	ret    

08049058 <initialize_bomb>:
 8049058:	83 ec 1c             	sub    $0x1c,%esp
 804905b:	c7 44 24 04 50 8f 04 	movl   $0x8048f50,0x4(%esp)
 8049062:	08 
 8049063:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 804906a:	e8 61 f7 ff ff       	call   80487d0 <signal@plt>
 804906f:	83 c4 1c             	add    $0x1c,%esp
 8049072:	c3                   	ret    

08049073 <initialize_bomb_solve>:
 8049073:	f3 c3                	repz ret 

08049075 <blank_line>:
 8049075:	56                   	push   %esi
 8049076:	53                   	push   %ebx
 8049077:	83 ec 04             	sub    $0x4,%esp
 804907a:	8b 5c 24 10          	mov    0x10(%esp),%ebx
 804907e:	eb 16                	jmp    8049096 <blank_line+0x21>
 8049080:	e8 9b f8 ff ff       	call   8048920 <__ctype_b_loc@plt>
 8049085:	83 c3 01             	add    $0x1,%ebx
 8049088:	89 f2                	mov    %esi,%edx
 804908a:	0f be f2             	movsbl %dl,%esi
 804908d:	8b 00                	mov    (%eax),%eax
 804908f:	f6 44 70 01 20       	testb  $0x20,0x1(%eax,%esi,2)
 8049094:	74 10                	je     80490a6 <blank_line+0x31>
 8049096:	0f b6 33             	movzbl (%ebx),%esi
 8049099:	89 f0                	mov    %esi,%eax
 804909b:	84 c0                	test   %al,%al
 804909d:	75 e1                	jne    8049080 <blank_line+0xb>
 804909f:	b8 01 00 00 00       	mov    $0x1,%eax
 80490a4:	eb 05                	jmp    80490ab <blank_line+0x36>
 80490a6:	b8 00 00 00 00       	mov    $0x0,%eax
 80490ab:	83 c4 04             	add    $0x4,%esp
 80490ae:	5b                   	pop    %ebx
 80490af:	5e                   	pop    %esi
 80490b0:	c3                   	ret    

080490b1 <skip>:
 80490b1:	53                   	push   %ebx
 80490b2:	83 ec 18             	sub    $0x18,%esp
 80490b5:	a1 cc b4 04 08       	mov    0x804b4cc,%eax
 80490ba:	89 44 24 08          	mov    %eax,0x8(%esp)
 80490be:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
 80490c5:	00 
 80490c6:	a1 c8 b4 04 08       	mov    0x804b4c8,%eax
 80490cb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 80490ce:	c1 e0 04             	shl    $0x4,%eax
 80490d1:	05 e0 b4 04 08       	add    $0x804b4e0,%eax
 80490d6:	89 04 24             	mov    %eax,(%esp)
 80490d9:	e8 e2 f6 ff ff       	call   80487c0 <fgets@plt>
 80490de:	89 c3                	mov    %eax,%ebx
 80490e0:	85 c0                	test   %eax,%eax
 80490e2:	74 0c                	je     80490f0 <skip+0x3f>
 80490e4:	89 04 24             	mov    %eax,(%esp)
 80490e7:	e8 89 ff ff ff       	call   8049075 <blank_line>
 80490ec:	85 c0                	test   %eax,%eax
 80490ee:	75 c5                	jne    80490b5 <skip+0x4>
 80490f0:	89 d8                	mov    %ebx,%eax
 80490f2:	83 c4 18             	add    $0x18,%esp
 80490f5:	5b                   	pop    %ebx
 80490f6:	c3                   	ret    

080490f7 <explode_bomb>:
 80490f7:	83 ec 1c             	sub    $0x1c,%esp
 80490fa:	c7 04 24 03 a2 04 08 	movl   $0x804a203,(%esp)
 8049101:	e8 2a f7 ff ff       	call   8048830 <puts@plt>
 8049106:	c7 04 24 0c a2 04 08 	movl   $0x804a20c,(%esp)
 804910d:	e8 1e f7 ff ff       	call   8048830 <puts@plt>
 8049112:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8049119:	e8 32 f7 ff ff       	call   8048850 <exit@plt>

0804911e <read_line>:
 804911e:	83 ec 1c             	sub    $0x1c,%esp
 8049121:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 8049125:	89 74 24 14          	mov    %esi,0x14(%esp)
 8049129:	89 7c 24 18          	mov    %edi,0x18(%esp)
 804912d:	e8 7f ff ff ff       	call   80490b1 <skip>
 8049132:	85 c0                	test   %eax,%eax
 8049134:	75 6c                	jne    80491a2 <read_line+0x84>
 8049136:	a1 a4 b4 04 08       	mov    0x804b4a4,%eax
 804913b:	39 05 cc b4 04 08    	cmp    %eax,0x804b4cc
 8049141:	75 18                	jne    804915b <read_line+0x3d>
 8049143:	c7 04 24 23 a2 04 08 	movl   $0x804a223,(%esp)
 804914a:	e8 e1 f6 ff ff       	call   8048830 <puts@plt>
 804914f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8049156:	e8 f5 f6 ff ff       	call   8048850 <exit@plt>
 804915b:	c7 04 24 41 a2 04 08 	movl   $0x804a241,(%esp)
 8049162:	e8 b9 f6 ff ff       	call   8048820 <getenv@plt>
 8049167:	85 c0                	test   %eax,%eax
 8049169:	74 0c                	je     8049177 <read_line+0x59>
 804916b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8049172:	e8 d9 f6 ff ff       	call   8048850 <exit@plt>
 8049177:	a1 a4 b4 04 08       	mov    0x804b4a4,%eax
 804917c:	a3 cc b4 04 08       	mov    %eax,0x804b4cc
 8049181:	e8 2b ff ff ff       	call   80490b1 <skip>
 8049186:	85 c0                	test   %eax,%eax
 8049188:	75 18                	jne    80491a2 <read_line+0x84>
 804918a:	c7 04 24 23 a2 04 08 	movl   $0x804a223,(%esp)
 8049191:	e8 9a f6 ff ff       	call   8048830 <puts@plt>
 8049196:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 804919d:	e8 ae f6 ff ff       	call   8048850 <exit@plt>
 80491a2:	8b 15 c8 b4 04 08    	mov    0x804b4c8,%edx
 80491a8:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 80491ab:	c1 e3 04             	shl    $0x4,%ebx
 80491ae:	81 c3 e0 b4 04 08    	add    $0x804b4e0,%ebx
 80491b4:	89 df                	mov    %ebx,%edi
 80491b6:	b8 00 00 00 00       	mov    $0x0,%eax
 80491bb:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 80491c0:	f2 ae                	repnz scas %es:(%edi),%al
 80491c2:	f7 d1                	not    %ecx
 80491c4:	83 e9 01             	sub    $0x1,%ecx
 80491c7:	83 f9 4e             	cmp    $0x4e,%ecx
 80491ca:	7e 35                	jle    8049201 <read_line+0xe3>
 80491cc:	c7 04 24 4c a2 04 08 	movl   $0x804a24c,(%esp)
 80491d3:	e8 58 f6 ff ff       	call   8048830 <puts@plt>
 80491d8:	a1 c8 b4 04 08       	mov    0x804b4c8,%eax
 80491dd:	8d 50 01             	lea    0x1(%eax),%edx
 80491e0:	89 15 c8 b4 04 08    	mov    %edx,0x804b4c8
 80491e6:	6b c0 50             	imul   $0x50,%eax,%eax
 80491e9:	05 e0 b4 04 08       	add    $0x804b4e0,%eax
 80491ee:	be 67 a2 04 08       	mov    $0x804a267,%esi
 80491f3:	b9 04 00 00 00       	mov    $0x4,%ecx
 80491f8:	89 c7                	mov    %eax,%edi
 80491fa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
 80491fc:	e8 f6 fe ff ff       	call   80490f7 <explode_bomb>
 8049201:	8d 04 92             	lea    (%edx,%edx,4),%eax
 8049204:	c1 e0 04             	shl    $0x4,%eax
 8049207:	c6 84 01 df b4 04 08 	movb   $0x0,0x804b4df(%ecx,%eax,1)
 804920e:	00 
 804920f:	83 c2 01             	add    $0x1,%edx
 8049212:	89 15 c8 b4 04 08    	mov    %edx,0x804b4c8
 8049218:	89 d8                	mov    %ebx,%eax
 804921a:	8b 5c 24 10          	mov    0x10(%esp),%ebx
 804921e:	8b 74 24 14          	mov    0x14(%esp),%esi
 8049222:	8b 7c 24 18          	mov    0x18(%esp),%edi
 8049226:	83 c4 1c             	add    $0x1c,%esp
 8049229:	c3                   	ret    

0804922a <read_six_numbers>:
 804922a:	83 ec 2c             	sub    $0x2c,%esp
 804922d:	8b 44 24 34          	mov    0x34(%esp),%eax
 8049231:	8d 50 14             	lea    0x14(%eax),%edx
 8049234:	89 54 24 1c          	mov    %edx,0x1c(%esp)
 8049238:	8d 50 10             	lea    0x10(%eax),%edx
 804923b:	89 54 24 18          	mov    %edx,0x18(%esp)
 804923f:	8d 50 0c             	lea    0xc(%eax),%edx
 8049242:	89 54 24 14          	mov    %edx,0x14(%esp)
 8049246:	8d 50 08             	lea    0x8(%eax),%edx
 8049249:	89 54 24 10          	mov    %edx,0x10(%esp)
 804924d:	8d 50 04             	lea    0x4(%eax),%edx
 8049250:	89 54 24 0c          	mov    %edx,0xc(%esp)
 8049254:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049258:	c7 44 24 04 77 a2 04 	movl   $0x804a277,0x4(%esp)
 804925f:	08 
 8049260:	8b 44 24 30          	mov    0x30(%esp),%eax
 8049264:	89 04 24             	mov    %eax,(%esp)
 8049267:	e8 24 f6 ff ff       	call   8048890 <__isoc99_sscanf@plt>
 804926c:	83 f8 05             	cmp    $0x5,%eax
 804926f:	7f 05                	jg     8049276 <read_six_numbers+0x4c>
 8049271:	e8 81 fe ff ff       	call   80490f7 <explode_bomb>
 8049276:	83 c4 2c             	add    $0x2c,%esp
 8049279:	c3                   	ret    

0804927a <phase_defused>:
 804927a:	83 3d c8 b4 04 08 06 	cmpl   $0x6,0x804b4c8
 8049281:	75 7e                	jne    8049301 <phase_defused+0x87>
 8049283:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
 8049289:	8d 44 24 30          	lea    0x30(%esp),%eax
 804928d:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049291:	8d 44 24 28          	lea    0x28(%esp),%eax
 8049295:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049299:	8d 44 24 2c          	lea    0x2c(%esp),%eax
 804929d:	89 44 24 08          	mov    %eax,0x8(%esp)
 80492a1:	c7 44 24 04 89 a2 04 	movl   $0x804a289,0x4(%esp)
 80492a8:	08 
 80492a9:	c7 04 24 d0 b5 04 08 	movl   $0x804b5d0,(%esp)
 80492b0:	e8 db f5 ff ff       	call   8048890 <__isoc99_sscanf@plt>
 80492b5:	83 f8 03             	cmp    $0x3,%eax
 80492b8:	75 35                	jne    80492ef <phase_defused+0x75>
 80492ba:	c7 44 24 04 92 a2 04 	movl   $0x804a292,0x4(%esp)
 80492c1:	08 
 80492c2:	8d 44 24 30          	lea    0x30(%esp),%eax
 80492c6:	89 04 24             	mov    %eax,(%esp)
 80492c9:	e8 1c fd ff ff       	call   8048fea <strings_not_equal>
 80492ce:	85 c0                	test   %eax,%eax
 80492d0:	75 1d                	jne    80492ef <phase_defused+0x75>
 80492d2:	c7 04 24 58 a1 04 08 	movl   $0x804a158,(%esp)
 80492d9:	e8 52 f5 ff ff       	call   8048830 <puts@plt>
 80492de:	c7 04 24 80 a1 04 08 	movl   $0x804a180,(%esp)
 80492e5:	e8 46 f5 ff ff       	call   8048830 <puts@plt>
 80492ea:	e8 f9 fb ff ff       	call   8048ee8 <secret_phase>
 80492ef:	c7 04 24 b8 a1 04 08 	movl   $0x804a1b8,(%esp)
 80492f6:	e8 35 f5 ff ff       	call   8048830 <puts@plt>
 80492fb:	81 c4 8c 00 00 00    	add    $0x8c,%esp
 8049301:	f3 c3                	repz ret 
 8049303:	90                   	nop
 8049304:	90                   	nop
 8049305:	90                   	nop
 8049306:	90                   	nop
 8049307:	90                   	nop
 8049308:	90                   	nop
 8049309:	90                   	nop
 804930a:	90                   	nop
 804930b:	90                   	nop
 804930c:	90                   	nop
 804930d:	90                   	nop
 804930e:	90                   	nop
 804930f:	90                   	nop

08049310 <rio_readlineb>:
 8049310:	55                   	push   %ebp
 8049311:	57                   	push   %edi
 8049312:	56                   	push   %esi
 8049313:	53                   	push   %ebx
 8049314:	83 ec 3c             	sub    $0x3c,%esp
 8049317:	83 f9 01             	cmp    $0x1,%ecx
 804931a:	0f 86 cd 00 00 00    	jbe    80493ed <rio_readlineb+0xdd>
 8049320:	89 c3                	mov    %eax,%ebx
 8049322:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
 8049326:	89 54 24 10          	mov    %edx,0x10(%esp)
 804932a:	bd 01 00 00 00       	mov    $0x1,%ebp
 804932f:	8d 78 0c             	lea    0xc(%eax),%edi
 8049332:	eb 38                	jmp    804936c <rio_readlineb+0x5c>
 8049334:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
 804933b:	00 
 804933c:	89 7c 24 04          	mov    %edi,0x4(%esp)
 8049340:	8b 03                	mov    (%ebx),%eax
 8049342:	89 04 24             	mov    %eax,(%esp)
 8049345:	e8 36 f4 ff ff       	call   8048780 <read@plt>
 804934a:	89 43 04             	mov    %eax,0x4(%ebx)
 804934d:	85 c0                	test   %eax,%eax
 804934f:	79 14                	jns    8049365 <rio_readlineb+0x55>
 8049351:	e8 5a f5 ff ff       	call   80488b0 <__errno_location@plt>
 8049356:	83 38 04             	cmpl   $0x4,(%eax)
 8049359:	74 11                	je     804936c <rio_readlineb+0x5c>
 804935b:	90                   	nop
 804935c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8049360:	e9 9a 00 00 00       	jmp    80493ff <rio_readlineb+0xef>
 8049365:	85 c0                	test   %eax,%eax
 8049367:	74 6d                	je     80493d6 <rio_readlineb+0xc6>
 8049369:	89 7b 08             	mov    %edi,0x8(%ebx)
 804936c:	8b 73 04             	mov    0x4(%ebx),%esi
 804936f:	85 f6                	test   %esi,%esi
 8049371:	7e c1                	jle    8049334 <rio_readlineb+0x24>
 8049373:	85 f6                	test   %esi,%esi
 8049375:	0f 95 c0             	setne  %al
 8049378:	0f b6 c0             	movzbl %al,%eax
 804937b:	89 44 24 14          	mov    %eax,0x14(%esp)
 804937f:	8b 53 08             	mov    0x8(%ebx),%edx
 8049382:	89 54 24 18          	mov    %edx,0x18(%esp)
 8049386:	89 44 24 08          	mov    %eax,0x8(%esp)
 804938a:	89 54 24 04          	mov    %edx,0x4(%esp)
 804938e:	8d 44 24 2f          	lea    0x2f(%esp),%eax
 8049392:	89 04 24             	mov    %eax,(%esp)
 8049395:	e8 16 f4 ff ff       	call   80487b0 <memcpy@plt>
 804939a:	8b 44 24 18          	mov    0x18(%esp),%eax
 804939e:	03 44 24 14          	add    0x14(%esp),%eax
 80493a2:	89 43 08             	mov    %eax,0x8(%ebx)
 80493a5:	2b 74 24 14          	sub    0x14(%esp),%esi
 80493a9:	89 73 04             	mov    %esi,0x4(%ebx)
 80493ac:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
 80493b1:	75 18                	jne    80493cb <rio_readlineb+0xbb>
 80493b3:	0f b6 44 24 2f       	movzbl 0x2f(%esp),%eax
 80493b8:	8b 54 24 10          	mov    0x10(%esp),%edx
 80493bc:	88 02                	mov    %al,(%edx)
 80493be:	83 c2 01             	add    $0x1,%edx
 80493c1:	89 54 24 10          	mov    %edx,0x10(%esp)
 80493c5:	3c 0a                	cmp    $0xa,%al
 80493c7:	75 19                	jne    80493e2 <rio_readlineb+0xd2>
 80493c9:	eb 2b                	jmp    80493f6 <rio_readlineb+0xe6>
 80493cb:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 80493d0:	75 34                	jne    8049406 <rio_readlineb+0xf6>
 80493d2:	89 e8                	mov    %ebp,%eax
 80493d4:	eb 02                	jmp    80493d8 <rio_readlineb+0xc8>
 80493d6:	89 e8                	mov    %ebp,%eax
 80493d8:	83 f8 01             	cmp    $0x1,%eax
 80493db:	75 19                	jne    80493f6 <rio_readlineb+0xe6>
 80493dd:	8d 76 00             	lea    0x0(%esi),%esi
 80493e0:	eb 2b                	jmp    804940d <rio_readlineb+0xfd>
 80493e2:	83 c5 01             	add    $0x1,%ebp
 80493e5:	3b 6c 24 1c          	cmp    0x1c(%esp),%ebp
 80493e9:	75 81                	jne    804936c <rio_readlineb+0x5c>
 80493eb:	eb 09                	jmp    80493f6 <rio_readlineb+0xe6>
 80493ed:	89 54 24 10          	mov    %edx,0x10(%esp)
 80493f1:	bd 01 00 00 00       	mov    $0x1,%ebp
 80493f6:	8b 44 24 10          	mov    0x10(%esp),%eax
 80493fa:	c6 00 00             	movb   $0x0,(%eax)
 80493fd:	eb 13                	jmp    8049412 <rio_readlineb+0x102>
 80493ff:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 8049404:	eb 0c                	jmp    8049412 <rio_readlineb+0x102>
 8049406:	bd ff ff ff ff       	mov    $0xffffffff,%ebp
 804940b:	eb 05                	jmp    8049412 <rio_readlineb+0x102>
 804940d:	bd 00 00 00 00       	mov    $0x0,%ebp
 8049412:	89 e8                	mov    %ebp,%eax
 8049414:	83 c4 3c             	add    $0x3c,%esp
 8049417:	5b                   	pop    %ebx
 8049418:	5e                   	pop    %esi
 8049419:	5f                   	pop    %edi
 804941a:	5d                   	pop    %ebp
 804941b:	c3                   	ret    

0804941c <sigalrm_handler>:
 804941c:	83 ec 1c             	sub    $0x1c,%esp
 804941f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 8049426:	00 
 8049427:	c7 44 24 04 e8 a2 04 	movl   $0x804a2e8,0x4(%esp)
 804942e:	08 
 804942f:	a1 a0 b4 04 08       	mov    0x804b4a0,%eax
 8049434:	89 04 24             	mov    %eax,(%esp)
 8049437:	e8 34 f4 ff ff       	call   8048870 <fprintf@plt>
 804943c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8049443:	e8 08 f4 ff ff       	call   8048850 <exit@plt>

08049448 <submitr>:
 8049448:	55                   	push   %ebp
 8049449:	57                   	push   %edi
 804944a:	56                   	push   %esi
 804944b:	53                   	push   %ebx
 804944c:	81 ec 6c a0 00 00    	sub    $0xa06c,%esp
 8049452:	8b 9c 24 94 a0 00 00 	mov    0xa094(%esp),%ebx
 8049459:	c7 84 24 40 20 00 00 	movl   $0x0,0x2040(%esp)
 8049460:	00 00 00 00 
 8049464:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 804946b:	00 
 804946c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049473:	00 
 8049474:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 804947b:	e8 50 f4 ff ff       	call   80488d0 <socket@plt>
 8049480:	89 c5                	mov    %eax,%ebp
 8049482:	85 c0                	test   %eax,%eax
 8049484:	79 55                	jns    80494db <submitr+0x93>
 8049486:	8b 84 24 98 a0 00 00 	mov    0xa098(%esp),%eax
 804948d:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049493:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 804949a:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 80494a1:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 80494a8:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 80494af:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 80494b6:	c7 40 18 63 72 65 61 	movl   $0x61657263,0x18(%eax)
 80494bd:	c7 40 1c 74 65 20 73 	movl   $0x73206574,0x1c(%eax)
 80494c4:	c7 40 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%eax)
 80494cb:	66 c7 40 24 74 00    	movw   $0x74,0x24(%eax)
 80494d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80494d6:	e9 47 07 00 00       	jmp    8049c22 <submitr+0x7da>
 80494db:	8b 84 24 80 a0 00 00 	mov    0xa080(%esp),%eax
 80494e2:	89 04 24             	mov    %eax,(%esp)
 80494e5:	e8 f6 f3 ff ff       	call   80488e0 <gethostbyname@plt>
 80494ea:	85 c0                	test   %eax,%eax
 80494ec:	75 6f                	jne    804955d <submitr+0x115>
 80494ee:	8b 94 24 98 a0 00 00 	mov    0xa098(%esp),%edx
 80494f5:	c7 02 45 72 72 6f    	movl   $0x6f727245,(%edx)
 80494fb:	c7 42 04 72 3a 20 44 	movl   $0x44203a72,0x4(%edx)
 8049502:	c7 42 08 4e 53 20 69 	movl   $0x6920534e,0x8(%edx)
 8049509:	c7 42 0c 73 20 75 6e 	movl   $0x6e752073,0xc(%edx)
 8049510:	c7 42 10 61 62 6c 65 	movl   $0x656c6261,0x10(%edx)
 8049517:	c7 42 14 20 74 6f 20 	movl   $0x206f7420,0x14(%edx)
 804951e:	c7 42 18 72 65 73 6f 	movl   $0x6f736572,0x18(%edx)
 8049525:	c7 42 1c 6c 76 65 20 	movl   $0x2065766c,0x1c(%edx)
 804952c:	c7 42 20 73 65 72 76 	movl   $0x76726573,0x20(%edx)
 8049533:	c7 42 24 65 72 20 61 	movl   $0x61207265,0x24(%edx)
 804953a:	c7 42 28 64 64 72 65 	movl   $0x65726464,0x28(%edx)
 8049541:	66 c7 42 2c 73 73    	movw   $0x7373,0x2c(%edx)
 8049547:	c6 42 2e 00          	movb   $0x0,0x2e(%edx)
 804954b:	89 2c 24             	mov    %ebp,(%esp)
 804954e:	e8 bd f3 ff ff       	call   8048910 <close@plt>
 8049553:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049558:	e9 c5 06 00 00       	jmp    8049c22 <submitr+0x7da>
 804955d:	8d b4 24 50 a0 00 00 	lea    0xa050(%esp),%esi
 8049564:	c7 84 24 50 a0 00 00 	movl   $0x0,0xa050(%esp)
 804956b:	00 00 00 00 
 804956f:	c7 84 24 54 a0 00 00 	movl   $0x0,0xa054(%esp)
 8049576:	00 00 00 00 
 804957a:	c7 84 24 58 a0 00 00 	movl   $0x0,0xa058(%esp)
 8049581:	00 00 00 00 
 8049585:	c7 84 24 5c a0 00 00 	movl   $0x0,0xa05c(%esp)
 804958c:	00 00 00 00 
 8049590:	66 c7 84 24 50 a0 00 	movw   $0x2,0xa050(%esp)
 8049597:	00 02 00 
 804959a:	8b 50 0c             	mov    0xc(%eax),%edx
 804959d:	89 54 24 08          	mov    %edx,0x8(%esp)
 80495a1:	8d 94 24 54 a0 00 00 	lea    0xa054(%esp),%edx
 80495a8:	89 54 24 04          	mov    %edx,0x4(%esp)
 80495ac:	8b 40 10             	mov    0x10(%eax),%eax
 80495af:	8b 00                	mov    (%eax),%eax
 80495b1:	89 04 24             	mov    %eax,(%esp)
 80495b4:	e8 47 f2 ff ff       	call   8048800 <bcopy@plt>
 80495b9:	0f b7 84 24 84 a0 00 	movzwl 0xa084(%esp),%eax
 80495c0:	00 
 80495c1:	66 c1 c8 08          	ror    $0x8,%ax
 80495c5:	66 89 84 24 52 a0 00 	mov    %ax,0xa052(%esp)
 80495cc:	00 
 80495cd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 80495d4:	00 
 80495d5:	89 74 24 04          	mov    %esi,0x4(%esp)
 80495d9:	89 2c 24             	mov    %ebp,(%esp)
 80495dc:	e8 1f f3 ff ff       	call   8048900 <connect@plt>
 80495e1:	85 c0                	test   %eax,%eax
 80495e3:	79 61                	jns    8049646 <submitr+0x1fe>
 80495e5:	8b 8c 24 98 a0 00 00 	mov    0xa098(%esp),%ecx
 80495ec:	c7 01 45 72 72 6f    	movl   $0x6f727245,(%ecx)
 80495f2:	c7 41 04 72 3a 20 55 	movl   $0x55203a72,0x4(%ecx)
 80495f9:	c7 41 08 6e 61 62 6c 	movl   $0x6c62616e,0x8(%ecx)
 8049600:	c7 41 0c 65 20 74 6f 	movl   $0x6f742065,0xc(%ecx)
 8049607:	c7 41 10 20 63 6f 6e 	movl   $0x6e6f6320,0x10(%ecx)
 804960e:	c7 41 14 6e 65 63 74 	movl   $0x7463656e,0x14(%ecx)
 8049615:	c7 41 18 20 74 6f 20 	movl   $0x206f7420,0x18(%ecx)
 804961c:	c7 41 1c 74 68 65 20 	movl   $0x20656874,0x1c(%ecx)
 8049623:	c7 41 20 73 65 72 76 	movl   $0x76726573,0x20(%ecx)
 804962a:	66 c7 41 24 65 72    	movw   $0x7265,0x24(%ecx)
 8049630:	c6 41 26 00          	movb   $0x0,0x26(%ecx)
 8049634:	89 2c 24             	mov    %ebp,(%esp)
 8049637:	e8 d4 f2 ff ff       	call   8048910 <close@plt>
 804963c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049641:	e9 dc 05 00 00       	jmp    8049c22 <submitr+0x7da>
 8049646:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 804964b:	89 df                	mov    %ebx,%edi
 804964d:	b8 00 00 00 00       	mov    $0x0,%eax
 8049652:	89 d1                	mov    %edx,%ecx
 8049654:	f2 ae                	repnz scas %es:(%edi),%al
 8049656:	89 ce                	mov    %ecx,%esi
 8049658:	f7 d6                	not    %esi
 804965a:	8b bc 24 88 a0 00 00 	mov    0xa088(%esp),%edi
 8049661:	89 d1                	mov    %edx,%ecx
 8049663:	f2 ae                	repnz scas %es:(%edi),%al
 8049665:	89 4c 24 28          	mov    %ecx,0x28(%esp)
 8049669:	8b bc 24 8c a0 00 00 	mov    0xa08c(%esp),%edi
 8049670:	89 d1                	mov    %edx,%ecx
 8049672:	f2 ae                	repnz scas %es:(%edi),%al
 8049674:	f7 d1                	not    %ecx
 8049676:	89 4c 24 2c          	mov    %ecx,0x2c(%esp)
 804967a:	8b bc 24 90 a0 00 00 	mov    0xa090(%esp),%edi
 8049681:	89 d1                	mov    %edx,%ecx
 8049683:	f2 ae                	repnz scas %es:(%edi),%al
 8049685:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 8049689:	2b 44 24 28          	sub    0x28(%esp),%eax
 804968d:	89 c2                	mov    %eax,%edx
 804968f:	29 ca                	sub    %ecx,%edx
 8049691:	8d 44 76 fd          	lea    -0x3(%esi,%esi,2),%eax
 8049695:	8d 44 02 7b          	lea    0x7b(%edx,%eax,1),%eax
 8049699:	3d 00 20 00 00       	cmp    $0x2000,%eax
 804969e:	76 7a                	jbe    804971a <submitr+0x2d2>
 80496a0:	8b 84 24 98 a0 00 00 	mov    0xa098(%esp),%eax
 80496a7:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 80496ad:	c7 40 04 72 3a 20 52 	movl   $0x52203a72,0x4(%eax)
 80496b4:	c7 40 08 65 73 75 6c 	movl   $0x6c757365,0x8(%eax)
 80496bb:	c7 40 0c 74 20 73 74 	movl   $0x74732074,0xc(%eax)
 80496c2:	c7 40 10 72 69 6e 67 	movl   $0x676e6972,0x10(%eax)
 80496c9:	c7 40 14 20 74 6f 6f 	movl   $0x6f6f7420,0x14(%eax)
 80496d0:	c7 40 18 20 6c 61 72 	movl   $0x72616c20,0x18(%eax)
 80496d7:	c7 40 1c 67 65 2e 20 	movl   $0x202e6567,0x1c(%eax)
 80496de:	c7 40 20 49 6e 63 72 	movl   $0x72636e49,0x20(%eax)
 80496e5:	c7 40 24 65 61 73 65 	movl   $0x65736165,0x24(%eax)
 80496ec:	c7 40 28 20 53 55 42 	movl   $0x42555320,0x28(%eax)
 80496f3:	c7 40 2c 4d 49 54 52 	movl   $0x5254494d,0x2c(%eax)
 80496fa:	c7 40 30 5f 4d 41 58 	movl   $0x58414d5f,0x30(%eax)
 8049701:	c7 40 34 42 55 46 00 	movl   $0x465542,0x34(%eax)
 8049708:	89 2c 24             	mov    %ebp,(%esp)
 804970b:	e8 00 f2 ff ff       	call   8048910 <close@plt>
 8049710:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049715:	e9 08 05 00 00       	jmp    8049c22 <submitr+0x7da>
 804971a:	8d 94 24 44 40 00 00 	lea    0x4044(%esp),%edx
 8049721:	b9 00 08 00 00       	mov    $0x800,%ecx
 8049726:	b8 00 00 00 00       	mov    $0x0,%eax
 804972b:	89 d7                	mov    %edx,%edi
 804972d:	f3 ab                	rep stos %eax,%es:(%edi)
 804972f:	89 df                	mov    %ebx,%edi
 8049731:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 8049736:	f2 ae                	repnz scas %es:(%edi),%al
 8049738:	f7 d1                	not    %ecx
 804973a:	89 cf                	mov    %ecx,%edi
 804973c:	83 ef 01             	sub    $0x1,%edi
 804973f:	0f 84 f3 03 00 00    	je     8049b38 <submitr+0x6f0>
 8049745:	89 d6                	mov    %edx,%esi
 8049747:	0f b6 03             	movzbl (%ebx),%eax
 804974a:	3c 2d                	cmp    $0x2d,%al
 804974c:	74 24                	je     8049772 <submitr+0x32a>
 804974e:	3c 2a                	cmp    $0x2a,%al
 8049750:	74 20                	je     8049772 <submitr+0x32a>
 8049752:	3c 2e                	cmp    $0x2e,%al
 8049754:	74 1c                	je     8049772 <submitr+0x32a>
 8049756:	3c 5f                	cmp    $0x5f,%al
 8049758:	74 18                	je     8049772 <submitr+0x32a>
 804975a:	8d 50 d0             	lea    -0x30(%eax),%edx
 804975d:	80 fa 09             	cmp    $0x9,%dl
 8049760:	76 10                	jbe    8049772 <submitr+0x32a>
 8049762:	8d 50 bf             	lea    -0x41(%eax),%edx
 8049765:	80 fa 19             	cmp    $0x19,%dl
 8049768:	76 08                	jbe    8049772 <submitr+0x32a>
 804976a:	8d 50 9f             	lea    -0x61(%eax),%edx
 804976d:	80 fa 19             	cmp    $0x19,%dl
 8049770:	77 07                	ja     8049779 <submitr+0x331>
 8049772:	88 06                	mov    %al,(%esi)
 8049774:	83 c6 01             	add    $0x1,%esi
 8049777:	eb 51                	jmp    80497ca <submitr+0x382>
 8049779:	3c 20                	cmp    $0x20,%al
 804977b:	75 08                	jne    8049785 <submitr+0x33d>
 804977d:	c6 06 2b             	movb   $0x2b,(%esi)
 8049780:	83 c6 01             	add    $0x1,%esi
 8049783:	eb 45                	jmp    80497ca <submitr+0x382>
 8049785:	8d 50 e0             	lea    -0x20(%eax),%edx
 8049788:	80 fa 5f             	cmp    $0x5f,%dl
 804978b:	76 08                	jbe    8049795 <submitr+0x34d>
 804978d:	3c 09                	cmp    $0x9,%al
 804978f:	0f 85 0d 04 00 00    	jne    8049ba2 <submitr+0x75a>
 8049795:	0f b6 c0             	movzbl %al,%eax
 8049798:	89 44 24 08          	mov    %eax,0x8(%esp)
 804979c:	c7 44 24 04 f4 a3 04 	movl   $0x804a3f4,0x4(%esp)
 80497a3:	08 
 80497a4:	8d 54 24 38          	lea    0x38(%esp),%edx
 80497a8:	89 14 24             	mov    %edx,(%esp)
 80497ab:	e8 10 f1 ff ff       	call   80488c0 <sprintf@plt>
 80497b0:	0f b6 44 24 38       	movzbl 0x38(%esp),%eax
 80497b5:	88 06                	mov    %al,(%esi)
 80497b7:	0f b6 44 24 39       	movzbl 0x39(%esp),%eax
 80497bc:	88 46 01             	mov    %al,0x1(%esi)
 80497bf:	0f b6 44 24 3a       	movzbl 0x3a(%esp),%eax
 80497c4:	88 46 02             	mov    %al,0x2(%esi)
 80497c7:	83 c6 03             	add    $0x3,%esi
 80497ca:	83 c3 01             	add    $0x1,%ebx
 80497cd:	83 ef 01             	sub    $0x1,%edi
 80497d0:	0f 85 71 ff ff ff    	jne    8049747 <submitr+0x2ff>
 80497d6:	e9 5d 03 00 00       	jmp    8049b38 <submitr+0x6f0>
 80497db:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 80497df:	89 74 24 04          	mov    %esi,0x4(%esp)
 80497e3:	89 2c 24             	mov    %ebp,(%esp)
 80497e6:	e8 95 f0 ff ff       	call   8048880 <write@plt>
 80497eb:	85 c0                	test   %eax,%eax
 80497ed:	7f 0f                	jg     80497fe <submitr+0x3b6>
 80497ef:	e8 bc f0 ff ff       	call   80488b0 <__errno_location@plt>
 80497f4:	83 38 04             	cmpl   $0x4,(%eax)
 80497f7:	75 0f                	jne    8049808 <submitr+0x3c0>
 80497f9:	b8 00 00 00 00       	mov    $0x0,%eax
 80497fe:	01 c6                	add    %eax,%esi
 8049800:	29 c3                	sub    %eax,%ebx
 8049802:	75 d7                	jne    80497db <submitr+0x393>
 8049804:	85 ff                	test   %edi,%edi
 8049806:	79 65                	jns    804986d <submitr+0x425>
 8049808:	8b 8c 24 98 a0 00 00 	mov    0xa098(%esp),%ecx
 804980f:	c7 01 45 72 72 6f    	movl   $0x6f727245,(%ecx)
 8049815:	c7 41 04 72 3a 20 43 	movl   $0x43203a72,0x4(%ecx)
 804981c:	c7 41 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%ecx)
 8049823:	c7 41 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%ecx)
 804982a:	c7 41 10 61 62 6c 65 	movl   $0x656c6261,0x10(%ecx)
 8049831:	c7 41 14 20 74 6f 20 	movl   $0x206f7420,0x14(%ecx)
 8049838:	c7 41 18 77 72 69 74 	movl   $0x74697277,0x18(%ecx)
 804983f:	c7 41 1c 65 20 74 6f 	movl   $0x6f742065,0x1c(%ecx)
 8049846:	c7 41 20 20 74 68 65 	movl   $0x65687420,0x20(%ecx)
 804984d:	c7 41 24 20 73 65 72 	movl   $0x72657320,0x24(%ecx)
 8049854:	c7 41 28 76 65 72 00 	movl   $0x726576,0x28(%ecx)
 804985b:	89 2c 24             	mov    %ebp,(%esp)
 804985e:	e8 ad f0 ff ff       	call   8048910 <close@plt>
 8049863:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049868:	e9 b5 03 00 00       	jmp    8049c22 <submitr+0x7da>
 804986d:	89 ac 24 44 80 00 00 	mov    %ebp,0x8044(%esp)
 8049874:	c7 84 24 48 80 00 00 	movl   $0x0,0x8048(%esp)
 804987b:	00 00 00 00 
 804987f:	8d 84 24 50 80 00 00 	lea    0x8050(%esp),%eax
 8049886:	89 84 24 4c 80 00 00 	mov    %eax,0x804c(%esp)
 804988d:	b9 00 20 00 00       	mov    $0x2000,%ecx
 8049892:	8d 94 24 44 60 00 00 	lea    0x6044(%esp),%edx
 8049899:	8d 84 24 44 80 00 00 	lea    0x8044(%esp),%eax
 80498a0:	e8 6b fa ff ff       	call   8049310 <rio_readlineb>
 80498a5:	85 c0                	test   %eax,%eax
 80498a7:	7f 79                	jg     8049922 <submitr+0x4da>
 80498a9:	8b 84 24 98 a0 00 00 	mov    0xa098(%esp),%eax
 80498b0:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 80498b6:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 80498bd:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 80498c4:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 80498cb:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 80498d2:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 80498d9:	c7 40 18 72 65 61 64 	movl   $0x64616572,0x18(%eax)
 80498e0:	c7 40 1c 20 66 69 72 	movl   $0x72696620,0x1c(%eax)
 80498e7:	c7 40 20 73 74 20 68 	movl   $0x68207473,0x20(%eax)
 80498ee:	c7 40 24 65 61 64 65 	movl   $0x65646165,0x24(%eax)
 80498f5:	c7 40 28 72 20 66 72 	movl   $0x72662072,0x28(%eax)
 80498fc:	c7 40 2c 6f 6d 20 73 	movl   $0x73206d6f,0x2c(%eax)
 8049903:	c7 40 30 65 72 76 65 	movl   $0x65767265,0x30(%eax)
 804990a:	66 c7 40 34 72 00    	movw   $0x72,0x34(%eax)
 8049910:	89 2c 24             	mov    %ebp,(%esp)
 8049913:	e8 f8 ef ff ff       	call   8048910 <close@plt>
 8049918:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804991d:	e9 00 03 00 00       	jmp    8049c22 <submitr+0x7da>
 8049922:	8d 44 24 40          	lea    0x40(%esp),%eax
 8049926:	89 44 24 10          	mov    %eax,0x10(%esp)
 804992a:	8d 84 24 40 20 00 00 	lea    0x2040(%esp),%eax
 8049931:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049935:	8d 84 24 44 20 00 00 	lea    0x2044(%esp),%eax
 804993c:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049940:	c7 44 24 04 fb a3 04 	movl   $0x804a3fb,0x4(%esp)
 8049947:	08 
 8049948:	8d 84 24 44 60 00 00 	lea    0x6044(%esp),%eax
 804994f:	89 04 24             	mov    %eax,(%esp)
 8049952:	e8 39 ef ff ff       	call   8048890 <__isoc99_sscanf@plt>
 8049957:	8b 84 24 40 20 00 00 	mov    0x2040(%esp),%eax
 804995e:	3d c8 00 00 00       	cmp    $0xc8,%eax
 8049963:	0f 84 c1 00 00 00    	je     8049a2a <submitr+0x5e2>
 8049969:	8d 54 24 40          	lea    0x40(%esp),%edx
 804996d:	89 54 24 0c          	mov    %edx,0xc(%esp)
 8049971:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049975:	c7 44 24 04 0c a3 04 	movl   $0x804a30c,0x4(%esp)
 804997c:	08 
 804997d:	8b 94 24 98 a0 00 00 	mov    0xa098(%esp),%edx
 8049984:	89 14 24             	mov    %edx,(%esp)
 8049987:	e8 34 ef ff ff       	call   80488c0 <sprintf@plt>
 804998c:	89 2c 24             	mov    %ebp,(%esp)
 804998f:	e8 7c ef ff ff       	call   8048910 <close@plt>
 8049994:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049999:	e9 84 02 00 00       	jmp    8049c22 <submitr+0x7da>
 804999e:	b9 00 20 00 00       	mov    $0x2000,%ecx
 80499a3:	8d 94 24 44 60 00 00 	lea    0x6044(%esp),%edx
 80499aa:	8d 84 24 44 80 00 00 	lea    0x8044(%esp),%eax
 80499b1:	e8 5a f9 ff ff       	call   8049310 <rio_readlineb>
 80499b6:	85 c0                	test   %eax,%eax
 80499b8:	7f 70                	jg     8049a2a <submitr+0x5e2>
 80499ba:	8b 8c 24 98 a0 00 00 	mov    0xa098(%esp),%ecx
 80499c1:	c7 01 45 72 72 6f    	movl   $0x6f727245,(%ecx)
 80499c7:	c7 41 04 72 3a 20 43 	movl   $0x43203a72,0x4(%ecx)
 80499ce:	c7 41 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%ecx)
 80499d5:	c7 41 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%ecx)
 80499dc:	c7 41 10 61 62 6c 65 	movl   $0x656c6261,0x10(%ecx)
 80499e3:	c7 41 14 20 74 6f 20 	movl   $0x206f7420,0x14(%ecx)
 80499ea:	c7 41 18 72 65 61 64 	movl   $0x64616572,0x18(%ecx)
 80499f1:	c7 41 1c 20 68 65 61 	movl   $0x61656820,0x1c(%ecx)
 80499f8:	c7 41 20 64 65 72 73 	movl   $0x73726564,0x20(%ecx)
 80499ff:	c7 41 24 20 66 72 6f 	movl   $0x6f726620,0x24(%ecx)
 8049a06:	c7 41 28 6d 20 73 65 	movl   $0x6573206d,0x28(%ecx)
 8049a0d:	c7 41 2c 72 76 65 72 	movl   $0x72657672,0x2c(%ecx)
 8049a14:	c6 41 30 00          	movb   $0x0,0x30(%ecx)
 8049a18:	89 2c 24             	mov    %ebp,(%esp)
 8049a1b:	e8 f0 ee ff ff       	call   8048910 <close@plt>
 8049a20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049a25:	e9 f8 01 00 00       	jmp    8049c22 <submitr+0x7da>
 8049a2a:	80 bc 24 44 60 00 00 	cmpb   $0xd,0x6044(%esp)
 8049a31:	0d 
 8049a32:	0f 85 66 ff ff ff    	jne    804999e <submitr+0x556>
 8049a38:	80 bc 24 45 60 00 00 	cmpb   $0xa,0x6045(%esp)
 8049a3f:	0a 
 8049a40:	0f 85 58 ff ff ff    	jne    804999e <submitr+0x556>
 8049a46:	80 bc 24 46 60 00 00 	cmpb   $0x0,0x6046(%esp)
 8049a4d:	00 
 8049a4e:	0f 85 4a ff ff ff    	jne    804999e <submitr+0x556>
 8049a54:	b9 00 20 00 00       	mov    $0x2000,%ecx
 8049a59:	8d 94 24 44 60 00 00 	lea    0x6044(%esp),%edx
 8049a60:	8d 84 24 44 80 00 00 	lea    0x8044(%esp),%eax
 8049a67:	e8 a4 f8 ff ff       	call   8049310 <rio_readlineb>
 8049a6c:	85 c0                	test   %eax,%eax
 8049a6e:	7f 7a                	jg     8049aea <submitr+0x6a2>
 8049a70:	8b 84 24 98 a0 00 00 	mov    0xa098(%esp),%eax
 8049a77:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049a7d:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049a84:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049a8b:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049a92:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049a99:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049aa0:	c7 40 18 72 65 61 64 	movl   $0x64616572,0x18(%eax)
 8049aa7:	c7 40 1c 20 73 74 61 	movl   $0x61747320,0x1c(%eax)
 8049aae:	c7 40 20 74 75 73 20 	movl   $0x20737574,0x20(%eax)
 8049ab5:	c7 40 24 6d 65 73 73 	movl   $0x7373656d,0x24(%eax)
 8049abc:	c7 40 28 61 67 65 20 	movl   $0x20656761,0x28(%eax)
 8049ac3:	c7 40 2c 66 72 6f 6d 	movl   $0x6d6f7266,0x2c(%eax)
 8049aca:	c7 40 30 20 73 65 72 	movl   $0x72657320,0x30(%eax)
 8049ad1:	c7 40 34 76 65 72 00 	movl   $0x726576,0x34(%eax)
 8049ad8:	89 2c 24             	mov    %ebp,(%esp)
 8049adb:	e8 30 ee ff ff       	call   8048910 <close@plt>
 8049ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049ae5:	e9 38 01 00 00       	jmp    8049c22 <submitr+0x7da>
 8049aea:	8d 84 24 44 60 00 00 	lea    0x6044(%esp),%eax
 8049af1:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049af5:	8b 94 24 98 a0 00 00 	mov    0xa098(%esp),%edx
 8049afc:	89 14 24             	mov    %edx,(%esp)
 8049aff:	e8 0c ed ff ff       	call   8048810 <strcpy@plt>
 8049b04:	89 2c 24             	mov    %ebp,(%esp)
 8049b07:	e8 04 ee ff ff       	call   8048910 <close@plt>
 8049b0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049b11:	8b 8c 24 98 a0 00 00 	mov    0xa098(%esp),%ecx
 8049b18:	80 39 4f             	cmpb   $0x4f,(%ecx)
 8049b1b:	0f 85 01 01 00 00    	jne    8049c22 <submitr+0x7da>
 8049b21:	80 79 01 4b          	cmpb   $0x4b,0x1(%ecx)
 8049b25:	0f 85 f7 00 00 00    	jne    8049c22 <submitr+0x7da>
 8049b2b:	80 79 02 01          	cmpb   $0x1,0x2(%ecx)
 8049b2f:	19 c0                	sbb    %eax,%eax
 8049b31:	f7 d0                	not    %eax
 8049b33:	e9 ea 00 00 00       	jmp    8049c22 <submitr+0x7da>
 8049b38:	8d 84 24 44 40 00 00 	lea    0x4044(%esp),%eax
 8049b3f:	89 44 24 14          	mov    %eax,0x14(%esp)
 8049b43:	8b 84 24 90 a0 00 00 	mov    0xa090(%esp),%eax
 8049b4a:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049b4e:	8b 94 24 8c a0 00 00 	mov    0xa08c(%esp),%edx
 8049b55:	89 54 24 0c          	mov    %edx,0xc(%esp)
 8049b59:	8b 8c 24 88 a0 00 00 	mov    0xa088(%esp),%ecx
 8049b60:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 8049b64:	c7 44 24 04 3c a3 04 	movl   $0x804a33c,0x4(%esp)
 8049b6b:	08 
 8049b6c:	8d bc 24 44 60 00 00 	lea    0x6044(%esp),%edi
 8049b73:	89 3c 24             	mov    %edi,(%esp)
 8049b76:	e8 45 ed ff ff       	call   80488c0 <sprintf@plt>
 8049b7b:	b8 00 00 00 00       	mov    $0x0,%eax
 8049b80:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 8049b85:	f2 ae                	repnz scas %es:(%edi),%al
 8049b87:	f7 d1                	not    %ecx
 8049b89:	8d 79 ff             	lea    -0x1(%ecx),%edi
 8049b8c:	89 fb                	mov    %edi,%ebx
 8049b8e:	8d b4 24 44 60 00 00 	lea    0x6044(%esp),%esi
 8049b95:	85 ff                	test   %edi,%edi
 8049b97:	0f 85 3e fc ff ff    	jne    80497db <submitr+0x393>
 8049b9d:	e9 cb fc ff ff       	jmp    804986d <submitr+0x425>
 8049ba2:	8b bc 24 98 a0 00 00 	mov    0xa098(%esp),%edi
 8049ba9:	be 88 a3 04 08       	mov    $0x804a388,%esi
 8049bae:	b8 43 00 00 00       	mov    $0x43,%eax
 8049bb3:	f7 c7 01 00 00 00    	test   $0x1,%edi
 8049bb9:	74 1d                	je     8049bd8 <submitr+0x790>
 8049bbb:	0f b6 05 88 a3 04 08 	movzbl 0x804a388,%eax
 8049bc2:	88 07                	mov    %al,(%edi)
 8049bc4:	8b bc 24 98 a0 00 00 	mov    0xa098(%esp),%edi
 8049bcb:	83 c7 01             	add    $0x1,%edi
 8049bce:	be 89 a3 04 08       	mov    $0x804a389,%esi
 8049bd3:	b8 42 00 00 00       	mov    $0x42,%eax
 8049bd8:	f7 c7 02 00 00 00    	test   $0x2,%edi
 8049bde:	74 0f                	je     8049bef <submitr+0x7a7>
 8049be0:	0f b7 16             	movzwl (%esi),%edx
 8049be3:	66 89 17             	mov    %dx,(%edi)
 8049be6:	83 c7 02             	add    $0x2,%edi
 8049be9:	83 c6 02             	add    $0x2,%esi
 8049bec:	83 e8 02             	sub    $0x2,%eax
 8049bef:	89 c1                	mov    %eax,%ecx
 8049bf1:	c1 e9 02             	shr    $0x2,%ecx
 8049bf4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
 8049bf6:	ba 00 00 00 00       	mov    $0x0,%edx
 8049bfb:	a8 02                	test   $0x2,%al
 8049bfd:	74 0b                	je     8049c0a <submitr+0x7c2>
 8049bff:	0f b7 16             	movzwl (%esi),%edx
 8049c02:	66 89 17             	mov    %dx,(%edi)
 8049c05:	ba 02 00 00 00       	mov    $0x2,%edx
 8049c0a:	a8 01                	test   $0x1,%al
 8049c0c:	74 07                	je     8049c15 <submitr+0x7cd>
 8049c0e:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
 8049c12:	88 04 17             	mov    %al,(%edi,%edx,1)
 8049c15:	89 2c 24             	mov    %ebp,(%esp)
 8049c18:	e8 f3 ec ff ff       	call   8048910 <close@plt>
 8049c1d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049c22:	81 c4 6c a0 00 00    	add    $0xa06c,%esp
 8049c28:	5b                   	pop    %ebx
 8049c29:	5e                   	pop    %esi
 8049c2a:	5f                   	pop    %edi
 8049c2b:	5d                   	pop    %ebp
 8049c2c:	c3                   	ret    

08049c2d <init_timeout>:
 8049c2d:	53                   	push   %ebx
 8049c2e:	83 ec 18             	sub    $0x18,%esp
 8049c31:	8b 5c 24 20          	mov    0x20(%esp),%ebx
 8049c35:	85 db                	test   %ebx,%ebx
 8049c37:	74 25                	je     8049c5e <init_timeout+0x31>
 8049c39:	c7 44 24 04 1c 94 04 	movl   $0x804941c,0x4(%esp)
 8049c40:	08 
 8049c41:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 8049c48:	e8 83 eb ff ff       	call   80487d0 <signal@plt>
 8049c4d:	89 d8                	mov    %ebx,%eax
 8049c4f:	c1 f8 1f             	sar    $0x1f,%eax
 8049c52:	f7 d0                	not    %eax
 8049c54:	21 c3                	and    %eax,%ebx
 8049c56:	89 1c 24             	mov    %ebx,(%esp)
 8049c59:	e8 92 eb ff ff       	call   80487f0 <alarm@plt>
 8049c5e:	83 c4 18             	add    $0x18,%esp
 8049c61:	5b                   	pop    %ebx
 8049c62:	c3                   	ret    

08049c63 <init_driver>:
 8049c63:	57                   	push   %edi
 8049c64:	56                   	push   %esi
 8049c65:	53                   	push   %ebx
 8049c66:	83 ec 20             	sub    $0x20,%esp
 8049c69:	8b 74 24 30          	mov    0x30(%esp),%esi
 8049c6d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049c74:	00 
 8049c75:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
 8049c7c:	e8 4f eb ff ff       	call   80487d0 <signal@plt>
 8049c81:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049c88:	00 
 8049c89:	c7 04 24 1d 00 00 00 	movl   $0x1d,(%esp)
 8049c90:	e8 3b eb ff ff       	call   80487d0 <signal@plt>
 8049c95:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049c9c:	00 
 8049c9d:	c7 04 24 1d 00 00 00 	movl   $0x1d,(%esp)
 8049ca4:	e8 27 eb ff ff       	call   80487d0 <signal@plt>
 8049ca9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 8049cb0:	00 
 8049cb1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049cb8:	00 
 8049cb9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 8049cc0:	e8 0b ec ff ff       	call   80488d0 <socket@plt>
 8049cc5:	89 c3                	mov    %eax,%ebx
 8049cc7:	85 c0                	test   %eax,%eax
 8049cc9:	79 4e                	jns    8049d19 <init_driver+0xb6>
 8049ccb:	c7 06 45 72 72 6f    	movl   $0x6f727245,(%esi)
 8049cd1:	c7 46 04 72 3a 20 43 	movl   $0x43203a72,0x4(%esi)
 8049cd8:	c7 46 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%esi)
 8049cdf:	c7 46 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%esi)
 8049ce6:	c7 46 10 61 62 6c 65 	movl   $0x656c6261,0x10(%esi)
 8049ced:	c7 46 14 20 74 6f 20 	movl   $0x206f7420,0x14(%esi)
 8049cf4:	c7 46 18 63 72 65 61 	movl   $0x61657263,0x18(%esi)
 8049cfb:	c7 46 1c 74 65 20 73 	movl   $0x73206574,0x1c(%esi)
 8049d02:	c7 46 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%esi)
 8049d09:	66 c7 46 24 74 00    	movw   $0x74,0x24(%esi)
 8049d0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049d14:	e9 1b 01 00 00       	jmp    8049e34 <init_driver+0x1d1>
 8049d19:	c7 04 24 0c a4 04 08 	movl   $0x804a40c,(%esp)
 8049d20:	e8 bb eb ff ff       	call   80488e0 <gethostbyname@plt>
 8049d25:	85 c0                	test   %eax,%eax
 8049d27:	75 68                	jne    8049d91 <init_driver+0x12e>
 8049d29:	c7 06 45 72 72 6f    	movl   $0x6f727245,(%esi)
 8049d2f:	c7 46 04 72 3a 20 44 	movl   $0x44203a72,0x4(%esi)
 8049d36:	c7 46 08 4e 53 20 69 	movl   $0x6920534e,0x8(%esi)
 8049d3d:	c7 46 0c 73 20 75 6e 	movl   $0x6e752073,0xc(%esi)
 8049d44:	c7 46 10 61 62 6c 65 	movl   $0x656c6261,0x10(%esi)
 8049d4b:	c7 46 14 20 74 6f 20 	movl   $0x206f7420,0x14(%esi)
 8049d52:	c7 46 18 72 65 73 6f 	movl   $0x6f736572,0x18(%esi)
 8049d59:	c7 46 1c 6c 76 65 20 	movl   $0x2065766c,0x1c(%esi)
 8049d60:	c7 46 20 73 65 72 76 	movl   $0x76726573,0x20(%esi)
 8049d67:	c7 46 24 65 72 20 61 	movl   $0x61207265,0x24(%esi)
 8049d6e:	c7 46 28 64 64 72 65 	movl   $0x65726464,0x28(%esi)
 8049d75:	66 c7 46 2c 73 73    	movw   $0x7373,0x2c(%esi)
 8049d7b:	c6 46 2e 00          	movb   $0x0,0x2e(%esi)
 8049d7f:	89 1c 24             	mov    %ebx,(%esp)
 8049d82:	e8 89 eb ff ff       	call   8048910 <close@plt>
 8049d87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049d8c:	e9 a3 00 00 00       	jmp    8049e34 <init_driver+0x1d1>
 8049d91:	8d 7c 24 10          	lea    0x10(%esp),%edi
 8049d95:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
 8049d9c:	00 
 8049d9d:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
 8049da4:	00 
 8049da5:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
 8049dac:	00 
 8049dad:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 8049db4:	00 
 8049db5:	66 c7 44 24 10 02 00 	movw   $0x2,0x10(%esp)
 8049dbc:	8b 50 0c             	mov    0xc(%eax),%edx
 8049dbf:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049dc3:	8d 54 24 14          	lea    0x14(%esp),%edx
 8049dc7:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049dcb:	8b 40 10             	mov    0x10(%eax),%eax
 8049dce:	8b 00                	mov    (%eax),%eax
 8049dd0:	89 04 24             	mov    %eax,(%esp)
 8049dd3:	e8 28 ea ff ff       	call   8048800 <bcopy@plt>
 8049dd8:	66 c7 44 24 12 3b 6e 	movw   $0x6e3b,0x12(%esp)
 8049ddf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8049de6:	00 
 8049de7:	89 7c 24 04          	mov    %edi,0x4(%esp)
 8049deb:	89 1c 24             	mov    %ebx,(%esp)
 8049dee:	e8 0d eb ff ff       	call   8048900 <connect@plt>
 8049df3:	85 c0                	test   %eax,%eax
 8049df5:	79 27                	jns    8049e1e <init_driver+0x1bb>
 8049df7:	c7 44 24 08 0c a4 04 	movl   $0x804a40c,0x8(%esp)
 8049dfe:	08 
 8049dff:	c7 44 24 04 cc a3 04 	movl   $0x804a3cc,0x4(%esp)
 8049e06:	08 
 8049e07:	89 34 24             	mov    %esi,(%esp)
 8049e0a:	e8 b1 ea ff ff       	call   80488c0 <sprintf@plt>
 8049e0f:	89 1c 24             	mov    %ebx,(%esp)
 8049e12:	e8 f9 ea ff ff       	call   8048910 <close@plt>
 8049e17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049e1c:	eb 16                	jmp    8049e34 <init_driver+0x1d1>
 8049e1e:	89 1c 24             	mov    %ebx,(%esp)
 8049e21:	e8 ea ea ff ff       	call   8048910 <close@plt>
 8049e26:	66 c7 06 4f 4b       	movw   $0x4b4f,(%esi)
 8049e2b:	c6 46 02 00          	movb   $0x0,0x2(%esi)
 8049e2f:	b8 00 00 00 00       	mov    $0x0,%eax
 8049e34:	83 c4 20             	add    $0x20,%esp
 8049e37:	5b                   	pop    %ebx
 8049e38:	5e                   	pop    %esi
 8049e39:	5f                   	pop    %edi
 8049e3a:	c3                   	ret    

08049e3b <driver_post>:
 8049e3b:	53                   	push   %ebx
 8049e3c:	83 ec 28             	sub    $0x28,%esp
 8049e3f:	8b 44 24 30          	mov    0x30(%esp),%eax
 8049e43:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
 8049e47:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
 8049e4c:	74 24                	je     8049e72 <driver_post+0x37>
 8049e4e:	8b 44 24 34          	mov    0x34(%esp),%eax
 8049e52:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049e56:	c7 04 24 1a a4 04 08 	movl   $0x804a41a,(%esp)
 8049e5d:	e8 2e e9 ff ff       	call   8048790 <printf@plt>
 8049e62:	66 c7 03 4f 4b       	movw   $0x4b4f,(%ebx)
 8049e67:	c6 43 02 00          	movb   $0x0,0x2(%ebx)
 8049e6b:	b8 00 00 00 00       	mov    $0x0,%eax
 8049e70:	eb 4d                	jmp    8049ebf <driver_post+0x84>
 8049e72:	85 c0                	test   %eax,%eax
 8049e74:	74 3b                	je     8049eb1 <driver_post+0x76>
 8049e76:	80 38 00             	cmpb   $0x0,(%eax)
 8049e79:	74 36                	je     8049eb1 <driver_post+0x76>
 8049e7b:	89 5c 24 18          	mov    %ebx,0x18(%esp)
 8049e7f:	8b 54 24 34          	mov    0x34(%esp),%edx
 8049e83:	89 54 24 14          	mov    %edx,0x14(%esp)
 8049e87:	c7 44 24 10 31 a4 04 	movl   $0x804a431,0x10(%esp)
 8049e8e:	08 
 8049e8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049e93:	c7 44 24 08 39 a4 04 	movl   $0x804a439,0x8(%esp)
 8049e9a:	08 
 8049e9b:	c7 44 24 04 6e 3b 00 	movl   $0x3b6e,0x4(%esp)
 8049ea2:	00 
 8049ea3:	c7 04 24 0c a4 04 08 	movl   $0x804a40c,(%esp)
 8049eaa:	e8 99 f5 ff ff       	call   8049448 <submitr>
 8049eaf:	eb 0e                	jmp    8049ebf <driver_post+0x84>
 8049eb1:	66 c7 03 4f 4b       	movw   $0x4b4f,(%ebx)
 8049eb6:	c6 43 02 00          	movb   $0x0,0x2(%ebx)
 8049eba:	b8 00 00 00 00       	mov    $0x0,%eax
 8049ebf:	83 c4 28             	add    $0x28,%esp
 8049ec2:	5b                   	pop    %ebx
 8049ec3:	c3                   	ret    
 8049ec4:	90                   	nop
 8049ec5:	90                   	nop
 8049ec6:	90                   	nop
 8049ec7:	90                   	nop
 8049ec8:	90                   	nop
 8049ec9:	90                   	nop
 8049eca:	90                   	nop
 8049ecb:	90                   	nop
 8049ecc:	90                   	nop
 8049ecd:	90                   	nop
 8049ece:	90                   	nop
 8049ecf:	90                   	nop

08049ed0 <__libc_csu_fini>:
 8049ed0:	55                   	push   %ebp
 8049ed1:	89 e5                	mov    %esp,%ebp
 8049ed3:	5d                   	pop    %ebp
 8049ed4:	c3                   	ret    
 8049ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8049ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

08049ee0 <__libc_csu_init>:
 8049ee0:	55                   	push   %ebp
 8049ee1:	89 e5                	mov    %esp,%ebp
 8049ee3:	57                   	push   %edi
 8049ee4:	56                   	push   %esi
 8049ee5:	53                   	push   %ebx
 8049ee6:	e8 4f 00 00 00       	call   8049f3a <__i686.get_pc_thunk.bx>
 8049eeb:	81 c3 15 12 00 00    	add    $0x1215,%ebx
 8049ef1:	83 ec 1c             	sub    $0x1c,%esp
 8049ef4:	e8 4f e8 ff ff       	call   8048748 <_init>
 8049ef9:	8d bb 04 ff ff ff    	lea    -0xfc(%ebx),%edi
 8049eff:	8d 83 00 ff ff ff    	lea    -0x100(%ebx),%eax
 8049f05:	29 c7                	sub    %eax,%edi
 8049f07:	c1 ff 02             	sar    $0x2,%edi
 8049f0a:	85 ff                	test   %edi,%edi
 8049f0c:	74 24                	je     8049f32 <__libc_csu_init+0x52>
 8049f0e:	31 f6                	xor    %esi,%esi
 8049f10:	8b 45 10             	mov    0x10(%ebp),%eax
 8049f13:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049f17:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049f1a:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049f1e:	8b 45 08             	mov    0x8(%ebp),%eax
 8049f21:	89 04 24             	mov    %eax,(%esp)
 8049f24:	ff 94 b3 00 ff ff ff 	call   *-0x100(%ebx,%esi,4)
 8049f2b:	83 c6 01             	add    $0x1,%esi
 8049f2e:	39 fe                	cmp    %edi,%esi
 8049f30:	72 de                	jb     8049f10 <__libc_csu_init+0x30>
 8049f32:	83 c4 1c             	add    $0x1c,%esp
 8049f35:	5b                   	pop    %ebx
 8049f36:	5e                   	pop    %esi
 8049f37:	5f                   	pop    %edi
 8049f38:	5d                   	pop    %ebp
 8049f39:	c3                   	ret    

08049f3a <__i686.get_pc_thunk.bx>:
 8049f3a:	8b 1c 24             	mov    (%esp),%ebx
 8049f3d:	c3                   	ret    
 8049f3e:	90                   	nop
 8049f3f:	90                   	nop

Disassembly of section .fini:

08049f40 <_fini>:
 8049f40:	55                   	push   %ebp
 8049f41:	89 e5                	mov    %esp,%ebp
 8049f43:	53                   	push   %ebx
 8049f44:	83 ec 04             	sub    $0x4,%esp
 8049f47:	e8 00 00 00 00       	call   8049f4c <_fini+0xc>
 8049f4c:	5b                   	pop    %ebx
 8049f4d:	81 c3 b4 11 00 00    	add    $0x11b4,%ebx
 8049f53:	59                   	pop    %ecx
 8049f54:	5b                   	pop    %ebx
 8049f55:	c9                   	leave  
 8049f56:	c3                   	ret    
 ```
