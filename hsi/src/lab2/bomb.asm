
bomb：     文件格式 elf32-i386


Disassembly of section .init:

08048724 <_init>:
 8048724:	53                   	push   %ebx
 8048725:	83 ec 08             	sub    $0x8,%esp
 8048728:	e8 23 02 00 00       	call   8048950 <__x86.get_pc_thunk.bx>
 804872d:	81 c3 d3 38 00 00    	add    $0x38d3,%ebx
 8048733:	8b 83 fc ff ff ff    	mov    -0x4(%ebx),%eax
 8048739:	85 c0                	test   %eax,%eax
 804873b:	74 05                	je     8048742 <_init+0x1e>
 804873d:	e8 de 00 00 00       	call   8048820 <__gmon_start__@plt>
 8048742:	83 c4 08             	add    $0x8,%esp
 8048745:	5b                   	pop    %ebx
 8048746:	c3                   	ret    

Disassembly of section .plt:

08048750 <read@plt-0x10>:
 8048750:	ff 35 04 c0 04 08    	pushl  0x804c004
 8048756:	ff 25 08 c0 04 08    	jmp    *0x804c008
 804875c:	00 00                	add    %al,(%eax)
	...

08048760 <read@plt>:
 8048760:	ff 25 0c c0 04 08    	jmp    *0x804c00c
 8048766:	68 00 00 00 00       	push   $0x0
 804876b:	e9 e0 ff ff ff       	jmp    8048750 <_init+0x2c>

08048770 <fflush@plt>:
 8048770:	ff 25 10 c0 04 08    	jmp    *0x804c010
 8048776:	68 08 00 00 00       	push   $0x8
 804877b:	e9 d0 ff ff ff       	jmp    8048750 <_init+0x2c>

08048780 <fgets@plt>:
 8048780:	ff 25 14 c0 04 08    	jmp    *0x804c014
 8048786:	68 10 00 00 00       	push   $0x10
 804878b:	e9 c0 ff ff ff       	jmp    8048750 <_init+0x2c>

08048790 <signal@plt>:
 8048790:	ff 25 18 c0 04 08    	jmp    *0x804c018
 8048796:	68 18 00 00 00       	push   $0x18
 804879b:	e9 b0 ff ff ff       	jmp    8048750 <_init+0x2c>

080487a0 <sleep@plt>:
 80487a0:	ff 25 1c c0 04 08    	jmp    *0x804c01c
 80487a6:	68 20 00 00 00       	push   $0x20
 80487ab:	e9 a0 ff ff ff       	jmp    8048750 <_init+0x2c>

080487b0 <alarm@plt>:
 80487b0:	ff 25 20 c0 04 08    	jmp    *0x804c020
 80487b6:	68 28 00 00 00       	push   $0x28
 80487bb:	e9 90 ff ff ff       	jmp    8048750 <_init+0x2c>

080487c0 <__stack_chk_fail@plt>:
 80487c0:	ff 25 24 c0 04 08    	jmp    *0x804c024
 80487c6:	68 30 00 00 00       	push   $0x30
 80487cb:	e9 80 ff ff ff       	jmp    8048750 <_init+0x2c>

080487d0 <strcpy@plt>:
 80487d0:	ff 25 28 c0 04 08    	jmp    *0x804c028
 80487d6:	68 38 00 00 00       	push   $0x38
 80487db:	e9 70 ff ff ff       	jmp    8048750 <_init+0x2c>

080487e0 <getenv@plt>:
 80487e0:	ff 25 2c c0 04 08    	jmp    *0x804c02c
 80487e6:	68 40 00 00 00       	push   $0x40
 80487eb:	e9 60 ff ff ff       	jmp    8048750 <_init+0x2c>

080487f0 <puts@plt>:
 80487f0:	ff 25 30 c0 04 08    	jmp    *0x804c030
 80487f6:	68 48 00 00 00       	push   $0x48
 80487fb:	e9 50 ff ff ff       	jmp    8048750 <_init+0x2c>

08048800 <__memmove_chk@plt>:
 8048800:	ff 25 34 c0 04 08    	jmp    *0x804c034
 8048806:	68 50 00 00 00       	push   $0x50
 804880b:	e9 40 ff ff ff       	jmp    8048750 <_init+0x2c>

08048810 <__memcpy_chk@plt>:
 8048810:	ff 25 38 c0 04 08    	jmp    *0x804c038
 8048816:	68 58 00 00 00       	push   $0x58
 804881b:	e9 30 ff ff ff       	jmp    8048750 <_init+0x2c>

08048820 <__gmon_start__@plt>:
 8048820:	ff 25 3c c0 04 08    	jmp    *0x804c03c
 8048826:	68 60 00 00 00       	push   $0x60
 804882b:	e9 20 ff ff ff       	jmp    8048750 <_init+0x2c>

08048830 <exit@plt>:
 8048830:	ff 25 40 c0 04 08    	jmp    *0x804c040
 8048836:	68 68 00 00 00       	push   $0x68
 804883b:	e9 10 ff ff ff       	jmp    8048750 <_init+0x2c>

08048840 <__libc_start_main@plt>:
 8048840:	ff 25 44 c0 04 08    	jmp    *0x804c044
 8048846:	68 70 00 00 00       	push   $0x70
 804884b:	e9 00 ff ff ff       	jmp    8048750 <_init+0x2c>

08048850 <write@plt>:
 8048850:	ff 25 48 c0 04 08    	jmp    *0x804c048
 8048856:	68 78 00 00 00       	push   $0x78
 804885b:	e9 f0 fe ff ff       	jmp    8048750 <_init+0x2c>

08048860 <__isoc99_sscanf@plt>:
 8048860:	ff 25 4c c0 04 08    	jmp    *0x804c04c
 8048866:	68 80 00 00 00       	push   $0x80
 804886b:	e9 e0 fe ff ff       	jmp    8048750 <_init+0x2c>

08048870 <fopen@plt>:
 8048870:	ff 25 50 c0 04 08    	jmp    *0x804c050
 8048876:	68 88 00 00 00       	push   $0x88
 804887b:	e9 d0 fe ff ff       	jmp    8048750 <_init+0x2c>

08048880 <__errno_location@plt>:
 8048880:	ff 25 54 c0 04 08    	jmp    *0x804c054
 8048886:	68 90 00 00 00       	push   $0x90
 804888b:	e9 c0 fe ff ff       	jmp    8048750 <_init+0x2c>

08048890 <__printf_chk@plt>:
 8048890:	ff 25 58 c0 04 08    	jmp    *0x804c058
 8048896:	68 98 00 00 00       	push   $0x98
 804889b:	e9 b0 fe ff ff       	jmp    8048750 <_init+0x2c>

080488a0 <socket@plt>:
 80488a0:	ff 25 5c c0 04 08    	jmp    *0x804c05c
 80488a6:	68 a0 00 00 00       	push   $0xa0
 80488ab:	e9 a0 fe ff ff       	jmp    8048750 <_init+0x2c>

080488b0 <__fprintf_chk@plt>:
 80488b0:	ff 25 60 c0 04 08    	jmp    *0x804c060
 80488b6:	68 a8 00 00 00       	push   $0xa8
 80488bb:	e9 90 fe ff ff       	jmp    8048750 <_init+0x2c>

080488c0 <gethostbyname@plt>:
 80488c0:	ff 25 64 c0 04 08    	jmp    *0x804c064
 80488c6:	68 b0 00 00 00       	push   $0xb0
 80488cb:	e9 80 fe ff ff       	jmp    8048750 <_init+0x2c>

080488d0 <strtol@plt>:
 80488d0:	ff 25 68 c0 04 08    	jmp    *0x804c068
 80488d6:	68 b8 00 00 00       	push   $0xb8
 80488db:	e9 70 fe ff ff       	jmp    8048750 <_init+0x2c>

080488e0 <connect@plt>:
 80488e0:	ff 25 6c c0 04 08    	jmp    *0x804c06c
 80488e6:	68 c0 00 00 00       	push   $0xc0
 80488eb:	e9 60 fe ff ff       	jmp    8048750 <_init+0x2c>

080488f0 <close@plt>:
 80488f0:	ff 25 70 c0 04 08    	jmp    *0x804c070
 80488f6:	68 c8 00 00 00       	push   $0xc8
 80488fb:	e9 50 fe ff ff       	jmp    8048750 <_init+0x2c>

08048900 <__ctype_b_loc@plt>:
 8048900:	ff 25 74 c0 04 08    	jmp    *0x804c074
 8048906:	68 d0 00 00 00       	push   $0xd0
 804890b:	e9 40 fe ff ff       	jmp    8048750 <_init+0x2c>

08048910 <__sprintf_chk@plt>:
 8048910:	ff 25 78 c0 04 08    	jmp    *0x804c078
 8048916:	68 d8 00 00 00       	push   $0xd8
 804891b:	e9 30 fe ff ff       	jmp    8048750 <_init+0x2c>

Disassembly of section .text:

08048920 <_start>:
 8048920:	31 ed                	xor    %ebp,%ebp
 8048922:	5e                   	pop    %esi
 8048923:	89 e1                	mov    %esp,%ecx
 8048925:	83 e4 f0             	and    $0xfffffff0,%esp
 8048928:	50                   	push   %eax
 8048929:	54                   	push   %esp
 804892a:	52                   	push   %edx
 804892b:	68 60 a0 04 08       	push   $0x804a060
 8048930:	68 f0 9f 04 08       	push   $0x8049ff0
 8048935:	51                   	push   %ecx
 8048936:	56                   	push   %esi
 8048937:	68 1d 8a 04 08       	push   $0x8048a1d
 804893c:	e8 ff fe ff ff       	call   8048840 <__libc_start_main@plt>
 8048941:	f4                   	hlt    
 8048942:	66 90                	xchg   %ax,%ax
 8048944:	66 90                	xchg   %ax,%ax
 8048946:	66 90                	xchg   %ax,%ax
 8048948:	66 90                	xchg   %ax,%ax
 804894a:	66 90                	xchg   %ax,%ax
 804894c:	66 90                	xchg   %ax,%ax
 804894e:	66 90                	xchg   %ax,%ax

08048950 <__x86.get_pc_thunk.bx>:
 8048950:	8b 1c 24             	mov    (%esp),%ebx
 8048953:	c3                   	ret    
 8048954:	66 90                	xchg   %ax,%ax
 8048956:	66 90                	xchg   %ax,%ax
 8048958:	66 90                	xchg   %ax,%ax
 804895a:	66 90                	xchg   %ax,%ax
 804895c:	66 90                	xchg   %ax,%ax
 804895e:	66 90                	xchg   %ax,%ax

08048960 <deregister_tm_clones>:
 8048960:	b8 a3 c3 04 08       	mov    $0x804c3a3,%eax
 8048965:	2d a0 c3 04 08       	sub    $0x804c3a0,%eax
 804896a:	83 f8 06             	cmp    $0x6,%eax
 804896d:	77 01                	ja     8048970 <deregister_tm_clones+0x10>
 804896f:	c3                   	ret    
 8048970:	b8 00 00 00 00       	mov    $0x0,%eax
 8048975:	85 c0                	test   %eax,%eax
 8048977:	74 f6                	je     804896f <deregister_tm_clones+0xf>
 8048979:	55                   	push   %ebp
 804897a:	89 e5                	mov    %esp,%ebp
 804897c:	83 ec 18             	sub    $0x18,%esp
 804897f:	c7 04 24 a0 c3 04 08 	movl   $0x804c3a0,(%esp)
 8048986:	ff d0                	call   *%eax
 8048988:	c9                   	leave  
 8048989:	c3                   	ret    
 804898a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

08048990 <register_tm_clones>:
 8048990:	b8 a0 c3 04 08       	mov    $0x804c3a0,%eax
 8048995:	2d a0 c3 04 08       	sub    $0x804c3a0,%eax
 804899a:	c1 f8 02             	sar    $0x2,%eax
 804899d:	89 c2                	mov    %eax,%edx
 804899f:	c1 ea 1f             	shr    $0x1f,%edx
 80489a2:	01 d0                	add    %edx,%eax
 80489a4:	d1 f8                	sar    %eax
 80489a6:	75 01                	jne    80489a9 <register_tm_clones+0x19>
 80489a8:	c3                   	ret    
 80489a9:	ba 00 00 00 00       	mov    $0x0,%edx
 80489ae:	85 d2                	test   %edx,%edx
 80489b0:	74 f6                	je     80489a8 <register_tm_clones+0x18>
 80489b2:	55                   	push   %ebp
 80489b3:	89 e5                	mov    %esp,%ebp
 80489b5:	83 ec 18             	sub    $0x18,%esp
 80489b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 80489bc:	c7 04 24 a0 c3 04 08 	movl   $0x804c3a0,(%esp)
 80489c3:	ff d2                	call   *%edx
 80489c5:	c9                   	leave  
 80489c6:	c3                   	ret    
 80489c7:	89 f6                	mov    %esi,%esi
 80489c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

080489d0 <__do_global_dtors_aux>:
 80489d0:	80 3d c4 c3 04 08 00 	cmpb   $0x0,0x804c3c4
 80489d7:	75 13                	jne    80489ec <__do_global_dtors_aux+0x1c>
 80489d9:	55                   	push   %ebp
 80489da:	89 e5                	mov    %esp,%ebp
 80489dc:	83 ec 08             	sub    $0x8,%esp
 80489df:	e8 7c ff ff ff       	call   8048960 <deregister_tm_clones>
 80489e4:	c6 05 c4 c3 04 08 01 	movb   $0x1,0x804c3c4
 80489eb:	c9                   	leave  
 80489ec:	f3 c3                	repz ret 
 80489ee:	66 90                	xchg   %ax,%ax

080489f0 <frame_dummy>:
 80489f0:	a1 10 bf 04 08       	mov    0x804bf10,%eax
 80489f5:	85 c0                	test   %eax,%eax
 80489f7:	74 1f                	je     8048a18 <frame_dummy+0x28>
 80489f9:	b8 00 00 00 00       	mov    $0x0,%eax
 80489fe:	85 c0                	test   %eax,%eax
 8048a00:	74 16                	je     8048a18 <frame_dummy+0x28>
 8048a02:	55                   	push   %ebp
 8048a03:	89 e5                	mov    %esp,%ebp
 8048a05:	83 ec 18             	sub    $0x18,%esp
 8048a08:	c7 04 24 10 bf 04 08 	movl   $0x804bf10,(%esp)
 8048a0f:	ff d0                	call   *%eax
 8048a11:	c9                   	leave  
 8048a12:	e9 79 ff ff ff       	jmp    8048990 <register_tm_clones>
 8048a17:	90                   	nop
 8048a18:	e9 73 ff ff ff       	jmp    8048990 <register_tm_clones>

08048a1d <main>:
 8048a1d:	55                   	push   %ebp
 8048a1e:	89 e5                	mov    %esp,%ebp
 8048a20:	53                   	push   %ebx
 8048a21:	83 e4 f0             	and    $0xfffffff0,%esp
 8048a24:	83 ec 10             	sub    $0x10,%esp
 8048a27:	8b 45 08             	mov    0x8(%ebp),%eax
 8048a2a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 8048a2d:	83 f8 01             	cmp    $0x1,%eax
 8048a30:	75 0c                	jne    8048a3e <main+0x21>
 8048a32:	a1 a4 c3 04 08       	mov    0x804c3a4,%eax
 8048a37:	a3 cc c3 04 08       	mov    %eax,0x804c3cc
 8048a3c:	eb 74                	jmp    8048ab2 <main+0x95>
 8048a3e:	83 f8 02             	cmp    $0x2,%eax
 8048a41:	75 49                	jne    8048a8c <main+0x6f>
 8048a43:	c7 44 24 04 88 a0 04 	movl   $0x804a088,0x4(%esp)
 8048a4a:	08 
 8048a4b:	8b 43 04             	mov    0x4(%ebx),%eax
 8048a4e:	89 04 24             	mov    %eax,(%esp)
 8048a51:	e8 1a fe ff ff       	call   8048870 <fopen@plt>
 8048a56:	a3 cc c3 04 08       	mov    %eax,0x804c3cc
 8048a5b:	85 c0                	test   %eax,%eax
 8048a5d:	75 53                	jne    8048ab2 <main+0x95>
 8048a5f:	8b 43 04             	mov    0x4(%ebx),%eax
 8048a62:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048a66:	8b 03                	mov    (%ebx),%eax
 8048a68:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048a6c:	c7 44 24 04 8a a0 04 	movl   $0x804a08a,0x4(%esp)
 8048a73:	08 
 8048a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8048a7b:	e8 10 fe ff ff       	call   8048890 <__printf_chk@plt>
 8048a80:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8048a87:	e8 a4 fd ff ff       	call   8048830 <exit@plt>
 8048a8c:	8b 03                	mov    (%ebx),%eax
 8048a8e:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048a92:	c7 44 24 04 a7 a0 04 	movl   $0x804a0a7,0x4(%esp)
 8048a99:	08 
 8048a9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8048aa1:	e8 ea fd ff ff       	call   8048890 <__printf_chk@plt>
 8048aa6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8048aad:	e8 7e fd ff ff       	call   8048830 <exit@plt>
 8048ab2:	e8 4f 06 00 00       	call   8049106 <initialize_bomb>
 8048ab7:	c7 04 24 0c a1 04 08 	movl   $0x804a10c,(%esp)
 8048abe:	e8 2d fd ff ff       	call   80487f0 <puts@plt>
 8048ac3:	c7 04 24 48 a1 04 08 	movl   $0x804a148,(%esp)
 8048aca:	e8 21 fd ff ff       	call   80487f0 <puts@plt>
 8048acf:	e8 48 07 00 00       	call   804921c <read_line>
 8048ad4:	89 04 24             	mov    %eax,(%esp)
 8048ad7:	e8 b4 00 00 00       	call   8048b90 <phase_1>
 8048adc:	e8 35 08 00 00       	call   8049316 <phase_defused>
 8048ae1:	c7 04 24 74 a1 04 08 	movl   $0x804a174,(%esp)
 8048ae8:	e8 03 fd ff ff       	call   80487f0 <puts@plt>
 8048aed:	e8 2a 07 00 00       	call   804921c <read_line>
 8048af2:	89 04 24             	mov    %eax,(%esp)
 8048af5:	e8 ba 00 00 00       	call   8048bb4 <phase_2>
 8048afa:	e8 17 08 00 00       	call   8049316 <phase_defused>
 8048aff:	c7 04 24 c1 a0 04 08 	movl   $0x804a0c1,(%esp)
 8048b06:	e8 e5 fc ff ff       	call   80487f0 <puts@plt>
 8048b0b:	e8 0c 07 00 00       	call   804921c <read_line>
 8048b10:	89 04 24             	mov    %eax,(%esp)
 8048b13:	e8 e9 00 00 00       	call   8048c01 <phase_3>
 8048b18:	e8 f9 07 00 00       	call   8049316 <phase_defused>
 8048b1d:	c7 04 24 df a0 04 08 	movl   $0x804a0df,(%esp)
 8048b24:	e8 c7 fc ff ff       	call   80487f0 <puts@plt>
 8048b29:	e8 ee 06 00 00       	call   804921c <read_line>
 8048b2e:	89 04 24             	mov    %eax,(%esp)
 8048b31:	e8 6e 02 00 00       	call   8048da4 <phase_4>
 8048b36:	e8 db 07 00 00       	call   8049316 <phase_defused>
 8048b3b:	c7 04 24 a0 a1 04 08 	movl   $0x804a1a0,(%esp)
 8048b42:	e8 a9 fc ff ff       	call   80487f0 <puts@plt>
 8048b47:	e8 d0 06 00 00       	call   804921c <read_line>
 8048b4c:	89 04 24             	mov    %eax,(%esp)
 8048b4f:	e8 b0 02 00 00       	call   8048e04 <phase_5>
 8048b54:	e8 bd 07 00 00       	call   8049316 <phase_defused>
 8048b59:	c7 04 24 ee a0 04 08 	movl   $0x804a0ee,(%esp)
 8048b60:	e8 8b fc ff ff       	call   80487f0 <puts@plt>
 8048b65:	e8 b2 06 00 00       	call   804921c <read_line>
 8048b6a:	89 04 24             	mov    %eax,(%esp)
 8048b6d:	e8 db 02 00 00       	call   8048e4d <phase_6>
 8048b72:	e8 9f 07 00 00       	call   8049316 <phase_defused>
 8048b77:	b8 00 00 00 00       	mov    $0x0,%eax
 8048b7c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048b7f:	c9                   	leave  
 8048b80:	c3                   	ret    
 8048b81:	66 90                	xchg   %ax,%ax
 8048b83:	66 90                	xchg   %ax,%ax
 8048b85:	66 90                	xchg   %ax,%ax
 8048b87:	66 90                	xchg   %ax,%ax
 8048b89:	66 90                	xchg   %ax,%ax
 8048b8b:	66 90                	xchg   %ax,%ax
 8048b8d:	66 90                	xchg   %ax,%ax
 8048b8f:	90                   	nop

08048b90 <phase_1>:
 8048b90:	83 ec 1c             	sub    $0x1c,%esp
 8048b93:	c7 44 24 04 c4 a1 04 	movl   $0x804a1c4,0x4(%esp)
 8048b9a:	08 
 8048b9b:	8b 44 24 20          	mov    0x20(%esp),%eax
 8048b9f:	89 04 24             	mov    %eax,(%esp)
 8048ba2:	e8 f3 04 00 00       	call   804909a <strings_not_equal>
 8048ba7:	85 c0                	test   %eax,%eax
 8048ba9:	74 05                	je     8048bb0 <phase_1+0x20>
 8048bab:	e8 f5 05 00 00       	call   80491a5 <explode_bomb>
 8048bb0:	83 c4 1c             	add    $0x1c,%esp
 8048bb3:	c3                   	ret    

08048bb4 <phase_2>:
 8048bb4:	53                   	push   %ebx
 8048bb5:	83 ec 38             	sub    $0x38,%esp
 8048bb8:	8d 44 24 18          	lea    0x18(%esp),%eax
 8048bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048bc0:	8b 44 24 40          	mov    0x40(%esp),%eax
 8048bc4:	89 04 24             	mov    %eax,(%esp)
 8048bc7:	e8 00 06 00 00       	call   80491cc <read_six_numbers>
 8048bcc:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 8048bd1:	79 22                	jns    8048bf5 <phase_2+0x41>
 8048bd3:	e8 cd 05 00 00       	call   80491a5 <explode_bomb>
 8048bd8:	eb 1b                	jmp    8048bf5 <phase_2+0x41>
 8048bda:	89 d8                	mov    %ebx,%eax
 8048bdc:	03 44 9c 14          	add    0x14(%esp,%ebx,4),%eax
 8048be0:	39 44 9c 18          	cmp    %eax,0x18(%esp,%ebx,4)
 8048be4:	74 05                	je     8048beb <phase_2+0x37>
 8048be6:	e8 ba 05 00 00       	call   80491a5 <explode_bomb>
 8048beb:	83 c3 01             	add    $0x1,%ebx
 8048bee:	83 fb 06             	cmp    $0x6,%ebx
 8048bf1:	75 e7                	jne    8048bda <phase_2+0x26>
 8048bf3:	eb 07                	jmp    8048bfc <phase_2+0x48>
 8048bf5:	bb 01 00 00 00       	mov    $0x1,%ebx
 8048bfa:	eb de                	jmp    8048bda <phase_2+0x26>
 8048bfc:	83 c4 38             	add    $0x38,%esp
 8048bff:	5b                   	pop    %ebx
 8048c00:	c3                   	ret    

08048c01 <phase_3>:
 8048c01:	83 ec 3c             	sub    $0x3c,%esp
 8048c04:	8d 44 24 2c          	lea    0x2c(%esp),%eax
 8048c08:	89 44 24 10          	mov    %eax,0x10(%esp)
 8048c0c:	8d 44 24 27          	lea    0x27(%esp),%eax
 8048c10:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048c14:	8d 44 24 28          	lea    0x28(%esp),%eax
 8048c18:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048c1c:	c7 44 24 04 1a a2 04 	movl   $0x804a21a,0x4(%esp)
 8048c23:	08 
 8048c24:	8b 44 24 40          	mov    0x40(%esp),%eax
 8048c28:	89 04 24             	mov    %eax,(%esp)
 8048c2b:	e8 30 fc ff ff       	call   8048860 <__isoc99_sscanf@plt>
 8048c30:	83 f8 02             	cmp    $0x2,%eax
 8048c33:	7f 05                	jg     8048c3a <phase_3+0x39>
 8048c35:	e8 6b 05 00 00       	call   80491a5 <explode_bomb>
 8048c3a:	83 7c 24 28 07       	cmpl   $0x7,0x28(%esp)
 8048c3f:	0f 87 fc 00 00 00    	ja     8048d41 <phase_3+0x140>
 8048c45:	8b 44 24 28          	mov    0x28(%esp),%eax
 8048c49:	ff 24 85 40 a2 04 08 	jmp    *0x804a240(,%eax,4)
 8048c50:	b8 63 00 00 00       	mov    $0x63,%eax
 8048c55:	81 7c 24 2c e2 02 00 	cmpl   $0x2e2,0x2c(%esp)
 8048c5c:	00 
 8048c5d:	0f 84 e8 00 00 00    	je     8048d4b <phase_3+0x14a>
 8048c63:	e8 3d 05 00 00       	call   80491a5 <explode_bomb>
 8048c68:	b8 63 00 00 00       	mov    $0x63,%eax
 8048c6d:	e9 d9 00 00 00       	jmp    8048d4b <phase_3+0x14a>
 8048c72:	b8 6e 00 00 00       	mov    $0x6e,%eax
 8048c77:	81 7c 24 2c ce 03 00 	cmpl   $0x3ce,0x2c(%esp)
 8048c7e:	00 
 8048c7f:	0f 84 c6 00 00 00    	je     8048d4b <phase_3+0x14a>
 8048c85:	e8 1b 05 00 00       	call   80491a5 <explode_bomb>
 8048c8a:	b8 6e 00 00 00       	mov    $0x6e,%eax
 8048c8f:	e9 b7 00 00 00       	jmp    8048d4b <phase_3+0x14a>
 8048c94:	b8 71 00 00 00       	mov    $0x71,%eax
 8048c99:	81 7c 24 2c d4 03 00 	cmpl   $0x3d4,0x2c(%esp)
 8048ca0:	00 
 8048ca1:	0f 84 a4 00 00 00    	je     8048d4b <phase_3+0x14a>
 8048ca7:	e8 f9 04 00 00       	call   80491a5 <explode_bomb>
 8048cac:	b8 71 00 00 00       	mov    $0x71,%eax
 8048cb1:	e9 95 00 00 00       	jmp    8048d4b <phase_3+0x14a>
 8048cb6:	b8 65 00 00 00       	mov    $0x65,%eax
 8048cbb:	81 7c 24 2c 56 03 00 	cmpl   $0x356,0x2c(%esp)
 8048cc2:	00 
 8048cc3:	0f 84 82 00 00 00    	je     8048d4b <phase_3+0x14a>
 8048cc9:	e8 d7 04 00 00       	call   80491a5 <explode_bomb>
 8048cce:	b8 65 00 00 00       	mov    $0x65,%eax
 8048cd3:	eb 76                	jmp    8048d4b <phase_3+0x14a>
 8048cd5:	b8 68 00 00 00       	mov    $0x68,%eax
 8048cda:	81 7c 24 2c c3 03 00 	cmpl   $0x3c3,0x2c(%esp)
 8048ce1:	00 
 8048ce2:	74 67                	je     8048d4b <phase_3+0x14a>
 8048ce4:	e8 bc 04 00 00       	call   80491a5 <explode_bomb>
 8048ce9:	b8 68 00 00 00       	mov    $0x68,%eax
 8048cee:	eb 5b                	jmp    8048d4b <phase_3+0x14a>
 8048cf0:	b8 75 00 00 00       	mov    $0x75,%eax
 8048cf5:	81 7c 24 2c e1 02 00 	cmpl   $0x2e1,0x2c(%esp)
 8048cfc:	00 
 8048cfd:	74 4c                	je     8048d4b <phase_3+0x14a>
 8048cff:	e8 a1 04 00 00       	call   80491a5 <explode_bomb>
 8048d04:	b8 75 00 00 00       	mov    $0x75,%eax
 8048d09:	eb 40                	jmp    8048d4b <phase_3+0x14a>
 8048d0b:	b8 76 00 00 00       	mov    $0x76,%eax
 8048d10:	81 7c 24 2c c7 00 00 	cmpl   $0xc7,0x2c(%esp)
 8048d17:	00 
 8048d18:	74 31                	je     8048d4b <phase_3+0x14a>
 8048d1a:	e8 86 04 00 00       	call   80491a5 <explode_bomb>
 8048d1f:	b8 76 00 00 00       	mov    $0x76,%eax
 8048d24:	eb 25                	jmp    8048d4b <phase_3+0x14a>
 8048d26:	b8 79 00 00 00       	mov    $0x79,%eax
 8048d2b:	81 7c 24 2c 86 00 00 	cmpl   $0x86,0x2c(%esp)
 8048d32:	00 
 8048d33:	74 16                	je     8048d4b <phase_3+0x14a>
 8048d35:	e8 6b 04 00 00       	call   80491a5 <explode_bomb>
 8048d3a:	b8 79 00 00 00       	mov    $0x79,%eax
 8048d3f:	eb 0a                	jmp    8048d4b <phase_3+0x14a>
 8048d41:	e8 5f 04 00 00       	call   80491a5 <explode_bomb>
 8048d46:	b8 73 00 00 00       	mov    $0x73,%eax
 8048d4b:	3a 44 24 27          	cmp    0x27(%esp),%al
 8048d4f:	74 05                	je     8048d56 <phase_3+0x155>
 8048d51:	e8 4f 04 00 00       	call   80491a5 <explode_bomb>
 8048d56:	83 c4 3c             	add    $0x3c,%esp
 8048d59:	c3                   	ret    

08048d5a <func4>:
 8048d5a:	57                   	push   %edi
 8048d5b:	56                   	push   %esi
 8048d5c:	53                   	push   %ebx
 8048d5d:	83 ec 10             	sub    $0x10,%esp
 8048d60:	8b 5c 24 20          	mov    0x20(%esp),%ebx
 8048d64:	8b 74 24 24          	mov    0x24(%esp),%esi
 8048d68:	85 db                	test   %ebx,%ebx
 8048d6a:	7e 2c                	jle    8048d98 <func4+0x3e>
 8048d6c:	89 f0                	mov    %esi,%eax
 8048d6e:	83 fb 01             	cmp    $0x1,%ebx
 8048d71:	74 2a                	je     8048d9d <func4+0x43>
 8048d73:	89 74 24 04          	mov    %esi,0x4(%esp)
 8048d77:	8d 43 ff             	lea    -0x1(%ebx),%eax
 8048d7a:	89 04 24             	mov    %eax,(%esp)
 8048d7d:	e8 d8 ff ff ff       	call   8048d5a <func4>
 8048d82:	8d 3c 30             	lea    (%eax,%esi,1),%edi
 8048d85:	89 74 24 04          	mov    %esi,0x4(%esp)
 8048d89:	83 eb 02             	sub    $0x2,%ebx
 8048d8c:	89 1c 24             	mov    %ebx,(%esp)
 8048d8f:	e8 c6 ff ff ff       	call   8048d5a <func4>
 8048d94:	01 f8                	add    %edi,%eax
 8048d96:	eb 05                	jmp    8048d9d <func4+0x43>
 8048d98:	b8 00 00 00 00       	mov    $0x0,%eax
 8048d9d:	83 c4 10             	add    $0x10,%esp
 8048da0:	5b                   	pop    %ebx
 8048da1:	5e                   	pop    %esi
 8048da2:	5f                   	pop    %edi
 8048da3:	c3                   	ret    

08048da4 <phase_4>:
 8048da4:	83 ec 2c             	sub    $0x2c,%esp
 8048da7:	8d 44 24 18          	lea    0x18(%esp),%eax
 8048dab:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048daf:	8d 44 24 1c          	lea    0x1c(%esp),%eax
 8048db3:	89 44 24 08          	mov    %eax,0x8(%esp)
 8048db7:	c7 44 24 04 af a3 04 	movl   $0x804a3af,0x4(%esp)
 8048dbe:	08 
 8048dbf:	8b 44 24 30          	mov    0x30(%esp),%eax
 8048dc3:	89 04 24             	mov    %eax,(%esp)
 8048dc6:	e8 95 fa ff ff       	call   8048860 <__isoc99_sscanf@plt>
 8048dcb:	83 f8 02             	cmp    $0x2,%eax
 8048dce:	75 0c                	jne    8048ddc <phase_4+0x38>
 8048dd0:	8b 44 24 18          	mov    0x18(%esp),%eax
 8048dd4:	83 e8 02             	sub    $0x2,%eax
 8048dd7:	83 f8 02             	cmp    $0x2,%eax
 8048dda:	76 05                	jbe    8048de1 <phase_4+0x3d>
 8048ddc:	e8 c4 03 00 00       	call   80491a5 <explode_bomb>
 8048de1:	8b 44 24 18          	mov    0x18(%esp),%eax
 8048de5:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048de9:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
 8048df0:	e8 65 ff ff ff       	call   8048d5a <func4>
 8048df5:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 8048df9:	74 05                	je     8048e00 <phase_4+0x5c>
 8048dfb:	e8 a5 03 00 00       	call   80491a5 <explode_bomb>
 8048e00:	83 c4 2c             	add    $0x2c,%esp
 8048e03:	c3                   	ret    

08048e04 <phase_5>:
 8048e04:	53                   	push   %ebx
 8048e05:	83 ec 18             	sub    $0x18,%esp
 8048e08:	8b 5c 24 20          	mov    0x20(%esp),%ebx
 8048e0c:	89 1c 24             	mov    %ebx,(%esp)
 8048e0f:	e8 67 02 00 00       	call   804907b <string_length>
 8048e14:	83 f8 06             	cmp    $0x6,%eax
 8048e17:	74 05                	je     8048e1e <phase_5+0x1a>
 8048e19:	e8 87 03 00 00       	call   80491a5 <explode_bomb>
 8048e1e:	ba 00 00 00 00       	mov    $0x0,%edx
 8048e23:	b8 00 00 00 00       	mov    $0x0,%eax
 8048e28:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
 8048e2c:	83 e1 0f             	and    $0xf,%ecx
 8048e2f:	03 14 8d 60 a2 04 08 	add    0x804a260(,%ecx,4),%edx
 8048e36:	83 c0 01             	add    $0x1,%eax
 8048e39:	83 f8 06             	cmp    $0x6,%eax
 8048e3c:	75 ea                	jne    8048e28 <phase_5+0x24>
 8048e3e:	83 fa 42             	cmp    $0x42,%edx
 8048e41:	74 05                	je     8048e48 <phase_5+0x44>
 8048e43:	e8 5d 03 00 00       	call   80491a5 <explode_bomb>
 8048e48:	83 c4 18             	add    $0x18,%esp
 8048e4b:	5b                   	pop    %ebx
 8048e4c:	c3                   	ret    

08048e4d <phase_6>:
 8048e4d:	56                   	push   %esi
 8048e4e:	53                   	push   %ebx
 8048e4f:	83 ec 44             	sub    $0x44,%esp
 8048e52:	8d 44 24 10          	lea    0x10(%esp),%eax
 8048e56:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048e5a:	8b 44 24 50          	mov    0x50(%esp),%eax
 8048e5e:	89 04 24             	mov    %eax,(%esp)
 8048e61:	e8 66 03 00 00       	call   80491cc <read_six_numbers>
 8048e66:	be 00 00 00 00       	mov    $0x0,%esi
 8048e6b:	8b 44 b4 10          	mov    0x10(%esp,%esi,4),%eax
 8048e6f:	83 e8 01             	sub    $0x1,%eax
 8048e72:	83 f8 05             	cmp    $0x5,%eax
 8048e75:	76 05                	jbe    8048e7c <phase_6+0x2f>
 8048e77:	e8 29 03 00 00       	call   80491a5 <explode_bomb>
 8048e7c:	83 c6 01             	add    $0x1,%esi
 8048e7f:	83 fe 06             	cmp    $0x6,%esi
 8048e82:	74 1b                	je     8048e9f <phase_6+0x52>
 8048e84:	89 f3                	mov    %esi,%ebx
 8048e86:	8b 44 9c 10          	mov    0x10(%esp,%ebx,4),%eax
 8048e8a:	39 44 b4 0c          	cmp    %eax,0xc(%esp,%esi,4)
 8048e8e:	75 05                	jne    8048e95 <phase_6+0x48>
 8048e90:	e8 10 03 00 00       	call   80491a5 <explode_bomb>
 8048e95:	83 c3 01             	add    $0x1,%ebx
 8048e98:	83 fb 05             	cmp    $0x5,%ebx
 8048e9b:	7e e9                	jle    8048e86 <phase_6+0x39>
 8048e9d:	eb cc                	jmp    8048e6b <phase_6+0x1e>
 8048e9f:	8d 44 24 10          	lea    0x10(%esp),%eax
 8048ea3:	8d 5c 24 28          	lea    0x28(%esp),%ebx
 8048ea7:	b9 07 00 00 00       	mov    $0x7,%ecx
 8048eac:	89 ca                	mov    %ecx,%edx
 8048eae:	2b 10                	sub    (%eax),%edx
 8048eb0:	89 10                	mov    %edx,(%eax)
 8048eb2:	83 c0 04             	add    $0x4,%eax
 8048eb5:	39 d8                	cmp    %ebx,%eax
 8048eb7:	75 f3                	jne    8048eac <phase_6+0x5f>
 8048eb9:	bb 00 00 00 00       	mov    $0x0,%ebx
 8048ebe:	eb 1d                	jmp    8048edd <phase_6+0x90>
 8048ec0:	8b 52 08             	mov    0x8(%edx),%edx
 8048ec3:	83 c0 01             	add    $0x1,%eax
 8048ec6:	39 c8                	cmp    %ecx,%eax
 8048ec8:	75 f6                	jne    8048ec0 <phase_6+0x73>
 8048eca:	eb 05                	jmp    8048ed1 <phase_6+0x84>
 8048ecc:	ba 3c c1 04 08       	mov    $0x804c13c,%edx
 8048ed1:	89 54 b4 28          	mov    %edx,0x28(%esp,%esi,4)
 8048ed5:	83 c3 01             	add    $0x1,%ebx
 8048ed8:	83 fb 06             	cmp    $0x6,%ebx
 8048edb:	74 17                	je     8048ef4 <phase_6+0xa7>
 8048edd:	89 de                	mov    %ebx,%esi
 8048edf:	8b 4c 9c 10          	mov    0x10(%esp,%ebx,4),%ecx
 8048ee3:	83 f9 01             	cmp    $0x1,%ecx
 8048ee6:	7e e4                	jle    8048ecc <phase_6+0x7f>
 8048ee8:	b8 01 00 00 00       	mov    $0x1,%eax
 8048eed:	ba 3c c1 04 08       	mov    $0x804c13c,%edx
 8048ef2:	eb cc                	jmp    8048ec0 <phase_6+0x73>
 8048ef4:	8b 5c 24 28          	mov    0x28(%esp),%ebx
 8048ef8:	8d 44 24 2c          	lea    0x2c(%esp),%eax
 8048efc:	8d 74 24 40          	lea    0x40(%esp),%esi
 8048f00:	89 d9                	mov    %ebx,%ecx
 8048f02:	8b 10                	mov    (%eax),%edx
 8048f04:	89 51 08             	mov    %edx,0x8(%ecx)
 8048f07:	83 c0 04             	add    $0x4,%eax
 8048f0a:	39 f0                	cmp    %esi,%eax
 8048f0c:	74 04                	je     8048f12 <phase_6+0xc5>
 8048f0e:	89 d1                	mov    %edx,%ecx
 8048f10:	eb f0                	jmp    8048f02 <phase_6+0xb5>
 8048f12:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
 8048f19:	be 05 00 00 00       	mov    $0x5,%esi
 8048f1e:	8b 43 08             	mov    0x8(%ebx),%eax
 8048f21:	8b 00                	mov    (%eax),%eax
 8048f23:	39 03                	cmp    %eax,(%ebx)
 8048f25:	7d 05                	jge    8048f2c <phase_6+0xdf>
 8048f27:	e8 79 02 00 00       	call   80491a5 <explode_bomb>
 8048f2c:	8b 5b 08             	mov    0x8(%ebx),%ebx
 8048f2f:	83 ee 01             	sub    $0x1,%esi
 8048f32:	75 ea                	jne    8048f1e <phase_6+0xd1>
 8048f34:	83 c4 44             	add    $0x44,%esp
 8048f37:	5b                   	pop    %ebx
 8048f38:	5e                   	pop    %esi
 8048f39:	c3                   	ret    

08048f3a <fun7>:
 8048f3a:	53                   	push   %ebx
 8048f3b:	83 ec 18             	sub    $0x18,%esp
 8048f3e:	8b 54 24 20          	mov    0x20(%esp),%edx
 8048f42:	8b 4c 24 24          	mov    0x24(%esp),%ecx
 8048f46:	85 d2                	test   %edx,%edx
 8048f48:	74 37                	je     8048f81 <fun7+0x47>
 8048f4a:	8b 1a                	mov    (%edx),%ebx
 8048f4c:	39 cb                	cmp    %ecx,%ebx
 8048f4e:	7e 13                	jle    8048f63 <fun7+0x29>
 8048f50:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 8048f54:	8b 42 04             	mov    0x4(%edx),%eax
 8048f57:	89 04 24             	mov    %eax,(%esp)
 8048f5a:	e8 db ff ff ff       	call   8048f3a <fun7>
 8048f5f:	01 c0                	add    %eax,%eax
 8048f61:	eb 23                	jmp    8048f86 <fun7+0x4c>
 8048f63:	b8 00 00 00 00       	mov    $0x0,%eax
 8048f68:	39 cb                	cmp    %ecx,%ebx
 8048f6a:	74 1a                	je     8048f86 <fun7+0x4c>
 8048f6c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 8048f70:	8b 42 08             	mov    0x8(%edx),%eax
 8048f73:	89 04 24             	mov    %eax,(%esp)
 8048f76:	e8 bf ff ff ff       	call   8048f3a <fun7>
 8048f7b:	8d 44 00 01          	lea    0x1(%eax,%eax,1),%eax
 8048f7f:	eb 05                	jmp    8048f86 <fun7+0x4c>
 8048f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8048f86:	83 c4 18             	add    $0x18,%esp
 8048f89:	5b                   	pop    %ebx
 8048f8a:	c3                   	ret    

08048f8b <secret_phase>:
 8048f8b:	53                   	push   %ebx
 8048f8c:	83 ec 18             	sub    $0x18,%esp
 8048f8f:	e8 88 02 00 00       	call   804921c <read_line>
 8048f94:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8048f9b:	00 
 8048f9c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8048fa3:	00 
 8048fa4:	89 04 24             	mov    %eax,(%esp)
 8048fa7:	e8 24 f9 ff ff       	call   80488d0 <strtol@plt>
 8048fac:	89 c3                	mov    %eax,%ebx
 8048fae:	8d 40 ff             	lea    -0x1(%eax),%eax
 8048fb1:	3d e8 03 00 00       	cmp    $0x3e8,%eax
 8048fb6:	76 05                	jbe    8048fbd <secret_phase+0x32>
 8048fb8:	e8 e8 01 00 00       	call   80491a5 <explode_bomb>
 8048fbd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 8048fc1:	c7 04 24 88 c0 04 08 	movl   $0x804c088,(%esp)
 8048fc8:	e8 6d ff ff ff       	call   8048f3a <fun7>
 8048fcd:	83 f8 06             	cmp    $0x6,%eax
 8048fd0:	74 05                	je     8048fd7 <secret_phase+0x4c>
 8048fd2:	e8 ce 01 00 00       	call   80491a5 <explode_bomb>
 8048fd7:	c7 04 24 f4 a1 04 08 	movl   $0x804a1f4,(%esp)
 8048fde:	e8 0d f8 ff ff       	call   80487f0 <puts@plt>
 8048fe3:	e8 2e 03 00 00       	call   8049316 <phase_defused>
 8048fe8:	83 c4 18             	add    $0x18,%esp
 8048feb:	5b                   	pop    %ebx
 8048fec:	c3                   	ret    
 8048fed:	66 90                	xchg   %ax,%ax
 8048fef:	90                   	nop

08048ff0 <sig_handler>:
 8048ff0:	83 ec 1c             	sub    $0x1c,%esp
 8048ff3:	c7 04 24 a0 a2 04 08 	movl   $0x804a2a0,(%esp)
 8048ffa:	e8 f1 f7 ff ff       	call   80487f0 <puts@plt>
 8048fff:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
 8049006:	e8 95 f7 ff ff       	call   80487a0 <sleep@plt>
 804900b:	c7 44 24 04 62 a3 04 	movl   $0x804a362,0x4(%esp)
 8049012:	08 
 8049013:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804901a:	e8 71 f8 ff ff       	call   8048890 <__printf_chk@plt>
 804901f:	a1 c0 c3 04 08       	mov    0x804c3c0,%eax
 8049024:	89 04 24             	mov    %eax,(%esp)
 8049027:	e8 44 f7 ff ff       	call   8048770 <fflush@plt>
 804902c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8049033:	e8 68 f7 ff ff       	call   80487a0 <sleep@plt>
 8049038:	c7 04 24 6a a3 04 08 	movl   $0x804a36a,(%esp)
 804903f:	e8 ac f7 ff ff       	call   80487f0 <puts@plt>
 8049044:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
 804904b:	e8 e0 f7 ff ff       	call   8048830 <exit@plt>

08049050 <invalid_phase>:
 8049050:	83 ec 1c             	sub    $0x1c,%esp
 8049053:	8b 44 24 20          	mov    0x20(%esp),%eax
 8049057:	89 44 24 08          	mov    %eax,0x8(%esp)
 804905b:	c7 44 24 04 72 a3 04 	movl   $0x804a372,0x4(%esp)
 8049062:	08 
 8049063:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 804906a:	e8 21 f8 ff ff       	call   8048890 <__printf_chk@plt>
 804906f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8049076:	e8 b5 f7 ff ff       	call   8048830 <exit@plt>

0804907b <string_length>:
 804907b:	8b 54 24 04          	mov    0x4(%esp),%edx
 804907f:	80 3a 00             	cmpb   $0x0,(%edx)
 8049082:	74 10                	je     8049094 <string_length+0x19>
 8049084:	b8 00 00 00 00       	mov    $0x0,%eax
 8049089:	83 c0 01             	add    $0x1,%eax
 804908c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 8049090:	75 f7                	jne    8049089 <string_length+0xe>
 8049092:	f3 c3                	repz ret 
 8049094:	b8 00 00 00 00       	mov    $0x0,%eax
 8049099:	c3                   	ret    

0804909a <strings_not_equal>:
 804909a:	57                   	push   %edi
 804909b:	56                   	push   %esi
 804909c:	53                   	push   %ebx
 804909d:	83 ec 04             	sub    $0x4,%esp
 80490a0:	8b 5c 24 14          	mov    0x14(%esp),%ebx
 80490a4:	8b 74 24 18          	mov    0x18(%esp),%esi
 80490a8:	89 1c 24             	mov    %ebx,(%esp)
 80490ab:	e8 cb ff ff ff       	call   804907b <string_length>
 80490b0:	89 c7                	mov    %eax,%edi
 80490b2:	89 34 24             	mov    %esi,(%esp)
 80490b5:	e8 c1 ff ff ff       	call   804907b <string_length>
 80490ba:	ba 01 00 00 00       	mov    $0x1,%edx
 80490bf:	39 c7                	cmp    %eax,%edi
 80490c1:	75 3a                	jne    80490fd <strings_not_equal+0x63>
 80490c3:	0f b6 03             	movzbl (%ebx),%eax
 80490c6:	84 c0                	test   %al,%al
 80490c8:	74 20                	je     80490ea <strings_not_equal+0x50>
 80490ca:	3a 06                	cmp    (%esi),%al
 80490cc:	74 08                	je     80490d6 <strings_not_equal+0x3c>
 80490ce:	66 90                	xchg   %ax,%ax
 80490d0:	eb 1f                	jmp    80490f1 <strings_not_equal+0x57>
 80490d2:	3a 06                	cmp    (%esi),%al
 80490d4:	75 22                	jne    80490f8 <strings_not_equal+0x5e>
 80490d6:	83 c3 01             	add    $0x1,%ebx
 80490d9:	83 c6 01             	add    $0x1,%esi
 80490dc:	0f b6 03             	movzbl (%ebx),%eax
 80490df:	84 c0                	test   %al,%al
 80490e1:	75 ef                	jne    80490d2 <strings_not_equal+0x38>
 80490e3:	ba 00 00 00 00       	mov    $0x0,%edx
 80490e8:	eb 13                	jmp    80490fd <strings_not_equal+0x63>
 80490ea:	ba 00 00 00 00       	mov    $0x0,%edx
 80490ef:	eb 0c                	jmp    80490fd <strings_not_equal+0x63>
 80490f1:	ba 01 00 00 00       	mov    $0x1,%edx
 80490f6:	eb 05                	jmp    80490fd <strings_not_equal+0x63>
 80490f8:	ba 01 00 00 00       	mov    $0x1,%edx
 80490fd:	89 d0                	mov    %edx,%eax
 80490ff:	83 c4 04             	add    $0x4,%esp
 8049102:	5b                   	pop    %ebx
 8049103:	5e                   	pop    %esi
 8049104:	5f                   	pop    %edi
 8049105:	c3                   	ret    

08049106 <initialize_bomb>:
 8049106:	83 ec 1c             	sub    $0x1c,%esp
 8049109:	c7 44 24 04 f0 8f 04 	movl   $0x8048ff0,0x4(%esp)
 8049110:	08 
 8049111:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 8049118:	e8 73 f6 ff ff       	call   8048790 <signal@plt>
 804911d:	83 c4 1c             	add    $0x1c,%esp
 8049120:	c3                   	ret    

08049121 <initialize_bomb_solve>:
 8049121:	f3 c3                	repz ret 

08049123 <blank_line>:
 8049123:	56                   	push   %esi
 8049124:	53                   	push   %ebx
 8049125:	83 ec 04             	sub    $0x4,%esp
 8049128:	8b 5c 24 10          	mov    0x10(%esp),%ebx
 804912c:	eb 16                	jmp    8049144 <blank_line+0x21>
 804912e:	e8 cd f7 ff ff       	call   8048900 <__ctype_b_loc@plt>
 8049133:	83 c3 01             	add    $0x1,%ebx
 8049136:	89 f2                	mov    %esi,%edx
 8049138:	0f be f2             	movsbl %dl,%esi
 804913b:	8b 00                	mov    (%eax),%eax
 804913d:	f6 44 70 01 20       	testb  $0x20,0x1(%eax,%esi,2)
 8049142:	74 10                	je     8049154 <blank_line+0x31>
 8049144:	0f b6 33             	movzbl (%ebx),%esi
 8049147:	89 f0                	mov    %esi,%eax
 8049149:	84 c0                	test   %al,%al
 804914b:	75 e1                	jne    804912e <blank_line+0xb>
 804914d:	b8 01 00 00 00       	mov    $0x1,%eax
 8049152:	eb 05                	jmp    8049159 <blank_line+0x36>
 8049154:	b8 00 00 00 00       	mov    $0x0,%eax
 8049159:	83 c4 04             	add    $0x4,%esp
 804915c:	5b                   	pop    %ebx
 804915d:	5e                   	pop    %esi
 804915e:	c3                   	ret    

0804915f <skip>:
 804915f:	53                   	push   %ebx
 8049160:	83 ec 18             	sub    $0x18,%esp
 8049163:	a1 cc c3 04 08       	mov    0x804c3cc,%eax
 8049168:	89 44 24 08          	mov    %eax,0x8(%esp)
 804916c:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
 8049173:	00 
 8049174:	a1 c8 c3 04 08       	mov    0x804c3c8,%eax
 8049179:	8d 04 80             	lea    (%eax,%eax,4),%eax
 804917c:	c1 e0 04             	shl    $0x4,%eax
 804917f:	05 e0 c3 04 08       	add    $0x804c3e0,%eax
 8049184:	89 04 24             	mov    %eax,(%esp)
 8049187:	e8 f4 f5 ff ff       	call   8048780 <fgets@plt>
 804918c:	89 c3                	mov    %eax,%ebx
 804918e:	85 c0                	test   %eax,%eax
 8049190:	74 0c                	je     804919e <skip+0x3f>
 8049192:	89 04 24             	mov    %eax,(%esp)
 8049195:	e8 89 ff ff ff       	call   8049123 <blank_line>
 804919a:	85 c0                	test   %eax,%eax
 804919c:	75 c5                	jne    8049163 <skip+0x4>
 804919e:	89 d8                	mov    %ebx,%eax
 80491a0:	83 c4 18             	add    $0x18,%esp
 80491a3:	5b                   	pop    %ebx
 80491a4:	c3                   	ret    

080491a5 <explode_bomb>:
 80491a5:	83 ec 1c             	sub    $0x1c,%esp
 80491a8:	c7 04 24 83 a3 04 08 	movl   $0x804a383,(%esp)
 80491af:	e8 3c f6 ff ff       	call   80487f0 <puts@plt>
 80491b4:	c7 04 24 8c a3 04 08 	movl   $0x804a38c,(%esp)
 80491bb:	e8 30 f6 ff ff       	call   80487f0 <puts@plt>
 80491c0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 80491c7:	e8 64 f6 ff ff       	call   8048830 <exit@plt>

080491cc <read_six_numbers>:
 80491cc:	83 ec 2c             	sub    $0x2c,%esp
 80491cf:	8b 44 24 34          	mov    0x34(%esp),%eax
 80491d3:	8d 50 14             	lea    0x14(%eax),%edx
 80491d6:	89 54 24 1c          	mov    %edx,0x1c(%esp)
 80491da:	8d 50 10             	lea    0x10(%eax),%edx
 80491dd:	89 54 24 18          	mov    %edx,0x18(%esp)
 80491e1:	8d 50 0c             	lea    0xc(%eax),%edx
 80491e4:	89 54 24 14          	mov    %edx,0x14(%esp)
 80491e8:	8d 50 08             	lea    0x8(%eax),%edx
 80491eb:	89 54 24 10          	mov    %edx,0x10(%esp)
 80491ef:	8d 50 04             	lea    0x4(%eax),%edx
 80491f2:	89 54 24 0c          	mov    %edx,0xc(%esp)
 80491f6:	89 44 24 08          	mov    %eax,0x8(%esp)
 80491fa:	c7 44 24 04 a3 a3 04 	movl   $0x804a3a3,0x4(%esp)
 8049201:	08 
 8049202:	8b 44 24 30          	mov    0x30(%esp),%eax
 8049206:	89 04 24             	mov    %eax,(%esp)
 8049209:	e8 52 f6 ff ff       	call   8048860 <__isoc99_sscanf@plt>
 804920e:	83 f8 05             	cmp    $0x5,%eax
 8049211:	7f 05                	jg     8049218 <read_six_numbers+0x4c>
 8049213:	e8 8d ff ff ff       	call   80491a5 <explode_bomb>
 8049218:	83 c4 2c             	add    $0x2c,%esp
 804921b:	c3                   	ret    

0804921c <read_line>:
 804921c:	57                   	push   %edi
 804921d:	56                   	push   %esi
 804921e:	53                   	push   %ebx
 804921f:	83 ec 10             	sub    $0x10,%esp
 8049222:	e8 38 ff ff ff       	call   804915f <skip>
 8049227:	85 c0                	test   %eax,%eax
 8049229:	75 6c                	jne    8049297 <read_line+0x7b>
 804922b:	a1 a4 c3 04 08       	mov    0x804c3a4,%eax
 8049230:	39 05 cc c3 04 08    	cmp    %eax,0x804c3cc
 8049236:	75 18                	jne    8049250 <read_line+0x34>
 8049238:	c7 04 24 b5 a3 04 08 	movl   $0x804a3b5,(%esp)
 804923f:	e8 ac f5 ff ff       	call   80487f0 <puts@plt>
 8049244:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 804924b:	e8 e0 f5 ff ff       	call   8048830 <exit@plt>
 8049250:	c7 04 24 d3 a3 04 08 	movl   $0x804a3d3,(%esp)
 8049257:	e8 84 f5 ff ff       	call   80487e0 <getenv@plt>
 804925c:	85 c0                	test   %eax,%eax
 804925e:	74 0c                	je     804926c <read_line+0x50>
 8049260:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8049267:	e8 c4 f5 ff ff       	call   8048830 <exit@plt>
 804926c:	a1 a4 c3 04 08       	mov    0x804c3a4,%eax
 8049271:	a3 cc c3 04 08       	mov    %eax,0x804c3cc
 8049276:	e8 e4 fe ff ff       	call   804915f <skip>
 804927b:	85 c0                	test   %eax,%eax
 804927d:	75 18                	jne    8049297 <read_line+0x7b>
 804927f:	c7 04 24 b5 a3 04 08 	movl   $0x804a3b5,(%esp)
 8049286:	e8 65 f5 ff ff       	call   80487f0 <puts@plt>
 804928b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8049292:	e8 99 f5 ff ff       	call   8048830 <exit@plt>
 8049297:	8b 15 c8 c3 04 08    	mov    0x804c3c8,%edx
 804929d:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 80492a0:	c1 e3 04             	shl    $0x4,%ebx
 80492a3:	81 c3 e0 c3 04 08    	add    $0x804c3e0,%ebx
 80492a9:	89 df                	mov    %ebx,%edi
 80492ab:	b8 00 00 00 00       	mov    $0x0,%eax
 80492b0:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 80492b5:	f2 ae                	repnz scas %es:(%edi),%al
 80492b7:	f7 d1                	not    %ecx
 80492b9:	83 e9 01             	sub    $0x1,%ecx
 80492bc:	83 f9 4e             	cmp    $0x4e,%ecx
 80492bf:	7e 35                	jle    80492f6 <read_line+0xda>
 80492c1:	c7 04 24 de a3 04 08 	movl   $0x804a3de,(%esp)
 80492c8:	e8 23 f5 ff ff       	call   80487f0 <puts@plt>
 80492cd:	a1 c8 c3 04 08       	mov    0x804c3c8,%eax
 80492d2:	8d 50 01             	lea    0x1(%eax),%edx
 80492d5:	89 15 c8 c3 04 08    	mov    %edx,0x804c3c8
 80492db:	6b c0 50             	imul   $0x50,%eax,%eax
 80492de:	05 e0 c3 04 08       	add    $0x804c3e0,%eax
 80492e3:	be f9 a3 04 08       	mov    $0x804a3f9,%esi
 80492e8:	b9 04 00 00 00       	mov    $0x4,%ecx
 80492ed:	89 c7                	mov    %eax,%edi
 80492ef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
 80492f1:	e8 af fe ff ff       	call   80491a5 <explode_bomb>
 80492f6:	8d 04 92             	lea    (%edx,%edx,4),%eax
 80492f9:	c1 e0 04             	shl    $0x4,%eax
 80492fc:	c6 84 01 df c3 04 08 	movb   $0x0,0x804c3df(%ecx,%eax,1)
 8049303:	00 
 8049304:	83 c2 01             	add    $0x1,%edx
 8049307:	89 15 c8 c3 04 08    	mov    %edx,0x804c3c8
 804930d:	89 d8                	mov    %ebx,%eax
 804930f:	83 c4 10             	add    $0x10,%esp
 8049312:	5b                   	pop    %ebx
 8049313:	5e                   	pop    %esi
 8049314:	5f                   	pop    %edi
 8049315:	c3                   	ret    

08049316 <phase_defused>:
 8049316:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
 804931c:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
 8049322:	89 44 24 7c          	mov    %eax,0x7c(%esp)
 8049326:	31 c0                	xor    %eax,%eax
 8049328:	83 3d c8 c3 04 08 06 	cmpl   $0x6,0x804c3c8
 804932f:	75 72                	jne    80493a3 <phase_defused+0x8d>
 8049331:	8d 44 24 2c          	lea    0x2c(%esp),%eax
 8049335:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049339:	8d 44 24 28          	lea    0x28(%esp),%eax
 804933d:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049341:	8d 44 24 24          	lea    0x24(%esp),%eax
 8049345:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049349:	c7 44 24 04 09 a4 04 	movl   $0x804a409,0x4(%esp)
 8049350:	08 
 8049351:	c7 04 24 d0 c4 04 08 	movl   $0x804c4d0,(%esp)
 8049358:	e8 03 f5 ff ff       	call   8048860 <__isoc99_sscanf@plt>
 804935d:	83 f8 03             	cmp    $0x3,%eax
 8049360:	75 35                	jne    8049397 <phase_defused+0x81>
 8049362:	c7 44 24 04 12 a4 04 	movl   $0x804a412,0x4(%esp)
 8049369:	08 
 804936a:	8d 44 24 2c          	lea    0x2c(%esp),%eax
 804936e:	89 04 24             	mov    %eax,(%esp)
 8049371:	e8 24 fd ff ff       	call   804909a <strings_not_equal>
 8049376:	85 c0                	test   %eax,%eax
 8049378:	75 1d                	jne    8049397 <phase_defused+0x81>
 804937a:	c7 04 24 d8 a2 04 08 	movl   $0x804a2d8,(%esp)
 8049381:	e8 6a f4 ff ff       	call   80487f0 <puts@plt>
 8049386:	c7 04 24 00 a3 04 08 	movl   $0x804a300,(%esp)
 804938d:	e8 5e f4 ff ff       	call   80487f0 <puts@plt>
 8049392:	e8 f4 fb ff ff       	call   8048f8b <secret_phase>
 8049397:	c7 04 24 38 a3 04 08 	movl   $0x804a338,(%esp)
 804939e:	e8 4d f4 ff ff       	call   80487f0 <puts@plt>
 80493a3:	8b 44 24 7c          	mov    0x7c(%esp),%eax
 80493a7:	65 33 05 14 00 00 00 	xor    %gs:0x14,%eax
 80493ae:	74 05                	je     80493b5 <phase_defused+0x9f>
 80493b0:	e8 0b f4 ff ff       	call   80487c0 <__stack_chk_fail@plt>
 80493b5:	81 c4 8c 00 00 00    	add    $0x8c,%esp
 80493bb:	c3                   	ret    
 80493bc:	66 90                	xchg   %ax,%ax
 80493be:	66 90                	xchg   %ax,%ax

080493c0 <sigalrm_handler>:
 80493c0:	83 ec 1c             	sub    $0x1c,%esp
 80493c3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 80493ca:	00 
 80493cb:	c7 44 24 08 68 a4 04 	movl   $0x804a468,0x8(%esp)
 80493d2:	08 
 80493d3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 80493da:	00 
 80493db:	a1 a0 c3 04 08       	mov    0x804c3a0,%eax
 80493e0:	89 04 24             	mov    %eax,(%esp)
 80493e3:	e8 c8 f4 ff ff       	call   80488b0 <__fprintf_chk@plt>
 80493e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 80493ef:	e8 3c f4 ff ff       	call   8048830 <exit@plt>

080493f4 <rio_readlineb>:
 80493f4:	55                   	push   %ebp
 80493f5:	57                   	push   %edi
 80493f6:	56                   	push   %esi
 80493f7:	53                   	push   %ebx
 80493f8:	83 ec 3c             	sub    $0x3c,%esp
 80493fb:	89 d5                	mov    %edx,%ebp
 80493fd:	83 f9 01             	cmp    $0x1,%ecx
 8049400:	0f 86 d0 00 00 00    	jbe    80494d6 <rio_readlineb+0xe2>
 8049406:	89 c3                	mov    %eax,%ebx
 8049408:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
 804940c:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
 8049413:	00 
 8049414:	8d 78 0c             	lea    0xc(%eax),%edi
 8049417:	eb 33                	jmp    804944c <rio_readlineb+0x58>
 8049419:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
 8049420:	00 
 8049421:	89 7c 24 04          	mov    %edi,0x4(%esp)
 8049425:	8b 03                	mov    (%ebx),%eax
 8049427:	89 04 24             	mov    %eax,(%esp)
 804942a:	e8 31 f3 ff ff       	call   8048760 <read@plt>
 804942f:	89 43 04             	mov    %eax,0x4(%ebx)
 8049432:	85 c0                	test   %eax,%eax
 8049434:	79 0f                	jns    8049445 <rio_readlineb+0x51>
 8049436:	e8 45 f4 ff ff       	call   8048880 <__errno_location@plt>
 804943b:	83 38 04             	cmpl   $0x4,(%eax)
 804943e:	74 0c                	je     804944c <rio_readlineb+0x58>
 8049440:	e9 a3 00 00 00       	jmp    80494e8 <rio_readlineb+0xf4>
 8049445:	85 c0                	test   %eax,%eax
 8049447:	74 6e                	je     80494b7 <rio_readlineb+0xc3>
 8049449:	89 7b 08             	mov    %edi,0x8(%ebx)
 804944c:	8b 73 04             	mov    0x4(%ebx),%esi
 804944f:	85 f6                	test   %esi,%esi
 8049451:	7e c6                	jle    8049419 <rio_readlineb+0x25>
 8049453:	85 f6                	test   %esi,%esi
 8049455:	0f 95 c0             	setne  %al
 8049458:	0f b6 c0             	movzbl %al,%eax
 804945b:	89 44 24 14          	mov    %eax,0x14(%esp)
 804945f:	8b 4b 08             	mov    0x8(%ebx),%ecx
 8049462:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8049469:	00 
 804946a:	89 44 24 08          	mov    %eax,0x8(%esp)
 804946e:	89 4c 24 18          	mov    %ecx,0x18(%esp)
 8049472:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 8049476:	8d 54 24 2f          	lea    0x2f(%esp),%edx
 804947a:	89 14 24             	mov    %edx,(%esp)
 804947d:	e8 8e f3 ff ff       	call   8048810 <__memcpy_chk@plt>
 8049482:	8b 4c 24 18          	mov    0x18(%esp),%ecx
 8049486:	8b 54 24 14          	mov    0x14(%esp),%edx
 804948a:	01 d1                	add    %edx,%ecx
 804948c:	89 4b 08             	mov    %ecx,0x8(%ebx)
 804948f:	29 d6                	sub    %edx,%esi
 8049491:	89 73 04             	mov    %esi,0x4(%ebx)
 8049494:	83 fa 01             	cmp    $0x1,%edx
 8049497:	75 11                	jne    80494aa <rio_readlineb+0xb6>
 8049499:	83 c5 01             	add    $0x1,%ebp
 804949c:	0f b6 44 24 2f       	movzbl 0x2f(%esp),%eax
 80494a1:	88 45 ff             	mov    %al,-0x1(%ebp)
 80494a4:	3c 0a                	cmp    $0xa,%al
 80494a6:	75 1a                	jne    80494c2 <rio_readlineb+0xce>
 80494a8:	eb 34                	jmp    80494de <rio_readlineb+0xea>
 80494aa:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 80494af:	75 3e                	jne    80494ef <rio_readlineb+0xfb>
 80494b1:	8b 44 24 10          	mov    0x10(%esp),%eax
 80494b5:	eb 04                	jmp    80494bb <rio_readlineb+0xc7>
 80494b7:	8b 44 24 10          	mov    0x10(%esp),%eax
 80494bb:	83 f8 01             	cmp    $0x1,%eax
 80494be:	75 1e                	jne    80494de <rio_readlineb+0xea>
 80494c0:	eb 34                	jmp    80494f6 <rio_readlineb+0x102>
 80494c2:	83 44 24 10 01       	addl   $0x1,0x10(%esp)
 80494c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 80494cb:	39 44 24 10          	cmp    %eax,0x10(%esp)
 80494cf:	74 0d                	je     80494de <rio_readlineb+0xea>
 80494d1:	e9 76 ff ff ff       	jmp    804944c <rio_readlineb+0x58>
 80494d6:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
 80494dd:	00 
 80494de:	c6 45 00 00          	movb   $0x0,0x0(%ebp)
 80494e2:	8b 44 24 10          	mov    0x10(%esp),%eax
 80494e6:	eb 13                	jmp    80494fb <rio_readlineb+0x107>
 80494e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80494ed:	eb 0c                	jmp    80494fb <rio_readlineb+0x107>
 80494ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80494f4:	eb 05                	jmp    80494fb <rio_readlineb+0x107>
 80494f6:	b8 00 00 00 00       	mov    $0x0,%eax
 80494fb:	83 c4 3c             	add    $0x3c,%esp
 80494fe:	5b                   	pop    %ebx
 80494ff:	5e                   	pop    %esi
 8049500:	5f                   	pop    %edi
 8049501:	5d                   	pop    %ebp
 8049502:	c3                   	ret    

08049503 <submitr>:
 8049503:	55                   	push   %ebp
 8049504:	57                   	push   %edi
 8049505:	56                   	push   %esi
 8049506:	53                   	push   %ebx
 8049507:	81 ec 7c a0 00 00    	sub    $0xa07c,%esp
 804950d:	8b b4 24 90 a0 00 00 	mov    0xa090(%esp),%esi
 8049514:	8b 84 24 98 a0 00 00 	mov    0xa098(%esp),%eax
 804951b:	89 44 24 28          	mov    %eax,0x28(%esp)
 804951f:	8b 84 24 9c a0 00 00 	mov    0xa09c(%esp),%eax
 8049526:	89 44 24 2c          	mov    %eax,0x2c(%esp)
 804952a:	8b 84 24 a0 a0 00 00 	mov    0xa0a0(%esp),%eax
 8049531:	89 44 24 30          	mov    %eax,0x30(%esp)
 8049535:	8b 9c 24 a4 a0 00 00 	mov    0xa0a4(%esp),%ebx
 804953c:	8b 84 24 a8 a0 00 00 	mov    0xa0a8(%esp),%eax
 8049543:	89 44 24 34          	mov    %eax,0x34(%esp)
 8049547:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
 804954d:	89 84 24 6c a0 00 00 	mov    %eax,0xa06c(%esp)
 8049554:	31 c0                	xor    %eax,%eax
 8049556:	c7 44 24 4c 00 00 00 	movl   $0x0,0x4c(%esp)
 804955d:	00 
 804955e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 8049565:	00 
 8049566:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 804956d:	00 
 804956e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 8049575:	e8 26 f3 ff ff       	call   80488a0 <socket@plt>
 804957a:	89 c5                	mov    %eax,%ebp
 804957c:	85 c0                	test   %eax,%eax
 804957e:	79 52                	jns    80495d2 <submitr+0xcf>
 8049580:	8b 44 24 34          	mov    0x34(%esp),%eax
 8049584:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 804958a:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049591:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049598:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 804959f:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 80495a6:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 80495ad:	c7 40 18 63 72 65 61 	movl   $0x61657263,0x18(%eax)
 80495b4:	c7 40 1c 74 65 20 73 	movl   $0x73206574,0x1c(%eax)
 80495bb:	c7 40 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%eax)
 80495c2:	66 c7 40 24 74 00    	movw   $0x74,0x24(%eax)
 80495c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80495cd:	e9 37 06 00 00       	jmp    8049c09 <submitr+0x706>
 80495d2:	89 34 24             	mov    %esi,(%esp)
 80495d5:	e8 e6 f2 ff ff       	call   80488c0 <gethostbyname@plt>
 80495da:	85 c0                	test   %eax,%eax
 80495dc:	75 6c                	jne    804964a <submitr+0x147>
 80495de:	8b 44 24 34          	mov    0x34(%esp),%eax
 80495e2:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 80495e8:	c7 40 04 72 3a 20 44 	movl   $0x44203a72,0x4(%eax)
 80495ef:	c7 40 08 4e 53 20 69 	movl   $0x6920534e,0x8(%eax)
 80495f6:	c7 40 0c 73 20 75 6e 	movl   $0x6e752073,0xc(%eax)
 80495fd:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049604:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 804960b:	c7 40 18 72 65 73 6f 	movl   $0x6f736572,0x18(%eax)
 8049612:	c7 40 1c 6c 76 65 20 	movl   $0x2065766c,0x1c(%eax)
 8049619:	c7 40 20 73 65 72 76 	movl   $0x76726573,0x20(%eax)
 8049620:	c7 40 24 65 72 20 61 	movl   $0x61207265,0x24(%eax)
 8049627:	c7 40 28 64 64 72 65 	movl   $0x65726464,0x28(%eax)
 804962e:	66 c7 40 2c 73 73    	movw   $0x7373,0x2c(%eax)
 8049634:	c6 40 2e 00          	movb   $0x0,0x2e(%eax)
 8049638:	89 2c 24             	mov    %ebp,(%esp)
 804963b:	e8 b0 f2 ff ff       	call   80488f0 <close@plt>
 8049640:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049645:	e9 bf 05 00 00       	jmp    8049c09 <submitr+0x706>
 804964a:	8d 74 24 50          	lea    0x50(%esp),%esi
 804964e:	c7 44 24 50 00 00 00 	movl   $0x0,0x50(%esp)
 8049655:	00 
 8049656:	c7 44 24 54 00 00 00 	movl   $0x0,0x54(%esp)
 804965d:	00 
 804965e:	c7 44 24 58 00 00 00 	movl   $0x0,0x58(%esp)
 8049665:	00 
 8049666:	c7 44 24 5c 00 00 00 	movl   $0x0,0x5c(%esp)
 804966d:	00 
 804966e:	66 c7 44 24 50 02 00 	movw   $0x2,0x50(%esp)
 8049675:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
 804967c:	00 
 804967d:	8b 50 0c             	mov    0xc(%eax),%edx
 8049680:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049684:	8b 40 10             	mov    0x10(%eax),%eax
 8049687:	8b 00                	mov    (%eax),%eax
 8049689:	89 44 24 04          	mov    %eax,0x4(%esp)
 804968d:	8d 44 24 54          	lea    0x54(%esp),%eax
 8049691:	89 04 24             	mov    %eax,(%esp)
 8049694:	e8 67 f1 ff ff       	call   8048800 <__memmove_chk@plt>
 8049699:	0f b7 84 24 94 a0 00 	movzwl 0xa094(%esp),%eax
 80496a0:	00 
 80496a1:	66 c1 c8 08          	ror    $0x8,%ax
 80496a5:	66 89 44 24 52       	mov    %ax,0x52(%esp)
 80496aa:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 80496b1:	00 
 80496b2:	89 74 24 04          	mov    %esi,0x4(%esp)
 80496b6:	89 2c 24             	mov    %ebp,(%esp)
 80496b9:	e8 22 f2 ff ff       	call   80488e0 <connect@plt>
 80496be:	85 c0                	test   %eax,%eax
 80496c0:	79 5e                	jns    8049720 <submitr+0x21d>
 80496c2:	8b 44 24 34          	mov    0x34(%esp),%eax
 80496c6:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 80496cc:	c7 40 04 72 3a 20 55 	movl   $0x55203a72,0x4(%eax)
 80496d3:	c7 40 08 6e 61 62 6c 	movl   $0x6c62616e,0x8(%eax)
 80496da:	c7 40 0c 65 20 74 6f 	movl   $0x6f742065,0xc(%eax)
 80496e1:	c7 40 10 20 63 6f 6e 	movl   $0x6e6f6320,0x10(%eax)
 80496e8:	c7 40 14 6e 65 63 74 	movl   $0x7463656e,0x14(%eax)
 80496ef:	c7 40 18 20 74 6f 20 	movl   $0x206f7420,0x18(%eax)
 80496f6:	c7 40 1c 74 68 65 20 	movl   $0x20656874,0x1c(%eax)
 80496fd:	c7 40 20 73 65 72 76 	movl   $0x76726573,0x20(%eax)
 8049704:	66 c7 40 24 65 72    	movw   $0x7265,0x24(%eax)
 804970a:	c6 40 26 00          	movb   $0x0,0x26(%eax)
 804970e:	89 2c 24             	mov    %ebp,(%esp)
 8049711:	e8 da f1 ff ff       	call   80488f0 <close@plt>
 8049716:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804971b:	e9 e9 04 00 00       	jmp    8049c09 <submitr+0x706>
 8049720:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 8049725:	89 df                	mov    %ebx,%edi
 8049727:	b8 00 00 00 00       	mov    $0x0,%eax
 804972c:	89 d1                	mov    %edx,%ecx
 804972e:	f2 ae                	repnz scas %es:(%edi),%al
 8049730:	f7 d1                	not    %ecx
 8049732:	89 ce                	mov    %ecx,%esi
 8049734:	8b 7c 24 28          	mov    0x28(%esp),%edi
 8049738:	89 d1                	mov    %edx,%ecx
 804973a:	f2 ae                	repnz scas %es:(%edi),%al
 804973c:	89 4c 24 38          	mov    %ecx,0x38(%esp)
 8049740:	8b 7c 24 2c          	mov    0x2c(%esp),%edi
 8049744:	89 d1                	mov    %edx,%ecx
 8049746:	f2 ae                	repnz scas %es:(%edi),%al
 8049748:	f7 d1                	not    %ecx
 804974a:	89 4c 24 3c          	mov    %ecx,0x3c(%esp)
 804974e:	8b 7c 24 30          	mov    0x30(%esp),%edi
 8049752:	89 d1                	mov    %edx,%ecx
 8049754:	f2 ae                	repnz scas %es:(%edi),%al
 8049756:	8b 44 24 3c          	mov    0x3c(%esp),%eax
 804975a:	2b 44 24 38          	sub    0x38(%esp),%eax
 804975e:	29 c8                	sub    %ecx,%eax
 8049760:	89 c2                	mov    %eax,%edx
 8049762:	8d 44 76 fd          	lea    -0x3(%esi,%esi,2),%eax
 8049766:	8d 44 02 7b          	lea    0x7b(%edx,%eax,1),%eax
 804976a:	3d 00 20 00 00       	cmp    $0x2000,%eax
 804976f:	76 77                	jbe    80497e8 <submitr+0x2e5>
 8049771:	8b 44 24 34          	mov    0x34(%esp),%eax
 8049775:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 804977b:	c7 40 04 72 3a 20 52 	movl   $0x52203a72,0x4(%eax)
 8049782:	c7 40 08 65 73 75 6c 	movl   $0x6c757365,0x8(%eax)
 8049789:	c7 40 0c 74 20 73 74 	movl   $0x74732074,0xc(%eax)
 8049790:	c7 40 10 72 69 6e 67 	movl   $0x676e6972,0x10(%eax)
 8049797:	c7 40 14 20 74 6f 6f 	movl   $0x6f6f7420,0x14(%eax)
 804979e:	c7 40 18 20 6c 61 72 	movl   $0x72616c20,0x18(%eax)
 80497a5:	c7 40 1c 67 65 2e 20 	movl   $0x202e6567,0x1c(%eax)
 80497ac:	c7 40 20 49 6e 63 72 	movl   $0x72636e49,0x20(%eax)
 80497b3:	c7 40 24 65 61 73 65 	movl   $0x65736165,0x24(%eax)
 80497ba:	c7 40 28 20 53 55 42 	movl   $0x42555320,0x28(%eax)
 80497c1:	c7 40 2c 4d 49 54 52 	movl   $0x5254494d,0x2c(%eax)
 80497c8:	c7 40 30 5f 4d 41 58 	movl   $0x58414d5f,0x30(%eax)
 80497cf:	c7 40 34 42 55 46 00 	movl   $0x465542,0x34(%eax)
 80497d6:	89 2c 24             	mov    %ebp,(%esp)
 80497d9:	e8 12 f1 ff ff       	call   80488f0 <close@plt>
 80497de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80497e3:	e9 21 04 00 00       	jmp    8049c09 <submitr+0x706>
 80497e8:	8d 94 24 60 20 00 00 	lea    0x2060(%esp),%edx
 80497ef:	b9 00 08 00 00       	mov    $0x800,%ecx
 80497f4:	b8 00 00 00 00       	mov    $0x0,%eax
 80497f9:	89 d7                	mov    %edx,%edi
 80497fb:	f3 ab                	rep stos %eax,%es:(%edi)
 80497fd:	89 df                	mov    %ebx,%edi
 80497ff:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 8049804:	f2 ae                	repnz scas %es:(%edi),%al
 8049806:	f7 d1                	not    %ecx
 8049808:	83 e9 01             	sub    $0x1,%ecx
 804980b:	89 ce                	mov    %ecx,%esi
 804980d:	0f 84 0f 04 00 00    	je     8049c22 <submitr+0x71f>
 8049813:	89 d7                	mov    %edx,%edi
 8049815:	0f b6 03             	movzbl (%ebx),%eax
 8049818:	3c 2a                	cmp    $0x2a,%al
 804981a:	74 21                	je     804983d <submitr+0x33a>
 804981c:	8d 50 d3             	lea    -0x2d(%eax),%edx
 804981f:	80 fa 01             	cmp    $0x1,%dl
 8049822:	76 19                	jbe    804983d <submitr+0x33a>
 8049824:	3c 5f                	cmp    $0x5f,%al
 8049826:	74 15                	je     804983d <submitr+0x33a>
 8049828:	8d 50 d0             	lea    -0x30(%eax),%edx
 804982b:	80 fa 09             	cmp    $0x9,%dl
 804982e:	76 0d                	jbe    804983d <submitr+0x33a>
 8049830:	89 c2                	mov    %eax,%edx
 8049832:	83 e2 df             	and    $0xffffffdf,%edx
 8049835:	83 ea 41             	sub    $0x41,%edx
 8049838:	80 fa 19             	cmp    $0x19,%dl
 804983b:	77 07                	ja     8049844 <submitr+0x341>
 804983d:	8d 57 01             	lea    0x1(%edi),%edx
 8049840:	88 07                	mov    %al,(%edi)
 8049842:	eb 6d                	jmp    80498b1 <submitr+0x3ae>
 8049844:	3c 20                	cmp    $0x20,%al
 8049846:	75 08                	jne    8049850 <submitr+0x34d>
 8049848:	8d 57 01             	lea    0x1(%edi),%edx
 804984b:	c6 07 2b             	movb   $0x2b,(%edi)
 804984e:	eb 61                	jmp    80498b1 <submitr+0x3ae>
 8049850:	8d 50 e0             	lea    -0x20(%eax),%edx
 8049853:	80 fa 5f             	cmp    $0x5f,%dl
 8049856:	76 08                	jbe    8049860 <submitr+0x35d>
 8049858:	3c 09                	cmp    $0x9,%al
 804985a:	0f 85 2d 04 00 00    	jne    8049c8d <submitr+0x78a>
 8049860:	0f b6 c0             	movzbl %al,%eax
 8049863:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049867:	c7 44 24 0c 74 a5 04 	movl   $0x804a574,0xc(%esp)
 804986e:	08 
 804986f:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
 8049876:	00 
 8049877:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 804987e:	00 
 804987f:	8d 84 24 60 80 00 00 	lea    0x8060(%esp),%eax
 8049886:	89 04 24             	mov    %eax,(%esp)
 8049889:	e8 82 f0 ff ff       	call   8048910 <__sprintf_chk@plt>
 804988e:	0f b6 84 24 60 80 00 	movzbl 0x8060(%esp),%eax
 8049895:	00 
 8049896:	88 07                	mov    %al,(%edi)
 8049898:	0f b6 84 24 61 80 00 	movzbl 0x8061(%esp),%eax
 804989f:	00 
 80498a0:	88 47 01             	mov    %al,0x1(%edi)
 80498a3:	8d 57 03             	lea    0x3(%edi),%edx
 80498a6:	0f b6 84 24 62 80 00 	movzbl 0x8062(%esp),%eax
 80498ad:	00 
 80498ae:	88 47 02             	mov    %al,0x2(%edi)
 80498b1:	83 c3 01             	add    $0x1,%ebx
 80498b4:	83 ee 01             	sub    $0x1,%esi
 80498b7:	0f 84 65 03 00 00    	je     8049c22 <submitr+0x71f>
 80498bd:	89 d7                	mov    %edx,%edi
 80498bf:	e9 51 ff ff ff       	jmp    8049815 <submitr+0x312>
 80498c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 80498c8:	89 74 24 04          	mov    %esi,0x4(%esp)
 80498cc:	89 2c 24             	mov    %ebp,(%esp)
 80498cf:	e8 7c ef ff ff       	call   8048850 <write@plt>
 80498d4:	85 c0                	test   %eax,%eax
 80498d6:	7f 0f                	jg     80498e7 <submitr+0x3e4>
 80498d8:	e8 a3 ef ff ff       	call   8048880 <__errno_location@plt>
 80498dd:	83 38 04             	cmpl   $0x4,(%eax)
 80498e0:	75 0f                	jne    80498f1 <submitr+0x3ee>
 80498e2:	b8 00 00 00 00       	mov    $0x0,%eax
 80498e7:	01 c6                	add    %eax,%esi
 80498e9:	29 c3                	sub    %eax,%ebx
 80498eb:	75 d7                	jne    80498c4 <submitr+0x3c1>
 80498ed:	85 ff                	test   %edi,%edi
 80498ef:	79 62                	jns    8049953 <submitr+0x450>
 80498f1:	8b 44 24 34          	mov    0x34(%esp),%eax
 80498f5:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 80498fb:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049902:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049909:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049910:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049917:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 804991e:	c7 40 18 77 72 69 74 	movl   $0x74697277,0x18(%eax)
 8049925:	c7 40 1c 65 20 74 6f 	movl   $0x6f742065,0x1c(%eax)
 804992c:	c7 40 20 20 74 68 65 	movl   $0x65687420,0x20(%eax)
 8049933:	c7 40 24 20 73 65 72 	movl   $0x72657320,0x24(%eax)
 804993a:	c7 40 28 76 65 72 00 	movl   $0x726576,0x28(%eax)
 8049941:	89 2c 24             	mov    %ebp,(%esp)
 8049944:	e8 a7 ef ff ff       	call   80488f0 <close@plt>
 8049949:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804994e:	e9 b6 02 00 00       	jmp    8049c09 <submitr+0x706>
 8049953:	89 ac 24 60 80 00 00 	mov    %ebp,0x8060(%esp)
 804995a:	c7 84 24 64 80 00 00 	movl   $0x0,0x8064(%esp)
 8049961:	00 00 00 00 
 8049965:	8d 84 24 6c 80 00 00 	lea    0x806c(%esp),%eax
 804996c:	89 84 24 68 80 00 00 	mov    %eax,0x8068(%esp)
 8049973:	b9 00 20 00 00       	mov    $0x2000,%ecx
 8049978:	8d 54 24 60          	lea    0x60(%esp),%edx
 804997c:	8d 84 24 60 80 00 00 	lea    0x8060(%esp),%eax
 8049983:	e8 6c fa ff ff       	call   80493f4 <rio_readlineb>
 8049988:	85 c0                	test   %eax,%eax
 804998a:	7f 76                	jg     8049a02 <submitr+0x4ff>
 804998c:	8b 44 24 34          	mov    0x34(%esp),%eax
 8049990:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049996:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 804999d:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 80499a4:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 80499ab:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 80499b2:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 80499b9:	c7 40 18 72 65 61 64 	movl   $0x64616572,0x18(%eax)
 80499c0:	c7 40 1c 20 66 69 72 	movl   $0x72696620,0x1c(%eax)
 80499c7:	c7 40 20 73 74 20 68 	movl   $0x68207473,0x20(%eax)
 80499ce:	c7 40 24 65 61 64 65 	movl   $0x65646165,0x24(%eax)
 80499d5:	c7 40 28 72 20 66 72 	movl   $0x72662072,0x28(%eax)
 80499dc:	c7 40 2c 6f 6d 20 73 	movl   $0x73206d6f,0x2c(%eax)
 80499e3:	c7 40 30 65 72 76 65 	movl   $0x65767265,0x30(%eax)
 80499ea:	66 c7 40 34 72 00    	movw   $0x72,0x34(%eax)
 80499f0:	89 2c 24             	mov    %ebp,(%esp)
 80499f3:	e8 f8 ee ff ff       	call   80488f0 <close@plt>
 80499f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80499fd:	e9 07 02 00 00       	jmp    8049c09 <submitr+0x706>
 8049a02:	8d 84 24 60 60 00 00 	lea    0x6060(%esp),%eax
 8049a09:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049a0d:	8d 44 24 4c          	lea    0x4c(%esp),%eax
 8049a11:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049a15:	8d 84 24 60 40 00 00 	lea    0x4060(%esp),%eax
 8049a1c:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049a20:	c7 44 24 04 7b a5 04 	movl   $0x804a57b,0x4(%esp)
 8049a27:	08 
 8049a28:	8d 44 24 60          	lea    0x60(%esp),%eax
 8049a2c:	89 04 24             	mov    %eax,(%esp)
 8049a2f:	e8 2c ee ff ff       	call   8048860 <__isoc99_sscanf@plt>
 8049a34:	8b 44 24 4c          	mov    0x4c(%esp),%eax
 8049a38:	3d c8 00 00 00       	cmp    $0xc8,%eax
 8049a3d:	0f 84 cb 00 00 00    	je     8049b0e <submitr+0x60b>
 8049a43:	8d 94 24 60 60 00 00 	lea    0x6060(%esp),%edx
 8049a4a:	89 54 24 14          	mov    %edx,0x14(%esp)
 8049a4e:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049a52:	c7 44 24 0c 8c a4 04 	movl   $0x804a48c,0xc(%esp)
 8049a59:	08 
 8049a5a:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
 8049a61:	ff 
 8049a62:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049a69:	00 
 8049a6a:	8b 44 24 34          	mov    0x34(%esp),%eax
 8049a6e:	89 04 24             	mov    %eax,(%esp)
 8049a71:	e8 9a ee ff ff       	call   8048910 <__sprintf_chk@plt>
 8049a76:	89 2c 24             	mov    %ebp,(%esp)
 8049a79:	e8 72 ee ff ff       	call   80488f0 <close@plt>
 8049a7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049a83:	e9 81 01 00 00       	jmp    8049c09 <submitr+0x706>
 8049a88:	b9 00 20 00 00       	mov    $0x2000,%ecx
 8049a8d:	8d 54 24 60          	lea    0x60(%esp),%edx
 8049a91:	8d 84 24 60 80 00 00 	lea    0x8060(%esp),%eax
 8049a98:	e8 57 f9 ff ff       	call   80493f4 <rio_readlineb>
 8049a9d:	85 c0                	test   %eax,%eax
 8049a9f:	7f 6d                	jg     8049b0e <submitr+0x60b>
 8049aa1:	8b 44 24 34          	mov    0x34(%esp),%eax
 8049aa5:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049aab:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049ab2:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049ab9:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049ac0:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049ac7:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049ace:	c7 40 18 72 65 61 64 	movl   $0x64616572,0x18(%eax)
 8049ad5:	c7 40 1c 20 68 65 61 	movl   $0x61656820,0x1c(%eax)
 8049adc:	c7 40 20 64 65 72 73 	movl   $0x73726564,0x20(%eax)
 8049ae3:	c7 40 24 20 66 72 6f 	movl   $0x6f726620,0x24(%eax)
 8049aea:	c7 40 28 6d 20 73 65 	movl   $0x6573206d,0x28(%eax)
 8049af1:	c7 40 2c 72 76 65 72 	movl   $0x72657672,0x2c(%eax)
 8049af8:	c6 40 30 00          	movb   $0x0,0x30(%eax)
 8049afc:	89 2c 24             	mov    %ebp,(%esp)
 8049aff:	e8 ec ed ff ff       	call   80488f0 <close@plt>
 8049b04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049b09:	e9 fb 00 00 00       	jmp    8049c09 <submitr+0x706>
 8049b0e:	80 7c 24 60 0d       	cmpb   $0xd,0x60(%esp)
 8049b13:	0f 85 6f ff ff ff    	jne    8049a88 <submitr+0x585>
 8049b19:	80 7c 24 61 0a       	cmpb   $0xa,0x61(%esp)
 8049b1e:	0f 85 64 ff ff ff    	jne    8049a88 <submitr+0x585>
 8049b24:	80 7c 24 62 00       	cmpb   $0x0,0x62(%esp)
 8049b29:	0f 85 59 ff ff ff    	jne    8049a88 <submitr+0x585>
 8049b2f:	b9 00 20 00 00       	mov    $0x2000,%ecx
 8049b34:	8d 54 24 60          	lea    0x60(%esp),%edx
 8049b38:	8d 84 24 60 80 00 00 	lea    0x8060(%esp),%eax
 8049b3f:	e8 b0 f8 ff ff       	call   80493f4 <rio_readlineb>
 8049b44:	85 c0                	test   %eax,%eax
 8049b46:	7f 74                	jg     8049bbc <submitr+0x6b9>
 8049b48:	8b 44 24 34          	mov    0x34(%esp),%eax
 8049b4c:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 8049b52:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049b59:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049b60:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049b67:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049b6e:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 8049b75:	c7 40 18 72 65 61 64 	movl   $0x64616572,0x18(%eax)
 8049b7c:	c7 40 1c 20 73 74 61 	movl   $0x61747320,0x1c(%eax)
 8049b83:	c7 40 20 74 75 73 20 	movl   $0x20737574,0x20(%eax)
 8049b8a:	c7 40 24 6d 65 73 73 	movl   $0x7373656d,0x24(%eax)
 8049b91:	c7 40 28 61 67 65 20 	movl   $0x20656761,0x28(%eax)
 8049b98:	c7 40 2c 66 72 6f 6d 	movl   $0x6d6f7266,0x2c(%eax)
 8049b9f:	c7 40 30 20 73 65 72 	movl   $0x72657320,0x30(%eax)
 8049ba6:	c7 40 34 76 65 72 00 	movl   $0x726576,0x34(%eax)
 8049bad:	89 2c 24             	mov    %ebp,(%esp)
 8049bb0:	e8 3b ed ff ff       	call   80488f0 <close@plt>
 8049bb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049bba:	eb 4d                	jmp    8049c09 <submitr+0x706>
 8049bbc:	8d 44 24 60          	lea    0x60(%esp),%eax
 8049bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049bc4:	8b 74 24 34          	mov    0x34(%esp),%esi
 8049bc8:	89 34 24             	mov    %esi,(%esp)
 8049bcb:	e8 00 ec ff ff       	call   80487d0 <strcpy@plt>
 8049bd0:	89 2c 24             	mov    %ebp,(%esp)
 8049bd3:	e8 18 ed ff ff       	call   80488f0 <close@plt>
 8049bd8:	0f b6 06             	movzbl (%esi),%eax
 8049bdb:	ba 4f 00 00 00       	mov    $0x4f,%edx
 8049be0:	29 c2                	sub    %eax,%edx
 8049be2:	75 1b                	jne    8049bff <submitr+0x6fc>
 8049be4:	8b 44 24 34          	mov    0x34(%esp),%eax
 8049be8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
 8049bec:	ba 4b 00 00 00       	mov    $0x4b,%edx
 8049bf1:	29 c2                	sub    %eax,%edx
 8049bf3:	75 0a                	jne    8049bff <submitr+0x6fc>
 8049bf5:	8b 44 24 34          	mov    0x34(%esp),%eax
 8049bf9:	0f b6 50 02          	movzbl 0x2(%eax),%edx
 8049bfd:	f7 da                	neg    %edx
 8049bff:	85 d2                	test   %edx,%edx
 8049c01:	0f 95 c0             	setne  %al
 8049c04:	0f b6 c0             	movzbl %al,%eax
 8049c07:	f7 d8                	neg    %eax
 8049c09:	8b 8c 24 6c a0 00 00 	mov    0xa06c(%esp),%ecx
 8049c10:	65 33 0d 14 00 00 00 	xor    %gs:0x14,%ecx
 8049c17:	0f 84 ef 00 00 00    	je     8049d0c <submitr+0x809>
 8049c1d:	e9 e5 00 00 00       	jmp    8049d07 <submitr+0x804>
 8049c22:	8d 84 24 60 20 00 00 	lea    0x2060(%esp),%eax
 8049c29:	89 44 24 1c          	mov    %eax,0x1c(%esp)
 8049c2d:	8b 44 24 30          	mov    0x30(%esp),%eax
 8049c31:	89 44 24 18          	mov    %eax,0x18(%esp)
 8049c35:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 8049c39:	89 44 24 14          	mov    %eax,0x14(%esp)
 8049c3d:	8b 44 24 28          	mov    0x28(%esp),%eax
 8049c41:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049c45:	c7 44 24 0c bc a4 04 	movl   $0x804a4bc,0xc(%esp)
 8049c4c:	08 
 8049c4d:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
 8049c54:	00 
 8049c55:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049c5c:	00 
 8049c5d:	8d 7c 24 60          	lea    0x60(%esp),%edi
 8049c61:	89 3c 24             	mov    %edi,(%esp)
 8049c64:	e8 a7 ec ff ff       	call   8048910 <__sprintf_chk@plt>
 8049c69:	b8 00 00 00 00       	mov    $0x0,%eax
 8049c6e:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 8049c73:	f2 ae                	repnz scas %es:(%edi),%al
 8049c75:	f7 d1                	not    %ecx
 8049c77:	83 e9 01             	sub    $0x1,%ecx
 8049c7a:	89 cf                	mov    %ecx,%edi
 8049c7c:	0f 84 d1 fc ff ff    	je     8049953 <submitr+0x450>
 8049c82:	89 cb                	mov    %ecx,%ebx
 8049c84:	8d 74 24 60          	lea    0x60(%esp),%esi
 8049c88:	e9 37 fc ff ff       	jmp    80498c4 <submitr+0x3c1>
 8049c8d:	8b 4c 24 34          	mov    0x34(%esp),%ecx
 8049c91:	89 cf                	mov    %ecx,%edi
 8049c93:	be 08 a5 04 08       	mov    $0x804a508,%esi
 8049c98:	b8 43 00 00 00       	mov    $0x43,%eax
 8049c9d:	f6 c1 01             	test   $0x1,%cl
 8049ca0:	74 16                	je     8049cb8 <submitr+0x7b5>
 8049ca2:	0f b6 05 08 a5 04 08 	movzbl 0x804a508,%eax
 8049ca9:	88 01                	mov    %al,(%ecx)
 8049cab:	8d 79 01             	lea    0x1(%ecx),%edi
 8049cae:	be 09 a5 04 08       	mov    $0x804a509,%esi
 8049cb3:	b8 42 00 00 00       	mov    $0x42,%eax
 8049cb8:	f7 c7 02 00 00 00    	test   $0x2,%edi
 8049cbe:	74 0f                	je     8049ccf <submitr+0x7cc>
 8049cc0:	0f b7 16             	movzwl (%esi),%edx
 8049cc3:	66 89 17             	mov    %dx,(%edi)
 8049cc6:	83 c7 02             	add    $0x2,%edi
 8049cc9:	83 c6 02             	add    $0x2,%esi
 8049ccc:	83 e8 02             	sub    $0x2,%eax
 8049ccf:	89 c1                	mov    %eax,%ecx
 8049cd1:	c1 e9 02             	shr    $0x2,%ecx
 8049cd4:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
 8049cd6:	ba 00 00 00 00       	mov    $0x0,%edx
 8049cdb:	a8 02                	test   $0x2,%al
 8049cdd:	74 0b                	je     8049cea <submitr+0x7e7>
 8049cdf:	0f b7 16             	movzwl (%esi),%edx
 8049ce2:	66 89 17             	mov    %dx,(%edi)
 8049ce5:	ba 02 00 00 00       	mov    $0x2,%edx
 8049cea:	a8 01                	test   $0x1,%al
 8049cec:	74 07                	je     8049cf5 <submitr+0x7f2>
 8049cee:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
 8049cf2:	88 04 17             	mov    %al,(%edi,%edx,1)
 8049cf5:	89 2c 24             	mov    %ebp,(%esp)
 8049cf8:	e8 f3 eb ff ff       	call   80488f0 <close@plt>
 8049cfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049d02:	e9 02 ff ff ff       	jmp    8049c09 <submitr+0x706>
 8049d07:	e8 b4 ea ff ff       	call   80487c0 <__stack_chk_fail@plt>
 8049d0c:	81 c4 7c a0 00 00    	add    $0xa07c,%esp
 8049d12:	5b                   	pop    %ebx
 8049d13:	5e                   	pop    %esi
 8049d14:	5f                   	pop    %edi
 8049d15:	5d                   	pop    %ebp
 8049d16:	c3                   	ret    

08049d17 <init_timeout>:
 8049d17:	53                   	push   %ebx
 8049d18:	83 ec 18             	sub    $0x18,%esp
 8049d1b:	8b 5c 24 20          	mov    0x20(%esp),%ebx
 8049d1f:	85 db                	test   %ebx,%ebx
 8049d21:	74 26                	je     8049d49 <init_timeout+0x32>
 8049d23:	c7 44 24 04 c0 93 04 	movl   $0x80493c0,0x4(%esp)
 8049d2a:	08 
 8049d2b:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 8049d32:	e8 59 ea ff ff       	call   8048790 <signal@plt>
 8049d37:	85 db                	test   %ebx,%ebx
 8049d39:	b8 00 00 00 00       	mov    $0x0,%eax
 8049d3e:	0f 48 d8             	cmovs  %eax,%ebx
 8049d41:	89 1c 24             	mov    %ebx,(%esp)
 8049d44:	e8 67 ea ff ff       	call   80487b0 <alarm@plt>
 8049d49:	83 c4 18             	add    $0x18,%esp
 8049d4c:	5b                   	pop    %ebx
 8049d4d:	c3                   	ret    

08049d4e <init_driver>:
 8049d4e:	57                   	push   %edi
 8049d4f:	56                   	push   %esi
 8049d50:	53                   	push   %ebx
 8049d51:	83 ec 40             	sub    $0x40,%esp
 8049d54:	8b 74 24 50          	mov    0x50(%esp),%esi
 8049d58:	65 a1 14 00 00 00    	mov    %gs:0x14,%eax
 8049d5e:	89 44 24 3c          	mov    %eax,0x3c(%esp)
 8049d62:	31 c0                	xor    %eax,%eax
 8049d64:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049d6b:	00 
 8049d6c:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
 8049d73:	e8 18 ea ff ff       	call   8048790 <signal@plt>
 8049d78:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049d7f:	00 
 8049d80:	c7 04 24 1d 00 00 00 	movl   $0x1d,(%esp)
 8049d87:	e8 04 ea ff ff       	call   8048790 <signal@plt>
 8049d8c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049d93:	00 
 8049d94:	c7 04 24 1d 00 00 00 	movl   $0x1d,(%esp)
 8049d9b:	e8 f0 e9 ff ff       	call   8048790 <signal@plt>
 8049da0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 8049da7:	00 
 8049da8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049daf:	00 
 8049db0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 8049db7:	e8 e4 ea ff ff       	call   80488a0 <socket@plt>
 8049dbc:	89 c3                	mov    %eax,%ebx
 8049dbe:	85 c0                	test   %eax,%eax
 8049dc0:	79 4e                	jns    8049e10 <init_driver+0xc2>
 8049dc2:	c7 06 45 72 72 6f    	movl   $0x6f727245,(%esi)
 8049dc8:	c7 46 04 72 3a 20 43 	movl   $0x43203a72,0x4(%esi)
 8049dcf:	c7 46 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%esi)
 8049dd6:	c7 46 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%esi)
 8049ddd:	c7 46 10 61 62 6c 65 	movl   $0x656c6261,0x10(%esi)
 8049de4:	c7 46 14 20 74 6f 20 	movl   $0x206f7420,0x14(%esi)
 8049deb:	c7 46 18 63 72 65 61 	movl   $0x61657263,0x18(%esi)
 8049df2:	c7 46 1c 74 65 20 73 	movl   $0x73206574,0x1c(%esi)
 8049df9:	c7 46 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%esi)
 8049e00:	66 c7 46 24 74 00    	movw   $0x74,0x24(%esi)
 8049e06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049e0b:	e9 33 01 00 00       	jmp    8049f43 <init_driver+0x1f5>
 8049e10:	c7 04 24 8c a5 04 08 	movl   $0x804a58c,(%esp)
 8049e17:	e8 a4 ea ff ff       	call   80488c0 <gethostbyname@plt>
 8049e1c:	85 c0                	test   %eax,%eax
 8049e1e:	75 68                	jne    8049e88 <init_driver+0x13a>
 8049e20:	c7 06 45 72 72 6f    	movl   $0x6f727245,(%esi)
 8049e26:	c7 46 04 72 3a 20 44 	movl   $0x44203a72,0x4(%esi)
 8049e2d:	c7 46 08 4e 53 20 69 	movl   $0x6920534e,0x8(%esi)
 8049e34:	c7 46 0c 73 20 75 6e 	movl   $0x6e752073,0xc(%esi)
 8049e3b:	c7 46 10 61 62 6c 65 	movl   $0x656c6261,0x10(%esi)
 8049e42:	c7 46 14 20 74 6f 20 	movl   $0x206f7420,0x14(%esi)
 8049e49:	c7 46 18 72 65 73 6f 	movl   $0x6f736572,0x18(%esi)
 8049e50:	c7 46 1c 6c 76 65 20 	movl   $0x2065766c,0x1c(%esi)
 8049e57:	c7 46 20 73 65 72 76 	movl   $0x76726573,0x20(%esi)
 8049e5e:	c7 46 24 65 72 20 61 	movl   $0x61207265,0x24(%esi)
 8049e65:	c7 46 28 64 64 72 65 	movl   $0x65726464,0x28(%esi)
 8049e6c:	66 c7 46 2c 73 73    	movw   $0x7373,0x2c(%esi)
 8049e72:	c6 46 2e 00          	movb   $0x0,0x2e(%esi)
 8049e76:	89 1c 24             	mov    %ebx,(%esp)
 8049e79:	e8 72 ea ff ff       	call   80488f0 <close@plt>
 8049e7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049e83:	e9 bb 00 00 00       	jmp    8049f43 <init_driver+0x1f5>
 8049e88:	8d 7c 24 2c          	lea    0x2c(%esp),%edi
 8049e8c:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
 8049e93:	00 
 8049e94:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
 8049e9b:	00 
 8049e9c:	c7 44 24 34 00 00 00 	movl   $0x0,0x34(%esp)
 8049ea3:	00 
 8049ea4:	c7 44 24 38 00 00 00 	movl   $0x0,0x38(%esp)
 8049eab:	00 
 8049eac:	66 c7 44 24 2c 02 00 	movw   $0x2,0x2c(%esp)
 8049eb3:	c7 44 24 0c 0c 00 00 	movl   $0xc,0xc(%esp)
 8049eba:	00 
 8049ebb:	8b 50 0c             	mov    0xc(%eax),%edx
 8049ebe:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049ec2:	8b 40 10             	mov    0x10(%eax),%eax
 8049ec5:	8b 00                	mov    (%eax),%eax
 8049ec7:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049ecb:	8d 44 24 30          	lea    0x30(%esp),%eax
 8049ecf:	89 04 24             	mov    %eax,(%esp)
 8049ed2:	e8 29 e9 ff ff       	call   8048800 <__memmove_chk@plt>
 8049ed7:	66 c7 44 24 2e 3b 6e 	movw   $0x6e3b,0x2e(%esp)
 8049ede:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8049ee5:	00 
 8049ee6:	89 7c 24 04          	mov    %edi,0x4(%esp)
 8049eea:	89 1c 24             	mov    %ebx,(%esp)
 8049eed:	e8 ee e9 ff ff       	call   80488e0 <connect@plt>
 8049ef2:	85 c0                	test   %eax,%eax
 8049ef4:	79 37                	jns    8049f2d <init_driver+0x1df>
 8049ef6:	c7 44 24 10 8c a5 04 	movl   $0x804a58c,0x10(%esp)
 8049efd:	08 
 8049efe:	c7 44 24 0c 4c a5 04 	movl   $0x804a54c,0xc(%esp)
 8049f05:	08 
 8049f06:	c7 44 24 08 ff ff ff 	movl   $0xffffffff,0x8(%esp)
 8049f0d:	ff 
 8049f0e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049f15:	00 
 8049f16:	89 34 24             	mov    %esi,(%esp)
 8049f19:	e8 f2 e9 ff ff       	call   8048910 <__sprintf_chk@plt>
 8049f1e:	89 1c 24             	mov    %ebx,(%esp)
 8049f21:	e8 ca e9 ff ff       	call   80488f0 <close@plt>
 8049f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049f2b:	eb 16                	jmp    8049f43 <init_driver+0x1f5>
 8049f2d:	89 1c 24             	mov    %ebx,(%esp)
 8049f30:	e8 bb e9 ff ff       	call   80488f0 <close@plt>
 8049f35:	66 c7 06 4f 4b       	movw   $0x4b4f,(%esi)
 8049f3a:	c6 46 02 00          	movb   $0x0,0x2(%esi)
 8049f3e:	b8 00 00 00 00       	mov    $0x0,%eax
 8049f43:	8b 4c 24 3c          	mov    0x3c(%esp),%ecx
 8049f47:	65 33 0d 14 00 00 00 	xor    %gs:0x14,%ecx
 8049f4e:	74 05                	je     8049f55 <init_driver+0x207>
 8049f50:	e8 6b e8 ff ff       	call   80487c0 <__stack_chk_fail@plt>
 8049f55:	83 c4 40             	add    $0x40,%esp
 8049f58:	5b                   	pop    %ebx
 8049f59:	5e                   	pop    %esi
 8049f5a:	5f                   	pop    %edi
 8049f5b:	c3                   	ret    

08049f5c <driver_post>:
 8049f5c:	53                   	push   %ebx
 8049f5d:	83 ec 28             	sub    $0x28,%esp
 8049f60:	8b 44 24 30          	mov    0x30(%esp),%eax
 8049f64:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
 8049f68:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
 8049f6d:	74 2c                	je     8049f9b <driver_post+0x3f>
 8049f6f:	8b 44 24 34          	mov    0x34(%esp),%eax
 8049f73:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049f77:	c7 44 24 04 9a a5 04 	movl   $0x804a59a,0x4(%esp)
 8049f7e:	08 
 8049f7f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8049f86:	e8 05 e9 ff ff       	call   8048890 <__printf_chk@plt>
 8049f8b:	66 c7 03 4f 4b       	movw   $0x4b4f,(%ebx)
 8049f90:	c6 43 02 00          	movb   $0x0,0x2(%ebx)
 8049f94:	b8 00 00 00 00       	mov    $0x0,%eax
 8049f99:	eb 4d                	jmp    8049fe8 <driver_post+0x8c>
 8049f9b:	85 c0                	test   %eax,%eax
 8049f9d:	74 3b                	je     8049fda <driver_post+0x7e>
 8049f9f:	80 38 00             	cmpb   $0x0,(%eax)
 8049fa2:	74 36                	je     8049fda <driver_post+0x7e>
 8049fa4:	89 5c 24 18          	mov    %ebx,0x18(%esp)
 8049fa8:	8b 54 24 34          	mov    0x34(%esp),%edx
 8049fac:	89 54 24 14          	mov    %edx,0x14(%esp)
 8049fb0:	c7 44 24 10 b1 a5 04 	movl   $0x804a5b1,0x10(%esp)
 8049fb7:	08 
 8049fb8:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049fbc:	c7 44 24 08 b9 a5 04 	movl   $0x804a5b9,0x8(%esp)
 8049fc3:	08 
 8049fc4:	c7 44 24 04 6e 3b 00 	movl   $0x3b6e,0x4(%esp)
 8049fcb:	00 
 8049fcc:	c7 04 24 8c a5 04 08 	movl   $0x804a58c,(%esp)
 8049fd3:	e8 2b f5 ff ff       	call   8049503 <submitr>
 8049fd8:	eb 0e                	jmp    8049fe8 <driver_post+0x8c>
 8049fda:	66 c7 03 4f 4b       	movw   $0x4b4f,(%ebx)
 8049fdf:	c6 43 02 00          	movb   $0x0,0x2(%ebx)
 8049fe3:	b8 00 00 00 00       	mov    $0x0,%eax
 8049fe8:	83 c4 28             	add    $0x28,%esp
 8049feb:	5b                   	pop    %ebx
 8049fec:	c3                   	ret    
 8049fed:	66 90                	xchg   %ax,%ax
 8049fef:	90                   	nop

08049ff0 <__libc_csu_init>:
 8049ff0:	55                   	push   %ebp
 8049ff1:	57                   	push   %edi
 8049ff2:	31 ff                	xor    %edi,%edi
 8049ff4:	56                   	push   %esi
 8049ff5:	53                   	push   %ebx
 8049ff6:	e8 55 e9 ff ff       	call   8048950 <__x86.get_pc_thunk.bx>
 8049ffb:	81 c3 05 20 00 00    	add    $0x2005,%ebx
 804a001:	83 ec 1c             	sub    $0x1c,%esp
 804a004:	8b 6c 24 30          	mov    0x30(%esp),%ebp
 804a008:	8d b3 0c ff ff ff    	lea    -0xf4(%ebx),%esi
 804a00e:	e8 11 e7 ff ff       	call   8048724 <_init>
 804a013:	8d 83 08 ff ff ff    	lea    -0xf8(%ebx),%eax
 804a019:	29 c6                	sub    %eax,%esi
 804a01b:	c1 fe 02             	sar    $0x2,%esi
 804a01e:	85 f6                	test   %esi,%esi
 804a020:	74 27                	je     804a049 <__libc_csu_init+0x59>
 804a022:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 804a028:	8b 44 24 38          	mov    0x38(%esp),%eax
 804a02c:	89 2c 24             	mov    %ebp,(%esp)
 804a02f:	89 44 24 08          	mov    %eax,0x8(%esp)
 804a033:	8b 44 24 34          	mov    0x34(%esp),%eax
 804a037:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a03b:	ff 94 bb 08 ff ff ff 	call   *-0xf8(%ebx,%edi,4)
 804a042:	83 c7 01             	add    $0x1,%edi
 804a045:	39 f7                	cmp    %esi,%edi
 804a047:	75 df                	jne    804a028 <__libc_csu_init+0x38>
 804a049:	83 c4 1c             	add    $0x1c,%esp
 804a04c:	5b                   	pop    %ebx
 804a04d:	5e                   	pop    %esi
 804a04e:	5f                   	pop    %edi
 804a04f:	5d                   	pop    %ebp
 804a050:	c3                   	ret    
 804a051:	eb 0d                	jmp    804a060 <__libc_csu_fini>
 804a053:	90                   	nop
 804a054:	90                   	nop
 804a055:	90                   	nop
 804a056:	90                   	nop
 804a057:	90                   	nop
 804a058:	90                   	nop
 804a059:	90                   	nop
 804a05a:	90                   	nop
 804a05b:	90                   	nop
 804a05c:	90                   	nop
 804a05d:	90                   	nop
 804a05e:	90                   	nop
 804a05f:	90                   	nop

0804a060 <__libc_csu_fini>:
 804a060:	f3 c3                	repz ret 

Disassembly of section .fini:

0804a064 <_fini>:
 804a064:	53                   	push   %ebx
 804a065:	83 ec 08             	sub    $0x8,%esp
 804a068:	e8 e3 e8 ff ff       	call   8048950 <__x86.get_pc_thunk.bx>
 804a06d:	81 c3 93 1f 00 00    	add    $0x1f93,%ebx
 804a073:	83 c4 08             	add    $0x8,%esp
 804a076:	5b                   	pop    %ebx
 804a077:	c3                   	ret    
