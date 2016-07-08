
bufbomb：     文件格式 elf32-i386


Disassembly of section bstack:

55586000 <_reserved>:
	...

Disassembly of section .interp:

08048154 <.interp>:
 8048154:	2f                   	das    
 8048155:	6c                   	insb   (%dx),%es:(%edi)
 8048156:	69 62 2f 6c 64 2d 6c 	imul   $0x6c2d646c,0x2f(%edx),%esp
 804815d:	69 6e 75 78 2e 73 6f 	imul   $0x6f732e78,0x75(%esi),%ebp
 8048164:	2e 32 00             	xor    %cs:(%eax),%al

Disassembly of section .note.ABI-tag:

08048168 <.note.ABI-tag>:
 8048168:	04 00                	add    $0x0,%al
 804816a:	00 00                	add    %al,(%eax)
 804816c:	10 00                	adc    %al,(%eax)
 804816e:	00 00                	add    %al,(%eax)
 8048170:	01 00                	add    %eax,(%eax)
 8048172:	00 00                	add    %al,(%eax)
 8048174:	47                   	inc    %edi
 8048175:	4e                   	dec    %esi
 8048176:	55                   	push   %ebp
 8048177:	00 00                	add    %al,(%eax)
 8048179:	00 00                	add    %al,(%eax)
 804817b:	00 02                	add    %al,(%edx)
 804817d:	00 00                	add    %al,(%eax)
 804817f:	00 06                	add    %al,(%esi)
 8048181:	00 00                	add    %al,(%eax)
 8048183:	00 1a                	add    %bl,(%edx)
 8048185:	00 00                	add    %al,(%eax)
	...

Disassembly of section .note.gnu.build-id:

08048188 <.note.gnu.build-id>:
 8048188:	04 00                	add    $0x0,%al
 804818a:	00 00                	add    %al,(%eax)
 804818c:	14 00                	adc    $0x0,%al
 804818e:	00 00                	add    %al,(%eax)
 8048190:	03 00                	add    (%eax),%eax
 8048192:	00 00                	add    %al,(%eax)
 8048194:	47                   	inc    %edi
 8048195:	4e                   	dec    %esi
 8048196:	55                   	push   %ebp
 8048197:	00 a9 19 b1 59 c4    	add    %ch,-0x3ba64ee7(%ecx)
 804819d:	ae                   	scas   %es:(%edi),%al
 804819e:	99                   	cltd   
 804819f:	17                   	pop    %ss
 80481a0:	0a 04 e9             	or     (%ecx,%ebp,8),%al
 80481a3:	51                   	push   %ecx
 80481a4:	97                   	xchg   %eax,%edi
 80481a5:	75 a7                	jne    804814e <_init-0x72a>
 80481a7:	bf b1 86 51 8f       	mov    $0x8f5186b1,%edi

Disassembly of section .hash:

080481ac <.hash>:
 80481ac:	25 00 00 00 27       	and    $0x27000000,%eax
 80481b1:	00 00                	add    %al,(%eax)
 80481b3:	00 1f                	add    %bl,(%edi)
 80481b5:	00 00                	add    %al,(%eax)
 80481b7:	00 19                	add    %bl,(%ecx)
 80481b9:	00 00                	add    %al,(%eax)
 80481bb:	00 04 00             	add    %al,(%eax,%eax,1)
 80481be:	00 00                	add    %al,(%eax)
 80481c0:	0c 00                	or     $0x0,%al
 80481c2:	00 00                	add    %al,(%eax)
 80481c4:	1b 00                	sbb    (%eax),%eax
	...
 80481d2:	00 00                	add    %al,(%eax)
 80481d4:	0e                   	push   %cs
 80481d5:	00 00                	add    %al,(%eax)
 80481d7:	00 23                	add    %ah,(%ebx)
 80481d9:	00 00                	add    %al,(%eax)
 80481db:	00 1d 00 00 00 00    	add    %bl,0x0
	...
 80481e9:	00 00                	add    %al,(%eax)
 80481eb:	00 12                	add    %dl,(%edx)
 80481ed:	00 00                	add    %al,(%eax)
 80481ef:	00 1e                	add    %bl,(%esi)
 80481f1:	00 00                	add    %al,(%eax)
 80481f3:	00 21                	add    %ah,(%ecx)
 80481f5:	00 00                	add    %al,(%eax)
 80481f7:	00 00                	add    %al,(%eax)
 80481f9:	00 00                	add    %al,(%eax)
 80481fb:	00 20                	add    %ah,(%eax)
 80481fd:	00 00                	add    %al,(%eax)
 80481ff:	00 1c 00             	add    %bl,(%eax,%eax,1)
 8048202:	00 00                	add    %al,(%eax)
 8048204:	00 00                	add    %al,(%eax)
 8048206:	00 00                	add    %al,(%eax)
 8048208:	24 00                	and    $0x0,%al
 804820a:	00 00                	add    %al,(%eax)
 804820c:	00 00                	add    %al,(%eax)
 804820e:	00 00                	add    %al,(%eax)
 8048210:	15 00 00 00 00       	adc    $0x0,%eax
 8048215:	00 00                	add    %al,(%eax)
 8048217:	00 18                	add    %bl,(%eax)
 8048219:	00 00                	add    %al,(%eax)
 804821b:	00 22                	add    %ah,(%edx)
 804821d:	00 00                	add    %al,(%eax)
 804821f:	00 11                	add    %dl,(%ecx)
 8048221:	00 00                	add    %al,(%eax)
 8048223:	00 25 00 00 00 0f    	add    %ah,0xf000000
	...
 8048231:	00 00                	add    %al,(%eax)
 8048233:	00 17                	add    %dl,(%edi)
 8048235:	00 00                	add    %al,(%eax)
 8048237:	00 00                	add    %al,(%eax)
 8048239:	00 00                	add    %al,(%eax)
 804823b:	00 02                	add    %al,(%edx)
 804823d:	00 00                	add    %al,(%eax)
 804823f:	00 00                	add    %al,(%eax)
 8048241:	00 00                	add    %al,(%eax)
 8048243:	00 26                	add    %ah,(%esi)
	...
 8048265:	00 00                	add    %al,(%eax)
 8048267:	00 03                	add    %al,(%ebx)
 8048269:	00 00                	add    %al,(%eax)
 804826b:	00 00                	add    %al,(%eax)
 804826d:	00 00                	add    %al,(%eax)
 804826f:	00 01                	add    %al,(%ecx)
	...
 8048285:	00 00                	add    %al,(%eax)
 8048287:	00 0d 00 00 00 00    	add    %cl,0x0
 804828d:	00 00                	add    %al,(%eax)
 804828f:	00 00                	add    %al,(%eax)
 8048291:	00 00                	add    %al,(%eax)
 8048293:	00 05 00 00 00 00    	add    %al,0x0
 8048299:	00 00                	add    %al,(%eax)
 804829b:	00 00                	add    %al,(%eax)
 804829d:	00 00                	add    %al,(%eax)
 804829f:	00 13                	add    %dl,(%ebx)
 80482a1:	00 00                	add    %al,(%eax)
 80482a3:	00 06                	add    %al,(%esi)
	...
 80482ad:	00 00                	add    %al,(%eax)
 80482af:	00 14 00             	add    %dl,(%eax,%eax,1)
 80482b2:	00 00                	add    %al,(%eax)
 80482b4:	09 00                	or     %eax,(%eax)
 80482b6:	00 00                	add    %al,(%eax)
 80482b8:	1a 00                	sbb    (%eax),%al
 80482ba:	00 00                	add    %al,(%eax)
 80482bc:	00 00                	add    %al,(%eax)
 80482be:	00 00                	add    %al,(%eax)
 80482c0:	08 00                	or     %al,(%eax)
 80482c2:	00 00                	add    %al,(%eax)
 80482c4:	00 00                	add    %al,(%eax)
 80482c6:	00 00                	add    %al,(%eax)
 80482c8:	10 00                	adc    %al,(%eax)
 80482ca:	00 00                	add    %al,(%eax)
 80482cc:	16                   	push   %ss
	...
 80482d5:	00 00                	add    %al,(%eax)
 80482d7:	00 0a                	add    %cl,(%edx)
 80482d9:	00 00                	add    %al,(%eax)
 80482db:	00 07                	add    %al,(%edi)
 80482dd:	00 00                	add    %al,(%eax)
 80482df:	00 0b                	add    %cl,(%ebx)
 80482e1:	00 00                	add    %al,(%eax)
	...

Disassembly of section .gnu.hash:

080482e4 <.gnu.hash>:
 80482e4:	03 00                	add    (%eax),%eax
 80482e6:	00 00                	add    %al,(%eax)
 80482e8:	23 00                	and    (%eax),%eax
 80482ea:	00 00                	add    %al,(%eax)
 80482ec:	01 00                	add    %eax,(%eax)
 80482ee:	00 00                	add    %al,(%eax)
 80482f0:	05 00 00 00 80       	add    $0x80000000,%eax
 80482f5:	28 26                	sub    %ah,(%esi)
 80482f7:	22 00                	and    (%eax),%al
 80482f9:	00 00                	add    %al,(%eax)
 80482fb:	00 23                	add    %ah,(%ebx)
 80482fd:	00 00                	add    %al,(%eax)
 80482ff:	00 26                	add    %ah,(%esi)
 8048301:	00 00                	add    %al,(%eax)
 8048303:	00 38                	add    %bh,(%eax)
 8048305:	f2 8b 1c ac          	repnz mov (%esp,%ebp,4),%ebx
 8048309:	4b                   	dec    %ebx
 804830a:	e3 c0                	jecxz  80482cc <_init-0x5ac>
 804830c:	67 55                	addr16 push %ebp
 804830e:	61                   	popa   
 804830f:	10                   	.byte 0x10
 8048310:	b3 a2                	mov    $0xa2,%bl
 8048312:	f7 12                	notl   (%edx)

Disassembly of section .dynsym:

08048314 <.dynsym>:
	...
 8048324:	a8 00                	test   $0x0,%al
	...
 804832e:	00 00                	add    %al,(%eax)
 8048330:	12 00                	adc    (%eax),%al
 8048332:	00 00                	add    %al,(%eax)
 8048334:	02 01                	add    (%ecx),%al
	...
 804833e:	00 00                	add    %al,(%eax)
 8048340:	12 00                	adc    (%eax),%al
 8048342:	00 00                	add    %al,(%eax)
 8048344:	3d 00 00 00 00       	cmp    $0x0,%eax
 8048349:	00 00                	add    %al,(%eax)
 804834b:	00 00                	add    %al,(%eax)
 804834d:	00 00                	add    %al,(%eax)
 804834f:	00 12                	add    %dl,(%edx)
 8048351:	00 00                	add    %al,(%eax)
 8048353:	00 b4 00 00 00 00 00 	add    %dh,0x0(%eax,%eax,1)
 804835a:	00 00                	add    %al,(%eax)
 804835c:	00 00                	add    %al,(%eax)
 804835e:	00 00                	add    %al,(%eax)
 8048360:	12 00                	adc    (%eax),%al
 8048362:	00 00                	add    %al,(%eax)
 8048364:	6b 00 00             	imul   $0x0,(%eax),%eax
	...
 804836f:	00 12                	add    %dl,(%edx)
 8048371:	00 00                	add    %al,(%eax)
 8048373:	00 d4                	add    %dl,%ah
	...
 804837d:	00 00                	add    %al,(%eax)
 804837f:	00 12                	add    %dl,(%edx)
 8048381:	00 00                	add    %al,(%eax)
 8048383:	00 16                	add    %dl,(%esi)
 8048385:	01 00                	add    %eax,(%eax)
	...
 804838f:	00 12                	add    %dl,(%edx)
 8048391:	00 00                	add    %al,(%eax)
 8048393:	00 fb                	add    %bh,%bl
	...
 804839d:	00 00                	add    %al,(%eax)
 804839f:	00 12                	add    %dl,(%edx)
 80483a1:	00 00                	add    %al,(%eax)
 80483a3:	00 0a                	add    %cl,(%edx)
 80483a5:	01 00                	add    %eax,(%eax)
	...
 80483af:	00 12                	add    %dl,(%edx)
 80483b1:	00 00                	add    %al,(%eax)
 80483b3:	00 30                	add    %dh,(%eax)
	...
 80483bd:	00 00                	add    %al,(%eax)
 80483bf:	00 12                	add    %dl,(%edx)
 80483c1:	00 00                	add    %al,(%eax)
 80483c3:	00 7d 00             	add    %bh,0x0(%ebp)
	...
 80483ce:	00 00                	add    %al,(%eax)
 80483d0:	12 00                	adc    (%eax),%al
 80483d2:	00 00                	add    %al,(%eax)
 80483d4:	ef                   	out    %eax,(%dx)
	...
 80483dd:	00 00                	add    %al,(%eax)
 80483df:	00 12                	add    %dl,(%edx)
 80483e1:	00 00                	add    %al,(%eax)
 80483e3:	00 72 00             	add    %dh,0x0(%edx)
	...
 80483ee:	00 00                	add    %al,(%eax)
 80483f0:	12 00                	adc    (%eax),%al
 80483f2:	00 00                	add    %al,(%eax)
 80483f4:	01 00                	add    %eax,(%eax)
	...
 80483fe:	00 00                	add    %al,(%eax)
 8048400:	20 00                	and    %al,(%eax)
 8048402:	00 00                	add    %al,(%eax)
 8048404:	37                   	aaa    
	...
 804840d:	00 00                	add    %al,(%eax)
 804840f:	00 12                	add    %dl,(%edx)
 8048411:	00 00                	add    %al,(%eax)
 8048413:	00 44 00 00          	add    %al,0x0(%eax,%eax,1)
	...
 804841f:	00 12                	add    %dl,(%edx)
 8048421:	00 00                	add    %al,(%eax)
 8048423:	00 84 00 00 00 00 00 	add    %al,0x0(%eax,%eax,1)
 804842a:	00 00                	add    %al,(%eax)
 804842c:	00 00                	add    %al,(%eax)
 804842e:	00 00                	add    %al,(%eax)
 8048430:	12 00                	adc    (%eax),%al
 8048432:	00 00                	add    %al,(%eax)
 8048434:	1f                   	pop    %ds
 8048435:	01 00                	add    %eax,(%eax)
	...
 804843f:	00 12                	add    %dl,(%edx)
 8048441:	00 00                	add    %al,(%eax)
 8048443:	00 fc                	add    %bh,%ah
	...
 804844d:	00 00                	add    %al,(%eax)
 804844f:	00 12                	add    %dl,(%edx)
 8048451:	00 00                	add    %al,(%eax)
 8048453:	00 ad 00 00 00 00    	add    %ch,0x0(%ebp)
 8048459:	00 00                	add    %al,(%eax)
 804845b:	00 00                	add    %al,(%eax)
 804845d:	00 00                	add    %al,(%eax)
 804845f:	00 12                	add    %dl,(%edx)
 8048461:	00 00                	add    %al,(%eax)
 8048463:	00 bb 00 00 00 00    	add    %bh,0x0(%ebx)
 8048469:	00 00                	add    %al,(%eax)
 804846b:	00 00                	add    %al,(%eax)
 804846d:	00 00                	add    %al,(%eax)
 804846f:	00 12                	add    %dl,(%edx)
 8048471:	00 00                	add    %al,(%eax)
 8048473:	00 53 00             	add    %dl,0x0(%ebx)
	...
 804847e:	00 00                	add    %al,(%eax)
 8048480:	12 00                	adc    (%eax),%al
 8048482:	00 00                	add    %al,(%eax)
 8048484:	90                   	nop
	...
 804848d:	00 00                	add    %al,(%eax)
 804848f:	00 12                	add    %dl,(%edx)
 8048491:	00 00                	add    %al,(%eax)
 8048493:	00 4a 00             	add    %cl,0x0(%edx)
	...
 804849e:	00 00                	add    %al,(%eax)
 80484a0:	12 00                	adc    (%eax),%al
 80484a2:	00 00                	add    %al,(%eax)
 80484a4:	97                   	xchg   %eax,%edi
	...
 80484ad:	00 00                	add    %al,(%eax)
 80484af:	00 12                	add    %dl,(%edx)
 80484b1:	00 00                	add    %al,(%eax)
 80484b3:	00 45 00             	add    %al,0x0(%ebp)
	...
 80484be:	00 00                	add    %al,(%eax)
 80484c0:	12 00                	adc    (%eax),%al
 80484c2:	00 00                	add    %al,(%eax)
 80484c4:	da 00                	fiaddl (%eax)
	...
 80484ce:	00 00                	add    %al,(%eax)
 80484d0:	12 00                	adc    (%eax),%al
 80484d2:	00 00                	add    %al,(%eax)
 80484d4:	3c 00                	cmp    $0x0,%al
	...
 80484de:	00 00                	add    %al,(%eax)
 80484e0:	12 00                	adc    (%eax),%al
 80484e2:	00 00                	add    %al,(%eax)
 80484e4:	29 00                	sub    %eax,(%eax)
	...
 80484ee:	00 00                	add    %al,(%eax)
 80484f0:	12 00                	adc    (%eax),%al
 80484f2:	00 00                	add    %al,(%eax)
 80484f4:	03 01                	add    (%ecx),%eax
	...
 80484fe:	00 00                	add    %al,(%eax)
 8048500:	12 00                	adc    (%eax),%al
 8048502:	00 00                	add    %al,(%eax)
 8048504:	e1 00                	loope  8048506 <_init-0x372>
	...
 804850e:	00 00                	add    %al,(%eax)
 8048510:	12 00                	adc    (%eax),%al
 8048512:	00 00                	add    %al,(%eax)
 8048514:	63 00                	arpl   %ax,(%eax)
	...
 804851e:	00 00                	add    %al,(%eax)
 8048520:	12 00                	adc    (%eax),%al
 8048522:	00 00                	add    %al,(%eax)
 8048524:	10 01                	adc    %al,(%ecx)
	...
 804852e:	00 00                	add    %al,(%eax)
 8048530:	12 00                	adc    (%eax),%al
 8048532:	00 00                	add    %al,(%eax)
 8048534:	89 00                	mov    %eax,(%eax)
	...
 804853e:	00 00                	add    %al,(%eax)
 8048540:	12 00                	adc    (%eax),%al
 8048542:	00 00                	add    %al,(%eax)
 8048544:	cd 00                	int    $0x0
 8048546:	00 00                	add    %al,(%eax)
 8048548:	e0 c1                	loopne 804850b <_init-0x36d>
 804854a:	04 08                	add    $0x8,%al
 804854c:	04 00                	add    $0x0,%al
 804854e:	00 00                	add    %al,(%eax)
 8048550:	11 00                	adc    %eax,(%eax)
 8048552:	1b 00                	sbb    (%eax),%eax
 8048554:	1a 00                	sbb    (%eax),%al
 8048556:	00 00                	add    %al,(%eax)
 8048558:	ac                   	lods   %ds:(%esi),%al
 8048559:	a0 04 08 04 00       	mov    0x40804,%al
 804855e:	00 00                	add    %al,(%eax)
 8048560:	11 00                	adc    %eax,(%eax)
 8048562:	11 00                	adc    %eax,(%eax)
 8048564:	77 00                	ja     8048566 <_init-0x312>
 8048566:	00 00                	add    %al,(%eax)
 8048568:	e4 c1                	in     $0xc1,%al
 804856a:	04 08                	add    $0x8,%al
 804856c:	04 00                	add    $0x0,%al
 804856e:	00 00                	add    %al,(%eax)
 8048570:	11 00                	adc    %eax,(%eax)
 8048572:	1b 00                	sbb    (%eax),%eax
 8048574:	c6 00 00             	movb   $0x0,(%eax)
 8048577:	00 00                	add    %al,(%eax)
 8048579:	c2 04 08             	ret    $0x804
 804857c:	04 00                	add    $0x0,%al
 804857e:	00 00                	add    %al,(%eax)
 8048580:	11 00                	adc    %eax,(%eax)
 8048582:	1b 00                	sbb    (%eax),%eax

Disassembly of section .dynstr:

08048584 <.dynstr>:
 8048584:	00 5f 5f             	add    %bl,0x5f(%edi)
 8048587:	67 6d                	insl   (%dx),%es:(%di)
 8048589:	6f                   	outsl  %ds:(%esi),(%dx)
 804858a:	6e                   	outsb  %ds:(%esi),(%dx)
 804858b:	5f                   	pop    %edi
 804858c:	73 74                	jae    8048602 <_init-0x276>
 804858e:	61                   	popa   
 804858f:	72 74                	jb     8048605 <_init-0x273>
 8048591:	5f                   	pop    %edi
 8048592:	5f                   	pop    %edi
 8048593:	00 6c 69 62          	add    %ch,0x62(%ecx,%ebp,2)
 8048597:	63 2e                	arpl   %bp,(%esi)
 8048599:	73 6f                	jae    804860a <_init-0x26e>
 804859b:	2e 36 00 5f 49       	cs add %bl,%ss:0x49(%edi)
 80485a0:	4f                   	dec    %edi
 80485a1:	5f                   	pop    %edi
 80485a2:	73 74                	jae    8048618 <_init-0x260>
 80485a4:	64 69 6e 5f 75 73 65 	imul   $0x64657375,%fs:0x5f(%esi),%ebp
 80485ab:	64 
 80485ac:	00 73 6f             	add    %dh,0x6f(%ebx)
 80485af:	63 6b 65             	arpl   %bp,0x65(%ebx)
 80485b2:	74 00                	je     80485b4 <_init-0x2c4>
 80485b4:	73 74                	jae    804862a <_init-0x24e>
 80485b6:	72 63                	jb     804861b <_init-0x25d>
 80485b8:	70 79                	jo     8048633 <_init-0x245>
 80485ba:	00 65 78             	add    %ah,0x78(%ebp)
 80485bd:	69 74 00 73 70 72 69 	imul   $0x6e697270,0x73(%eax,%eax,1),%esi
 80485c4:	6e 
 80485c5:	74 66                	je     804862d <_init-0x24b>
 80485c7:	00 73 72             	add    %dh,0x72(%ebx)
 80485ca:	61                   	popa   
 80485cb:	6e                   	outsb  %ds:(%esi),(%dx)
 80485cc:	64 00 5f 5f          	add    %bl,%fs:0x5f(%edi)
 80485d0:	73 74                	jae    8048646 <_init-0x232>
 80485d2:	72 64                	jb     8048638 <_init-0x240>
 80485d4:	75 70                	jne    8048646 <_init-0x232>
 80485d6:	00 5f 5f             	add    %bl,0x5f(%edi)
 80485d9:	69 73 6f 63 39 39 5f 	imul   $0x5f393963,0x6f(%ebx),%esi
 80485e0:	73 73                	jae    8048655 <_init-0x223>
 80485e2:	63 61 6e             	arpl   %sp,0x6e(%ecx)
 80485e5:	66 00 63 6f          	data16 add %ah,0x6f(%ebx)
 80485e9:	6e                   	outsb  %ds:(%esi),(%dx)
 80485ea:	6e                   	outsb  %ds:(%esi),(%dx)
 80485eb:	65 63 74 00 73       	arpl   %si,%gs:0x73(%eax,%eax,1)
 80485f0:	69 67 6e 61 6c 00 70 	imul   $0x70006c61,0x6e(%edi),%esp
 80485f7:	75 74                	jne    804866d <_init-0x20b>
 80485f9:	73 00                	jae    80485fb <_init-0x27d>
 80485fb:	73 74                	jae    8048671 <_init-0x207>
 80485fd:	64 69 6e 00 67 65 74 	imul   $0x70746567,%fs:0x0(%esi),%ebp
 8048604:	70 
 8048605:	69 64 00 6d 6d 61 70 	imul   $0x70616d,0x6d(%eax,%eax,1),%esp
 804860c:	00 
 804860d:	63 61 6c             	arpl   %sp,0x6c(%ecx)
 8048610:	6c                   	insb   (%dx),%es:(%edi)
 8048611:	6f                   	outsl  %ds:(%esi),(%dx)
 8048612:	63 00                	arpl   %ax,(%eax)
 8048614:	6d                   	insl   (%dx),%es:(%edi)
 8048615:	65 6d                	gs insl (%dx),%es:(%edi)
 8048617:	73 65                	jae    804867e <_init-0x1fa>
 8048619:	74 00                	je     804861b <_init-0x25d>
 804861b:	5f                   	pop    %edi
 804861c:	5f                   	pop    %edi
 804861d:	65 72 72             	gs jb  8048692 <_init-0x1e6>
 8048620:	6e                   	outsb  %ds:(%esi),(%dx)
 8048621:	6f                   	outsl  %ds:(%esi),(%dx)
 8048622:	5f                   	pop    %edi
 8048623:	6c                   	insb   (%dx),%es:(%edi)
 8048624:	6f                   	outsl  %ds:(%esi),(%dx)
 8048625:	63 61 74             	arpl   %sp,0x74(%ecx)
 8048628:	69 6f 6e 00 72 65 61 	imul   $0x61657200,0x6e(%edi),%ebp
 804862f:	64 00 67 65          	add    %ah,%fs:0x65(%edi)
 8048633:	74 6f                	je     80486a4 <_init-0x1d4>
 8048635:	70 74                	jo     80486ab <_init-0x1cd>
 8048637:	00 6d 65             	add    %ch,0x65(%ebp)
 804863a:	6d                   	insl   (%dx),%es:(%edi)
 804863b:	63 70 79             	arpl   %si,0x79(%eax)
 804863e:	00 73 74             	add    %dh,0x74(%ebx)
 8048641:	72 63                	jb     80486a6 <_init-0x1d2>
 8048643:	61                   	popa   
 8048644:	73 65                	jae    80486ab <_init-0x1cd>
 8048646:	63 6d 70             	arpl   %bp,0x70(%ebp)
 8048649:	00 6f 70             	add    %ch,0x70(%edi)
 804864c:	74 61                	je     80486af <_init-0x1c9>
 804864e:	72 67                	jb     80486b7 <_init-0x1c1>
 8048650:	00 73 74             	add    %dh,0x74(%ebx)
 8048653:	64 65 72 72          	fs gs jb 80486c9 <_init-0x1af>
 8048657:	00 61 6c             	add    %ah,0x6c(%ecx)
 804865a:	61                   	popa   
 804865b:	72 6d                	jb     80486ca <_init-0x1ae>
 804865d:	00 6d 75             	add    %ch,0x75(%ebp)
 8048660:	6e                   	outsb  %ds:(%esi),(%dx)
 8048661:	6d                   	insl   (%dx),%es:(%edi)
 8048662:	61                   	popa   
 8048663:	70 00                	jo     8048665 <_init-0x213>
 8048665:	67 65 74 68          	addr16 gs je 80486d1 <_init-0x1a7>
 8048669:	6f                   	outsl  %ds:(%esi),(%dx)
 804866a:	73 74                	jae    80486e0 <_init-0x198>
 804866c:	62 79 6e             	bound  %edi,0x6e(%ecx)
 804866f:	61                   	popa   
 8048670:	6d                   	insl   (%dx),%es:(%edi)
 8048671:	65 00 67 65          	add    %ah,%gs:0x65(%edi)
 8048675:	74 68                	je     80486df <_init-0x199>
 8048677:	6f                   	outsl  %ds:(%esi),(%dx)
 8048678:	73 74                	jae    80486ee <_init-0x18a>
 804867a:	6e                   	outsb  %ds:(%esi),(%dx)
 804867b:	61                   	popa   
 804867c:	6d                   	insl   (%dx),%es:(%edi)
 804867d:	65 00 66 77          	add    %ah,%gs:0x77(%esi)
 8048681:	72 69                	jb     80486ec <_init-0x18c>
 8048683:	74 65                	je     80486ea <_init-0x18e>
 8048685:	00 73 72             	add    %dh,0x72(%ebx)
 8048688:	61                   	popa   
 8048689:	6e                   	outsb  %ds:(%esi),(%dx)
 804868a:	64 6f                	outsl  %fs:(%esi),(%dx)
 804868c:	6d                   	insl   (%dx),%es:(%edi)
 804868d:	00 62 63             	add    %ah,0x63(%edx)
 8048690:	6f                   	outsl  %ds:(%esi),(%dx)
 8048691:	70 79                	jo     804870c <_init-0x16c>
 8048693:	00 63 6c             	add    %ah,0x6c(%ebx)
 8048696:	6f                   	outsl  %ds:(%esi),(%dx)
 8048697:	73 65                	jae    80486fe <_init-0x17a>
 8048699:	00 5f 49             	add    %bl,0x49(%edi)
 804869c:	4f                   	dec    %edi
 804869d:	5f                   	pop    %edi
 804869e:	67 65 74 63          	addr16 gs je 8048705 <_init-0x173>
 80486a2:	00 5f 5f             	add    %bl,0x5f(%edi)
 80486a5:	6c                   	insb   (%dx),%es:(%edi)
 80486a6:	69 62 63 5f 73 74 61 	imul   $0x6174735f,0x63(%edx),%esp
 80486ad:	72 74                	jb     8048723 <_init-0x155>
 80486af:	5f                   	pop    %edi
 80486b0:	6d                   	insl   (%dx),%es:(%edi)
 80486b1:	61                   	popa   
 80486b2:	69 6e 00 47 4c 49 42 	imul   $0x42494c47,0x0(%esi),%ebp
 80486b9:	43                   	inc    %ebx
 80486ba:	5f                   	pop    %edi
 80486bb:	32 2e                	xor    (%esi),%ch
 80486bd:	37                   	aaa    
 80486be:	00 47 4c             	add    %al,0x4c(%edi)
 80486c1:	49                   	dec    %ecx
 80486c2:	42                   	inc    %edx
 80486c3:	43                   	inc    %ebx
 80486c4:	5f                   	pop    %edi
 80486c5:	32 2e                	xor    (%esi),%ch
 80486c7:	30 00                	xor    %al,(%eax)

Disassembly of section .gnu.version:

080486ca <.gnu.version>:
 80486ca:	00 00                	add    %al,(%eax)
 80486cc:	02 00                	add    (%eax),%al
 80486ce:	02 00                	add    (%eax),%al
 80486d0:	02 00                	add    (%eax),%al
 80486d2:	02 00                	add    (%eax),%al
 80486d4:	02 00                	add    (%eax),%al
 80486d6:	02 00                	add    (%eax),%al
 80486d8:	02 00                	add    (%eax),%al
 80486da:	02 00                	add    (%eax),%al
 80486dc:	02 00                	add    (%eax),%al
 80486de:	02 00                	add    (%eax),%al
 80486e0:	02 00                	add    (%eax),%al
 80486e2:	02 00                	add    (%eax),%al
 80486e4:	02 00                	add    (%eax),%al
 80486e6:	00 00                	add    %al,(%eax)
 80486e8:	02 00                	add    (%eax),%al
 80486ea:	02 00                	add    (%eax),%al
 80486ec:	02 00                	add    (%eax),%al
 80486ee:	02 00                	add    (%eax),%al
 80486f0:	02 00                	add    (%eax),%al
 80486f2:	02 00                	add    (%eax),%al
 80486f4:	02 00                	add    (%eax),%al
 80486f6:	03 00                	add    (%eax),%eax
 80486f8:	02 00                	add    (%eax),%al
 80486fa:	02 00                	add    (%eax),%al
 80486fc:	02 00                	add    (%eax),%al
 80486fe:	02 00                	add    (%eax),%al
 8048700:	02 00                	add    (%eax),%al
 8048702:	02 00                	add    (%eax),%al
 8048704:	02 00                	add    (%eax),%al
 8048706:	02 00                	add    (%eax),%al
 8048708:	02 00                	add    (%eax),%al
 804870a:	02 00                	add    (%eax),%al
 804870c:	02 00                	add    (%eax),%al
 804870e:	02 00                	add    (%eax),%al
 8048710:	02 00                	add    (%eax),%al
 8048712:	01 00                	add    %eax,(%eax)
 8048714:	02 00                	add    (%eax),%al
 8048716:	02 00                	add    (%eax),%al

Disassembly of section .gnu.version_r:

08048718 <.gnu.version_r>:
 8048718:	01 00                	add    %eax,(%eax)
 804871a:	02 00                	add    (%eax),%al
 804871c:	10 00                	adc    %al,(%eax)
 804871e:	00 00                	add    %al,(%eax)
 8048720:	10 00                	adc    %al,(%eax)
 8048722:	00 00                	add    %al,(%eax)
 8048724:	00 00                	add    %al,(%eax)
 8048726:	00 00                	add    %al,(%eax)
 8048728:	17                   	pop    %ss
 8048729:	69 69 0d 00 00 03 00 	imul   $0x30000,0xd(%ecx),%ebp
 8048730:	31 01                	xor    %eax,(%ecx)
 8048732:	00 00                	add    %al,(%eax)
 8048734:	10 00                	adc    %al,(%eax)
 8048736:	00 00                	add    %al,(%eax)
 8048738:	10 69 69             	adc    %ch,0x69(%ecx)
 804873b:	0d 00 00 02 00       	or     $0x20000,%eax
 8048740:	3b 01                	cmp    (%ecx),%eax
 8048742:	00 00                	add    %al,(%eax)
 8048744:	00 00                	add    %al,(%eax)
	...

Disassembly of section .rel.dyn:

08048748 <.rel.dyn>:
 8048748:	fc                   	cld    
 8048749:	b0 04                	mov    $0x4,%al
 804874b:	08 06                	or     %al,(%esi)
 804874d:	0e                   	push   %cs
 804874e:	00 00                	add    %al,(%eax)
 8048750:	e0 c1                	loopne 8048713 <_init-0x165>
 8048752:	04 08                	add    $0x8,%al
 8048754:	05 23 00 00 e4       	add    $0xe4000023,%eax
 8048759:	c1 04 08 05          	roll   $0x5,(%eax,%ecx,1)
 804875d:	25 00 00 00 c2       	and    $0xc2000000,%eax
 8048762:	04 08                	add    $0x8,%al
 8048764:	05                   	.byte 0x5
 8048765:	26 00 00             	add    %al,%es:(%eax)

Disassembly of section .rel.plt:

08048768 <.rel.plt>:
 8048768:	0c b1                	or     $0xb1,%al
 804876a:	04 08                	add    $0x8,%al
 804876c:	07                   	pop    %es
 804876d:	01 00                	add    %eax,(%eax)
 804876f:	00 10                	add    %dl,(%eax)
 8048771:	b1 04                	mov    $0x4,%cl
 8048773:	08 07                	or     %al,(%edi)
 8048775:	02 00                	add    (%eax),%al
 8048777:	00 14 b1             	add    %dl,(%ecx,%esi,4)
 804877a:	04 08                	add    $0x8,%al
 804877c:	07                   	pop    %es
 804877d:	03 00                	add    (%eax),%eax
 804877f:	00 18                	add    %bl,(%eax)
 8048781:	b1 04                	mov    $0x4,%cl
 8048783:	08 07                	or     %al,(%edi)
 8048785:	04 00                	add    $0x0,%al
 8048787:	00 1c b1             	add    %bl,(%ecx,%esi,4)
 804878a:	04 08                	add    $0x8,%al
 804878c:	07                   	pop    %es
 804878d:	05 00 00 20 b1       	add    $0xb1200000,%eax
 8048792:	04 08                	add    $0x8,%al
 8048794:	07                   	pop    %es
 8048795:	06                   	push   %es
 8048796:	00 00                	add    %al,(%eax)
 8048798:	24 b1                	and    $0xb1,%al
 804879a:	04 08                	add    $0x8,%al
 804879c:	07                   	pop    %es
 804879d:	07                   	pop    %es
 804879e:	00 00                	add    %al,(%eax)
 80487a0:	28 b1 04 08 07 08    	sub    %dh,0x8070804(%ecx)
 80487a6:	00 00                	add    %al,(%eax)
 80487a8:	2c b1                	sub    $0xb1,%al
 80487aa:	04 08                	add    $0x8,%al
 80487ac:	07                   	pop    %es
 80487ad:	09 00                	or     %eax,(%eax)
 80487af:	00 30                	add    %dh,(%eax)
 80487b1:	b1 04                	mov    $0x4,%cl
 80487b3:	08 07                	or     %al,(%edi)
 80487b5:	0a 00                	or     (%eax),%al
 80487b7:	00 34 b1             	add    %dh,(%ecx,%esi,4)
 80487ba:	04 08                	add    $0x8,%al
 80487bc:	07                   	pop    %es
 80487bd:	0b 00                	or     (%eax),%eax
 80487bf:	00 38                	add    %bh,(%eax)
 80487c1:	b1 04                	mov    $0x4,%cl
 80487c3:	08 07                	or     %al,(%edi)
 80487c5:	0c 00                	or     $0x0,%al
 80487c7:	00 3c b1             	add    %bh,(%ecx,%esi,4)
 80487ca:	04 08                	add    $0x8,%al
 80487cc:	07                   	pop    %es
 80487cd:	0d 00 00 40 b1       	or     $0xb1400000,%eax
 80487d2:	04 08                	add    $0x8,%al
 80487d4:	07                   	pop    %es
 80487d5:	0e                   	push   %cs
 80487d6:	00 00                	add    %al,(%eax)
 80487d8:	44                   	inc    %esp
 80487d9:	b1 04                	mov    $0x4,%cl
 80487db:	08 07                	or     %al,(%edi)
 80487dd:	0f 00 00             	sldt   (%eax)
 80487e0:	48                   	dec    %eax
 80487e1:	b1 04                	mov    $0x4,%cl
 80487e3:	08 07                	or     %al,(%edi)
 80487e5:	10 00                	adc    %al,(%eax)
 80487e7:	00 4c b1 04          	add    %cl,0x4(%ecx,%esi,4)
 80487eb:	08 07                	or     %al,(%edi)
 80487ed:	11 00                	adc    %eax,(%eax)
 80487ef:	00 50 b1             	add    %dl,-0x4f(%eax)
 80487f2:	04 08                	add    $0x8,%al
 80487f4:	07                   	pop    %es
 80487f5:	12 00                	adc    (%eax),%al
 80487f7:	00 54 b1 04          	add    %dl,0x4(%ecx,%esi,4)
 80487fb:	08 07                	or     %al,(%edi)
 80487fd:	13 00                	adc    (%eax),%eax
 80487ff:	00 58 b1             	add    %bl,-0x4f(%eax)
 8048802:	04 08                	add    $0x8,%al
 8048804:	07                   	pop    %es
 8048805:	14 00                	adc    $0x0,%al
 8048807:	00 5c b1 04          	add    %bl,0x4(%ecx,%esi,4)
 804880b:	08 07                	or     %al,(%edi)
 804880d:	15 00 00 60 b1       	adc    $0xb1600000,%eax
 8048812:	04 08                	add    $0x8,%al
 8048814:	07                   	pop    %es
 8048815:	16                   	push   %ss
 8048816:	00 00                	add    %al,(%eax)
 8048818:	64 b1 04             	fs mov $0x4,%cl
 804881b:	08 07                	or     %al,(%edi)
 804881d:	17                   	pop    %ss
 804881e:	00 00                	add    %al,(%eax)
 8048820:	68 b1 04 08 07       	push   $0x70804b1
 8048825:	18 00                	sbb    %al,(%eax)
 8048827:	00 6c b1 04          	add    %ch,0x4(%ecx,%esi,4)
 804882b:	08 07                	or     %al,(%edi)
 804882d:	19 00                	sbb    %eax,(%eax)
 804882f:	00 70 b1             	add    %dh,-0x4f(%eax)
 8048832:	04 08                	add    $0x8,%al
 8048834:	07                   	pop    %es
 8048835:	1a 00                	sbb    (%eax),%al
 8048837:	00 74 b1 04          	add    %dh,0x4(%ecx,%esi,4)
 804883b:	08 07                	or     %al,(%edi)
 804883d:	1b 00                	sbb    (%eax),%eax
 804883f:	00 78 b1             	add    %bh,-0x4f(%eax)
 8048842:	04 08                	add    $0x8,%al
 8048844:	07                   	pop    %es
 8048845:	1c 00                	sbb    $0x0,%al
 8048847:	00 7c b1 04          	add    %bh,0x4(%ecx,%esi,4)
 804884b:	08 07                	or     %al,(%edi)
 804884d:	1d 00 00 80 b1       	sbb    $0xb1800000,%eax
 8048852:	04 08                	add    $0x8,%al
 8048854:	07                   	pop    %es
 8048855:	1e                   	push   %ds
 8048856:	00 00                	add    %al,(%eax)
 8048858:	84 b1 04 08 07 1f    	test   %dh,0x1f070804(%ecx)
 804885e:	00 00                	add    %al,(%eax)
 8048860:	88 b1 04 08 07 20    	mov    %dh,0x20070804(%ecx)
 8048866:	00 00                	add    %al,(%eax)
 8048868:	8c b1 04 08 07 21    	mov    %?,0x21070804(%ecx)
 804886e:	00 00                	add    %al,(%eax)
 8048870:	90                   	nop
 8048871:	b1 04                	mov    $0x4,%cl
 8048873:	08 07                	or     %al,(%edi)
 8048875:	22 00                	and    (%eax),%al
	...

Disassembly of section .init:

08048878 <_init>:
 8048878:	55                   	push   %ebp
 8048879:	89 e5                	mov    %esp,%ebp
 804887b:	53                   	push   %ebx
 804887c:	83 ec 04             	sub    $0x4,%esp
 804887f:	e8 00 00 00 00       	call   8048884 <_init+0xc>
 8048884:	5b                   	pop    %ebx
 8048885:	81 c3 7c 28 00 00    	add    $0x287c,%ebx
 804888b:	8b 93 fc ff ff ff    	mov    -0x4(%ebx),%edx
 8048891:	85 d2                	test   %edx,%edx
 8048893:	74 05                	je     804889a <_init+0x22>
 8048895:	e8 e6 00 00 00       	call   8048980 <__gmon_start__@plt>
 804889a:	58                   	pop    %eax
 804889b:	5b                   	pop    %ebx
 804889c:	c9                   	leave  
 804889d:	c3                   	ret    

Disassembly of section .plt:

080488a0 <read@plt-0x10>:
 80488a0:	ff 35 04 b1 04 08    	pushl  0x804b104
 80488a6:	ff 25 08 b1 04 08    	jmp    *0x804b108
 80488ac:	00 00                	add    %al,(%eax)
	...

080488b0 <read@plt>:
 80488b0:	ff 25 0c b1 04 08    	jmp    *0x804b10c
 80488b6:	68 00 00 00 00       	push   $0x0
 80488bb:	e9 e0 ff ff ff       	jmp    80488a0 <_init+0x28>

080488c0 <srandom@plt>:
 80488c0:	ff 25 10 b1 04 08    	jmp    *0x804b110
 80488c6:	68 08 00 00 00       	push   $0x8
 80488cb:	e9 d0 ff ff ff       	jmp    80488a0 <_init+0x28>

080488d0 <printf@plt>:
 80488d0:	ff 25 14 b1 04 08    	jmp    *0x804b114
 80488d6:	68 10 00 00 00       	push   $0x10
 80488db:	e9 c0 ff ff ff       	jmp    80488a0 <_init+0x28>

080488e0 <memcpy@plt>:
 80488e0:	ff 25 18 b1 04 08    	jmp    *0x804b118
 80488e6:	68 18 00 00 00       	push   $0x18
 80488eb:	e9 b0 ff ff ff       	jmp    80488a0 <_init+0x28>

080488f0 <signal@plt>:
 80488f0:	ff 25 1c b1 04 08    	jmp    *0x804b11c
 80488f6:	68 20 00 00 00       	push   $0x20
 80488fb:	e9 a0 ff ff ff       	jmp    80488a0 <_init+0x28>

08048900 <alarm@plt>:
 8048900:	ff 25 20 b1 04 08    	jmp    *0x804b120
 8048906:	68 28 00 00 00       	push   $0x28
 804890b:	e9 90 ff ff ff       	jmp    80488a0 <_init+0x28>

08048910 <_IO_getc@plt>:
 8048910:	ff 25 24 b1 04 08    	jmp    *0x804b124
 8048916:	68 30 00 00 00       	push   $0x30
 804891b:	e9 80 ff ff ff       	jmp    80488a0 <_init+0x28>

08048920 <fwrite@plt>:
 8048920:	ff 25 28 b1 04 08    	jmp    *0x804b128
 8048926:	68 38 00 00 00       	push   $0x38
 804892b:	e9 70 ff ff ff       	jmp    80488a0 <_init+0x28>

08048930 <bcopy@plt>:
 8048930:	ff 25 2c b1 04 08    	jmp    *0x804b12c
 8048936:	68 40 00 00 00       	push   $0x40
 804893b:	e9 60 ff ff ff       	jmp    80488a0 <_init+0x28>

08048940 <strcpy@plt>:
 8048940:	ff 25 30 b1 04 08    	jmp    *0x804b130
 8048946:	68 48 00 00 00       	push   $0x48
 804894b:	e9 50 ff ff ff       	jmp    80488a0 <_init+0x28>

08048950 <getpid@plt>:
 8048950:	ff 25 34 b1 04 08    	jmp    *0x804b134
 8048956:	68 50 00 00 00       	push   $0x50
 804895b:	e9 40 ff ff ff       	jmp    80488a0 <_init+0x28>

08048960 <gethostname@plt>:
 8048960:	ff 25 38 b1 04 08    	jmp    *0x804b138
 8048966:	68 58 00 00 00       	push   $0x58
 804896b:	e9 30 ff ff ff       	jmp    80488a0 <_init+0x28>

08048970 <puts@plt>:
 8048970:	ff 25 3c b1 04 08    	jmp    *0x804b13c
 8048976:	68 60 00 00 00       	push   $0x60
 804897b:	e9 20 ff ff ff       	jmp    80488a0 <_init+0x28>

08048980 <__gmon_start__@plt>:
 8048980:	ff 25 40 b1 04 08    	jmp    *0x804b140
 8048986:	68 68 00 00 00       	push   $0x68
 804898b:	e9 10 ff ff ff       	jmp    80488a0 <_init+0x28>

08048990 <exit@plt>:
 8048990:	ff 25 44 b1 04 08    	jmp    *0x804b144
 8048996:	68 70 00 00 00       	push   $0x70
 804899b:	e9 00 ff ff ff       	jmp    80488a0 <_init+0x28>

080489a0 <srand@plt>:
 80489a0:	ff 25 48 b1 04 08    	jmp    *0x804b148
 80489a6:	68 78 00 00 00       	push   $0x78
 80489ab:	e9 f0 fe ff ff       	jmp    80488a0 <_init+0x28>

080489b0 <mmap@plt>:
 80489b0:	ff 25 4c b1 04 08    	jmp    *0x804b14c
 80489b6:	68 80 00 00 00       	push   $0x80
 80489bb:	e9 e0 fe ff ff       	jmp    80488a0 <_init+0x28>

080489c0 <__libc_start_main@plt>:
 80489c0:	ff 25 50 b1 04 08    	jmp    *0x804b150
 80489c6:	68 88 00 00 00       	push   $0x88
 80489cb:	e9 d0 fe ff ff       	jmp    80488a0 <_init+0x28>

080489d0 <write@plt>:
 80489d0:	ff 25 54 b1 04 08    	jmp    *0x804b154
 80489d6:	68 90 00 00 00       	push   $0x90
 80489db:	e9 c0 fe ff ff       	jmp    80488a0 <_init+0x28>

080489e0 <getopt@plt>:
 80489e0:	ff 25 58 b1 04 08    	jmp    *0x804b158
 80489e6:	68 98 00 00 00       	push   $0x98
 80489eb:	e9 b0 fe ff ff       	jmp    80488a0 <_init+0x28>

080489f0 <strcasecmp@plt>:
 80489f0:	ff 25 5c b1 04 08    	jmp    *0x804b15c
 80489f6:	68 a0 00 00 00       	push   $0xa0
 80489fb:	e9 a0 fe ff ff       	jmp    80488a0 <_init+0x28>

08048a00 <__isoc99_sscanf@plt>:
 8048a00:	ff 25 60 b1 04 08    	jmp    *0x804b160
 8048a06:	68 a8 00 00 00       	push   $0xa8
 8048a0b:	e9 90 fe ff ff       	jmp    80488a0 <_init+0x28>

08048a10 <memset@plt>:
 8048a10:	ff 25 64 b1 04 08    	jmp    *0x804b164
 8048a16:	68 b0 00 00 00       	push   $0xb0
 8048a1b:	e9 80 fe ff ff       	jmp    80488a0 <_init+0x28>

08048a20 <__strdup@plt>:
 8048a20:	ff 25 68 b1 04 08    	jmp    *0x804b168
 8048a26:	68 b8 00 00 00       	push   $0xb8
 8048a2b:	e9 70 fe ff ff       	jmp    80488a0 <_init+0x28>

08048a30 <__errno_location@plt>:
 8048a30:	ff 25 6c b1 04 08    	jmp    *0x804b16c
 8048a36:	68 c0 00 00 00       	push   $0xc0
 8048a3b:	e9 60 fe ff ff       	jmp    80488a0 <_init+0x28>

08048a40 <rand@plt>:
 8048a40:	ff 25 70 b1 04 08    	jmp    *0x804b170
 8048a46:	68 c8 00 00 00       	push   $0xc8
 8048a4b:	e9 50 fe ff ff       	jmp    80488a0 <_init+0x28>

08048a50 <munmap@plt>:
 8048a50:	ff 25 74 b1 04 08    	jmp    *0x804b174
 8048a56:	68 d0 00 00 00       	push   $0xd0
 8048a5b:	e9 40 fe ff ff       	jmp    80488a0 <_init+0x28>

08048a60 <sprintf@plt>:
 8048a60:	ff 25 78 b1 04 08    	jmp    *0x804b178
 8048a66:	68 d8 00 00 00       	push   $0xd8
 8048a6b:	e9 30 fe ff ff       	jmp    80488a0 <_init+0x28>

08048a70 <socket@plt>:
 8048a70:	ff 25 7c b1 04 08    	jmp    *0x804b17c
 8048a76:	68 e0 00 00 00       	push   $0xe0
 8048a7b:	e9 20 fe ff ff       	jmp    80488a0 <_init+0x28>

08048a80 <random@plt>:
 8048a80:	ff 25 80 b1 04 08    	jmp    *0x804b180
 8048a86:	68 e8 00 00 00       	push   $0xe8
 8048a8b:	e9 10 fe ff ff       	jmp    80488a0 <_init+0x28>

08048a90 <gethostbyname@plt>:
 8048a90:	ff 25 84 b1 04 08    	jmp    *0x804b184
 8048a96:	68 f0 00 00 00       	push   $0xf0
 8048a9b:	e9 00 fe ff ff       	jmp    80488a0 <_init+0x28>

08048aa0 <connect@plt>:
 8048aa0:	ff 25 88 b1 04 08    	jmp    *0x804b188
 8048aa6:	68 f8 00 00 00       	push   $0xf8
 8048aab:	e9 f0 fd ff ff       	jmp    80488a0 <_init+0x28>

08048ab0 <close@plt>:
 8048ab0:	ff 25 8c b1 04 08    	jmp    *0x804b18c
 8048ab6:	68 00 01 00 00       	push   $0x100
 8048abb:	e9 e0 fd ff ff       	jmp    80488a0 <_init+0x28>

08048ac0 <calloc@plt>:
 8048ac0:	ff 25 90 b1 04 08    	jmp    *0x804b190
 8048ac6:	68 08 01 00 00       	push   $0x108
 8048acb:	e9 d0 fd ff ff       	jmp    80488a0 <_init+0x28>

Disassembly of section .text:

08048ad0 <_start>:
 8048ad0:	31 ed                	xor    %ebp,%ebp
 8048ad2:	5e                   	pop    %esi
 8048ad3:	89 e1                	mov    %esp,%ecx
 8048ad5:	83 e4 f0             	and    $0xfffffff0,%esp
 8048ad8:	50                   	push   %eax
 8048ad9:	54                   	push   %esp
 8048ada:	52                   	push   %edx
 8048adb:	68 20 a0 04 08       	push   $0x804a020
 8048ae0:	68 30 a0 04 08       	push   $0x804a030
 8048ae5:	51                   	push   %ecx
 8048ae6:	56                   	push   %esi
 8048ae7:	68 19 90 04 08       	push   $0x8049019
 8048aec:	e8 cf fe ff ff       	call   80489c0 <__libc_start_main@plt>
 8048af1:	f4                   	hlt    
 8048af2:	90                   	nop
 8048af3:	90                   	nop
 8048af4:	90                   	nop
 8048af5:	90                   	nop
 8048af6:	90                   	nop
 8048af7:	90                   	nop
 8048af8:	90                   	nop
 8048af9:	90                   	nop
 8048afa:	90                   	nop
 8048afb:	90                   	nop
 8048afc:	90                   	nop
 8048afd:	90                   	nop
 8048afe:	90                   	nop
 8048aff:	90                   	nop

08048b00 <deregister_tm_clones>:
 8048b00:	b8 d7 c1 04 08       	mov    $0x804c1d7,%eax
 8048b05:	2d d4 c1 04 08       	sub    $0x804c1d4,%eax
 8048b0a:	83 f8 06             	cmp    $0x6,%eax
 8048b0d:	77 02                	ja     8048b11 <deregister_tm_clones+0x11>
 8048b0f:	f3 c3                	repz ret 
 8048b11:	b8 00 00 00 00       	mov    $0x0,%eax
 8048b16:	85 c0                	test   %eax,%eax
 8048b18:	74 f5                	je     8048b0f <deregister_tm_clones+0xf>
 8048b1a:	55                   	push   %ebp
 8048b1b:	89 e5                	mov    %esp,%ebp
 8048b1d:	83 ec 18             	sub    $0x18,%esp
 8048b20:	c7 04 24 d4 c1 04 08 	movl   $0x804c1d4,(%esp)
 8048b27:	ff d0                	call   *%eax
 8048b29:	c9                   	leave  
 8048b2a:	c3                   	ret    
 8048b2b:	90                   	nop
 8048b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

08048b30 <register_tm_clones>:
 8048b30:	b8 d4 c1 04 08       	mov    $0x804c1d4,%eax
 8048b35:	2d d4 c1 04 08       	sub    $0x804c1d4,%eax
 8048b3a:	c1 f8 02             	sar    $0x2,%eax
 8048b3d:	89 c2                	mov    %eax,%edx
 8048b3f:	c1 ea 1f             	shr    $0x1f,%edx
 8048b42:	01 d0                	add    %edx,%eax
 8048b44:	d1 f8                	sar    %eax
 8048b46:	75 02                	jne    8048b4a <register_tm_clones+0x1a>
 8048b48:	f3 c3                	repz ret 
 8048b4a:	ba 00 00 00 00       	mov    $0x0,%edx
 8048b4f:	85 d2                	test   %edx,%edx
 8048b51:	74 f5                	je     8048b48 <register_tm_clones+0x18>
 8048b53:	55                   	push   %ebp
 8048b54:	89 e5                	mov    %esp,%ebp
 8048b56:	83 ec 18             	sub    $0x18,%esp
 8048b59:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048b5d:	c7 04 24 d4 c1 04 08 	movl   $0x804c1d4,(%esp)
 8048b64:	ff d2                	call   *%edx
 8048b66:	c9                   	leave  
 8048b67:	c3                   	ret    
 8048b68:	90                   	nop
 8048b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

08048b70 <__do_global_dtors_aux>:
 8048b70:	80 3d 04 c2 04 08 00 	cmpb   $0x0,0x804c204
 8048b77:	75 13                	jne    8048b8c <__do_global_dtors_aux+0x1c>
 8048b79:	55                   	push   %ebp
 8048b7a:	89 e5                	mov    %esp,%ebp
 8048b7c:	83 ec 08             	sub    $0x8,%esp
 8048b7f:	e8 7c ff ff ff       	call   8048b00 <deregister_tm_clones>
 8048b84:	c6 05 04 c2 04 08 01 	movb   $0x1,0x804c204
 8048b8b:	c9                   	leave  
 8048b8c:	f3 c3                	repz ret 
 8048b8e:	66 90                	xchg   %ax,%ax

08048b90 <frame_dummy>:
 8048b90:	a1 08 b0 04 08       	mov    0x804b008,%eax
 8048b95:	85 c0                	test   %eax,%eax
 8048b97:	74 1e                	je     8048bb7 <frame_dummy+0x27>
 8048b99:	b8 00 00 00 00       	mov    $0x0,%eax
 8048b9e:	85 c0                	test   %eax,%eax
 8048ba0:	74 15                	je     8048bb7 <frame_dummy+0x27>
 8048ba2:	55                   	push   %ebp
 8048ba3:	89 e5                	mov    %esp,%ebp
 8048ba5:	83 ec 18             	sub    $0x18,%esp
 8048ba8:	c7 04 24 08 b0 04 08 	movl   $0x804b008,(%esp)
 8048baf:	ff d0                	call   *%eax
 8048bb1:	c9                   	leave  
 8048bb2:	e9 79 ff ff ff       	jmp    8048b30 <register_tm_clones>
 8048bb7:	e9 74 ff ff ff       	jmp    8048b30 <register_tm_clones>
 8048bbc:	90                   	nop
 8048bbd:	90                   	nop
 8048bbe:	90                   	nop
 8048bbf:	90                   	nop

08048bc0 <usage>:
 8048bc0:	55                   	push   %ebp
 8048bc1:	89 e5                	mov    %esp,%ebp
 8048bc3:	83 ec 18             	sub    $0x18,%esp
 8048bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048bca:	c7 04 24 b0 a0 04 08 	movl   $0x804a0b0,(%esp)
 8048bd1:	e8 fa fc ff ff       	call   80488d0 <printf@plt>
 8048bd6:	c7 04 24 ce a0 04 08 	movl   $0x804a0ce,(%esp)
 8048bdd:	e8 8e fd ff ff       	call   8048970 <puts@plt>
 8048be2:	c7 04 24 e4 a0 04 08 	movl   $0x804a0e4,(%esp)
 8048be9:	e8 82 fd ff ff       	call   8048970 <puts@plt>
 8048bee:	c7 04 24 ec a1 04 08 	movl   $0x804a1ec,(%esp)
 8048bf5:	e8 76 fd ff ff       	call   8048970 <puts@plt>
 8048bfa:	c7 04 24 28 a2 04 08 	movl   $0x804a228,(%esp)
 8048c01:	e8 6a fd ff ff       	call   8048970 <puts@plt>
 8048c06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048c0d:	e8 7e fd ff ff       	call   8048990 <exit@plt>

08048c12 <illegalhandler>:
 8048c12:	55                   	push   %ebp
 8048c13:	89 e5                	mov    %esp,%ebp
 8048c15:	83 ec 18             	sub    $0x18,%esp
 8048c18:	c7 04 24 50 a2 04 08 	movl   $0x804a250,(%esp)
 8048c1f:	e8 4c fd ff ff       	call   8048970 <puts@plt>
 8048c24:	c7 04 24 fd a0 04 08 	movl   $0x804a0fd,(%esp)
 8048c2b:	e8 40 fd ff ff       	call   8048970 <puts@plt>
 8048c30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048c37:	e8 54 fd ff ff       	call   8048990 <exit@plt>

08048c3c <seghandler>:
 8048c3c:	55                   	push   %ebp
 8048c3d:	89 e5                	mov    %esp,%ebp
 8048c3f:	83 ec 18             	sub    $0x18,%esp
 8048c42:	c7 04 24 7c a2 04 08 	movl   $0x804a27c,(%esp)
 8048c49:	e8 22 fd ff ff       	call   8048970 <puts@plt>
 8048c4e:	c7 04 24 fd a0 04 08 	movl   $0x804a0fd,(%esp)
 8048c55:	e8 16 fd ff ff       	call   8048970 <puts@plt>
 8048c5a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048c61:	e8 2a fd ff ff       	call   8048990 <exit@plt>

08048c66 <bushandler>:
 8048c66:	55                   	push   %ebp
 8048c67:	89 e5                	mov    %esp,%ebp
 8048c69:	83 ec 18             	sub    $0x18,%esp
 8048c6c:	c7 04 24 a4 a2 04 08 	movl   $0x804a2a4,(%esp)
 8048c73:	e8 f8 fc ff ff       	call   8048970 <puts@plt>
 8048c78:	c7 04 24 fd a0 04 08 	movl   $0x804a0fd,(%esp)
 8048c7f:	e8 ec fc ff ff       	call   8048970 <puts@plt>
 8048c84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048c8b:	e8 00 fd ff ff       	call   8048990 <exit@plt>

08048c90 <smoke>:
 8048c90:	55                   	push   %ebp
 8048c91:	89 e5                	mov    %esp,%ebp
 8048c93:	83 ec 18             	sub    $0x18,%esp
 8048c96:	c7 04 24 13 a1 04 08 	movl   $0x804a113,(%esp)
 8048c9d:	e8 ce fc ff ff       	call   8048970 <puts@plt>
 8048ca2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048ca9:	e8 96 06 00 00       	call   8049344 <validate>
 8048cae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048cb5:	e8 d6 fc ff ff       	call   8048990 <exit@plt>

08048cba <fizz>:
 8048cba:	55                   	push   %ebp
 8048cbb:	89 e5                	mov    %esp,%ebp
 8048cbd:	83 ec 18             	sub    $0x18,%esp
 8048cc0:	8b 45 08             	mov    0x8(%ebp),%eax
 8048cc3:	3b 05 20 c2 04 08    	cmp    0x804c220,%eax
 8048cc9:	75 1e                	jne    8048ce9 <fizz+0x2f>
 8048ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048ccf:	c7 04 24 2e a1 04 08 	movl   $0x804a12e,(%esp)
 8048cd6:	e8 f5 fb ff ff       	call   80488d0 <printf@plt>
 8048cdb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8048ce2:	e8 5d 06 00 00       	call   8049344 <validate>
 8048ce7:	eb 10                	jmp    8048cf9 <fizz+0x3f>
 8048ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048ced:	c7 04 24 c4 a2 04 08 	movl   $0x804a2c4,(%esp)
 8048cf4:	e8 d7 fb ff ff       	call   80488d0 <printf@plt>
 8048cf9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048d00:	e8 8b fc ff ff       	call   8048990 <exit@plt>

08048d05 <bang>:
 8048d05:	55                   	push   %ebp
 8048d06:	89 e5                	mov    %esp,%ebp
 8048d08:	83 ec 18             	sub    $0x18,%esp
 8048d0b:	a1 18 c2 04 08       	mov    0x804c218,%eax
 8048d10:	3b 05 20 c2 04 08    	cmp    0x804c220,%eax
 8048d16:	75 1e                	jne    8048d36 <bang+0x31>
 8048d18:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048d1c:	c7 04 24 e4 a2 04 08 	movl   $0x804a2e4,(%esp)
 8048d23:	e8 a8 fb ff ff       	call   80488d0 <printf@plt>
 8048d28:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 8048d2f:	e8 10 06 00 00       	call   8049344 <validate>
 8048d34:	eb 10                	jmp    8048d46 <bang+0x41>
 8048d36:	89 44 24 04          	mov    %eax,0x4(%esp)
 8048d3a:	c7 04 24 4c a1 04 08 	movl   $0x804a14c,(%esp)
 8048d41:	e8 8a fb ff ff       	call   80488d0 <printf@plt>
 8048d46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8048d4d:	e8 3e fc ff ff       	call   8048990 <exit@plt>

08048d52 <Gets>:
 8048d52:	55                   	push   %ebp
 8048d53:	89 e5                	mov    %esp,%ebp
 8048d55:	57                   	push   %edi
 8048d56:	56                   	push   %esi
 8048d57:	53                   	push   %ebx
 8048d58:	83 ec 1c             	sub    $0x1c,%esp
 8048d5b:	8b 75 08             	mov    0x8(%ebp),%esi
 8048d5e:	c7 05 14 c2 04 08 00 	movl   $0x0,0x804c214
 8048d65:	00 00 00 
 8048d68:	89 f3                	mov    %esi,%ebx
 8048d6a:	eb 48                	jmp    8048db4 <Gets+0x62>
 8048d6c:	89 d1                	mov    %edx,%ecx
 8048d6e:	88 13                	mov    %dl,(%ebx)
 8048d70:	83 c3 01             	add    $0x1,%ebx
 8048d73:	a1 14 c2 04 08       	mov    0x804c214,%eax
 8048d78:	3d ff 03 00 00       	cmp    $0x3ff,%eax
 8048d7d:	7f 35                	jg     8048db4 <Gets+0x62>
 8048d7f:	8d 3c 40             	lea    (%eax,%eax,2),%edi
 8048d82:	c0 e9 04             	shr    $0x4,%cl
 8048d85:	0f be c9             	movsbl %cl,%ecx
 8048d88:	0f b6 89 30 a4 04 08 	movzbl 0x804a430(%ecx),%ecx
 8048d8f:	88 8f 60 c2 04 08    	mov    %cl,0x804c260(%edi)
 8048d95:	83 e2 0f             	and    $0xf,%edx
 8048d98:	0f b6 92 30 a4 04 08 	movzbl 0x804a430(%edx),%edx
 8048d9f:	88 97 61 c2 04 08    	mov    %dl,0x804c261(%edi)
 8048da5:	c6 87 62 c2 04 08 20 	movb   $0x20,0x804c262(%edi)
 8048dac:	83 c0 01             	add    $0x1,%eax
 8048daf:	a3 14 c2 04 08       	mov    %eax,0x804c214
 8048db4:	a1 24 c2 04 08       	mov    0x804c224,%eax
 8048db9:	89 04 24             	mov    %eax,(%esp)
 8048dbc:	e8 4f fb ff ff       	call   8048910 <_IO_getc@plt>
 8048dc1:	89 c2                	mov    %eax,%edx
 8048dc3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8048dc6:	74 05                	je     8048dcd <Gets+0x7b>
 8048dc8:	83 f8 0a             	cmp    $0xa,%eax
 8048dcb:	75 9f                	jne    8048d6c <Gets+0x1a>
 8048dcd:	c6 03 00             	movb   $0x0,(%ebx)
 8048dd0:	a1 14 c2 04 08       	mov    0x804c214,%eax
 8048dd5:	c6 84 40 60 c2 04 08 	movb   $0x0,0x804c260(%eax,%eax,2)
 8048ddc:	00 
 8048ddd:	89 f0                	mov    %esi,%eax
 8048ddf:	83 c4 1c             	add    $0x1c,%esp
 8048de2:	5b                   	pop    %ebx
 8048de3:	5e                   	pop    %esi
 8048de4:	5f                   	pop    %edi
 8048de5:	5d                   	pop    %ebp
 8048de6:	c3                   	ret    

08048de7 <uniqueval>:
 8048de7:	55                   	push   %ebp
 8048de8:	89 e5                	mov    %esp,%ebp
 8048dea:	83 ec 18             	sub    $0x18,%esp
 8048ded:	e8 5e fb ff ff       	call   8048950 <getpid@plt>
 8048df2:	89 04 24             	mov    %eax,(%esp)
 8048df5:	e8 c6 fa ff ff       	call   80488c0 <srandom@plt>
 8048dfa:	e8 81 fc ff ff       	call   8048a80 <random@plt>
 8048dff:	c9                   	leave  
 8048e00:	c3                   	ret    

08048e01 <testn>:
 8048e01:	55                   	push   %ebp
 8048e02:	89 e5                	mov    %esp,%ebp
 8048e04:	53                   	push   %ebx
 8048e05:	83 ec 24             	sub    $0x24,%esp
 8048e08:	e8 da ff ff ff       	call   8048de7 <uniqueval>
 8048e0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048e10:	e8 ef 03 00 00       	call   8049204 <getbufn>
 8048e15:	89 c3                	mov    %eax,%ebx
 8048e17:	e8 cb ff ff ff       	call   8048de7 <uniqueval>
 8048e1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048e1f:	39 d0                	cmp    %edx,%eax
 8048e21:	74 0e                	je     8048e31 <testn+0x30>
 8048e23:	c7 04 24 0c a3 04 08 	movl   $0x804a30c,(%esp)
 8048e2a:	e8 41 fb ff ff       	call   8048970 <puts@plt>
 8048e2f:	eb 36                	jmp    8048e67 <testn+0x66>
 8048e31:	3b 1d 20 c2 04 08    	cmp    0x804c220,%ebx
 8048e37:	75 1e                	jne    8048e57 <testn+0x56>
 8048e39:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 8048e3d:	c7 04 24 38 a3 04 08 	movl   $0x804a338,(%esp)
 8048e44:	e8 87 fa ff ff       	call   80488d0 <printf@plt>
 8048e49:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 8048e50:	e8 ef 04 00 00       	call   8049344 <validate>
 8048e55:	eb 10                	jmp    8048e67 <testn+0x66>
 8048e57:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 8048e5b:	c7 04 24 6a a1 04 08 	movl   $0x804a16a,(%esp)
 8048e62:	e8 69 fa ff ff       	call   80488d0 <printf@plt>
 8048e67:	83 c4 24             	add    $0x24,%esp
 8048e6a:	5b                   	pop    %ebx
 8048e6b:	5d                   	pop    %ebp
 8048e6c:	c3                   	ret    

08048e6d <test>:
 8048e6d:	55                   	push   %ebp
 8048e6e:	89 e5                	mov    %esp,%ebp
 8048e70:	53                   	push   %ebx
 8048e71:	83 ec 24             	sub    $0x24,%esp
 8048e74:	e8 6e ff ff ff       	call   8048de7 <uniqueval>
 8048e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8048e7c:	e8 6b 03 00 00       	call   80491ec <getbuf>
 8048e81:	89 c3                	mov    %eax,%ebx
 8048e83:	e8 5f ff ff ff       	call   8048de7 <uniqueval>
 8048e88:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8048e8b:	39 d0                	cmp    %edx,%eax
 8048e8d:	74 0e                	je     8048e9d <test+0x30>
 8048e8f:	c7 04 24 0c a3 04 08 	movl   $0x804a30c,(%esp)
 8048e96:	e8 d5 fa ff ff       	call   8048970 <puts@plt>
 8048e9b:	eb 36                	jmp    8048ed3 <test+0x66>
 8048e9d:	3b 1d 20 c2 04 08    	cmp    0x804c220,%ebx
 8048ea3:	75 1e                	jne    8048ec3 <test+0x56>
 8048ea5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 8048ea9:	c7 04 24 86 a1 04 08 	movl   $0x804a186,(%esp)
 8048eb0:	e8 1b fa ff ff       	call   80488d0 <printf@plt>
 8048eb5:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
 8048ebc:	e8 83 04 00 00       	call   8049344 <validate>
 8048ec1:	eb 10                	jmp    8048ed3 <test+0x66>
 8048ec3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 8048ec7:	c7 04 24 a3 a1 04 08 	movl   $0x804a1a3,(%esp)
 8048ece:	e8 fd f9 ff ff       	call   80488d0 <printf@plt>
 8048ed3:	83 c4 24             	add    $0x24,%esp
 8048ed6:	5b                   	pop    %ebx
 8048ed7:	5d                   	pop    %ebp
 8048ed8:	c3                   	ret    

08048ed9 <launch>:
 8048ed9:	55                   	push   %ebp
 8048eda:	89 e5                	mov    %esp,%ebp
 8048edc:	53                   	push   %ebx
 8048edd:	83 ec 54             	sub    $0x54,%esp
 8048ee0:	89 c3                	mov    %eax,%ebx
 8048ee2:	8d 4d b8             	lea    -0x48(%ebp),%ecx
 8048ee5:	81 e1 f0 3f 00 00    	and    $0x3ff0,%ecx
 8048eeb:	8d 44 11 1e          	lea    0x1e(%ecx,%edx,1),%eax
 8048eef:	83 e0 f0             	and    $0xfffffff0,%eax
 8048ef2:	29 c4                	sub    %eax,%esp
 8048ef4:	8d 44 24 1b          	lea    0x1b(%esp),%eax
 8048ef8:	83 e0 f0             	and    $0xfffffff0,%eax
 8048efb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 8048eff:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
 8048f06:	00 
 8048f07:	89 04 24             	mov    %eax,(%esp)
 8048f0a:	e8 01 fb ff ff       	call   8048a10 <memset@plt>
 8048f0f:	c7 04 24 be a1 04 08 	movl   $0x804a1be,(%esp)
 8048f16:	e8 b5 f9 ff ff       	call   80488d0 <printf@plt>
 8048f1b:	85 db                	test   %ebx,%ebx
 8048f1d:	74 07                	je     8048f26 <launch+0x4d>
 8048f1f:	e8 dd fe ff ff       	call   8048e01 <testn>
 8048f24:	eb 05                	jmp    8048f2b <launch+0x52>
 8048f26:	e8 42 ff ff ff       	call   8048e6d <test>
 8048f2b:	83 3d 1c c2 04 08 00 	cmpl   $0x0,0x804c21c
 8048f32:	75 16                	jne    8048f4a <launch+0x71>
 8048f34:	c7 04 24 fd a0 04 08 	movl   $0x804a0fd,(%esp)
 8048f3b:	e8 30 fa ff ff       	call   8048970 <puts@plt>
 8048f40:	c7 05 1c c2 04 08 00 	movl   $0x0,0x804c21c
 8048f47:	00 00 00 
 8048f4a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 8048f4d:	c9                   	leave  
 8048f4e:	c3                   	ret    

08048f4f <launcher>:
 8048f4f:	55                   	push   %ebp
 8048f50:	89 e5                	mov    %esp,%ebp
 8048f52:	83 ec 28             	sub    $0x28,%esp
 8048f55:	8b 45 08             	mov    0x8(%ebp),%eax
 8048f58:	a3 10 c2 04 08       	mov    %eax,0x804c210
 8048f5d:	8b 45 0c             	mov    0xc(%ebp),%eax
 8048f60:	a3 0c c2 04 08       	mov    %eax,0x804c20c
 8048f65:	c7 44 24 14 00 00 00 	movl   $0x0,0x14(%esp)
 8048f6c:	00 
 8048f6d:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
 8048f74:	00 
 8048f75:	c7 44 24 0c 32 01 00 	movl   $0x132,0xc(%esp)
 8048f7c:	00 
 8048f7d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
 8048f84:	00 
 8048f85:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
 8048f8c:	00 
 8048f8d:	c7 04 24 00 60 58 55 	movl   $0x55586000,(%esp)
 8048f94:	e8 17 fa ff ff       	call   80489b0 <mmap@plt>
 8048f99:	3d 00 60 58 55       	cmp    $0x55586000,%eax
 8048f9e:	74 31                	je     8048fd1 <launcher+0x82>
 8048fa0:	a1 e0 c1 04 08       	mov    0x804c1e0,%eax
 8048fa5:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8048fa9:	c7 44 24 08 47 00 00 	movl   $0x47,0x8(%esp)
 8048fb0:	00 
 8048fb1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8048fb8:	00 
 8048fb9:	c7 04 24 58 a3 04 08 	movl   $0x804a358,(%esp)
 8048fc0:	e8 5b f9 ff ff       	call   8048920 <fwrite@plt>
 8048fc5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 8048fcc:	e8 bf f9 ff ff       	call   8048990 <exit@plt>
 8048fd1:	c7 05 40 c2 04 08 f8 	movl   $0x55685ff8,0x804c240
 8048fd8:	5f 68 55 
 8048fdb:	ba f8 5f 68 55       	mov    $0x55685ff8,%edx
 8048fe0:	89 e0                	mov    %esp,%eax
 8048fe2:	89 d4                	mov    %edx,%esp
 8048fe4:	89 c2                	mov    %eax,%edx
 8048fe6:	89 15 08 c2 04 08    	mov    %edx,0x804c208
 8048fec:	8b 15 0c c2 04 08    	mov    0x804c20c,%edx
 8048ff2:	a1 10 c2 04 08       	mov    0x804c210,%eax
 8048ff7:	e8 dd fe ff ff       	call   8048ed9 <launch>
 8048ffc:	a1 08 c2 04 08       	mov    0x804c208,%eax
 8049001:	89 c4                	mov    %eax,%esp
 8049003:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
 804900a:	00 
 804900b:	c7 04 24 00 60 58 55 	movl   $0x55586000,(%esp)
 8049012:	e8 39 fa ff ff       	call   8048a50 <munmap@plt>
 8049017:	c9                   	leave  
 8049018:	c3                   	ret    

08049019 <main>:
 8049019:	55                   	push   %ebp
 804901a:	89 e5                	mov    %esp,%ebp
 804901c:	57                   	push   %edi
 804901d:	56                   	push   %esi
 804901e:	53                   	push   %ebx
 804901f:	83 e4 f0             	and    $0xfffffff0,%esp
 8049022:	83 ec 20             	sub    $0x20,%esp
 8049025:	8b 75 08             	mov    0x8(%ebp),%esi
 8049028:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 804902b:	c7 44 24 04 3c 8c 04 	movl   $0x8048c3c,0x4(%esp)
 8049032:	08 
 8049033:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
 804903a:	e8 b1 f8 ff ff       	call   80488f0 <signal@plt>
 804903f:	c7 44 24 04 66 8c 04 	movl   $0x8048c66,0x4(%esp)
 8049046:	08 
 8049047:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
 804904e:	e8 9d f8 ff ff       	call   80488f0 <signal@plt>
 8049053:	c7 44 24 04 12 8c 04 	movl   $0x8048c12,0x4(%esp)
 804905a:	08 
 804905b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
 8049062:	e8 89 f8 ff ff       	call   80488f0 <signal@plt>
 8049067:	a1 e4 c1 04 08       	mov    0x804c1e4,%eax
 804906c:	a3 24 c2 04 08       	mov    %eax,0x804c224
 8049071:	bf 01 00 00 00       	mov    $0x1,%edi
 8049076:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 804907d:	00 
 804907e:	eb 71                	jmp    80490f1 <main+0xd8>
 8049080:	83 e8 67             	sub    $0x67,%eax
 8049083:	3c 0e                	cmp    $0xe,%al
 8049085:	77 56                	ja     80490dd <main+0xc4>
 8049087:	0f b6 c0             	movzbl %al,%eax
 804908a:	ff 24 85 f4 a3 04 08 	jmp    *0x804a3f4(,%eax,4)
 8049091:	8b 03                	mov    (%ebx),%eax
 8049093:	e8 28 fb ff ff       	call   8048bc0 <usage>
 8049098:	a1 00 c2 04 08       	mov    0x804c200,%eax
 804909d:	89 04 24             	mov    %eax,(%esp)
 80490a0:	e8 7b f9 ff ff       	call   8048a20 <__strdup@plt>
 80490a5:	a3 30 c2 04 08       	mov    %eax,0x804c230
 80490aa:	89 04 24             	mov    %eax,(%esp)
 80490ad:	e8 38 0f 00 00       	call   8049fea <gencookie>
 80490b2:	a3 20 c2 04 08       	mov    %eax,0x804c220
 80490b7:	eb 38                	jmp    80490f1 <main+0xd8>
 80490b9:	c7 04 24 a0 a3 04 08 	movl   $0x804a3a0,(%esp)
 80490c0:	e8 ab f8 ff ff       	call   8048970 <puts@plt>
 80490c5:	c7 05 2c c2 04 08 00 	movl   $0x0,0x804c22c
 80490cc:	00 00 00 
 80490cf:	eb 20                	jmp    80490f1 <main+0xd8>
 80490d1:	c7 05 28 c2 04 08 01 	movl   $0x1,0x804c228
 80490d8:	00 00 00 
 80490db:	eb 14                	jmp    80490f1 <main+0xd8>
 80490dd:	8b 03                	mov    (%ebx),%eax
 80490df:	e8 dc fa ff ff       	call   8048bc0 <usage>
 80490e4:	bf 05 00 00 00       	mov    $0x5,%edi
 80490e9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 80490f0:	00 
 80490f1:	c7 44 24 08 cb a1 04 	movl   $0x804a1cb,0x8(%esp)
 80490f8:	08 
 80490f9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 80490fd:	89 34 24             	mov    %esi,(%esp)
 8049100:	e8 db f8 ff ff       	call   80489e0 <getopt@plt>
 8049105:	3c ff                	cmp    $0xff,%al
 8049107:	0f 85 73 ff ff ff    	jne    8049080 <main+0x67>
 804910d:	83 3d 30 c2 04 08 00 	cmpl   $0x0,0x804c230
 8049114:	75 19                	jne    804912f <main+0x116>
 8049116:	8b 03                	mov    (%ebx),%eax
 8049118:	89 44 24 04          	mov    %eax,0x4(%esp)
 804911c:	c7 04 24 c8 a3 04 08 	movl   $0x804a3c8,(%esp)
 8049123:	e8 a8 f7 ff ff       	call   80488d0 <printf@plt>
 8049128:	8b 03                	mov    (%ebx),%eax
 804912a:	e8 91 fa ff ff       	call   8048bc0 <usage>
 804912f:	e8 f0 00 00 00       	call   8049224 <initialize_bomb>
 8049134:	a1 30 c2 04 08       	mov    0x804c230,%eax
 8049139:	89 44 24 04          	mov    %eax,0x4(%esp)
 804913d:	c7 04 24 d2 a1 04 08 	movl   $0x804a1d2,(%esp)
 8049144:	e8 87 f7 ff ff       	call   80488d0 <printf@plt>
 8049149:	a1 20 c2 04 08       	mov    0x804c220,%eax
 804914e:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049152:	c7 04 24 de a1 04 08 	movl   $0x804a1de,(%esp)
 8049159:	e8 72 f7 ff ff       	call   80488d0 <printf@plt>
 804915e:	a1 20 c2 04 08       	mov    0x804c220,%eax
 8049163:	89 04 24             	mov    %eax,(%esp)
 8049166:	e8 55 f7 ff ff       	call   80488c0 <srandom@plt>
 804916b:	e8 10 f9 ff ff       	call   8048a80 <random@plt>
 8049170:	25 f0 0f 00 00       	and    $0xff0,%eax
 8049175:	05 00 01 00 00       	add    $0x100,%eax
 804917a:	89 44 24 18          	mov    %eax,0x18(%esp)
 804917e:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
 8049185:	00 
 8049186:	89 3c 24             	mov    %edi,(%esp)
 8049189:	e8 32 f9 ff ff       	call   8048ac0 <calloc@plt>
 804918e:	89 c6                	mov    %eax,%esi
 8049190:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
 8049196:	bb 01 00 00 00       	mov    $0x1,%ebx
 804919b:	eb 17                	jmp    80491b4 <main+0x19b>
 804919d:	e8 de f8 ff ff       	call   8048a80 <random@plt>
 80491a2:	25 f0 00 00 00       	and    $0xf0,%eax
 80491a7:	ba 80 00 00 00       	mov    $0x80,%edx
 80491ac:	29 c2                	sub    %eax,%edx
 80491ae:	89 14 9e             	mov    %edx,(%esi,%ebx,4)
 80491b1:	83 c3 01             	add    $0x1,%ebx
 80491b4:	39 fb                	cmp    %edi,%ebx
 80491b6:	7c e5                	jl     804919d <main+0x184>
 80491b8:	bb 00 00 00 00       	mov    $0x0,%ebx
 80491bd:	eb 1a                	jmp    80491d9 <main+0x1c0>
 80491bf:	8b 44 24 18          	mov    0x18(%esp),%eax
 80491c3:	03 04 9e             	add    (%esi,%ebx,4),%eax
 80491c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 80491ca:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 80491ce:	89 04 24             	mov    %eax,(%esp)
 80491d1:	e8 79 fd ff ff       	call   8048f4f <launcher>
 80491d6:	83 c3 01             	add    $0x1,%ebx
 80491d9:	39 fb                	cmp    %edi,%ebx
 80491db:	7c e2                	jl     80491bf <main+0x1a6>
 80491dd:	b8 00 00 00 00       	mov    $0x0,%eax
 80491e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 80491e5:	5b                   	pop    %ebx
 80491e6:	5e                   	pop    %esi
 80491e7:	5f                   	pop    %edi
 80491e8:	5d                   	pop    %ebp
 80491e9:	c3                   	ret    
 80491ea:	90                   	nop
 80491eb:	90                   	nop

080491ec <getbuf>:
 80491ec:	55                   	push   %ebp
 80491ed:	89 e5                	mov    %esp,%ebp
 80491ef:	83 ec 38             	sub    $0x38,%esp
 80491f2:	8d 45 d8             	lea    -0x28(%ebp),%eax
 80491f5:	89 04 24             	mov    %eax,(%esp)
 80491f8:	e8 55 fb ff ff       	call   8048d52 <Gets>
 80491fd:	b8 01 00 00 00       	mov    $0x1,%eax
 8049202:	c9                   	leave  
 8049203:	c3                   	ret    

08049204 <getbufn>:
 8049204:	55                   	push   %ebp
 8049205:	89 e5                	mov    %esp,%ebp
 8049207:	81 ec 18 02 00 00    	sub    $0x218,%esp
 804920d:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
 8049213:	89 04 24             	mov    %eax,(%esp)
 8049216:	e8 37 fb ff ff       	call   8048d52 <Gets>
 804921b:	b8 01 00 00 00       	mov    $0x1,%eax
 8049220:	c9                   	leave  
 8049221:	c3                   	ret    
 8049222:	90                   	nop
 8049223:	90                   	nop

08049224 <initialize_bomb>:
 8049224:	55                   	push   %ebp
 8049225:	89 e5                	mov    %esp,%ebp
 8049227:	56                   	push   %esi
 8049228:	53                   	push   %ebx
 8049229:	81 ec 10 24 00 00    	sub    $0x2410,%esp
 804922f:	83 3d 28 c2 04 08 00 	cmpl   $0x0,0x804c228
 8049236:	74 0c                	je     8049244 <initialize_bomb+0x20>
 8049238:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 804923f:	e8 ce 0a 00 00       	call   8049d12 <init_timeout>
 8049244:	83 3d 2c c2 04 08 00 	cmpl   $0x0,0x804c22c
 804924b:	0f 84 e9 00 00 00    	je     804933a <initialize_bomb+0x116>
 8049251:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
 8049258:	00 
 8049259:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 804925f:	89 04 24             	mov    %eax,(%esp)
 8049262:	e8 f9 f6 ff ff       	call   8048960 <gethostname@plt>
 8049267:	85 c0                	test   %eax,%eax
 8049269:	75 19                	jne    8049284 <initialize_bomb+0x60>
 804926b:	a1 c0 b1 04 08       	mov    0x804b1c0,%eax
 8049270:	bb 00 00 00 00       	mov    $0x0,%ebx
 8049275:	8d b5 f8 fb ff ff    	lea    -0x408(%ebp),%esi
 804927b:	85 c0                	test   %eax,%eax
 804927d:	75 1d                	jne    804929c <initialize_bomb+0x78>
 804927f:	e9 95 00 00 00       	jmp    8049319 <initialize_bomb+0xf5>
 8049284:	c7 04 24 40 a4 04 08 	movl   $0x804a440,(%esp)
 804928b:	e8 e0 f6 ff ff       	call   8048970 <puts@plt>
 8049290:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8049297:	e8 f4 f6 ff ff       	call   8048990 <exit@plt>
 804929c:	89 74 24 04          	mov    %esi,0x4(%esp)
 80492a0:	89 04 24             	mov    %eax,(%esp)
 80492a3:	e8 48 f7 ff ff       	call   80489f0 <strcasecmp@plt>
 80492a8:	85 c0                	test   %eax,%eax
 80492aa:	74 59                	je     8049305 <initialize_bomb+0xe1>
 80492ac:	83 c3 01             	add    $0x1,%ebx
 80492af:	8b 04 9d c0 b1 04 08 	mov    0x804b1c0(,%ebx,4),%eax
 80492b6:	85 c0                	test   %eax,%eax
 80492b8:	75 e2                	jne    804929c <initialize_bomb+0x78>
 80492ba:	eb 5d                	jmp    8049319 <initialize_bomb+0xf5>
 80492bc:	bb 00 00 00 00       	mov    $0x0,%ebx
 80492c1:	89 04 24             	mov    %eax,(%esp)
 80492c4:	e8 a7 f6 ff ff       	call   8048970 <puts@plt>
 80492c9:	83 c3 01             	add    $0x1,%ebx
 80492cc:	8b 04 9d c0 b1 04 08 	mov    0x804b1c0(,%ebx,4),%eax
 80492d3:	85 c0                	test   %eax,%eax
 80492d5:	75 ea                	jne    80492c1 <initialize_bomb+0x9d>
 80492d7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 80492de:	e8 ad f6 ff ff       	call   8048990 <exit@plt>
 80492e3:	8d 85 f8 db ff ff    	lea    -0x2408(%ebp),%eax
 80492e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 80492ed:	c7 04 24 ae a5 04 08 	movl   $0x804a5ae,(%esp)
 80492f4:	e8 d7 f5 ff ff       	call   80488d0 <printf@plt>
 80492f9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
 8049300:	e8 8b f6 ff ff       	call   8048990 <exit@plt>
 8049305:	8d 85 f8 db ff ff    	lea    -0x2408(%ebp),%eax
 804930b:	89 04 24             	mov    %eax,(%esp)
 804930e:	e8 38 0a 00 00       	call   8049d4b <init_driver>
 8049313:	85 c0                	test   %eax,%eax
 8049315:	79 23                	jns    804933a <initialize_bomb+0x116>
 8049317:	eb ca                	jmp    80492e3 <initialize_bomb+0xbf>
 8049319:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
 804931f:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049323:	c7 04 24 78 a4 04 08 	movl   $0x804a478,(%esp)
 804932a:	e8 a1 f5 ff ff       	call   80488d0 <printf@plt>
 804932f:	a1 c0 b1 04 08       	mov    0x804b1c0,%eax
 8049334:	85 c0                	test   %eax,%eax
 8049336:	75 84                	jne    80492bc <initialize_bomb+0x98>
 8049338:	eb 9d                	jmp    80492d7 <initialize_bomb+0xb3>
 804933a:	81 c4 10 24 00 00    	add    $0x2410,%esp
 8049340:	5b                   	pop    %ebx
 8049341:	5e                   	pop    %esi
 8049342:	5d                   	pop    %ebp
 8049343:	c3                   	ret    

08049344 <validate>:
 8049344:	55                   	push   %ebp
 8049345:	89 e5                	mov    %esp,%ebp
 8049347:	81 ec 28 40 00 00    	sub    $0x4028,%esp
 804934d:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 8049350:	89 7d fc             	mov    %edi,-0x4(%ebp)
 8049353:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8049356:	83 3d 30 c2 04 08 00 	cmpl   $0x0,0x804c230
 804935d:	75 11                	jne    8049370 <validate+0x2c>
 804935f:	c7 04 24 b4 a4 04 08 	movl   $0x804a4b4,(%esp)
 8049366:	e8 05 f6 ff ff       	call   8048970 <puts@plt>
 804936b:	e9 10 01 00 00       	jmp    8049480 <validate+0x13c>
 8049370:	83 fb 04             	cmp    $0x4,%ebx
 8049373:	76 11                	jbe    8049386 <validate+0x42>
 8049375:	c7 04 24 e0 a4 04 08 	movl   $0x804a4e0,(%esp)
 804937c:	e8 ef f5 ff ff       	call   8048970 <puts@plt>
 8049381:	e9 fa 00 00 00       	jmp    8049480 <validate+0x13c>
 8049386:	c7 05 1c c2 04 08 01 	movl   $0x1,0x804c21c
 804938d:	00 00 00 
 8049390:	8b 04 9d c0 c1 04 08 	mov    0x804c1c0(,%ebx,4),%eax
 8049397:	83 e8 01             	sub    $0x1,%eax
 804939a:	89 04 9d c0 c1 04 08 	mov    %eax,0x804c1c0(,%ebx,4)
 80493a1:	85 c0                	test   %eax,%eax
 80493a3:	7e 11                	jle    80493b6 <validate+0x72>
 80493a5:	c7 04 24 c3 a5 04 08 	movl   $0x804a5c3,(%esp)
 80493ac:	e8 bf f5 ff ff       	call   8048970 <puts@plt>
 80493b1:	e9 ca 00 00 00       	jmp    8049480 <validate+0x13c>
 80493b6:	c7 04 24 ce a5 04 08 	movl   $0x804a5ce,(%esp)
 80493bd:	e8 ae f5 ff ff       	call   8048970 <puts@plt>
 80493c2:	83 3d 2c c2 04 08 00 	cmpl   $0x0,0x804c22c
 80493c9:	0f 84 a5 00 00 00    	je     8049474 <validate+0x130>
 80493cf:	bf 60 c2 04 08       	mov    $0x804c260,%edi
 80493d4:	b8 00 00 00 00       	mov    $0x0,%eax
 80493d9:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 80493de:	f2 ae                	repnz scas %es:(%edi),%al
 80493e0:	f7 d1                	not    %ecx
 80493e2:	83 c1 1f             	add    $0x1f,%ecx
 80493e5:	81 f9 00 20 00 00    	cmp    $0x2000,%ecx
 80493eb:	76 11                	jbe    80493fe <validate+0xba>
 80493ed:	c7 04 24 08 a5 04 08 	movl   $0x804a508,(%esp)
 80493f4:	e8 77 f5 ff ff       	call   8048970 <puts@plt>
 80493f9:	e9 82 00 00 00       	jmp    8049480 <validate+0x13c>
 80493fe:	c7 44 24 10 60 c2 04 	movl   $0x804c260,0x10(%esp)
 8049405:	08 
 8049406:	a1 20 c2 04 08       	mov    0x804c220,%eax
 804940b:	89 44 24 0c          	mov    %eax,0xc(%esp)
 804940f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 8049413:	c7 44 24 04 d4 a5 04 	movl   $0x804a5d4,0x4(%esp)
 804941a:	08 
 804941b:	8d 9d f8 df ff ff    	lea    -0x2008(%ebp),%ebx
 8049421:	89 1c 24             	mov    %ebx,(%esp)
 8049424:	e8 37 f6 ff ff       	call   8048a60 <sprintf@plt>
 8049429:	8d 85 f8 bf ff ff    	lea    -0x4008(%ebp),%eax
 804942f:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049433:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 804943a:	00 
 804943b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 804943f:	a1 30 c2 04 08       	mov    0x804c230,%eax
 8049444:	89 04 24             	mov    %eax,(%esp)
 8049447:	e8 9c 0a 00 00       	call   8049ee8 <driver_post>
 804944c:	85 c0                	test   %eax,%eax
 804944e:	75 0e                	jne    804945e <validate+0x11a>
 8049450:	c7 04 24 40 a5 04 08 	movl   $0x804a540,(%esp)
 8049457:	e8 14 f5 ff ff       	call   8048970 <puts@plt>
 804945c:	eb 16                	jmp    8049474 <validate+0x130>
 804945e:	8d 85 f8 bf ff ff    	lea    -0x4008(%ebp),%eax
 8049464:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049468:	c7 04 24 70 a5 04 08 	movl   $0x804a570,(%esp)
 804946f:	e8 5c f4 ff ff       	call   80488d0 <printf@plt>
 8049474:	c7 04 24 dd a5 04 08 	movl   $0x804a5dd,(%esp)
 804947b:	e8 f0 f4 ff ff       	call   8048970 <puts@plt>
 8049480:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 8049483:	8b 7d fc             	mov    -0x4(%ebp),%edi
 8049486:	89 ec                	mov    %ebp,%esp
 8049488:	5d                   	pop    %ebp
 8049489:	c3                   	ret    
 804948a:	90                   	nop
 804948b:	90                   	nop
 804948c:	90                   	nop
 804948d:	90                   	nop
 804948e:	90                   	nop
 804948f:	90                   	nop

08049490 <rio_readlineb>:
 8049490:	55                   	push   %ebp
 8049491:	89 e5                	mov    %esp,%ebp
 8049493:	57                   	push   %edi
 8049494:	56                   	push   %esi
 8049495:	53                   	push   %ebx
 8049496:	83 ec 4c             	sub    $0x4c,%esp
 8049499:	83 f9 01             	cmp    $0x1,%ecx
 804949c:	0f 86 c2 00 00 00    	jbe    8049564 <rio_readlineb+0xd4>
 80494a2:	89 c3                	mov    %eax,%ebx
 80494a4:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
 80494a7:	89 55 d0             	mov    %edx,-0x30(%ebp)
 80494aa:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 80494b1:	8d 78 0c             	lea    0xc(%eax),%edi
 80494b4:	eb 36                	jmp    80494ec <rio_readlineb+0x5c>
 80494b6:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
 80494bd:	00 
 80494be:	89 7c 24 04          	mov    %edi,0x4(%esp)
 80494c2:	8b 03                	mov    (%ebx),%eax
 80494c4:	89 04 24             	mov    %eax,(%esp)
 80494c7:	e8 e4 f3 ff ff       	call   80488b0 <read@plt>
 80494cc:	89 43 04             	mov    %eax,0x4(%ebx)
 80494cf:	85 c0                	test   %eax,%eax
 80494d1:	79 12                	jns    80494e5 <rio_readlineb+0x55>
 80494d3:	e8 58 f5 ff ff       	call   8048a30 <__errno_location@plt>
 80494d8:	83 38 04             	cmpl   $0x4,(%eax)
 80494db:	74 0f                	je     80494ec <rio_readlineb+0x5c>
 80494dd:	8d 76 00             	lea    0x0(%esi),%esi
 80494e0:	e9 91 00 00 00       	jmp    8049576 <rio_readlineb+0xe6>
 80494e5:	85 c0                	test   %eax,%eax
 80494e7:	74 63                	je     804954c <rio_readlineb+0xbc>
 80494e9:	89 7b 08             	mov    %edi,0x8(%ebx)
 80494ec:	8b 73 04             	mov    0x4(%ebx),%esi
 80494ef:	85 f6                	test   %esi,%esi
 80494f1:	7e c3                	jle    80494b6 <rio_readlineb+0x26>
 80494f3:	85 f6                	test   %esi,%esi
 80494f5:	0f 95 c0             	setne  %al
 80494f8:	0f b6 c0             	movzbl %al,%eax
 80494fb:	89 45 cc             	mov    %eax,-0x34(%ebp)
 80494fe:	8b 53 08             	mov    0x8(%ebx),%edx
 8049501:	89 55 c8             	mov    %edx,-0x38(%ebp)
 8049504:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049508:	89 54 24 04          	mov    %edx,0x4(%esp)
 804950c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 804950f:	89 04 24             	mov    %eax,(%esp)
 8049512:	e8 c9 f3 ff ff       	call   80488e0 <memcpy@plt>
 8049517:	8b 45 c8             	mov    -0x38(%ebp),%eax
 804951a:	03 45 cc             	add    -0x34(%ebp),%eax
 804951d:	89 43 08             	mov    %eax,0x8(%ebx)
 8049520:	2b 75 cc             	sub    -0x34(%ebp),%esi
 8049523:	89 73 04             	mov    %esi,0x4(%ebx)
 8049526:	83 7d cc 01          	cmpl   $0x1,-0x34(%ebp)
 804952a:	75 15                	jne    8049541 <rio_readlineb+0xb1>
 804952c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 8049530:	8b 55 d0             	mov    -0x30(%ebp),%edx
 8049533:	88 02                	mov    %al,(%edx)
 8049535:	83 c2 01             	add    $0x1,%edx
 8049538:	89 55 d0             	mov    %edx,-0x30(%ebp)
 804953b:	3c 0a                	cmp    $0xa,%al
 804953d:	75 17                	jne    8049556 <rio_readlineb+0xc6>
 804953f:	eb 2d                	jmp    804956e <rio_readlineb+0xde>
 8049541:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
 8049545:	75 38                	jne    804957f <rio_readlineb+0xef>
 8049547:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 804954a:	eb 03                	jmp    804954f <rio_readlineb+0xbf>
 804954c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 804954f:	83 f8 01             	cmp    $0x1,%eax
 8049552:	75 1a                	jne    804956e <rio_readlineb+0xde>
 8049554:	eb 32                	jmp    8049588 <rio_readlineb+0xf8>
 8049556:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
 804955a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 804955d:	39 45 d4             	cmp    %eax,-0x2c(%ebp)
 8049560:	75 8a                	jne    80494ec <rio_readlineb+0x5c>
 8049562:	eb 0a                	jmp    804956e <rio_readlineb+0xde>
 8049564:	89 55 d0             	mov    %edx,-0x30(%ebp)
 8049567:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
 804956e:	8b 55 d0             	mov    -0x30(%ebp),%edx
 8049571:	c6 02 00             	movb   $0x0,(%edx)
 8049574:	eb 19                	jmp    804958f <rio_readlineb+0xff>
 8049576:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
 804957d:	eb 10                	jmp    804958f <rio_readlineb+0xff>
 804957f:	c7 45 d4 ff ff ff ff 	movl   $0xffffffff,-0x2c(%ebp)
 8049586:	eb 07                	jmp    804958f <rio_readlineb+0xff>
 8049588:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 804958f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 8049592:	83 c4 4c             	add    $0x4c,%esp
 8049595:	5b                   	pop    %ebx
 8049596:	5e                   	pop    %esi
 8049597:	5f                   	pop    %edi
 8049598:	5d                   	pop    %ebp
 8049599:	c3                   	ret    

0804959a <sigalrm_handler>:
 804959a:	55                   	push   %ebp
 804959b:	89 e5                	mov    %esp,%ebp
 804959d:	83 ec 18             	sub    $0x18,%esp
 80495a0:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
 80495a7:	00 
 80495a8:	c7 04 24 4c a6 04 08 	movl   $0x804a64c,(%esp)
 80495af:	e8 1c f3 ff ff       	call   80488d0 <printf@plt>
 80495b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 80495bb:	e8 d0 f3 ff ff       	call   8048990 <exit@plt>

080495c0 <submitr>:
 80495c0:	55                   	push   %ebp
 80495c1:	89 e5                	mov    %esp,%ebp
 80495c3:	57                   	push   %edi
 80495c4:	56                   	push   %esi
 80495c5:	53                   	push   %ebx
 80495c6:	81 ec 6c a0 00 00    	sub    $0xa06c,%esp
 80495cc:	8b 7d 08             	mov    0x8(%ebp),%edi
 80495cf:	8b 5d 1c             	mov    0x1c(%ebp),%ebx
 80495d2:	c7 85 c8 7f ff ff 00 	movl   $0x0,-0x8038(%ebp)
 80495d9:	00 00 00 
 80495dc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 80495e3:	00 
 80495e4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 80495eb:	00 
 80495ec:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 80495f3:	e8 78 f4 ff ff       	call   8048a70 <socket@plt>
 80495f8:	89 85 b4 5f ff ff    	mov    %eax,-0xa04c(%ebp)
 80495fe:	85 c0                	test   %eax,%eax
 8049600:	79 51                	jns    8049653 <submitr+0x93>
 8049602:	8b 45 20             	mov    0x20(%ebp),%eax
 8049605:	c7 00 45 72 72 6f    	movl   $0x6f727245,(%eax)
 804960b:	c7 40 04 72 3a 20 43 	movl   $0x43203a72,0x4(%eax)
 8049612:	c7 40 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%eax)
 8049619:	c7 40 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%eax)
 8049620:	c7 40 10 61 62 6c 65 	movl   $0x656c6261,0x10(%eax)
 8049627:	c7 40 14 20 74 6f 20 	movl   $0x206f7420,0x14(%eax)
 804962e:	c7 40 18 63 72 65 61 	movl   $0x61657263,0x18(%eax)
 8049635:	c7 40 1c 74 65 20 73 	movl   $0x73206574,0x1c(%eax)
 804963c:	c7 40 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%eax)
 8049643:	66 c7 40 24 74 00    	movw   $0x74,0x24(%eax)
 8049649:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 804964e:	e9 b4 06 00 00       	jmp    8049d07 <submitr+0x747>
 8049653:	89 3c 24             	mov    %edi,(%esp)
 8049656:	e8 35 f4 ff ff       	call   8048a90 <gethostbyname@plt>
 804965b:	85 c0                	test   %eax,%eax
 804965d:	75 2f                	jne    804968e <submitr+0xce>
 804965f:	89 7c 24 08          	mov    %edi,0x8(%esp)
 8049663:	c7 44 24 04 70 a6 04 	movl   $0x804a670,0x4(%esp)
 804966a:	08 
 804966b:	8b 55 20             	mov    0x20(%ebp),%edx
 804966e:	89 14 24             	mov    %edx,(%esp)
 8049671:	e8 ea f3 ff ff       	call   8048a60 <sprintf@plt>
 8049676:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 804967c:	89 04 24             	mov    %eax,(%esp)
 804967f:	e8 2c f4 ff ff       	call   8048ab0 <close@plt>
 8049684:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049689:	e9 79 06 00 00       	jmp    8049d07 <submitr+0x747>
 804968e:	8d 75 d8             	lea    -0x28(%ebp),%esi
 8049691:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 8049698:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 804969f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 80496a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 80496ad:	66 c7 45 d8 02 00    	movw   $0x2,-0x28(%ebp)
 80496b3:	8b 50 0c             	mov    0xc(%eax),%edx
 80496b6:	89 54 24 08          	mov    %edx,0x8(%esp)
 80496ba:	8d 55 dc             	lea    -0x24(%ebp),%edx
 80496bd:	89 54 24 04          	mov    %edx,0x4(%esp)
 80496c1:	8b 40 10             	mov    0x10(%eax),%eax
 80496c4:	8b 00                	mov    (%eax),%eax
 80496c6:	89 04 24             	mov    %eax,(%esp)
 80496c9:	e8 62 f2 ff ff       	call   8048930 <bcopy@plt>
 80496ce:	0f b7 45 0c          	movzwl 0xc(%ebp),%eax
 80496d2:	66 c1 c8 08          	ror    $0x8,%ax
 80496d6:	66 89 45 da          	mov    %ax,-0x26(%ebp)
 80496da:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 80496e1:	00 
 80496e2:	89 74 24 04          	mov    %esi,0x4(%esp)
 80496e6:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 80496ec:	89 04 24             	mov    %eax,(%esp)
 80496ef:	e8 ac f3 ff ff       	call   8048aa0 <connect@plt>
 80496f4:	85 c0                	test   %eax,%eax
 80496f6:	79 2f                	jns    8049727 <submitr+0x167>
 80496f8:	89 7c 24 08          	mov    %edi,0x8(%esp)
 80496fc:	c7 44 24 04 9c a6 04 	movl   $0x804a69c,0x4(%esp)
 8049703:	08 
 8049704:	8b 55 20             	mov    0x20(%ebp),%edx
 8049707:	89 14 24             	mov    %edx,(%esp)
 804970a:	e8 51 f3 ff ff       	call   8048a60 <sprintf@plt>
 804970f:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049715:	89 04 24             	mov    %eax,(%esp)
 8049718:	e8 93 f3 ff ff       	call   8048ab0 <close@plt>
 804971d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049722:	e9 e0 05 00 00       	jmp    8049d07 <submitr+0x747>
 8049727:	ba ff ff ff ff       	mov    $0xffffffff,%edx
 804972c:	89 df                	mov    %ebx,%edi
 804972e:	b8 00 00 00 00       	mov    $0x0,%eax
 8049733:	89 d1                	mov    %edx,%ecx
 8049735:	f2 ae                	repnz scas %es:(%edi),%al
 8049737:	f7 d1                	not    %ecx
 8049739:	89 8d ac 5f ff ff    	mov    %ecx,-0xa054(%ebp)
 804973f:	8b 7d 10             	mov    0x10(%ebp),%edi
 8049742:	89 d1                	mov    %edx,%ecx
 8049744:	f2 ae                	repnz scas %es:(%edi),%al
 8049746:	89 8d a8 5f ff ff    	mov    %ecx,-0xa058(%ebp)
 804974c:	8b 7d 14             	mov    0x14(%ebp),%edi
 804974f:	89 d1                	mov    %edx,%ecx
 8049751:	f2 ae                	repnz scas %es:(%edi),%al
 8049753:	89 ce                	mov    %ecx,%esi
 8049755:	f7 d6                	not    %esi
 8049757:	8b 7d 18             	mov    0x18(%ebp),%edi
 804975a:	89 d1                	mov    %edx,%ecx
 804975c:	f2 ae                	repnz scas %es:(%edi),%al
 804975e:	2b b5 a8 5f ff ff    	sub    -0xa058(%ebp),%esi
 8049764:	29 ce                	sub    %ecx,%esi
 8049766:	8b 95 ac 5f ff ff    	mov    -0xa054(%ebp),%edx
 804976c:	8d 44 52 fd          	lea    -0x3(%edx,%edx,2),%eax
 8049770:	8d 44 06 7b          	lea    0x7b(%esi,%eax,1),%eax
 8049774:	3d 00 20 00 00       	cmp    $0x2000,%eax
 8049779:	76 7c                	jbe    80497f7 <submitr+0x237>
 804977b:	8b 4d 20             	mov    0x20(%ebp),%ecx
 804977e:	c7 01 45 72 72 6f    	movl   $0x6f727245,(%ecx)
 8049784:	c7 41 04 72 3a 20 52 	movl   $0x52203a72,0x4(%ecx)
 804978b:	c7 41 08 65 73 75 6c 	movl   $0x6c757365,0x8(%ecx)
 8049792:	c7 41 0c 74 20 73 74 	movl   $0x74732074,0xc(%ecx)
 8049799:	c7 41 10 72 69 6e 67 	movl   $0x676e6972,0x10(%ecx)
 80497a0:	c7 41 14 20 74 6f 6f 	movl   $0x6f6f7420,0x14(%ecx)
 80497a7:	c7 41 18 20 6c 61 72 	movl   $0x72616c20,0x18(%ecx)
 80497ae:	c7 41 1c 67 65 2e 20 	movl   $0x202e6567,0x1c(%ecx)
 80497b5:	c7 41 20 49 6e 63 72 	movl   $0x72636e49,0x20(%ecx)
 80497bc:	c7 41 24 65 61 73 65 	movl   $0x65736165,0x24(%ecx)
 80497c3:	c7 41 28 20 53 55 42 	movl   $0x42555320,0x28(%ecx)
 80497ca:	c7 41 2c 4d 49 54 52 	movl   $0x5254494d,0x2c(%ecx)
 80497d1:	c7 41 30 5f 4d 41 58 	movl   $0x58414d5f,0x30(%ecx)
 80497d8:	c7 41 34 42 55 46 00 	movl   $0x465542,0x34(%ecx)
 80497df:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 80497e5:	89 04 24             	mov    %eax,(%esp)
 80497e8:	e8 c3 f2 ff ff       	call   8048ab0 <close@plt>
 80497ed:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80497f2:	e9 10 05 00 00       	jmp    8049d07 <submitr+0x747>
 80497f7:	8d 95 cc 9f ff ff    	lea    -0x6034(%ebp),%edx
 80497fd:	b9 00 08 00 00       	mov    $0x800,%ecx
 8049802:	b8 00 00 00 00       	mov    $0x0,%eax
 8049807:	89 d7                	mov    %edx,%edi
 8049809:	f3 ab                	rep stos %eax,%es:(%edi)
 804980b:	89 df                	mov    %ebx,%edi
 804980d:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 8049812:	f2 ae                	repnz scas %es:(%edi),%al
 8049814:	f7 d1                	not    %ecx
 8049816:	89 cf                	mov    %ecx,%edi
 8049818:	83 ef 01             	sub    $0x1,%edi
 804981b:	0f 84 0d 04 00 00    	je     8049c2e <submitr+0x66e>
 8049821:	89 d6                	mov    %edx,%esi
 8049823:	0f b6 03             	movzbl (%ebx),%eax
 8049826:	3c 2d                	cmp    $0x2d,%al
 8049828:	74 24                	je     804984e <submitr+0x28e>
 804982a:	3c 2a                	cmp    $0x2a,%al
 804982c:	74 20                	je     804984e <submitr+0x28e>
 804982e:	3c 2e                	cmp    $0x2e,%al
 8049830:	74 1c                	je     804984e <submitr+0x28e>
 8049832:	3c 5f                	cmp    $0x5f,%al
 8049834:	74 18                	je     804984e <submitr+0x28e>
 8049836:	8d 50 d0             	lea    -0x30(%eax),%edx
 8049839:	80 fa 09             	cmp    $0x9,%dl
 804983c:	76 10                	jbe    804984e <submitr+0x28e>
 804983e:	8d 50 bf             	lea    -0x41(%eax),%edx
 8049841:	80 fa 19             	cmp    $0x19,%dl
 8049844:	76 08                	jbe    804984e <submitr+0x28e>
 8049846:	8d 50 9f             	lea    -0x61(%eax),%edx
 8049849:	80 fa 19             	cmp    $0x19,%dl
 804984c:	77 07                	ja     8049855 <submitr+0x295>
 804984e:	88 06                	mov    %al,(%esi)
 8049850:	83 c6 01             	add    $0x1,%esi
 8049853:	eb 59                	jmp    80498ae <submitr+0x2ee>
 8049855:	3c 20                	cmp    $0x20,%al
 8049857:	75 08                	jne    8049861 <submitr+0x2a1>
 8049859:	c6 06 2b             	movb   $0x2b,(%esi)
 804985c:	83 c6 01             	add    $0x1,%esi
 804985f:	eb 4d                	jmp    80498ae <submitr+0x2ee>
 8049861:	8d 50 e0             	lea    -0x20(%eax),%edx
 8049864:	80 fa 5f             	cmp    $0x5f,%dl
 8049867:	76 08                	jbe    8049871 <submitr+0x2b1>
 8049869:	3c 09                	cmp    $0x9,%al
 804986b:	0f 85 18 04 00 00    	jne    8049c89 <submitr+0x6c9>
 8049871:	0f b6 c0             	movzbl %al,%eax
 8049874:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049878:	c7 44 24 04 b0 a7 04 	movl   $0x804a7b0,0x4(%esp)
 804987f:	08 
 8049880:	8d 95 c0 5f ff ff    	lea    -0xa040(%ebp),%edx
 8049886:	89 14 24             	mov    %edx,(%esp)
 8049889:	e8 d2 f1 ff ff       	call   8048a60 <sprintf@plt>
 804988e:	0f b6 85 c0 5f ff ff 	movzbl -0xa040(%ebp),%eax
 8049895:	88 06                	mov    %al,(%esi)
 8049897:	0f b6 85 c1 5f ff ff 	movzbl -0xa03f(%ebp),%eax
 804989e:	88 46 01             	mov    %al,0x1(%esi)
 80498a1:	0f b6 85 c2 5f ff ff 	movzbl -0xa03e(%ebp),%eax
 80498a8:	88 46 02             	mov    %al,0x2(%esi)
 80498ab:	83 c6 03             	add    $0x3,%esi
 80498ae:	83 c3 01             	add    $0x1,%ebx
 80498b1:	83 ef 01             	sub    $0x1,%edi
 80498b4:	0f 85 69 ff ff ff    	jne    8049823 <submitr+0x263>
 80498ba:	e9 6f 03 00 00       	jmp    8049c2e <submitr+0x66e>
 80498bf:	89 bd b0 5f ff ff    	mov    %edi,-0xa050(%ebp)
 80498c5:	8b bd b4 5f ff ff    	mov    -0xa04c(%ebp),%edi
 80498cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
 80498cf:	89 74 24 04          	mov    %esi,0x4(%esp)
 80498d3:	89 3c 24             	mov    %edi,(%esp)
 80498d6:	e8 f5 f0 ff ff       	call   80489d0 <write@plt>
 80498db:	85 c0                	test   %eax,%eax
 80498dd:	7f 0f                	jg     80498ee <submitr+0x32e>
 80498df:	e8 4c f1 ff ff       	call   8048a30 <__errno_location@plt>
 80498e4:	83 38 04             	cmpl   $0x4,(%eax)
 80498e7:	75 15                	jne    80498fe <submitr+0x33e>
 80498e9:	b8 00 00 00 00       	mov    $0x0,%eax
 80498ee:	01 c6                	add    %eax,%esi
 80498f0:	29 c3                	sub    %eax,%ebx
 80498f2:	75 d7                	jne    80498cb <submitr+0x30b>
 80498f4:	8b bd b0 5f ff ff    	mov    -0xa050(%ebp),%edi
 80498fa:	85 ff                	test   %edi,%edi
 80498fc:	79 67                	jns    8049965 <submitr+0x3a5>
 80498fe:	8b 4d 20             	mov    0x20(%ebp),%ecx
 8049901:	c7 01 45 72 72 6f    	movl   $0x6f727245,(%ecx)
 8049907:	c7 41 04 72 3a 20 43 	movl   $0x43203a72,0x4(%ecx)
 804990e:	c7 41 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%ecx)
 8049915:	c7 41 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%ecx)
 804991c:	c7 41 10 61 62 6c 65 	movl   $0x656c6261,0x10(%ecx)
 8049923:	c7 41 14 20 74 6f 20 	movl   $0x206f7420,0x14(%ecx)
 804992a:	c7 41 18 77 72 69 74 	movl   $0x74697277,0x18(%ecx)
 8049931:	c7 41 1c 65 20 74 6f 	movl   $0x6f742065,0x1c(%ecx)
 8049938:	c7 41 20 20 74 68 65 	movl   $0x65687420,0x20(%ecx)
 804993f:	c7 41 24 20 73 65 72 	movl   $0x72657320,0x24(%ecx)
 8049946:	c7 41 28 76 65 72 00 	movl   $0x726576,0x28(%ecx)
 804994d:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049953:	89 04 24             	mov    %eax,(%esp)
 8049956:	e8 55 f1 ff ff       	call   8048ab0 <close@plt>
 804995b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049960:	e9 a2 03 00 00       	jmp    8049d07 <submitr+0x747>
 8049965:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 804996b:	89 85 cc df ff ff    	mov    %eax,-0x2034(%ebp)
 8049971:	c7 85 d0 df ff ff 00 	movl   $0x0,-0x2030(%ebp)
 8049978:	00 00 00 
 804997b:	8d 85 d8 df ff ff    	lea    -0x2028(%ebp),%eax
 8049981:	89 85 d4 df ff ff    	mov    %eax,-0x202c(%ebp)
 8049987:	b9 00 20 00 00       	mov    $0x2000,%ecx
 804998c:	8d 95 cc bf ff ff    	lea    -0x4034(%ebp),%edx
 8049992:	8d 85 cc df ff ff    	lea    -0x2034(%ebp),%eax
 8049998:	e8 f3 fa ff ff       	call   8049490 <rio_readlineb>
 804999d:	85 c0                	test   %eax,%eax
 804999f:	7f 7b                	jg     8049a1c <submitr+0x45c>
 80499a1:	8b 55 20             	mov    0x20(%ebp),%edx
 80499a4:	c7 02 45 72 72 6f    	movl   $0x6f727245,(%edx)
 80499aa:	c7 42 04 72 3a 20 43 	movl   $0x43203a72,0x4(%edx)
 80499b1:	c7 42 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%edx)
 80499b8:	c7 42 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%edx)
 80499bf:	c7 42 10 61 62 6c 65 	movl   $0x656c6261,0x10(%edx)
 80499c6:	c7 42 14 20 74 6f 20 	movl   $0x206f7420,0x14(%edx)
 80499cd:	c7 42 18 72 65 61 64 	movl   $0x64616572,0x18(%edx)
 80499d4:	c7 42 1c 20 66 69 72 	movl   $0x72696620,0x1c(%edx)
 80499db:	c7 42 20 73 74 20 68 	movl   $0x68207473,0x20(%edx)
 80499e2:	c7 42 24 65 61 64 65 	movl   $0x65646165,0x24(%edx)
 80499e9:	c7 42 28 72 20 66 72 	movl   $0x72662072,0x28(%edx)
 80499f0:	c7 42 2c 6f 6d 20 73 	movl   $0x73206d6f,0x2c(%edx)
 80499f7:	c7 42 30 65 72 76 65 	movl   $0x65767265,0x30(%edx)
 80499fe:	66 c7 42 34 72 00    	movw   $0x72,0x34(%edx)
 8049a04:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049a0a:	89 04 24             	mov    %eax,(%esp)
 8049a0d:	e8 9e f0 ff ff       	call   8048ab0 <close@plt>
 8049a12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049a17:	e9 eb 02 00 00       	jmp    8049d07 <submitr+0x747>
 8049a1c:	8d 85 c8 5f ff ff    	lea    -0xa038(%ebp),%eax
 8049a22:	89 44 24 10          	mov    %eax,0x10(%esp)
 8049a26:	8d 85 c8 7f ff ff    	lea    -0x8038(%ebp),%eax
 8049a2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049a30:	8d 85 cc 7f ff ff    	lea    -0x8034(%ebp),%eax
 8049a36:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049a3a:	c7 44 24 04 b7 a7 04 	movl   $0x804a7b7,0x4(%esp)
 8049a41:	08 
 8049a42:	8d 85 cc bf ff ff    	lea    -0x4034(%ebp),%eax
 8049a48:	89 04 24             	mov    %eax,(%esp)
 8049a4b:	e8 b0 ef ff ff       	call   8048a00 <__isoc99_sscanf@plt>
 8049a50:	8b 85 c8 7f ff ff    	mov    -0x8038(%ebp),%eax
 8049a56:	3d c8 00 00 00       	cmp    $0xc8,%eax
 8049a5b:	0f 84 c5 00 00 00    	je     8049b26 <submitr+0x566>
 8049a61:	8d 95 c8 5f ff ff    	lea    -0xa038(%ebp),%edx
 8049a67:	89 54 24 0c          	mov    %edx,0xc(%esp)
 8049a6b:	89 44 24 08          	mov    %eax,0x8(%esp)
 8049a6f:	c7 44 24 04 c4 a6 04 	movl   $0x804a6c4,0x4(%esp)
 8049a76:	08 
 8049a77:	8b 55 20             	mov    0x20(%ebp),%edx
 8049a7a:	89 14 24             	mov    %edx,(%esp)
 8049a7d:	e8 de ef ff ff       	call   8048a60 <sprintf@plt>
 8049a82:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049a88:	89 04 24             	mov    %eax,(%esp)
 8049a8b:	e8 20 f0 ff ff       	call   8048ab0 <close@plt>
 8049a90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049a95:	e9 6d 02 00 00       	jmp    8049d07 <submitr+0x747>
 8049a9a:	b9 00 20 00 00       	mov    $0x2000,%ecx
 8049a9f:	8d 95 cc bf ff ff    	lea    -0x4034(%ebp),%edx
 8049aa5:	8d 85 cc df ff ff    	lea    -0x2034(%ebp),%eax
 8049aab:	e8 e0 f9 ff ff       	call   8049490 <rio_readlineb>
 8049ab0:	85 c0                	test   %eax,%eax
 8049ab2:	7f 72                	jg     8049b26 <submitr+0x566>
 8049ab4:	8b 55 20             	mov    0x20(%ebp),%edx
 8049ab7:	c7 02 45 72 72 6f    	movl   $0x6f727245,(%edx)
 8049abd:	c7 42 04 72 3a 20 43 	movl   $0x43203a72,0x4(%edx)
 8049ac4:	c7 42 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%edx)
 8049acb:	c7 42 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%edx)
 8049ad2:	c7 42 10 61 62 6c 65 	movl   $0x656c6261,0x10(%edx)
 8049ad9:	c7 42 14 20 74 6f 20 	movl   $0x206f7420,0x14(%edx)
 8049ae0:	c7 42 18 72 65 61 64 	movl   $0x64616572,0x18(%edx)
 8049ae7:	c7 42 1c 20 68 65 61 	movl   $0x61656820,0x1c(%edx)
 8049aee:	c7 42 20 64 65 72 73 	movl   $0x73726564,0x20(%edx)
 8049af5:	c7 42 24 20 66 72 6f 	movl   $0x6f726620,0x24(%edx)
 8049afc:	c7 42 28 6d 20 73 65 	movl   $0x6573206d,0x28(%edx)
 8049b03:	c7 42 2c 72 76 65 72 	movl   $0x72657672,0x2c(%edx)
 8049b0a:	c6 42 30 00          	movb   $0x0,0x30(%edx)
 8049b0e:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049b14:	89 04 24             	mov    %eax,(%esp)
 8049b17:	e8 94 ef ff ff       	call   8048ab0 <close@plt>
 8049b1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049b21:	e9 e1 01 00 00       	jmp    8049d07 <submitr+0x747>
 8049b26:	80 bd cc bf ff ff 0d 	cmpb   $0xd,-0x4034(%ebp)
 8049b2d:	0f 85 67 ff ff ff    	jne    8049a9a <submitr+0x4da>
 8049b33:	80 bd cd bf ff ff 0a 	cmpb   $0xa,-0x4033(%ebp)
 8049b3a:	0f 85 5a ff ff ff    	jne    8049a9a <submitr+0x4da>
 8049b40:	80 bd ce bf ff ff 00 	cmpb   $0x0,-0x4032(%ebp)
 8049b47:	0f 85 4d ff ff ff    	jne    8049a9a <submitr+0x4da>
 8049b4d:	b9 00 20 00 00       	mov    $0x2000,%ecx
 8049b52:	8d 95 cc bf ff ff    	lea    -0x4034(%ebp),%edx
 8049b58:	8d 85 cc df ff ff    	lea    -0x2034(%ebp),%eax
 8049b5e:	e8 2d f9 ff ff       	call   8049490 <rio_readlineb>
 8049b63:	85 c0                	test   %eax,%eax
 8049b65:	7f 7c                	jg     8049be3 <submitr+0x623>
 8049b67:	8b 55 20             	mov    0x20(%ebp),%edx
 8049b6a:	c7 02 45 72 72 6f    	movl   $0x6f727245,(%edx)
 8049b70:	c7 42 04 72 3a 20 43 	movl   $0x43203a72,0x4(%edx)
 8049b77:	c7 42 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%edx)
 8049b7e:	c7 42 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%edx)
 8049b85:	c7 42 10 61 62 6c 65 	movl   $0x656c6261,0x10(%edx)
 8049b8c:	c7 42 14 20 74 6f 20 	movl   $0x206f7420,0x14(%edx)
 8049b93:	c7 42 18 72 65 61 64 	movl   $0x64616572,0x18(%edx)
 8049b9a:	c7 42 1c 20 73 74 61 	movl   $0x61747320,0x1c(%edx)
 8049ba1:	c7 42 20 74 75 73 20 	movl   $0x20737574,0x20(%edx)
 8049ba8:	c7 42 24 6d 65 73 73 	movl   $0x7373656d,0x24(%edx)
 8049baf:	c7 42 28 61 67 65 20 	movl   $0x20656761,0x28(%edx)
 8049bb6:	c7 42 2c 66 72 6f 6d 	movl   $0x6d6f7266,0x2c(%edx)
 8049bbd:	c7 42 30 20 73 65 72 	movl   $0x72657320,0x30(%edx)
 8049bc4:	c7 42 34 76 65 72 00 	movl   $0x726576,0x34(%edx)
 8049bcb:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049bd1:	89 04 24             	mov    %eax,(%esp)
 8049bd4:	e8 d7 ee ff ff       	call   8048ab0 <close@plt>
 8049bd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049bde:	e9 24 01 00 00       	jmp    8049d07 <submitr+0x747>
 8049be3:	8d 85 cc bf ff ff    	lea    -0x4034(%ebp),%eax
 8049be9:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049bed:	8b 55 20             	mov    0x20(%ebp),%edx
 8049bf0:	89 14 24             	mov    %edx,(%esp)
 8049bf3:	e8 48 ed ff ff       	call   8048940 <strcpy@plt>
 8049bf8:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049bfe:	89 04 24             	mov    %eax,(%esp)
 8049c01:	e8 aa ee ff ff       	call   8048ab0 <close@plt>
 8049c06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049c0b:	8b 55 20             	mov    0x20(%ebp),%edx
 8049c0e:	80 3a 4f             	cmpb   $0x4f,(%edx)
 8049c11:	0f 85 f0 00 00 00    	jne    8049d07 <submitr+0x747>
 8049c17:	80 7a 01 4b          	cmpb   $0x4b,0x1(%edx)
 8049c1b:	0f 85 e6 00 00 00    	jne    8049d07 <submitr+0x747>
 8049c21:	80 7a 02 01          	cmpb   $0x1,0x2(%edx)
 8049c25:	19 c0                	sbb    %eax,%eax
 8049c27:	f7 d0                	not    %eax
 8049c29:	e9 d9 00 00 00       	jmp    8049d07 <submitr+0x747>
 8049c2e:	8d 85 cc 9f ff ff    	lea    -0x6034(%ebp),%eax
 8049c34:	89 44 24 14          	mov    %eax,0x14(%esp)
 8049c38:	8b 4d 18             	mov    0x18(%ebp),%ecx
 8049c3b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
 8049c3f:	8b 45 14             	mov    0x14(%ebp),%eax
 8049c42:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049c46:	8b 55 10             	mov    0x10(%ebp),%edx
 8049c49:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049c4d:	c7 44 24 04 f4 a6 04 	movl   $0x804a6f4,0x4(%esp)
 8049c54:	08 
 8049c55:	8d bd cc bf ff ff    	lea    -0x4034(%ebp),%edi
 8049c5b:	89 3c 24             	mov    %edi,(%esp)
 8049c5e:	e8 fd ed ff ff       	call   8048a60 <sprintf@plt>
 8049c63:	b8 00 00 00 00       	mov    $0x0,%eax
 8049c68:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
 8049c6d:	f2 ae                	repnz scas %es:(%edi),%al
 8049c6f:	f7 d1                	not    %ecx
 8049c71:	8d 79 ff             	lea    -0x1(%ecx),%edi
 8049c74:	89 fb                	mov    %edi,%ebx
 8049c76:	8d b5 cc bf ff ff    	lea    -0x4034(%ebp),%esi
 8049c7c:	85 ff                	test   %edi,%edi
 8049c7e:	0f 85 3b fc ff ff    	jne    80498bf <submitr+0x2ff>
 8049c84:	e9 dc fc ff ff       	jmp    8049965 <submitr+0x3a5>
 8049c89:	8b 7d 20             	mov    0x20(%ebp),%edi
 8049c8c:	be 40 a7 04 08       	mov    $0x804a740,%esi
 8049c91:	b8 43 00 00 00       	mov    $0x43,%eax
 8049c96:	f7 c7 01 00 00 00    	test   $0x1,%edi
 8049c9c:	74 19                	je     8049cb7 <submitr+0x6f7>
 8049c9e:	0f b6 05 40 a7 04 08 	movzbl 0x804a740,%eax
 8049ca5:	88 07                	mov    %al,(%edi)
 8049ca7:	8b 7d 20             	mov    0x20(%ebp),%edi
 8049caa:	83 c7 01             	add    $0x1,%edi
 8049cad:	be 41 a7 04 08       	mov    $0x804a741,%esi
 8049cb2:	b8 42 00 00 00       	mov    $0x42,%eax
 8049cb7:	f7 c7 02 00 00 00    	test   $0x2,%edi
 8049cbd:	74 0f                	je     8049cce <submitr+0x70e>
 8049cbf:	0f b7 16             	movzwl (%esi),%edx
 8049cc2:	66 89 17             	mov    %dx,(%edi)
 8049cc5:	83 c7 02             	add    $0x2,%edi
 8049cc8:	83 c6 02             	add    $0x2,%esi
 8049ccb:	83 e8 02             	sub    $0x2,%eax
 8049cce:	89 c1                	mov    %eax,%ecx
 8049cd0:	c1 e9 02             	shr    $0x2,%ecx
 8049cd3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
 8049cd5:	ba 00 00 00 00       	mov    $0x0,%edx
 8049cda:	a8 02                	test   $0x2,%al
 8049cdc:	74 0b                	je     8049ce9 <submitr+0x729>
 8049cde:	0f b7 16             	movzwl (%esi),%edx
 8049ce1:	66 89 17             	mov    %dx,(%edi)
 8049ce4:	ba 02 00 00 00       	mov    $0x2,%edx
 8049ce9:	a8 01                	test   $0x1,%al
 8049ceb:	74 07                	je     8049cf4 <submitr+0x734>
 8049ced:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
 8049cf1:	88 04 17             	mov    %al,(%edi,%edx,1)
 8049cf4:	8b 85 b4 5f ff ff    	mov    -0xa04c(%ebp),%eax
 8049cfa:	89 04 24             	mov    %eax,(%esp)
 8049cfd:	e8 ae ed ff ff       	call   8048ab0 <close@plt>
 8049d02:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049d07:	81 c4 6c a0 00 00    	add    $0xa06c,%esp
 8049d0d:	5b                   	pop    %ebx
 8049d0e:	5e                   	pop    %esi
 8049d0f:	5f                   	pop    %edi
 8049d10:	5d                   	pop    %ebp
 8049d11:	c3                   	ret    

08049d12 <init_timeout>:
 8049d12:	55                   	push   %ebp
 8049d13:	89 e5                	mov    %esp,%ebp
 8049d15:	53                   	push   %ebx
 8049d16:	83 ec 14             	sub    $0x14,%esp
 8049d19:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8049d1c:	85 db                	test   %ebx,%ebx
 8049d1e:	74 25                	je     8049d45 <init_timeout+0x33>
 8049d20:	85 db                	test   %ebx,%ebx
 8049d22:	79 05                	jns    8049d29 <init_timeout+0x17>
 8049d24:	bb 02 00 00 00       	mov    $0x2,%ebx
 8049d29:	c7 44 24 04 9a 95 04 	movl   $0x804959a,0x4(%esp)
 8049d30:	08 
 8049d31:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
 8049d38:	e8 b3 eb ff ff       	call   80488f0 <signal@plt>
 8049d3d:	89 1c 24             	mov    %ebx,(%esp)
 8049d40:	e8 bb eb ff ff       	call   8048900 <alarm@plt>
 8049d45:	83 c4 14             	add    $0x14,%esp
 8049d48:	5b                   	pop    %ebx
 8049d49:	5d                   	pop    %ebp
 8049d4a:	c3                   	ret    

08049d4b <init_driver>:
 8049d4b:	55                   	push   %ebp
 8049d4c:	89 e5                	mov    %esp,%ebp
 8049d4e:	57                   	push   %edi
 8049d4f:	56                   	push   %esi
 8049d50:	53                   	push   %ebx
 8049d51:	83 ec 2c             	sub    $0x2c,%esp
 8049d54:	8b 75 08             	mov    0x8(%ebp),%esi
 8049d57:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049d5e:	00 
 8049d5f:	c7 04 24 0d 00 00 00 	movl   $0xd,(%esp)
 8049d66:	e8 85 eb ff ff       	call   80488f0 <signal@plt>
 8049d6b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049d72:	00 
 8049d73:	c7 04 24 1d 00 00 00 	movl   $0x1d,(%esp)
 8049d7a:	e8 71 eb ff ff       	call   80488f0 <signal@plt>
 8049d7f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049d86:	00 
 8049d87:	c7 04 24 1d 00 00 00 	movl   $0x1d,(%esp)
 8049d8e:	e8 5d eb ff ff       	call   80488f0 <signal@plt>
 8049d93:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
 8049d9a:	00 
 8049d9b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
 8049da2:	00 
 8049da3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 8049daa:	e8 c1 ec ff ff       	call   8048a70 <socket@plt>
 8049daf:	89 c3                	mov    %eax,%ebx
 8049db1:	85 c0                	test   %eax,%eax
 8049db3:	79 4e                	jns    8049e03 <init_driver+0xb8>
 8049db5:	c7 06 45 72 72 6f    	movl   $0x6f727245,(%esi)
 8049dbb:	c7 46 04 72 3a 20 43 	movl   $0x43203a72,0x4(%esi)
 8049dc2:	c7 46 08 6c 69 65 6e 	movl   $0x6e65696c,0x8(%esi)
 8049dc9:	c7 46 0c 74 20 75 6e 	movl   $0x6e752074,0xc(%esi)
 8049dd0:	c7 46 10 61 62 6c 65 	movl   $0x656c6261,0x10(%esi)
 8049dd7:	c7 46 14 20 74 6f 20 	movl   $0x206f7420,0x14(%esi)
 8049dde:	c7 46 18 63 72 65 61 	movl   $0x61657263,0x18(%esi)
 8049de5:	c7 46 1c 74 65 20 73 	movl   $0x73206574,0x1c(%esi)
 8049dec:	c7 46 20 6f 63 6b 65 	movl   $0x656b636f,0x20(%esi)
 8049df3:	66 c7 46 24 74 00    	movw   $0x74,0x24(%esi)
 8049df9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049dfe:	e9 dd 00 00 00       	jmp    8049ee0 <init_driver+0x195>
 8049e03:	c7 04 24 c8 a7 04 08 	movl   $0x804a7c8,(%esp)
 8049e0a:	e8 81 ec ff ff       	call   8048a90 <gethostbyname@plt>
 8049e0f:	85 c0                	test   %eax,%eax
 8049e11:	75 2a                	jne    8049e3d <init_driver+0xf2>
 8049e13:	c7 44 24 08 c8 a7 04 	movl   $0x804a7c8,0x8(%esp)
 8049e1a:	08 
 8049e1b:	c7 44 24 04 70 a6 04 	movl   $0x804a670,0x4(%esp)
 8049e22:	08 
 8049e23:	89 34 24             	mov    %esi,(%esp)
 8049e26:	e8 35 ec ff ff       	call   8048a60 <sprintf@plt>
 8049e2b:	89 1c 24             	mov    %ebx,(%esp)
 8049e2e:	e8 7d ec ff ff       	call   8048ab0 <close@plt>
 8049e33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049e38:	e9 a3 00 00 00       	jmp    8049ee0 <init_driver+0x195>
 8049e3d:	8d 7d d8             	lea    -0x28(%ebp),%edi
 8049e40:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
 8049e47:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
 8049e4e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 8049e55:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 8049e5c:	66 c7 45 d8 02 00    	movw   $0x2,-0x28(%ebp)
 8049e62:	8b 50 0c             	mov    0xc(%eax),%edx
 8049e65:	89 54 24 08          	mov    %edx,0x8(%esp)
 8049e69:	8d 55 dc             	lea    -0x24(%ebp),%edx
 8049e6c:	89 54 24 04          	mov    %edx,0x4(%esp)
 8049e70:	8b 40 10             	mov    0x10(%eax),%eax
 8049e73:	8b 00                	mov    (%eax),%eax
 8049e75:	89 04 24             	mov    %eax,(%esp)
 8049e78:	e8 b3 ea ff ff       	call   8048930 <bcopy@plt>
 8049e7d:	66 c7 45 da 47 26    	movw   $0x2647,-0x26(%ebp)
 8049e83:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 8049e8a:	00 
 8049e8b:	89 7c 24 04          	mov    %edi,0x4(%esp)
 8049e8f:	89 1c 24             	mov    %ebx,(%esp)
 8049e92:	e8 09 ec ff ff       	call   8048aa0 <connect@plt>
 8049e97:	85 c0                	test   %eax,%eax
 8049e99:	79 2f                	jns    8049eca <init_driver+0x17f>
 8049e9b:	c7 44 24 0c 26 47 00 	movl   $0x4726,0xc(%esp)
 8049ea2:	00 
 8049ea3:	c7 44 24 08 c8 a7 04 	movl   $0x804a7c8,0x8(%esp)
 8049eaa:	08 
 8049eab:	c7 44 24 04 84 a7 04 	movl   $0x804a784,0x4(%esp)
 8049eb2:	08 
 8049eb3:	89 34 24             	mov    %esi,(%esp)
 8049eb6:	e8 a5 eb ff ff       	call   8048a60 <sprintf@plt>
 8049ebb:	89 1c 24             	mov    %ebx,(%esp)
 8049ebe:	e8 ed eb ff ff       	call   8048ab0 <close@plt>
 8049ec3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8049ec8:	eb 16                	jmp    8049ee0 <init_driver+0x195>
 8049eca:	89 1c 24             	mov    %ebx,(%esp)
 8049ecd:	e8 de eb ff ff       	call   8048ab0 <close@plt>
 8049ed2:	66 c7 06 4f 4b       	movw   $0x4b4f,(%esi)
 8049ed7:	c6 46 02 00          	movb   $0x0,0x2(%esi)
 8049edb:	b8 00 00 00 00       	mov    $0x0,%eax
 8049ee0:	83 c4 2c             	add    $0x2c,%esp
 8049ee3:	5b                   	pop    %ebx
 8049ee4:	5e                   	pop    %esi
 8049ee5:	5f                   	pop    %edi
 8049ee6:	5d                   	pop    %ebp
 8049ee7:	c3                   	ret    

08049ee8 <driver_post>:
 8049ee8:	55                   	push   %ebp
 8049ee9:	89 e5                	mov    %esp,%ebp
 8049eeb:	53                   	push   %ebx
 8049eec:	83 ec 24             	sub    $0x24,%esp
 8049eef:	8b 45 08             	mov    0x8(%ebp),%eax
 8049ef2:	8b 5d 14             	mov    0x14(%ebp),%ebx
 8049ef5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 8049ef9:	74 23                	je     8049f1e <driver_post+0x36>
 8049efb:	8b 45 0c             	mov    0xc(%ebp),%eax
 8049efe:	89 44 24 04          	mov    %eax,0x4(%esp)
 8049f02:	c7 04 24 d6 a7 04 08 	movl   $0x804a7d6,(%esp)
 8049f09:	e8 c2 e9 ff ff       	call   80488d0 <printf@plt>
 8049f0e:	66 c7 03 4f 4b       	movw   $0x4b4f,(%ebx)
 8049f13:	c6 43 02 00          	movb   $0x0,0x2(%ebx)
 8049f17:	b8 00 00 00 00       	mov    $0x0,%eax
 8049f1c:	eb 4c                	jmp    8049f6a <driver_post+0x82>
 8049f1e:	85 c0                	test   %eax,%eax
 8049f20:	74 3a                	je     8049f5c <driver_post+0x74>
 8049f22:	80 38 00             	cmpb   $0x0,(%eax)
 8049f25:	74 35                	je     8049f5c <driver_post+0x74>
 8049f27:	89 5c 24 18          	mov    %ebx,0x18(%esp)
 8049f2b:	8b 55 0c             	mov    0xc(%ebp),%edx
 8049f2e:	89 54 24 14          	mov    %edx,0x14(%esp)
 8049f32:	c7 44 24 10 ed a7 04 	movl   $0x804a7ed,0x10(%esp)
 8049f39:	08 
 8049f3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
 8049f3e:	c7 44 24 08 f4 a7 04 	movl   $0x804a7f4,0x8(%esp)
 8049f45:	08 
 8049f46:	c7 44 24 04 26 47 00 	movl   $0x4726,0x4(%esp)
 8049f4d:	00 
 8049f4e:	c7 04 24 c8 a7 04 08 	movl   $0x804a7c8,(%esp)
 8049f55:	e8 66 f6 ff ff       	call   80495c0 <submitr>
 8049f5a:	eb 0e                	jmp    8049f6a <driver_post+0x82>
 8049f5c:	66 c7 03 4f 4b       	movw   $0x4b4f,(%ebx)
 8049f61:	c6 43 02 00          	movb   $0x0,0x2(%ebx)
 8049f65:	b8 00 00 00 00       	mov    $0x0,%eax
 8049f6a:	83 c4 24             	add    $0x24,%esp
 8049f6d:	5b                   	pop    %ebx
 8049f6e:	5d                   	pop    %ebp
 8049f6f:	c3                   	ret    

08049f70 <hash>:
 8049f70:	55                   	push   %ebp
 8049f71:	89 e5                	mov    %esp,%ebp
 8049f73:	8b 4d 08             	mov    0x8(%ebp),%ecx
 8049f76:	0f b6 11             	movzbl (%ecx),%edx
 8049f79:	84 d2                	test   %dl,%dl
 8049f7b:	74 19                	je     8049f96 <hash+0x26>
 8049f7d:	b8 00 00 00 00       	mov    $0x0,%eax
 8049f82:	6b c0 67             	imul   $0x67,%eax,%eax
 8049f85:	0f be d2             	movsbl %dl,%edx
 8049f88:	01 d0                	add    %edx,%eax
 8049f8a:	83 c1 01             	add    $0x1,%ecx
 8049f8d:	0f b6 11             	movzbl (%ecx),%edx
 8049f90:	84 d2                	test   %dl,%dl
 8049f92:	75 ee                	jne    8049f82 <hash+0x12>
 8049f94:	eb 05                	jmp    8049f9b <hash+0x2b>
 8049f96:	b8 00 00 00 00       	mov    $0x0,%eax
 8049f9b:	5d                   	pop    %ebp
 8049f9c:	c3                   	ret    

08049f9d <check>:
 8049f9d:	55                   	push   %ebp
 8049f9e:	89 e5                	mov    %esp,%ebp
 8049fa0:	8b 55 08             	mov    0x8(%ebp),%edx
 8049fa3:	89 d1                	mov    %edx,%ecx
 8049fa5:	c1 e9 1c             	shr    $0x1c,%ecx
 8049fa8:	b8 00 00 00 00       	mov    $0x0,%eax
 8049fad:	85 c9                	test   %ecx,%ecx
 8049faf:	74 37                	je     8049fe8 <check+0x4b>
 8049fb1:	80 fa 0a             	cmp    $0xa,%dl
 8049fb4:	74 1f                	je     8049fd5 <check+0x38>
 8049fb6:	0f b6 c6             	movzbl %dh,%eax
 8049fb9:	83 f8 0a             	cmp    $0xa,%eax
 8049fbc:	74 1e                	je     8049fdc <check+0x3f>
 8049fbe:	89 d0                	mov    %edx,%eax
 8049fc0:	c1 e8 10             	shr    $0x10,%eax
 8049fc3:	3c 0a                	cmp    $0xa,%al
 8049fc5:	74 1c                	je     8049fe3 <check+0x46>
 8049fc7:	c1 ea 18             	shr    $0x18,%edx
 8049fca:	83 fa 0a             	cmp    $0xa,%edx
 8049fcd:	0f 95 c0             	setne  %al
 8049fd0:	0f b6 c0             	movzbl %al,%eax
 8049fd3:	eb 13                	jmp    8049fe8 <check+0x4b>
 8049fd5:	b8 00 00 00 00       	mov    $0x0,%eax
 8049fda:	eb 0c                	jmp    8049fe8 <check+0x4b>
 8049fdc:	b8 00 00 00 00       	mov    $0x0,%eax
 8049fe1:	eb 05                	jmp    8049fe8 <check+0x4b>
 8049fe3:	b8 00 00 00 00       	mov    $0x0,%eax
 8049fe8:	5d                   	pop    %ebp
 8049fe9:	c3                   	ret    

08049fea <gencookie>:
 8049fea:	55                   	push   %ebp
 8049feb:	89 e5                	mov    %esp,%ebp
 8049fed:	53                   	push   %ebx
 8049fee:	83 ec 14             	sub    $0x14,%esp
 8049ff1:	8b 45 08             	mov    0x8(%ebp),%eax
 8049ff4:	89 04 24             	mov    %eax,(%esp)
 8049ff7:	e8 74 ff ff ff       	call   8049f70 <hash>
 8049ffc:	89 04 24             	mov    %eax,(%esp)
 8049fff:	e8 9c e9 ff ff       	call   80489a0 <srand@plt>
 804a004:	e8 37 ea ff ff       	call   8048a40 <rand@plt>
 804a009:	89 c3                	mov    %eax,%ebx
 804a00b:	89 04 24             	mov    %eax,(%esp)
 804a00e:	e8 8a ff ff ff       	call   8049f9d <check>
 804a013:	85 c0                	test   %eax,%eax
 804a015:	74 ed                	je     804a004 <gencookie+0x1a>
 804a017:	89 d8                	mov    %ebx,%eax
 804a019:	83 c4 14             	add    $0x14,%esp
 804a01c:	5b                   	pop    %ebx
 804a01d:	5d                   	pop    %ebp
 804a01e:	c3                   	ret    
 804a01f:	90                   	nop

0804a020 <__libc_csu_fini>:
 804a020:	55                   	push   %ebp
 804a021:	89 e5                	mov    %esp,%ebp
 804a023:	5d                   	pop    %ebp
 804a024:	c3                   	ret    
 804a025:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 804a029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

0804a030 <__libc_csu_init>:
 804a030:	55                   	push   %ebp
 804a031:	89 e5                	mov    %esp,%ebp
 804a033:	57                   	push   %edi
 804a034:	56                   	push   %esi
 804a035:	53                   	push   %ebx
 804a036:	e8 4f 00 00 00       	call   804a08a <__i686.get_pc_thunk.bx>
 804a03b:	81 c3 c5 10 00 00    	add    $0x10c5,%ebx
 804a041:	83 ec 1c             	sub    $0x1c,%esp
 804a044:	e8 2f e8 ff ff       	call   8048878 <_init>
 804a049:	8d bb 04 ff ff ff    	lea    -0xfc(%ebx),%edi
 804a04f:	8d 83 00 ff ff ff    	lea    -0x100(%ebx),%eax
 804a055:	29 c7                	sub    %eax,%edi
 804a057:	c1 ff 02             	sar    $0x2,%edi
 804a05a:	85 ff                	test   %edi,%edi
 804a05c:	74 24                	je     804a082 <__libc_csu_init+0x52>
 804a05e:	31 f6                	xor    %esi,%esi
 804a060:	8b 45 10             	mov    0x10(%ebp),%eax
 804a063:	89 44 24 08          	mov    %eax,0x8(%esp)
 804a067:	8b 45 0c             	mov    0xc(%ebp),%eax
 804a06a:	89 44 24 04          	mov    %eax,0x4(%esp)
 804a06e:	8b 45 08             	mov    0x8(%ebp),%eax
 804a071:	89 04 24             	mov    %eax,(%esp)
 804a074:	ff 94 b3 00 ff ff ff 	call   *-0x100(%ebx,%esi,4)
 804a07b:	83 c6 01             	add    $0x1,%esi
 804a07e:	39 fe                	cmp    %edi,%esi
 804a080:	72 de                	jb     804a060 <__libc_csu_init+0x30>
 804a082:	83 c4 1c             	add    $0x1c,%esp
 804a085:	5b                   	pop    %ebx
 804a086:	5e                   	pop    %esi
 804a087:	5f                   	pop    %edi
 804a088:	5d                   	pop    %ebp
 804a089:	c3                   	ret    

0804a08a <__i686.get_pc_thunk.bx>:
 804a08a:	8b 1c 24             	mov    (%esp),%ebx
 804a08d:	c3                   	ret    
 804a08e:	90                   	nop
 804a08f:	90                   	nop

Disassembly of section .fini:

0804a090 <_fini>:
 804a090:	55                   	push   %ebp
 804a091:	89 e5                	mov    %esp,%ebp
 804a093:	53                   	push   %ebx
 804a094:	83 ec 04             	sub    $0x4,%esp
 804a097:	e8 00 00 00 00       	call   804a09c <_fini+0xc>
 804a09c:	5b                   	pop    %ebx
 804a09d:	81 c3 64 10 00 00    	add    $0x1064,%ebx
 804a0a3:	59                   	pop    %ecx
 804a0a4:	5b                   	pop    %ebx
 804a0a5:	c9                   	leave  
 804a0a6:	c3                   	ret    

Disassembly of section .rodata:

0804a0a8 <_fp_hw>:
 804a0a8:	03 00                	add    (%eax),%eax
	...

0804a0ac <_IO_stdin_used>:
 804a0ac:	01 00                	add    %eax,(%eax)
 804a0ae:	02 00                	add    (%eax),%al
 804a0b0:	55                   	push   %ebp
 804a0b1:	73 61                	jae    804a114 <_IO_stdin_used+0x68>
 804a0b3:	67 65 3a 20          	cmp    %gs:(%bx,%si),%ah
 804a0b7:	25 73 20 2d 75       	and    $0x752d2073,%eax
 804a0bc:	20 3c 75 73 65 72 69 	and    %bh,0x69726573(,%esi,2)
 804a0c3:	64 3e 20 5b 2d       	fs and %bl,%ds:0x2d(%ebx)
 804a0c8:	6e                   	outsb  %ds:(%esi),(%dx)
 804a0c9:	73 68                	jae    804a133 <_IO_stdin_used+0x87>
 804a0cb:	5d                   	pop    %ebp
 804a0cc:	0a 00                	or     (%eax),%al
 804a0ce:	20 20                	and    %ah,(%eax)
 804a0d0:	2d 75 20 3c 75       	sub    $0x753c2075,%eax
 804a0d5:	73 65                	jae    804a13c <_IO_stdin_used+0x90>
 804a0d7:	72 69                	jb     804a142 <_IO_stdin_used+0x96>
 804a0d9:	64 3e 20 55 73       	fs and %dl,%ds:0x73(%ebp)
 804a0de:	65 72 20             	gs jb  804a101 <_IO_stdin_used+0x55>
 804a0e1:	49                   	dec    %ecx
 804a0e2:	44                   	inc    %esp
 804a0e3:	00 20                	add    %ah,(%eax)
 804a0e5:	20 2d 6e 20 20 20    	and    %ch,0x2020206e
 804a0eb:	20 20                	and    %ah,(%eax)
 804a0ed:	20 20                	and    %ah,(%eax)
 804a0ef:	20 20                	and    %ah,(%eax)
 804a0f1:	20 4e 69             	and    %cl,0x69(%esi)
 804a0f4:	74 72                	je     804a168 <_IO_stdin_used+0xbc>
 804a0f6:	6f                   	outsl  %ds:(%esi),(%dx)
 804a0f7:	20 6d 6f             	and    %ch,0x6f(%ebp)
 804a0fa:	64 65 00 42 65       	fs add %al,%gs:0x65(%edx)
 804a0ff:	74 74                	je     804a175 <_IO_stdin_used+0xc9>
 804a101:	65 72 20             	gs jb  804a124 <_IO_stdin_used+0x78>
 804a104:	6c                   	insb   (%dx),%es:(%edi)
 804a105:	75 63                	jne    804a16a <_IO_stdin_used+0xbe>
 804a107:	6b 20 6e             	imul   $0x6e,(%eax),%esp
 804a10a:	65 78 74             	gs js  804a181 <_IO_stdin_used+0xd5>
 804a10d:	20 74 69 6d          	and    %dh,0x6d(%ecx,%ebp,2)
 804a111:	65 00 53 6d          	add    %dl,%gs:0x6d(%ebx)
 804a115:	6f                   	outsl  %ds:(%esi),(%dx)
 804a116:	6b 65 21 3a          	imul   $0x3a,0x21(%ebp),%esp
 804a11a:	20 59 6f             	and    %bl,0x6f(%ecx)
 804a11d:	75 20                	jne    804a13f <_IO_stdin_used+0x93>
 804a11f:	63 61 6c             	arpl   %sp,0x6c(%ecx)
 804a122:	6c                   	insb   (%dx),%es:(%edi)
 804a123:	65 64 20 73 6d       	gs and %dh,%fs:0x6d(%ebx)
 804a128:	6f                   	outsl  %ds:(%esi),(%dx)
 804a129:	6b 65 28 29          	imul   $0x29,0x28(%ebp),%esp
 804a12d:	00 46 69             	add    %al,0x69(%esi)
 804a130:	7a 7a                	jp     804a1ac <_IO_stdin_used+0x100>
 804a132:	21 3a                	and    %edi,(%edx)
 804a134:	20 59 6f             	and    %bl,0x6f(%ecx)
 804a137:	75 20                	jne    804a159 <_IO_stdin_used+0xad>
 804a139:	63 61 6c             	arpl   %sp,0x6c(%ecx)
 804a13c:	6c                   	insb   (%dx),%es:(%edi)
 804a13d:	65 64 20 66 69       	gs and %ah,%fs:0x69(%esi)
 804a142:	7a 7a                	jp     804a1be <_IO_stdin_used+0x112>
 804a144:	28 30                	sub    %dh,(%eax)
 804a146:	78 25                	js     804a16d <_IO_stdin_used+0xc1>
 804a148:	78 29                	js     804a173 <_IO_stdin_used+0xc7>
 804a14a:	0a 00                	or     (%eax),%al
 804a14c:	4d                   	dec    %ebp
 804a14d:	69 73 66 69 72 65 3a 	imul   $0x3a657269,0x66(%ebx),%esi
 804a154:	20 67 6c             	and    %ah,0x6c(%edi)
 804a157:	6f                   	outsl  %ds:(%esi),(%dx)
 804a158:	62 61 6c             	bound  %esp,0x6c(%ecx)
 804a15b:	5f                   	pop    %edi
 804a15c:	76 61                	jbe    804a1bf <_IO_stdin_used+0x113>
 804a15e:	6c                   	insb   (%dx),%es:(%edi)
 804a15f:	75 65                	jne    804a1c6 <_IO_stdin_used+0x11a>
 804a161:	20 3d 20 30 78 25    	and    %bh,0x25783020
 804a167:	78 0a                	js     804a173 <_IO_stdin_used+0xc7>
 804a169:	00 44 75 64          	add    %al,0x64(%ebp,%esi,2)
 804a16d:	3a 20                	cmp    (%eax),%ah
 804a16f:	67 65 74 62          	addr16 gs je 804a1d5 <_IO_stdin_used+0x129>
 804a173:	75 66                	jne    804a1db <_IO_stdin_used+0x12f>
 804a175:	6e                   	outsb  %ds:(%esi),(%dx)
 804a176:	20 72 65             	and    %dh,0x65(%edx)
 804a179:	74 75                	je     804a1f0 <_IO_stdin_used+0x144>
 804a17b:	72 6e                	jb     804a1eb <_IO_stdin_used+0x13f>
 804a17d:	65 64 20 30          	gs and %dh,%fs:(%eax)
 804a181:	78 25                	js     804a1a8 <_IO_stdin_used+0xfc>
 804a183:	78 0a                	js     804a18f <_IO_stdin_used+0xe3>
 804a185:	00 42 6f             	add    %al,0x6f(%edx)
 804a188:	6f                   	outsl  %ds:(%esi),(%dx)
 804a189:	6d                   	insl   (%dx),%es:(%edi)
 804a18a:	21 3a                	and    %edi,(%edx)
 804a18c:	20 67 65             	and    %ah,0x65(%edi)
 804a18f:	74 62                	je     804a1f3 <_IO_stdin_used+0x147>
 804a191:	75 66                	jne    804a1f9 <_IO_stdin_used+0x14d>
 804a193:	20 72 65             	and    %dh,0x65(%edx)
 804a196:	74 75                	je     804a20d <_IO_stdin_used+0x161>
 804a198:	72 6e                	jb     804a208 <_IO_stdin_used+0x15c>
 804a19a:	65 64 20 30          	gs and %dh,%fs:(%eax)
 804a19e:	78 25                	js     804a1c5 <_IO_stdin_used+0x119>
 804a1a0:	78 0a                	js     804a1ac <_IO_stdin_used+0x100>
 804a1a2:	00 44 75 64          	add    %al,0x64(%ebp,%esi,2)
 804a1a6:	3a 20                	cmp    (%eax),%ah
 804a1a8:	67 65 74 62          	addr16 gs je 804a20e <_IO_stdin_used+0x162>
 804a1ac:	75 66                	jne    804a214 <_IO_stdin_used+0x168>
 804a1ae:	20 72 65             	and    %dh,0x65(%edx)
 804a1b1:	74 75                	je     804a228 <_IO_stdin_used+0x17c>
 804a1b3:	72 6e                	jb     804a223 <_IO_stdin_used+0x177>
 804a1b5:	65 64 20 30          	gs and %dh,%fs:(%eax)
 804a1b9:	78 25                	js     804a1e0 <_IO_stdin_used+0x134>
 804a1bb:	78 0a                	js     804a1c7 <_IO_stdin_used+0x11b>
 804a1bd:	00 54 79 70          	add    %dl,0x70(%ecx,%edi,2)
 804a1c1:	65 20 73 74          	and    %dh,%gs:0x74(%ebx)
 804a1c5:	72 69                	jb     804a230 <_IO_stdin_used+0x184>
 804a1c7:	6e                   	outsb  %ds:(%esi),(%dx)
 804a1c8:	67 3a 00             	cmp    (%bx,%si),%al
 804a1cb:	67 73 6e             	addr16 jae 804a23c <_IO_stdin_used+0x190>
 804a1ce:	68 75 3a 00 55       	push   $0x55003a75
 804a1d3:	73 65                	jae    804a23a <_IO_stdin_used+0x18e>
 804a1d5:	72 69                	jb     804a240 <_IO_stdin_used+0x194>
 804a1d7:	64 3a 20             	cmp    %fs:(%eax),%ah
 804a1da:	25 73 0a 00 43       	and    $0x43000a73,%eax
 804a1df:	6f                   	outsl  %ds:(%esi),(%dx)
 804a1e0:	6f                   	outsl  %ds:(%esi),(%dx)
 804a1e1:	6b 69 65 3a          	imul   $0x3a,0x65(%ecx),%ebp
 804a1e5:	20 30                	and    %dh,(%eax)
 804a1e7:	78 25                	js     804a20e <_IO_stdin_used+0x162>
 804a1e9:	78 0a                	js     804a1f5 <_IO_stdin_used+0x149>
 804a1eb:	00 20                	add    %ah,(%eax)
 804a1ed:	20 2d 73 20 20 20    	and    %ch,0x20202073
 804a1f3:	20 20                	and    %ah,(%eax)
 804a1f5:	20 20                	and    %ah,(%eax)
 804a1f7:	20 20                	and    %ah,(%eax)
 804a1f9:	20 53 75             	and    %dl,0x75(%ebx)
 804a1fc:	62 6d 69             	bound  %ebp,0x69(%ebp)
 804a1ff:	74 20                	je     804a221 <_IO_stdin_used+0x175>
 804a201:	79 6f                	jns    804a272 <_IO_stdin_used+0x1c6>
 804a203:	75 72                	jne    804a277 <_IO_stdin_used+0x1cb>
 804a205:	20 73 6f             	and    %dh,0x6f(%ebx)
 804a208:	6c                   	insb   (%dx),%es:(%edi)
 804a209:	75 74                	jne    804a27f <_IO_stdin_used+0x1d3>
 804a20b:	69 6f 6e 20 74 6f 20 	imul   $0x206f7420,0x6e(%edi),%ebp
 804a212:	74 68                	je     804a27c <_IO_stdin_used+0x1d0>
 804a214:	65 20 67 72          	and    %ah,%gs:0x72(%edi)
 804a218:	61                   	popa   
 804a219:	64 69 6e 67 20 73 65 	imul   $0x72657320,%fs:0x67(%esi),%ebp
 804a220:	72 
 804a221:	76 65                	jbe    804a288 <_IO_stdin_used+0x1dc>
 804a223:	72 00                	jb     804a225 <_IO_stdin_used+0x179>
 804a225:	00 00                	add    %al,(%eax)
 804a227:	00 20                	add    %ah,(%eax)
 804a229:	20 2d 68 20 20 20    	and    %ch,0x20202068
 804a22f:	20 20                	and    %ah,(%eax)
 804a231:	20 20                	and    %ah,(%eax)
 804a233:	20 20                	and    %ah,(%eax)
 804a235:	20 50 72             	and    %dl,0x72(%eax)
 804a238:	69 6e 74 20 68 65 6c 	imul   $0x6c656820,0x74(%esi),%ebp
 804a23f:	70 20                	jo     804a261 <_IO_stdin_used+0x1b5>
 804a241:	69 6e 66 6f 72 6d 61 	imul   $0x616d726f,0x66(%esi),%ebp
 804a248:	74 69                	je     804a2b3 <_IO_stdin_used+0x207>
 804a24a:	6f                   	outsl  %ds:(%esi),(%dx)
 804a24b:	6e                   	outsb  %ds:(%esi),(%dx)
 804a24c:	00 00                	add    %al,(%eax)
 804a24e:	00 00                	add    %al,(%eax)
 804a250:	4f                   	dec    %edi
 804a251:	6f                   	outsl  %ds:(%esi),(%dx)
 804a252:	70 73                	jo     804a2c7 <_IO_stdin_used+0x21b>
 804a254:	21 3a                	and    %edi,(%edx)
 804a256:	20 59 6f             	and    %bl,0x6f(%ecx)
 804a259:	75 20                	jne    804a27b <_IO_stdin_used+0x1cf>
 804a25b:	65 78 65             	gs js  804a2c3 <_IO_stdin_used+0x217>
 804a25e:	63 75 74             	arpl   %si,0x74(%ebp)
 804a261:	65 64 20 61 6e       	gs and %ah,%fs:0x6e(%ecx)
 804a266:	20 69 6c             	and    %ch,0x6c(%ecx)
 804a269:	6c                   	insb   (%dx),%es:(%edi)
 804a26a:	65 67 61             	gs addr16 popa 
 804a26d:	6c                   	insb   (%dx),%es:(%edi)
 804a26e:	20 69 6e             	and    %ch,0x6e(%ecx)
 804a271:	73 74                	jae    804a2e7 <_IO_stdin_used+0x23b>
 804a273:	72 75                	jb     804a2ea <_IO_stdin_used+0x23e>
 804a275:	63 74 69 6f          	arpl   %si,0x6f(%ecx,%ebp,2)
 804a279:	6e                   	outsb  %ds:(%esi),(%dx)
 804a27a:	00 00                	add    %al,(%eax)
 804a27c:	4f                   	dec    %edi
 804a27d:	75 63                	jne    804a2e2 <_IO_stdin_used+0x236>
 804a27f:	68 21 3a 20 59       	push   $0x59203a21
 804a284:	6f                   	outsl  %ds:(%esi),(%dx)
 804a285:	75 20                	jne    804a2a7 <_IO_stdin_used+0x1fb>
 804a287:	63 61 75             	arpl   %sp,0x75(%ecx)
 804a28a:	73 65                	jae    804a2f1 <_IO_stdin_used+0x245>
 804a28c:	64 20 61 20          	and    %ah,%fs:0x20(%ecx)
 804a290:	73 65                	jae    804a2f7 <_IO_stdin_used+0x24b>
 804a292:	67 6d                	insl   (%dx),%es:(%di)
 804a294:	65 6e                	outsb  %gs:(%esi),(%dx)
 804a296:	74 61                	je     804a2f9 <_IO_stdin_used+0x24d>
 804a298:	74 69                	je     804a303 <_IO_stdin_used+0x257>
 804a29a:	6f                   	outsl  %ds:(%esi),(%dx)
 804a29b:	6e                   	outsb  %ds:(%esi),(%dx)
 804a29c:	20 66 61             	and    %ah,0x61(%esi)
 804a29f:	75 6c                	jne    804a30d <_IO_stdin_used+0x261>
 804a2a1:	74 21                	je     804a2c4 <_IO_stdin_used+0x218>
 804a2a3:	00 43 72             	add    %al,0x72(%ebx)
 804a2a6:	61                   	popa   
 804a2a7:	73 68                	jae    804a311 <_IO_stdin_used+0x265>
 804a2a9:	21 3a                	and    %edi,(%edx)
 804a2ab:	20 59 6f             	and    %bl,0x6f(%ecx)
 804a2ae:	75 20                	jne    804a2d0 <_IO_stdin_used+0x224>
 804a2b0:	63 61 75             	arpl   %sp,0x75(%ecx)
 804a2b3:	73 65                	jae    804a31a <_IO_stdin_used+0x26e>
 804a2b5:	64 20 61 20          	and    %ah,%fs:0x20(%ecx)
 804a2b9:	62 75 73             	bound  %esi,0x73(%ebp)
 804a2bc:	20 65 72             	and    %ah,0x72(%ebp)
 804a2bf:	72 6f                	jb     804a330 <_IO_stdin_used+0x284>
 804a2c1:	72 21                	jb     804a2e4 <_IO_stdin_used+0x238>
 804a2c3:	00 4d 69             	add    %cl,0x69(%ebp)
 804a2c6:	73 66                	jae    804a32e <_IO_stdin_used+0x282>
 804a2c8:	69 72 65 3a 20 59 6f 	imul   $0x6f59203a,0x65(%edx),%esi
 804a2cf:	75 20                	jne    804a2f1 <_IO_stdin_used+0x245>
 804a2d1:	63 61 6c             	arpl   %sp,0x6c(%ecx)
 804a2d4:	6c                   	insb   (%dx),%es:(%edi)
 804a2d5:	65 64 20 66 69       	gs and %ah,%fs:0x69(%esi)
 804a2da:	7a 7a                	jp     804a356 <_IO_stdin_used+0x2aa>
 804a2dc:	28 30                	sub    %dh,(%eax)
 804a2de:	78 25                	js     804a305 <_IO_stdin_used+0x259>
 804a2e0:	78 29                	js     804a30b <_IO_stdin_used+0x25f>
 804a2e2:	0a 00                	or     (%eax),%al
 804a2e4:	42                   	inc    %edx
 804a2e5:	61                   	popa   
 804a2e6:	6e                   	outsb  %ds:(%esi),(%dx)
 804a2e7:	67 21 3a             	and    %edi,(%bp,%si)
 804a2ea:	20 59 6f             	and    %bl,0x6f(%ecx)
 804a2ed:	75 20                	jne    804a30f <_IO_stdin_used+0x263>
 804a2ef:	73 65                	jae    804a356 <_IO_stdin_used+0x2aa>
 804a2f1:	74 20                	je     804a313 <_IO_stdin_used+0x267>
 804a2f3:	67 6c                	insb   (%dx),%es:(%di)
 804a2f5:	6f                   	outsl  %ds:(%esi),(%dx)
 804a2f6:	62 61 6c             	bound  %esp,0x6c(%ecx)
 804a2f9:	5f                   	pop    %edi
 804a2fa:	76 61                	jbe    804a35d <_IO_stdin_used+0x2b1>
 804a2fc:	6c                   	insb   (%dx),%es:(%edi)
 804a2fd:	75 65                	jne    804a364 <_IO_stdin_used+0x2b8>
 804a2ff:	20 74 6f 20          	and    %dh,0x20(%edi,%ebp,2)
 804a303:	30 78 25             	xor    %bh,0x25(%eax)
 804a306:	78 0a                	js     804a312 <_IO_stdin_used+0x266>
 804a308:	00 00                	add    %al,(%eax)
 804a30a:	00 00                	add    %al,(%eax)
 804a30c:	53                   	push   %ebx
 804a30d:	61                   	popa   
 804a30e:	62 6f 74             	bound  %ebp,0x74(%edi)
 804a311:	61                   	popa   
 804a312:	67 65 64 21 3a       	gs and %edi,%fs:(%bp,%si)
 804a317:	20 74 68 65          	and    %dh,0x65(%eax,%ebp,2)
 804a31b:	20 73 74             	and    %dh,0x74(%ebx)
 804a31e:	61                   	popa   
 804a31f:	63 6b 20             	arpl   %bp,0x20(%ebx)
 804a322:	68 61 73 20 62       	push   $0x62207361
 804a327:	65 65 6e             	gs outsb %gs:(%esi),(%dx)
 804a32a:	20 63 6f             	and    %ah,0x6f(%ebx)
 804a32d:	72 72                	jb     804a3a1 <_IO_stdin_used+0x2f5>
 804a32f:	75 70                	jne    804a3a1 <_IO_stdin_used+0x2f5>
 804a331:	74 65                	je     804a398 <_IO_stdin_used+0x2ec>
 804a333:	64 00 00             	add    %al,%fs:(%eax)
 804a336:	00 00                	add    %al,(%eax)
 804a338:	4b                   	dec    %ebx
 804a339:	41                   	inc    %ecx
 804a33a:	42                   	inc    %edx
 804a33b:	4f                   	dec    %edi
 804a33c:	4f                   	dec    %edi
 804a33d:	4d                   	dec    %ebp
 804a33e:	21 3a                	and    %edi,(%edx)
 804a340:	20 67 65             	and    %ah,0x65(%edi)
 804a343:	74 62                	je     804a3a7 <_IO_stdin_used+0x2fb>
 804a345:	75 66                	jne    804a3ad <_IO_stdin_used+0x301>
 804a347:	6e                   	outsb  %ds:(%esi),(%dx)
 804a348:	20 72 65             	and    %dh,0x65(%edx)
 804a34b:	74 75                	je     804a3c2 <_IO_stdin_used+0x316>
 804a34d:	72 6e                	jb     804a3bd <_IO_stdin_used+0x311>
 804a34f:	65 64 20 30          	gs and %dh,%fs:(%eax)
 804a353:	78 25                	js     804a37a <_IO_stdin_used+0x2ce>
 804a355:	78 0a                	js     804a361 <_IO_stdin_used+0x2b5>
 804a357:	00 49 6e             	add    %cl,0x6e(%ecx)
 804a35a:	74 65                	je     804a3c1 <_IO_stdin_used+0x315>
 804a35c:	72 6e                	jb     804a3cc <_IO_stdin_used+0x320>
 804a35e:	61                   	popa   
 804a35f:	6c                   	insb   (%dx),%es:(%edi)
 804a360:	20 65 72             	and    %ah,0x72(%ebp)
 804a363:	72 6f                	jb     804a3d4 <_IO_stdin_used+0x328>
 804a365:	72 2e                	jb     804a395 <_IO_stdin_used+0x2e9>
 804a367:	20 20                	and    %ah,(%eax)
 804a369:	43                   	inc    %ebx
 804a36a:	6f                   	outsl  %ds:(%esi),(%dx)
 804a36b:	75 6c                	jne    804a3d9 <_IO_stdin_used+0x32d>
 804a36d:	64 6e                	outsb  %fs:(%esi),(%dx)
 804a36f:	27                   	daa    
 804a370:	74 20                	je     804a392 <_IO_stdin_used+0x2e6>
 804a372:	75 73                	jne    804a3e7 <_IO_stdin_used+0x33b>
 804a374:	65 20 6d 6d          	and    %ch,%gs:0x6d(%ebp)
 804a378:	61                   	popa   
 804a379:	70 2e                	jo     804a3a9 <_IO_stdin_used+0x2fd>
 804a37b:	20 54 72 79          	and    %dl,0x79(%edx,%esi,2)
 804a37f:	20 64 69 66          	and    %ah,0x66(%ecx,%ebp,2)
 804a383:	66 65 72 65          	data16 gs jb 804a3ec <_IO_stdin_used+0x340>
 804a387:	6e                   	outsb  %ds:(%esi),(%dx)
 804a388:	74 20                	je     804a3aa <_IO_stdin_used+0x2fe>
 804a38a:	76 61                	jbe    804a3ed <_IO_stdin_used+0x341>
 804a38c:	6c                   	insb   (%dx),%es:(%edi)
 804a38d:	75 65                	jne    804a3f4 <_IO_stdin_used+0x348>
 804a38f:	20 66 6f             	and    %ah,0x6f(%esi)
 804a392:	72 20                	jb     804a3b4 <_IO_stdin_used+0x308>
 804a394:	53                   	push   %ebx
 804a395:	54                   	push   %esp
 804a396:	41                   	inc    %ecx
 804a397:	52                   	push   %edx
 804a398:	54                   	push   %esp
 804a399:	5f                   	pop    %edi
 804a39a:	41                   	inc    %ecx
 804a39b:	44                   	inc    %esp
 804a39c:	44                   	inc    %esp
 804a39d:	52                   	push   %edx
 804a39e:	0a 00                	or     (%eax),%al
 804a3a0:	54                   	push   %esp
 804a3a1:	68 69 73 20 69       	push   $0x69207369
 804a3a6:	73 20                	jae    804a3c8 <_IO_stdin_used+0x31c>
 804a3a8:	61                   	popa   
 804a3a9:	20 71 75             	and    %dh,0x75(%ecx)
 804a3ac:	69 65 74 20 62 6f 6d 	imul   $0x6d6f6220,0x74(%ebp),%esp
 804a3b3:	62 2e                	bound  %ebp,(%esi)
 804a3b5:	20 49 67             	and    %cl,0x67(%ecx)
 804a3b8:	6e                   	outsb  %ds:(%esi),(%dx)
 804a3b9:	6f                   	outsl  %ds:(%esi),(%dx)
 804a3ba:	72 69                	jb     804a425 <_IO_stdin_used+0x379>
 804a3bc:	6e                   	outsb  %ds:(%esi),(%dx)
 804a3bd:	67 20 2d             	and    %ch,(%di)
 804a3c0:	73 20                	jae    804a3e2 <_IO_stdin_used+0x336>
 804a3c2:	66 6c                	data16 insb (%dx),%es:(%edi)
 804a3c4:	61                   	popa   
 804a3c5:	67 2e 00 25          	add    %ah,%cs:(%di)
 804a3c9:	73 3a                	jae    804a405 <_IO_stdin_used+0x359>
 804a3cb:	20 4d 69             	and    %cl,0x69(%ebp)
 804a3ce:	73 73                	jae    804a443 <trans_char+0x13>
 804a3d0:	69 6e 67 20 72 65 71 	imul   $0x71657220,0x67(%esi),%ebp
 804a3d7:	75 69                	jne    804a442 <trans_char+0x12>
 804a3d9:	72 65                	jb     804a440 <trans_char+0x10>
 804a3db:	64 20 61 72          	and    %ah,%fs:0x72(%ecx)
 804a3df:	67 75 6d             	addr16 jne 804a44f <trans_char+0x1f>
 804a3e2:	65 6e                	outsb  %gs:(%esi),(%dx)
 804a3e4:	74 20                	je     804a406 <_IO_stdin_used+0x35a>
 804a3e6:	28 2d 75 20 3c 75    	sub    %ch,0x753c2075
 804a3ec:	73 65                	jae    804a453 <trans_char+0x23>
 804a3ee:	72 69                	jb     804a459 <trans_char+0x29>
 804a3f0:	64 29 0a             	sub    %ecx,%fs:(%edx)
 804a3f3:	00 d1                	add    %dl,%cl
 804a3f5:	90                   	nop
 804a3f6:	04 08                	add    $0x8,%al
 804a3f8:	91                   	xchg   %eax,%ecx
 804a3f9:	90                   	nop
 804a3fa:	04 08                	add    $0x8,%al
 804a3fc:	dd 90 04 08 dd 90    	fstl   -0x6f22f7fc(%eax)
 804a402:	04 08                	add    $0x8,%al
 804a404:	dd 90 04 08 dd 90    	fstl   -0x6f22f7fc(%eax)
 804a40a:	04 08                	add    $0x8,%al
 804a40c:	dd 90 04 08 e4 90    	fstl   -0x6f1bf7fc(%eax)
 804a412:	04 08                	add    $0x8,%al
 804a414:	dd 90 04 08 dd 90    	fstl   -0x6f22f7fc(%eax)
 804a41a:	04 08                	add    $0x8,%al
 804a41c:	dd 90 04 08 dd 90    	fstl   -0x6f22f7fc(%eax)
 804a422:	04 08                	add    $0x8,%al
 804a424:	b9 90 04 08 dd       	mov    $0xdd080490,%ecx
 804a429:	90                   	nop
 804a42a:	04 08                	add    $0x8,%al
 804a42c:	98                   	cwtl   
 804a42d:	90                   	nop
 804a42e:	04 08                	add    $0x8,%al

0804a430 <trans_char>:
 804a430:	30 31                	xor    %dh,(%ecx)
 804a432:	32 33                	xor    (%ebx),%dh
 804a434:	34 35                	xor    $0x35,%al
 804a436:	36 37                	ss aaa 
 804a438:	38 39                	cmp    %bh,(%ecx)
 804a43a:	41                   	inc    %ecx
 804a43b:	42                   	inc    %edx
 804a43c:	43                   	inc    %ebx
 804a43d:	44                   	inc    %esp
 804a43e:	45                   	inc    %ebp
 804a43f:	46                   	inc    %esi
 804a440:	69 6e 69 74 69 61 6c 	imul   $0x6c616974,0x69(%esi),%ebp
 804a447:	69 7a 65 5f 62 6f 6d 	imul   $0x6d6f625f,0x65(%edx),%edi
 804a44e:	62 3a                	bound  %edi,(%edx)
 804a450:	20 43 6f             	and    %al,0x6f(%ebx)
 804a453:	75 6c                	jne    804a4c1 <trans_char+0x91>
 804a455:	64 20 6e 6f          	and    %ch,%fs:0x6f(%esi)
 804a459:	74 20                	je     804a47b <trans_char+0x4b>
 804a45b:	67 65 74 20          	addr16 gs je 804a47f <trans_char+0x4f>
 804a45f:	68 6f 73 74 6e       	push   $0x6e74736f
 804a464:	61                   	popa   
 804a465:	6d                   	insl   (%dx),%es:(%edi)
 804a466:	65 20 6f 66          	and    %ch,%gs:0x66(%edi)
 804a46a:	20 74 68 69          	and    %dh,0x69(%eax,%ebp,2)
 804a46e:	73 20                	jae    804a490 <trans_char+0x60>
 804a470:	6d                   	insl   (%dx),%es:(%edi)
 804a471:	61                   	popa   
 804a472:	63 68 69             	arpl   %bp,0x69(%eax)
 804a475:	6e                   	outsb  %ds:(%esi),(%dx)
 804a476:	65 00 69 6e          	add    %ch,%gs:0x6e(%ecx)
 804a47a:	69 74 69 61 6c 69 7a 	imul   $0x657a696c,0x61(%ecx,%ebp,2),%esi
 804a481:	65 
 804a482:	5f                   	pop    %edi
 804a483:	62 6f 6d             	bound  %ebp,0x6d(%edi)
 804a486:	62 3a                	bound  %edi,(%edx)
 804a488:	20 45 72             	and    %al,0x72(%ebp)
 804a48b:	72 6f                	jb     804a4fc <trans_char+0xcc>
 804a48d:	72 3a                	jb     804a4c9 <trans_char+0x99>
 804a48f:	20 25 73 20 69 73    	and    %ah,0x73692073
 804a495:	20 6e 6f             	and    %ch,0x6f(%esi)
 804a498:	74 20                	je     804a4ba <trans_char+0x8a>
 804a49a:	6f                   	outsl  %ds:(%esi),(%dx)
 804a49b:	6e                   	outsb  %ds:(%esi),(%dx)
 804a49c:	65 20 6f 66          	and    %ch,%gs:0x66(%edi)
 804a4a0:	20 74 68 65          	and    %dh,0x65(%eax,%ebp,2)
 804a4a4:	20 6c 65 67          	and    %ch,0x67(%ebp,%eiz,2)
 804a4a8:	61                   	popa   
 804a4a9:	6c                   	insb   (%dx),%es:(%edi)
 804a4aa:	20 68 6f             	and    %ch,0x6f(%eax)
 804a4ad:	73 74                	jae    804a523 <trans_char+0xf3>
 804a4af:	73 3a                	jae    804a4eb <trans_char+0xbb>
 804a4b1:	0a 00                	or     (%eax),%al
 804a4b3:	00 4e 6f             	add    %cl,0x6f(%esi)
 804a4b6:	20 75 73             	and    %dh,0x73(%ebp)
 804a4b9:	65 72 69             	gs jb  804a525 <trans_char+0xf5>
 804a4bc:	64 20 69 6e          	and    %ch,%fs:0x6e(%ecx)
 804a4c0:	64 69 63 61 74 65 64 	imul   $0x2e646574,%fs:0x61(%ebx),%esp
 804a4c7:	2e 
 804a4c8:	20 20                	and    %ah,(%eax)
 804a4ca:	52                   	push   %edx
 804a4cb:	65 73 75             	gs jae 804a543 <trans_char+0x113>
 804a4ce:	6c                   	insb   (%dx),%es:(%edi)
 804a4cf:	74 73                	je     804a544 <trans_char+0x114>
 804a4d1:	20 6e 6f             	and    %ch,0x6f(%esi)
 804a4d4:	74 20                	je     804a4f6 <trans_char+0xc6>
 804a4d6:	76 61                	jbe    804a539 <trans_char+0x109>
 804a4d8:	6c                   	insb   (%dx),%es:(%edi)
 804a4d9:	69 64 61 74 65 64 00 	imul   $0x49006465,0x74(%ecx,%eiz,2),%esp
 804a4e0:	49 
 804a4e1:	6e                   	outsb  %ds:(%esi),(%dx)
 804a4e2:	76 61                	jbe    804a545 <trans_char+0x115>
 804a4e4:	6c                   	insb   (%dx),%es:(%edi)
 804a4e5:	69 64 20 6c 65 76 65 	imul   $0x6c657665,0x6c(%eax,%eiz,1),%esp
 804a4ec:	6c 
 804a4ed:	2e 20 20             	and    %ah,%cs:(%eax)
 804a4f0:	52                   	push   %edx
 804a4f1:	65 73 75             	gs jae 804a569 <trans_char+0x139>
 804a4f4:	6c                   	insb   (%dx),%es:(%edi)
 804a4f5:	74 73                	je     804a56a <trans_char+0x13a>
 804a4f7:	20 6e 6f             	and    %ch,0x6f(%esi)
 804a4fa:	74 20                	je     804a51c <trans_char+0xec>
 804a4fc:	76 61                	jbe    804a55f <trans_char+0x12f>
 804a4fe:	6c                   	insb   (%dx),%es:(%edi)
 804a4ff:	69 64 61 74 65 64 00 	imul   $0x6465,0x74(%ecx,%eiz,2),%esp
 804a506:	00 
 804a507:	00 57 61             	add    %dl,0x61(%edi)
 804a50a:	72 6e                	jb     804a57a <trans_char+0x14a>
 804a50c:	69 6e 67 3a 20 49 6e 	imul   $0x6e49203a,0x67(%esi),%ebp
 804a513:	70 75                	jo     804a58a <trans_char+0x15a>
 804a515:	74 20                	je     804a537 <trans_char+0x107>
 804a517:	73 74                	jae    804a58d <trans_char+0x15d>
 804a519:	72 69                	jb     804a584 <trans_char+0x154>
 804a51b:	6e                   	outsb  %ds:(%esi),(%dx)
 804a51c:	67 20 74 6f          	and    %dh,0x6f(%si)
 804a520:	6f                   	outsl  %ds:(%esi),(%dx)
 804a521:	20 6c 61 72          	and    %ch,0x72(%ecx,%eiz,2)
 804a525:	67 65 2e 20 52 65    	gs and %dl,%cs:0x65(%bp,%si)
 804a52b:	73 75                	jae    804a5a2 <trans_char+0x172>
 804a52d:	6c                   	insb   (%dx),%es:(%edi)
 804a52e:	74 73                	je     804a5a3 <trans_char+0x173>
 804a530:	20 6e 6f             	and    %ch,0x6f(%esi)
 804a533:	74 20                	je     804a555 <trans_char+0x125>
 804a535:	76 61                	jbe    804a598 <trans_char+0x168>
 804a537:	6c                   	insb   (%dx),%es:(%edi)
 804a538:	69 64 61 74 65 64 00 	imul   $0x6465,0x74(%ecx,%eiz,2),%esp
 804a53f:	00 
 804a540:	53                   	push   %ebx
 804a541:	65 6e                	outsb  %gs:(%esi),(%dx)
 804a543:	74 20                	je     804a565 <trans_char+0x135>
 804a545:	65 78 70             	gs js  804a5b8 <trans_char+0x188>
 804a548:	6c                   	insb   (%dx),%es:(%edi)
 804a549:	6f                   	outsl  %ds:(%esi),(%dx)
 804a54a:	69 74 20 73 74 72 69 	imul   $0x6e697274,0x73(%eax,%eiz,1),%esi
 804a551:	6e 
 804a552:	67 20 74 6f          	and    %dh,0x6f(%si)
 804a556:	20 73 65             	and    %dh,0x65(%ebx)
 804a559:	72 76                	jb     804a5d1 <trans_char+0x1a1>
 804a55b:	65 72 20             	gs jb  804a57e <trans_char+0x14e>
 804a55e:	74 6f                	je     804a5cf <trans_char+0x19f>
 804a560:	20 62 65             	and    %ah,0x65(%edx)
 804a563:	20 76 61             	and    %dh,0x61(%esi)
 804a566:	6c                   	insb   (%dx),%es:(%edi)
 804a567:	69 64 61 74 65 64 2e 	imul   $0x2e6465,0x74(%ecx,%eiz,2),%esp
 804a56e:	00 
 804a56f:	00 57 61             	add    %dl,0x61(%edi)
 804a572:	72 6e                	jb     804a5e2 <trans_char+0x1b2>
 804a574:	69 6e 67 3a 20 55 6e 	imul   $0x6e55203a,0x67(%esi),%ebp
 804a57b:	61                   	popa   
 804a57c:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
 804a580:	74 6f                	je     804a5f1 <trans_char+0x1c1>
 804a582:	20 73 65             	and    %dh,0x65(%ebx)
 804a585:	6e                   	outsb  %ds:(%esi),(%dx)
 804a586:	64 20 65 78          	and    %ah,%fs:0x78(%ebp)
 804a58a:	70 6c                	jo     804a5f8 <trans_char+0x1c8>
 804a58c:	6f                   	outsl  %ds:(%esi),(%dx)
 804a58d:	69 74 20 73 74 72 69 	imul   $0x6e697274,0x73(%eax,%eiz,1),%esi
 804a594:	6e 
 804a595:	67 20 74 6f          	and    %dh,0x6f(%si)
 804a599:	20 67 72             	and    %ah,0x72(%edi)
 804a59c:	61                   	popa   
 804a59d:	64 69 6e 67 20 73 65 	imul   $0x72657320,%fs:0x67(%esi),%ebp
 804a5a4:	72 
 804a5a5:	76 65                	jbe    804a60c <trans_char+0x1dc>
 804a5a7:	72 3a                	jb     804a5e3 <trans_char+0x1b3>
 804a5a9:	0a 25 73 0a 00 69    	or     0x69000a73,%ah
 804a5af:	6e                   	outsb  %ds:(%esi),(%dx)
 804a5b0:	69 74 69 61 6c 69 7a 	imul   $0x657a696c,0x61(%ecx,%ebp,2),%esi
 804a5b7:	65 
 804a5b8:	5f                   	pop    %edi
 804a5b9:	62 6f 6d             	bound  %ebp,0x6d(%edi)
 804a5bc:	62 3a                	bound  %edi,(%edx)
 804a5be:	20 25 73 0a 00 4b    	and    %ah,0x4b000a73
 804a5c4:	65 65 70 20          	gs gs jo 804a5e8 <trans_char+0x1b8>
 804a5c8:	67 6f                	outsl  %ds:(%si),(%dx)
 804a5ca:	69 6e 67 00 56 41 4c 	imul   $0x4c415600,0x67(%esi),%ebp
 804a5d1:	49                   	dec    %ecx
 804a5d2:	44                   	inc    %esp
 804a5d3:	00 25 64 3a 25 78    	add    %ah,0x78253a64
 804a5d9:	3a 25 73 00 4e 49    	cmp    0x494e0073,%ah
 804a5df:	43                   	inc    %ebx
 804a5e0:	45                   	inc    %ebp
 804a5e1:	20 4a 4f             	and    %cl,0x4f(%edx)
 804a5e4:	42                   	inc    %edx
 804a5e5:	21 00                	and    %eax,(%eax)
 804a5e7:	62 6c 75 65          	bound  %ebp,0x65(%ebp,%esi,2)
 804a5eb:	66 69 73 68 2e 69    	imul   $0x692e,0x68(%ebx),%si
 804a5f1:	63 73 2e             	arpl   %si,0x2e(%ebx)
 804a5f4:	63 73 2e             	arpl   %si,0x2e(%ebx)
 804a5f7:	63 6d 75             	arpl   %bp,0x75(%ebp)
 804a5fa:	2e 65 64 75 00       	cs gs fs jne,pn 804a5ff <trans_char+0x1cf>
 804a5ff:	61                   	popa   
 804a600:	6e                   	outsb  %ds:(%esi),(%dx)
 804a601:	67 65 6c             	gs insb (%dx),%es:(%di)
 804a604:	73 68                	jae    804a66e <trans_char+0x23e>
 804a606:	61                   	popa   
 804a607:	72 6b                	jb     804a674 <trans_char+0x244>
 804a609:	2e 69 63 73 2e 63 73 	imul   $0x2e73632e,%cs:0x73(%ebx),%esp
 804a610:	2e 
 804a611:	63 6d 75             	arpl   %bp,0x75(%ebp)
 804a614:	2e 65 64 75 00       	cs gs fs jne,pn 804a619 <trans_char+0x1e9>
 804a619:	67 72 65             	addr16 jb 804a681 <trans_char+0x251>
 804a61c:	61                   	popa   
 804a61d:	74 77                	je     804a696 <trans_char+0x266>
 804a61f:	68 69 74 65 2e       	push   $0x2e657469
 804a624:	69 63 73 2e 63 73 2e 	imul   $0x2e73632e,0x73(%ebx),%esp
 804a62b:	63 6d 75             	arpl   %bp,0x75(%ebp)
 804a62e:	2e 65 64 75 00       	cs gs fs jne,pn 804a633 <trans_char+0x203>
 804a633:	6d                   	insl   (%dx),%es:(%edi)
 804a634:	61                   	popa   
 804a635:	6b 6f 73 68          	imul   $0x68,0x73(%edi),%ebp
 804a639:	61                   	popa   
 804a63a:	72 6b                	jb     804a6a7 <trans_char+0x277>
 804a63c:	2e 69 63 73 2e 63 73 	imul   $0x2e73632e,%cs:0x73(%ebx),%esp
 804a643:	2e 
 804a644:	63 6d 75             	arpl   %bp,0x75(%ebp)
 804a647:	2e 65 64 75 00       	cs gs fs jne,pn 804a64c <trans_char+0x21c>
 804a64c:	50                   	push   %eax
 804a64d:	72 6f                	jb     804a6be <trans_char+0x28e>
 804a64f:	67 72 61             	addr16 jb 804a6b3 <trans_char+0x283>
 804a652:	6d                   	insl   (%dx),%es:(%edi)
 804a653:	20 74 69 6d          	and    %dh,0x6d(%ecx,%ebp,2)
 804a657:	65 64 20 6f 75       	gs and %ch,%fs:0x75(%edi)
 804a65c:	74 20                	je     804a67e <trans_char+0x24e>
 804a65e:	61                   	popa   
 804a65f:	66 74 65             	data16 je 804a6c7 <trans_char+0x297>
 804a662:	72 20                	jb     804a684 <trans_char+0x254>
 804a664:	25 64 20 73 65       	and    $0x65732064,%eax
 804a669:	63 6f 6e             	arpl   %bp,0x6e(%edi)
 804a66c:	64 73 0a             	fs jae 804a679 <trans_char+0x249>
 804a66f:	00 45 72             	add    %al,0x72(%ebp)
 804a672:	72 6f                	jb     804a6e3 <trans_char+0x2b3>
 804a674:	72 3a                	jb     804a6b0 <trans_char+0x280>
 804a676:	20 44 4e 53          	and    %al,0x53(%esi,%ecx,2)
 804a67a:	20 75 6e             	and    %dh,0x6e(%ebp)
 804a67d:	61                   	popa   
 804a67e:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
 804a682:	74 6f                	je     804a6f3 <trans_char+0x2c3>
 804a684:	20 72 65             	and    %dh,0x65(%edx)
 804a687:	73 6f                	jae    804a6f8 <trans_char+0x2c8>
 804a689:	6c                   	insb   (%dx),%es:(%edi)
 804a68a:	76 65                	jbe    804a6f1 <trans_char+0x2c1>
 804a68c:	20 61 64             	and    %ah,0x64(%ecx)
 804a68f:	64 72 65             	fs jb  804a6f7 <trans_char+0x2c7>
 804a692:	73 73                	jae    804a707 <trans_char+0x2d7>
 804a694:	20 66 6f             	and    %ah,0x6f(%esi)
 804a697:	72 20                	jb     804a6b9 <trans_char+0x289>
 804a699:	25 73 00 45 72       	and    $0x72450073,%eax
 804a69e:	72 6f                	jb     804a70f <trans_char+0x2df>
 804a6a0:	72 3a                	jb     804a6dc <trans_char+0x2ac>
 804a6a2:	20 55 6e             	and    %dl,0x6e(%ebp)
 804a6a5:	61                   	popa   
 804a6a6:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
 804a6aa:	74 6f                	je     804a71b <trans_char+0x2eb>
 804a6ac:	20 63 6f             	and    %ah,0x6f(%ebx)
 804a6af:	6e                   	outsb  %ds:(%esi),(%dx)
 804a6b0:	6e                   	outsb  %ds:(%esi),(%dx)
 804a6b1:	65 63 74 20 74       	arpl   %si,%gs:0x74(%eax,%eiz,1)
 804a6b6:	6f                   	outsl  %ds:(%esi),(%dx)
 804a6b7:	20 73 65             	and    %dh,0x65(%ebx)
 804a6ba:	72 76                	jb     804a732 <trans_char+0x302>
 804a6bc:	65 72 20             	gs jb  804a6df <trans_char+0x2af>
 804a6bf:	25 73 00 00 00       	and    $0x73,%eax
 804a6c4:	45                   	inc    %ebp
 804a6c5:	72 72                	jb     804a739 <trans_char+0x309>
 804a6c7:	6f                   	outsl  %ds:(%esi),(%dx)
 804a6c8:	72 3a                	jb     804a704 <trans_char+0x2d4>
 804a6ca:	20 48 54             	and    %cl,0x54(%eax)
 804a6cd:	54                   	push   %esp
 804a6ce:	50                   	push   %eax
 804a6cf:	20 72 65             	and    %dh,0x65(%edx)
 804a6d2:	71 75                	jno    804a749 <trans_char+0x319>
 804a6d4:	65 73 74             	gs jae 804a74b <trans_char+0x31b>
 804a6d7:	20 66 61             	and    %ah,0x61(%esi)
 804a6da:	69 6c 65 64 20 77 69 	imul   $0x74697720,0x64(%ebp,%eiz,2),%ebp
 804a6e1:	74 
 804a6e2:	68 20 65 72 72       	push   $0x72726520
 804a6e7:	6f                   	outsl  %ds:(%esi),(%dx)
 804a6e8:	72 20                	jb     804a70a <trans_char+0x2da>
 804a6ea:	25 64 3a 20 25       	and    $0x25203a64,%eax
 804a6ef:	73 00                	jae    804a6f1 <trans_char+0x2c1>
 804a6f1:	00 00                	add    %al,(%eax)
 804a6f3:	00 47 45             	add    %al,0x45(%edi)
 804a6f6:	54                   	push   %esp
 804a6f7:	20 2f                	and    %ch,(%edi)
 804a6f9:	25 73 2f 73 75       	and    $0x75732f73,%eax
 804a6fe:	62 6d 69             	bound  %ebp,0x69(%ebp)
 804a701:	74 72                	je     804a775 <trans_char+0x345>
 804a703:	2e 70 6c             	jo,pn  804a772 <trans_char+0x342>
 804a706:	2f                   	das    
 804a707:	3f                   	aas    
 804a708:	75 73                	jne    804a77d <trans_char+0x34d>
 804a70a:	65 72 69             	gs jb  804a776 <trans_char+0x346>
 804a70d:	64 3d 25 73 26 6c    	fs cmp $0x6c267325,%eax
 804a713:	61                   	popa   
 804a714:	62 3d 25 73 26 72    	bound  %edi,0x72267325
 804a71a:	65 73 75             	gs jae 804a792 <trans_char+0x362>
 804a71d:	6c                   	insb   (%dx),%es:(%edi)
 804a71e:	74 3d                	je     804a75d <trans_char+0x32d>
 804a720:	25 73 26 73 75       	and    $0x75732673,%eax
 804a725:	62 6d 69             	bound  %ebp,0x69(%ebp)
 804a728:	74 3d                	je     804a767 <trans_char+0x337>
 804a72a:	73 75                	jae    804a7a1 <trans_char+0x371>
 804a72c:	62 6d 69             	bound  %ebp,0x69(%ebp)
 804a72f:	74 20                	je     804a751 <trans_char+0x321>
 804a731:	48                   	dec    %eax
 804a732:	54                   	push   %esp
 804a733:	54                   	push   %esp
 804a734:	50                   	push   %eax
 804a735:	2f                   	das    
 804a736:	31 2e                	xor    %ebp,(%esi)
 804a738:	30 0d 0a 0d 0a 00    	xor    %cl,0xa0d0a
 804a73e:	00 00                	add    %al,(%eax)
 804a740:	45                   	inc    %ebp
 804a741:	72 72                	jb     804a7b5 <trans_char+0x385>
 804a743:	6f                   	outsl  %ds:(%esi),(%dx)
 804a744:	72 3a                	jb     804a780 <trans_char+0x350>
 804a746:	20 52 65             	and    %dl,0x65(%edx)
 804a749:	73 75                	jae    804a7c0 <trans_char+0x390>
 804a74b:	6c                   	insb   (%dx),%es:(%edi)
 804a74c:	74 20                	je     804a76e <trans_char+0x33e>
 804a74e:	73 74                	jae    804a7c4 <trans_char+0x394>
 804a750:	72 69                	jb     804a7bb <trans_char+0x38b>
 804a752:	6e                   	outsb  %ds:(%esi),(%dx)
 804a753:	67 20 63 6f          	and    %ah,0x6f(%bp,%di)
 804a757:	6e                   	outsb  %ds:(%esi),(%dx)
 804a758:	74 61                	je     804a7bb <trans_char+0x38b>
 804a75a:	69 6e 73 20 61 6e 20 	imul   $0x206e6120,0x73(%esi),%ebp
 804a761:	69 6c 6c 65 67 61 6c 	imul   $0x206c6167,0x65(%esp,%ebp,2),%ebp
 804a768:	20 
 804a769:	6f                   	outsl  %ds:(%esi),(%dx)
 804a76a:	72 20                	jb     804a78c <trans_char+0x35c>
 804a76c:	75 6e                	jne    804a7dc <trans_char+0x3ac>
 804a76e:	70 72                	jo     804a7e2 <trans_char+0x3b2>
 804a770:	69 6e 74 61 62 6c 65 	imul   $0x656c6261,0x74(%esi),%ebp
 804a777:	20 63 68             	and    %ah,0x68(%ebx)
 804a77a:	61                   	popa   
 804a77b:	72 61                	jb     804a7de <trans_char+0x3ae>
 804a77d:	63 74 65 72          	arpl   %si,0x72(%ebp,%eiz,2)
 804a781:	2e 00 00             	add    %al,%cs:(%eax)
 804a784:	45                   	inc    %ebp
 804a785:	72 72                	jb     804a7f9 <trans_char+0x3c9>
 804a787:	6f                   	outsl  %ds:(%esi),(%dx)
 804a788:	72 3a                	jb     804a7c4 <trans_char+0x394>
 804a78a:	20 55 6e             	and    %dl,0x6e(%ebp)
 804a78d:	61                   	popa   
 804a78e:	62 6c 65 20          	bound  %ebp,0x20(%ebp,%eiz,2)
 804a792:	74 6f                	je     804a803 <trans_char+0x3d3>
 804a794:	20 63 6f             	and    %ah,0x6f(%ebx)
 804a797:	6e                   	outsb  %ds:(%esi),(%dx)
 804a798:	6e                   	outsb  %ds:(%esi),(%dx)
 804a799:	65 63 74 20 74       	arpl   %si,%gs:0x74(%eax,%eiz,1)
 804a79e:	6f                   	outsl  %ds:(%esi),(%dx)
 804a79f:	20 73 65             	and    %dh,0x65(%ebx)
 804a7a2:	72 76                	jb     804a81a <trans_char+0x3ea>
 804a7a4:	65 72 20             	gs jb  804a7c7 <trans_char+0x397>
 804a7a7:	25 73 3a 25 64       	and    $0x64253a73,%eax
 804a7ac:	00 00                	add    %al,(%eax)
 804a7ae:	00 00                	add    %al,(%eax)
 804a7b0:	25 25 25 30 32       	and    $0x32302525,%eax
 804a7b5:	58                   	pop    %eax
 804a7b6:	00 25 73 20 25 64    	add    %ah,0x64252073
 804a7bc:	20 25 5b 61 2d 7a    	and    %ah,0x7a2d615b
 804a7c2:	41                   	inc    %ecx
 804a7c3:	2d 7a 20 5d 00       	sub    $0x5d207a,%eax
 804a7c8:	63 73 2e             	arpl   %si,0x2e(%ebx)
 804a7cb:	6e                   	outsb  %ds:(%esi),(%dx)
 804a7cc:	6a 75                	push   $0x75
 804a7ce:	2e 65 64 75 2e       	cs gs fs jne,pn 804a801 <trans_char+0x3d1>
 804a7d3:	63 6e 00             	arpl   %bp,0x0(%esi)
 804a7d6:	0a 41 55             	or     0x55(%ecx),%al
 804a7d9:	54                   	push   %esp
 804a7da:	4f                   	dec    %edi
 804a7db:	52                   	push   %edx
 804a7dc:	45                   	inc    %ebp
 804a7dd:	53                   	push   %ebx
 804a7de:	55                   	push   %ebp
 804a7df:	4c                   	dec    %esp
 804a7e0:	54                   	push   %esp
 804a7e1:	5f                   	pop    %edi
 804a7e2:	53                   	push   %ebx
 804a7e3:	54                   	push   %esp
 804a7e4:	52                   	push   %edx
 804a7e5:	49                   	dec    %ecx
 804a7e6:	4e                   	dec    %esi
 804a7e7:	47                   	inc    %edi
 804a7e8:	3d 25 73 0a 00       	cmp    $0xa7325,%eax
 804a7ed:	62 75 66             	bound  %esi,0x66(%ebp)
 804a7f0:	6c                   	insb   (%dx),%es:(%edi)
 804a7f1:	61                   	popa   
 804a7f2:	62 00                	bound  %eax,(%eax)
 804a7f4:	63 73 61             	arpl   %si,0x61(%ebx)
 804a7f7:	70 70                	jo     804a869 <trans_char+0x439>
	...

Disassembly of section .eh_frame_hdr:

0804a7fc <.eh_frame_hdr>:
 804a7fc:	01 1b                	add    %ebx,(%ebx)
 804a7fe:	03 3b                	add    (%ebx),%edi
 804a800:	e8 00 00 00 1c       	call   2404a805 <_end+0x1bffd9a1>
 804a805:	00 00                	add    %al,(%eax)
 804a807:	00 a4 e0 ff ff 04 01 	add    %ah,0x104ffff(%eax,%eiz,8)
 804a80e:	00 00                	add    %al,(%eax)
 804a810:	c4 e3 ff ff          	(bad)  
 804a814:	28 01                	sub    %al,(%ecx)
 804a816:	00 00                	add    %al,(%eax)
 804a818:	16                   	push   %ss
 804a819:	e4 ff                	in     $0xff,%al
 804a81b:	ff 44 01 00          	incl   0x0(%ecx,%eax,1)
 804a81f:	00 40 e4             	add    %al,-0x1c(%eax)
 804a822:	ff                   	(bad)  
 804a823:	ff 60 01             	jmp    *0x1(%eax)
 804a826:	00 00                	add    %al,(%eax)
 804a828:	6a e4                	push   $0xffffffe4
 804a82a:	ff                   	(bad)  
 804a82b:	ff                   	(bad)  
 804a82c:	7c 01                	jl     804a82f <trans_char+0x3ff>
 804a82e:	00 00                	add    %al,(%eax)
 804a830:	94                   	xchg   %eax,%esp
 804a831:	e4 ff                	in     $0xff,%al
 804a833:	ff 98 01 00 00 be    	lcall  *-0x41ffffff(%eax)
 804a839:	e4 ff                	in     $0xff,%al
 804a83b:	ff b4 01 00 00 09 e5 	pushl  -0x1af70000(%ecx,%eax,1)
 804a842:	ff                   	(bad)  
 804a843:	ff d0                	call   *%eax
 804a845:	01 00                	add    %eax,(%eax)
 804a847:	00 56 e5             	add    %dl,-0x1b(%esi)
 804a84a:	ff                   	(bad)  
 804a84b:	ff                   	(bad)  
 804a84c:	ec                   	in     (%dx),%al
 804a84d:	01 00                	add    %eax,(%eax)
 804a84f:	00 eb                	add    %ch,%bl
 804a851:	e5 ff                	in     $0xff,%eax
 804a853:	ff 18                	lcall  *(%eax)
 804a855:	02 00                	add    (%eax),%al
 804a857:	00 05 e6 ff ff 38    	add    %al,0x38ffffe6
 804a85d:	02 00                	add    (%eax),%al
 804a85f:	00 71 e6             	add    %dh,-0x1a(%ecx)
 804a862:	ff                   	(bad)  
 804a863:	ff 5c 02 00          	lcall  *0x0(%edx,%eax,1)
 804a867:	00 dd                	add    %bl,%ch
 804a869:	e6 ff                	out    %al,$0xff
 804a86b:	ff 80 02 00 00 53    	incl   0x53000002(%eax)
 804a871:	e7 ff                	out    %eax,$0xff
 804a873:	ff a4 02 00 00 1d e8 	jmp    *-0x17e30000(%edx,%eax,1)
 804a87a:	ff                   	(bad)  
 804a87b:	ff c4                	inc    %esp
 804a87d:	02 00                	add    (%eax),%al
 804a87f:	00 f0                	add    %dh,%al
 804a881:	e9 ff ff f4 02       	jmp    af9a885 <_end+0x2f4da21>
 804a886:	00 00                	add    %al,(%eax)
 804a888:	08 ea                	or     %ch,%dl
 804a88a:	ff                   	(bad)  
 804a88b:	ff 14 03             	call   *(%ebx,%eax,1)
 804a88e:	00 00                	add    %al,(%eax)
 804a890:	28 ea                	sub    %ch,%dl
 804a892:	ff                   	(bad)  
 804a893:	ff 34 03             	pushl  (%ebx,%eax,1)
 804a896:	00 00                	add    %al,(%eax)
 804a898:	48                   	dec    %eax
 804a899:	eb ff                	jmp    804a89a <trans_char+0x46a>
 804a89b:	ff 60 03             	jmp    *0x3(%eax)
 804a89e:	00 00                	add    %al,(%eax)
 804a8a0:	94                   	xchg   %eax,%esp
 804a8a1:	ec                   	in     (%dx),%al
 804a8a2:	ff                   	(bad)  
 804a8a3:	ff 8c 03 00 00 9e ed 	decl   -0x12620000(%ebx,%eax,1)
 804a8aa:	ff                   	(bad)  
 804a8ab:	ff                   	(bad)  
 804a8ac:	b8 03 00 00 c4       	mov    $0xc4000003,%eax
 804a8b1:	ed                   	in     (%dx),%eax
 804a8b2:	ff                   	(bad)  
 804a8b3:	ff d4                	call   *%esp
 804a8b5:	03 00                	add    (%eax),%eax
 804a8b7:	00 16                	add    %dl,(%esi)
 804a8b9:	f5                   	cmc    
 804a8ba:	ff                   	(bad)  
 804a8bb:	ff 04 04             	incl   (%esp,%eax,1)
 804a8be:	00 00                	add    %al,(%eax)
 804a8c0:	4f                   	dec    %edi
 804a8c1:	f5                   	cmc    
 804a8c2:	ff                   	(bad)  
 804a8c3:	ff 28                	ljmp   *(%eax)
 804a8c5:	04 00                	add    $0x0,%al
 804a8c7:	00 ec                	add    %ch,%ah
 804a8c9:	f6 ff                	idiv   %bh
 804a8cb:	ff 58 04             	lcall  *0x4(%eax)
 804a8ce:	00 00                	add    %al,(%eax)
 804a8d0:	74 f7                	je     804a8c9 <trans_char+0x499>
 804a8d2:	ff                   	(bad)  
 804a8d3:	ff                   	(bad)  
 804a8d4:	7c 04                	jl     804a8da <trans_char+0x4aa>
 804a8d6:	00 00                	add    %al,(%eax)
 804a8d8:	a1 f7 ff ff 9c       	mov    0x9cfffff7,%eax
 804a8dd:	04 00                	add    $0x0,%al
 804a8df:	00 ee                	add    %ch,%dh
 804a8e1:	f7 ff                	idiv   %edi
 804a8e3:	ff                   	(bad)  
 804a8e4:	bc                   	.byte 0xbc
 804a8e5:	04 00                	add    $0x0,%al
	...

Disassembly of section .eh_frame:

0804a8e8 <__FRAME_END__-0x3f4>:
 804a8e8:	14 00                	adc    $0x0,%al
 804a8ea:	00 00                	add    %al,(%eax)
 804a8ec:	00 00                	add    %al,(%eax)
 804a8ee:	00 00                	add    %al,(%eax)
 804a8f0:	01 7a 52             	add    %edi,0x52(%edx)
 804a8f3:	00 01                	add    %al,(%ecx)
 804a8f5:	7c 08                	jl     804a8ff <trans_char+0x4cf>
 804a8f7:	01 1b                	add    %ebx,(%ebx)
 804a8f9:	0c 04                	or     $0x4,%al
 804a8fb:	04 88                	add    $0x88,%al
 804a8fd:	01 00                	add    %eax,(%eax)
 804a8ff:	00 20                	add    %ah,(%eax)
 804a901:	00 00                	add    %al,(%eax)
 804a903:	00 1c 00             	add    %bl,(%eax,%eax,1)
 804a906:	00 00                	add    %al,(%eax)
 804a908:	98                   	cwtl   
 804a909:	df ff                	(bad)  
 804a90b:	ff 30                	pushl  (%eax)
 804a90d:	02 00                	add    (%eax),%al
 804a90f:	00 00                	add    %al,(%eax)
 804a911:	0e                   	push   %cs
 804a912:	08 46 0e             	or     %al,0xe(%esi)
 804a915:	0c 4a                	or     $0x4a,%al
 804a917:	0f 0b                	ud2    
 804a919:	74 04                	je     804a91f <trans_char+0x4ef>
 804a91b:	78 00                	js     804a91d <trans_char+0x4ed>
 804a91d:	3f                   	aas    
 804a91e:	1a 3b                	sbb    (%ebx),%bh
 804a920:	2a 32                	sub    (%edx),%dh
 804a922:	24 22                	and    $0x22,%al
 804a924:	18 00                	sbb    %al,(%eax)
 804a926:	00 00                	add    %al,(%eax)
 804a928:	40                   	inc    %eax
 804a929:	00 00                	add    %al,(%eax)
 804a92b:	00 94 e2 ff ff 52 00 	add    %dl,0x52ffff(%edx,%eiz,8)
 804a932:	00 00                	add    %al,(%eax)
 804a934:	00 41 0e             	add    %al,0xe(%ecx)
 804a937:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804a93d:	00 00                	add    %al,(%eax)
 804a93f:	00 18                	add    %bl,(%eax)
 804a941:	00 00                	add    %al,(%eax)
 804a943:	00 5c 00 00          	add    %bl,0x0(%eax,%eax,1)
 804a947:	00 ca                	add    %cl,%dl
 804a949:	e2 ff                	loop   804a94a <trans_char+0x51a>
 804a94b:	ff 2a                	ljmp   *(%edx)
 804a94d:	00 00                	add    %al,(%eax)
 804a94f:	00 00                	add    %al,(%eax)
 804a951:	41                   	inc    %ecx
 804a952:	0e                   	push   %cs
 804a953:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804a959:	00 00                	add    %al,(%eax)
 804a95b:	00 18                	add    %bl,(%eax)
 804a95d:	00 00                	add    %al,(%eax)
 804a95f:	00 78 00             	add    %bh,0x0(%eax)
 804a962:	00 00                	add    %al,(%eax)
 804a964:	d8 e2                	fsub   %st(2),%st
 804a966:	ff                   	(bad)  
 804a967:	ff 2a                	ljmp   *(%edx)
 804a969:	00 00                	add    %al,(%eax)
 804a96b:	00 00                	add    %al,(%eax)
 804a96d:	41                   	inc    %ecx
 804a96e:	0e                   	push   %cs
 804a96f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804a975:	00 00                	add    %al,(%eax)
 804a977:	00 18                	add    %bl,(%eax)
 804a979:	00 00                	add    %al,(%eax)
 804a97b:	00 94 00 00 00 e6 e2 	add    %dl,-0x1d1a0000(%eax,%eax,1)
 804a982:	ff                   	(bad)  
 804a983:	ff 2a                	ljmp   *(%edx)
 804a985:	00 00                	add    %al,(%eax)
 804a987:	00 00                	add    %al,(%eax)
 804a989:	41                   	inc    %ecx
 804a98a:	0e                   	push   %cs
 804a98b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804a991:	00 00                	add    %al,(%eax)
 804a993:	00 18                	add    %bl,(%eax)
 804a995:	00 00                	add    %al,(%eax)
 804a997:	00 b0 00 00 00 f4    	add    %dh,-0xc000000(%eax)
 804a99d:	e2 ff                	loop   804a99e <trans_char+0x56e>
 804a99f:	ff 2a                	ljmp   *(%edx)
 804a9a1:	00 00                	add    %al,(%eax)
 804a9a3:	00 00                	add    %al,(%eax)
 804a9a5:	41                   	inc    %ecx
 804a9a6:	0e                   	push   %cs
 804a9a7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804a9ad:	00 00                	add    %al,(%eax)
 804a9af:	00 18                	add    %bl,(%eax)
 804a9b1:	00 00                	add    %al,(%eax)
 804a9b3:	00 cc                	add    %cl,%ah
 804a9b5:	00 00                	add    %al,(%eax)
 804a9b7:	00 02                	add    %al,(%edx)
 804a9b9:	e3 ff                	jecxz  804a9ba <trans_char+0x58a>
 804a9bb:	ff 4b 00             	decl   0x0(%ebx)
 804a9be:	00 00                	add    %al,(%eax)
 804a9c0:	00 41 0e             	add    %al,0xe(%ecx)
 804a9c3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804a9c9:	00 00                	add    %al,(%eax)
 804a9cb:	00 18                	add    %bl,(%eax)
 804a9cd:	00 00                	add    %al,(%eax)
 804a9cf:	00 e8                	add    %ch,%al
 804a9d1:	00 00                	add    %al,(%eax)
 804a9d3:	00 31                	add    %dh,(%ecx)
 804a9d5:	e3 ff                	jecxz  804a9d6 <trans_char+0x5a6>
 804a9d7:	ff 4d 00             	decl   0x0(%ebp)
 804a9da:	00 00                	add    %al,(%eax)
 804a9dc:	00 41 0e             	add    %al,0xe(%ecx)
 804a9df:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804a9e5:	00 00                	add    %al,(%eax)
 804a9e7:	00 28                	add    %ch,(%eax)
 804a9e9:	00 00                	add    %al,(%eax)
 804a9eb:	00 04 01             	add    %al,(%ecx,%eax,1)
 804a9ee:	00 00                	add    %al,(%eax)
 804a9f0:	62 e3 ff ff 95       	(bad)  {%k7}{z}
 804a9f5:	00 00                	add    %al,(%eax)
 804a9f7:	00 00                	add    %al,(%eax)
 804a9f9:	41                   	inc    %ecx
 804a9fa:	0e                   	push   %cs
 804a9fb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804aa01:	46                   	inc    %esi
 804aa02:	87 03                	xchg   %eax,(%ebx)
 804aa04:	86 04 83             	xchg   %al,(%ebx,%eax,4)
 804aa07:	05 02 88 c3 41       	add    $0x41c38802,%eax
 804aa0c:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
 804aa10:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804aa13:	04 1c                	add    $0x1c,%al
 804aa15:	00 00                	add    %al,(%eax)
 804aa17:	00 30                	add    %dh,(%eax)
 804aa19:	01 00                	add    %eax,(%eax)
 804aa1b:	00 cb                	add    %cl,%bl
 804aa1d:	e3 ff                	jecxz  804aa1e <trans_char+0x5ee>
 804aa1f:	ff 1a                	lcall  *(%edx)
 804aa21:	00 00                	add    %al,(%eax)
 804aa23:	00 00                	add    %al,(%eax)
 804aa25:	41                   	inc    %ecx
 804aa26:	0e                   	push   %cs
 804aa27:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804aa2d:	56                   	push   %esi
 804aa2e:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804aa31:	04 00                	add    $0x0,%al
 804aa33:	00 20                	add    %ah,(%eax)
 804aa35:	00 00                	add    %al,(%eax)
 804aa37:	00 50 01             	add    %dl,0x1(%eax)
 804aa3a:	00 00                	add    %al,(%eax)
 804aa3c:	c5 e3 ff             	(bad)  
 804aa3f:	ff 6c 00 00          	ljmp   *0x0(%eax,%eax,1)
 804aa43:	00 00                	add    %al,(%eax)
 804aa45:	41                   	inc    %ecx
 804aa46:	0e                   	push   %cs
 804aa47:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804aa4d:	44                   	inc    %esp
 804aa4e:	83 03 02             	addl   $0x2,(%ebx)
 804aa51:	63 c3                	arpl   %ax,%bx
 804aa53:	41                   	inc    %ecx
 804aa54:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804aa57:	04 20                	add    $0x20,%al
 804aa59:	00 00                	add    %al,(%eax)
 804aa5b:	00 74 01 00          	add    %dh,0x0(%ecx,%eax,1)
 804aa5f:	00 0d e4 ff ff 6c    	add    %cl,0x6cffffe4
 804aa65:	00 00                	add    %al,(%eax)
 804aa67:	00 00                	add    %al,(%eax)
 804aa69:	41                   	inc    %ecx
 804aa6a:	0e                   	push   %cs
 804aa6b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804aa71:	44                   	inc    %esp
 804aa72:	83 03 02             	addl   $0x2,(%ebx)
 804aa75:	63 c3                	arpl   %ax,%bx
 804aa77:	41                   	inc    %ecx
 804aa78:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804aa7b:	04 20                	add    $0x20,%al
 804aa7d:	00 00                	add    %al,(%eax)
 804aa7f:	00 98 01 00 00 55    	add    %bl,0x55000001(%eax)
 804aa85:	e4 ff                	in     $0xff,%al
 804aa87:	ff 76 00             	pushl  0x0(%esi)
 804aa8a:	00 00                	add    %al,(%eax)
 804aa8c:	00 41 0e             	add    %al,0xe(%ecx)
 804aa8f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804aa95:	44                   	inc    %esp
 804aa96:	83 03 02             	addl   $0x2,(%ebx)
 804aa99:	6e                   	outsb  %ds:(%esi),(%dx)
 804aa9a:	c5 c3 0c             	(bad)  
 804aa9d:	04 04                	add    $0x4,%al
 804aa9f:	00 1c 00             	add    %bl,(%eax,%eax,1)
 804aaa2:	00 00                	add    %al,(%eax)
 804aaa4:	bc 01 00 00 a7       	mov    $0xa7000001,%esp
 804aaa9:	e4 ff                	in     $0xff,%al
 804aaab:	ff ca                	dec    %edx
 804aaad:	00 00                	add    %al,(%eax)
 804aaaf:	00 00                	add    %al,(%eax)
 804aab1:	41                   	inc    %ecx
 804aab2:	0e                   	push   %cs
 804aab3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804aab9:	02 c6                	add    %dh,%al
 804aabb:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804aabe:	04 00                	add    $0x0,%al
 804aac0:	2c 00                	sub    $0x0,%al
 804aac2:	00 00                	add    %al,(%eax)
 804aac4:	dc 01                	faddl  (%ecx)
 804aac6:	00 00                	add    %al,(%eax)
 804aac8:	51                   	push   %ecx
 804aac9:	e5 ff                	in     $0xff,%eax
 804aacb:	ff d1                	call   *%ecx
 804aacd:	01 00                	add    %eax,(%eax)
 804aacf:	00 00                	add    %al,(%eax)
 804aad1:	41                   	inc    %ecx
 804aad2:	0e                   	push   %cs
 804aad3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804aad9:	49                   	dec    %ecx
 804aada:	87 03                	xchg   %eax,(%ebx)
 804aadc:	86 04 83             	xchg   %al,(%ebx,%eax,4)
 804aadf:	05 03 c1 01 c3       	add    $0xc301c103,%eax
 804aae4:	41                   	inc    %ecx
 804aae5:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
 804aae9:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804aaec:	04 00                	add    $0x0,%al
 804aaee:	00 00                	add    %al,(%eax)
 804aaf0:	1c 00                	sbb    $0x0,%al
 804aaf2:	00 00                	add    %al,(%eax)
 804aaf4:	0c 02                	or     $0x2,%al
 804aaf6:	00 00                	add    %al,(%eax)
 804aaf8:	f4                   	hlt    
 804aaf9:	e6 ff                	out    %al,$0xff
 804aafb:	ff 18                	lcall  *(%eax)
 804aafd:	00 00                	add    %al,(%eax)
 804aaff:	00 00                	add    %al,(%eax)
 804ab01:	41                   	inc    %ecx
 804ab02:	0e                   	push   %cs
 804ab03:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804ab09:	54                   	push   %esp
 804ab0a:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804ab0d:	04 00                	add    $0x0,%al
 804ab0f:	00 1c 00             	add    %bl,(%eax,%eax,1)
 804ab12:	00 00                	add    %al,(%eax)
 804ab14:	2c 02                	sub    $0x2,%al
 804ab16:	00 00                	add    %al,(%eax)
 804ab18:	ec                   	in     (%dx),%al
 804ab19:	e6 ff                	out    %al,$0xff
 804ab1b:	ff 1e                	lcall  *(%esi)
 804ab1d:	00 00                	add    %al,(%eax)
 804ab1f:	00 00                	add    %al,(%eax)
 804ab21:	41                   	inc    %ecx
 804ab22:	0e                   	push   %cs
 804ab23:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804ab29:	5a                   	pop    %edx
 804ab2a:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804ab2d:	04 00                	add    $0x0,%al
 804ab2f:	00 28                	add    %ch,(%eax)
 804ab31:	00 00                	add    %al,(%eax)
 804ab33:	00 4c 02 00          	add    %cl,0x0(%edx,%eax,1)
 804ab37:	00 ec                	add    %ch,%ah
 804ab39:	e6 ff                	out    %al,$0xff
 804ab3b:	ff 20                	jmp    *(%eax)
 804ab3d:	01 00                	add    %eax,(%eax)
 804ab3f:	00 00                	add    %al,(%eax)
 804ab41:	41                   	inc    %ecx
 804ab42:	0e                   	push   %cs
 804ab43:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804ab49:	48                   	dec    %eax
 804ab4a:	86 03                	xchg   %al,(%ebx)
 804ab4c:	83 04 03 12          	addl   $0x12,(%ebx,%eax,1)
 804ab50:	01 c3                	add    %eax,%ebx
 804ab52:	41                   	inc    %ecx
 804ab53:	c6 41 c5 0c          	movb   $0xc,-0x3b(%ecx)
 804ab57:	04 04                	add    $0x4,%al
 804ab59:	00 00                	add    %al,(%eax)
 804ab5b:	00 28                	add    %ch,(%eax)
 804ab5d:	00 00                	add    %al,(%eax)
 804ab5f:	00 78 02             	add    %bh,0x2(%eax)
 804ab62:	00 00                	add    %al,(%eax)
 804ab64:	e0 e7                	loopne 804ab4d <trans_char+0x71d>
 804ab66:	ff                   	(bad)  
 804ab67:	ff 46 01             	incl   0x1(%esi)
 804ab6a:	00 00                	add    %al,(%eax)
 804ab6c:	00 41 0e             	add    %al,0xe(%ecx)
 804ab6f:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804ab75:	4c                   	dec    %esp
 804ab76:	83 04 87 03          	addl   $0x3,(%edi,%eax,4)
 804ab7a:	03 35 01 c7 c3 0d    	add    0xdc3c701,%esi
 804ab80:	04 41                	add    $0x41,%al
 804ab82:	c5 0e                	lds    (%esi),%ecx
 804ab84:	04 00                	add    $0x0,%al
 804ab86:	00 00                	add    %al,(%eax)
 804ab88:	28 00                	sub    %al,(%eax)
 804ab8a:	00 00                	add    %al,(%eax)
 804ab8c:	a4                   	movsb  %ds:(%esi),%es:(%edi)
 804ab8d:	02 00                	add    (%eax),%al
 804ab8f:	00 00                	add    %al,(%eax)
 804ab91:	e9 ff ff 0a 01       	jmp    90fab95 <_end+0x10add31>
 804ab96:	00 00                	add    %al,(%eax)
 804ab98:	00 41 0e             	add    %al,0xe(%ecx)
 804ab9b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804aba1:	46                   	inc    %esi
 804aba2:	87 03                	xchg   %eax,(%ebx)
 804aba4:	86 04 83             	xchg   %al,(%ebx,%eax,4)
 804aba7:	05 02 fd c3 41       	add    $0x41c3fd02,%eax
 804abac:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
 804abb0:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804abb3:	04 18                	add    $0x18,%al
 804abb5:	00 00                	add    %al,(%eax)
 804abb7:	00 d0                	add    %dl,%al
 804abb9:	02 00                	add    (%eax),%al
 804abbb:	00 de                	add    %bl,%dh
 804abbd:	e9 ff ff 26 00       	jmp    82babc1 <_end+0x26dd5d>
 804abc2:	00 00                	add    %al,(%eax)
 804abc4:	00 41 0e             	add    %al,0xe(%ecx)
 804abc7:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804abcd:	00 00                	add    %al,(%eax)
 804abcf:	00 2c 00             	add    %ch,(%eax,%eax,1)
 804abd2:	00 00                	add    %al,(%eax)
 804abd4:	ec                   	in     (%dx),%al
 804abd5:	02 00                	add    (%eax),%al
 804abd7:	00 e8                	add    %ch,%al
 804abd9:	e9 ff ff 52 07       	jmp    f57abdd <_end+0x752dd79>
 804abde:	00 00                	add    %al,(%eax)
 804abe0:	00 41 0e             	add    %al,0xe(%ecx)
 804abe3:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804abe9:	49                   	dec    %ecx
 804abea:	87 03                	xchg   %eax,(%ebx)
 804abec:	86 04 83             	xchg   %al,(%ebx,%eax,4)
 804abef:	05 03 42 07 c3       	add    $0xc3074203,%eax
 804abf4:	41                   	inc    %ecx
 804abf5:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
 804abf9:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804abfc:	04 00                	add    $0x0,%al
 804abfe:	00 00                	add    %al,(%eax)
 804ac00:	20 00                	and    %al,(%eax)
 804ac02:	00 00                	add    %al,(%eax)
 804ac04:	1c 03                	sbb    $0x3,%al
 804ac06:	00 00                	add    %al,(%eax)
 804ac08:	0a f1                	or     %cl,%dh
 804ac0a:	ff                   	(bad)  
 804ac0b:	ff                   	(bad)  
 804ac0c:	39 00                	cmp    %eax,(%eax)
 804ac0e:	00 00                	add    %al,(%eax)
 804ac10:	00 41 0e             	add    %al,0xe(%ecx)
 804ac13:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804ac19:	44                   	inc    %esp
 804ac1a:	83 03 70             	addl   $0x70,(%ebx)
 804ac1d:	c3                   	ret    
 804ac1e:	41                   	inc    %ecx
 804ac1f:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804ac22:	04 00                	add    $0x0,%al
 804ac24:	2c 00                	sub    $0x0,%al
 804ac26:	00 00                	add    %al,(%eax)
 804ac28:	40                   	inc    %eax
 804ac29:	03 00                	add    (%eax),%eax
 804ac2b:	00 1f                	add    %bl,(%edi)
 804ac2d:	f1                   	icebp  
 804ac2e:	ff                   	(bad)  
 804ac2f:	ff 9d 01 00 00 00    	lcall  *0x1(%ebp)
 804ac35:	41                   	inc    %ecx
 804ac36:	0e                   	push   %cs
 804ac37:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804ac3d:	46                   	inc    %esi
 804ac3e:	87 03                	xchg   %eax,(%ebx)
 804ac40:	86 04 83             	xchg   %al,(%ebx,%eax,4)
 804ac43:	05 03 90 01 c3       	add    $0xc3019003,%eax
 804ac48:	41                   	inc    %ecx
 804ac49:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
 804ac4d:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804ac50:	04 00                	add    $0x0,%al
 804ac52:	00 00                	add    %al,(%eax)
 804ac54:	20 00                	and    %al,(%eax)
 804ac56:	00 00                	add    %al,(%eax)
 804ac58:	70 03                	jo     804ac5d <trans_char+0x82d>
 804ac5a:	00 00                	add    %al,(%eax)
 804ac5c:	8c f2                	mov    %?,%edx
 804ac5e:	ff                   	(bad)  
 804ac5f:	ff 88 00 00 00 00    	decl   0x0(%eax)
 804ac65:	41                   	inc    %ecx
 804ac66:	0e                   	push   %cs
 804ac67:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804ac6d:	44                   	inc    %esp
 804ac6e:	83 03 02             	addl   $0x2,(%ebx)
 804ac71:	7f c3                	jg     804ac36 <trans_char+0x806>
 804ac73:	41                   	inc    %ecx
 804ac74:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804ac77:	04 1c                	add    $0x1c,%al
 804ac79:	00 00                	add    %al,(%eax)
 804ac7b:	00 94 03 00 00 f0 f2 	add    %dl,-0xd100000(%ebx,%eax,1)
 804ac82:	ff                   	(bad)  
 804ac83:	ff 2d 00 00 00 00    	ljmp   *0x0
 804ac89:	41                   	inc    %ecx
 804ac8a:	0e                   	push   %cs
 804ac8b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804ac91:	69 c5 0c 04 04 00    	imul   $0x4040c,%ebp,%eax
 804ac97:	00 1c 00             	add    %bl,(%eax,%eax,1)
 804ac9a:	00 00                	add    %al,(%eax)
 804ac9c:	b4 03                	mov    $0x3,%ah
 804ac9e:	00 00                	add    %al,(%eax)
 804aca0:	fd                   	std    
 804aca1:	f2 ff                	repnz (bad) 
 804aca3:	ff 4d 00             	decl   0x0(%ebp)
 804aca6:	00 00                	add    %al,(%eax)
 804aca8:	00 41 0e             	add    %al,0xe(%ecx)
 804acab:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804acb1:	02 49 c5             	add    -0x3b(%ecx),%cl
 804acb4:	0c 04                	or     $0x4,%al
 804acb6:	04 00                	add    $0x0,%al
 804acb8:	20 00                	and    %al,(%eax)
 804acba:	00 00                	add    %al,(%eax)
 804acbc:	d4 03                	aam    $0x3
 804acbe:	00 00                	add    %al,(%eax)
 804acc0:	2a f3                	sub    %bl,%dh
 804acc2:	ff                   	(bad)  
 804acc3:	ff 35 00 00 00 00    	pushl  0x0
 804acc9:	41                   	inc    %ecx
 804acca:	0e                   	push   %cs
 804accb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
 804acd1:	44                   	inc    %esp
 804acd2:	83 03 6c             	addl   $0x6c,(%ebx)
 804acd5:	c3                   	ret    
 804acd6:	41                   	inc    %ecx
 804acd7:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
 804acda:	04 00                	add    $0x0,%al

0804acdc <__FRAME_END__>:
 804acdc:	00 00                	add    %al,(%eax)
	...

Disassembly of section .init_array:

0804b000 <__frame_dummy_init_array_entry>:
 804b000:	90                   	nop
 804b001:	8b 04 08             	mov    (%eax,%ecx,1),%eax

Disassembly of section .fini_array:

0804b004 <__do_global_dtors_aux_fini_array_entry>:
 804b004:	70 8b                	jo     804af91 <__FRAME_END__+0x2b5>
 804b006:	04 08                	add    $0x8,%al

Disassembly of section .jcr:

0804b008 <__JCR_END__>:
 804b008:	00 00                	add    %al,(%eax)
	...

Disassembly of section .dynamic:

0804b00c <_DYNAMIC>:
 804b00c:	01 00                	add    %eax,(%eax)
 804b00e:	00 00                	add    %al,(%eax)
 804b010:	10 00                	adc    %al,(%eax)
 804b012:	00 00                	add    %al,(%eax)
 804b014:	0c 00                	or     $0x0,%al
 804b016:	00 00                	add    %al,(%eax)
 804b018:	78 88                	js     804afa2 <__FRAME_END__+0x2c6>
 804b01a:	04 08                	add    $0x8,%al
 804b01c:	0d 00 00 00 90       	or     $0x90000000,%eax
 804b021:	a0 04 08 19 00       	mov    0x190804,%al
 804b026:	00 00                	add    %al,(%eax)
 804b028:	00 b0 04 08 1b 00    	add    %dh,0x1b0804(%eax)
 804b02e:	00 00                	add    %al,(%eax)
 804b030:	04 00                	add    $0x0,%al
 804b032:	00 00                	add    %al,(%eax)
 804b034:	1a 00                	sbb    (%eax),%al
 804b036:	00 00                	add    %al,(%eax)
 804b038:	04 b0                	add    $0xb0,%al
 804b03a:	04 08                	add    $0x8,%al
 804b03c:	1c 00                	sbb    $0x0,%al
 804b03e:	00 00                	add    %al,(%eax)
 804b040:	04 00                	add    $0x0,%al
 804b042:	00 00                	add    %al,(%eax)
 804b044:	04 00                	add    $0x0,%al
 804b046:	00 00                	add    %al,(%eax)
 804b048:	ac                   	lods   %ds:(%esi),%al
 804b049:	81 04 08 f5 fe ff 6f 	addl   $0x6ffffef5,(%eax,%ecx,1)
 804b050:	e4 82                	in     $0x82,%al
 804b052:	04 08                	add    $0x8,%al
 804b054:	05 00 00 00 84       	add    $0x84000000,%eax
 804b059:	85 04 08             	test   %eax,(%eax,%ecx,1)
 804b05c:	06                   	push   %es
 804b05d:	00 00                	add    %al,(%eax)
 804b05f:	00 14 83             	add    %dl,(%ebx,%eax,4)
 804b062:	04 08                	add    $0x8,%al
 804b064:	0a 00                	or     (%eax),%al
 804b066:	00 00                	add    %al,(%eax)
 804b068:	45                   	inc    %ebp
 804b069:	01 00                	add    %eax,(%eax)
 804b06b:	00 0b                	add    %cl,(%ebx)
 804b06d:	00 00                	add    %al,(%eax)
 804b06f:	00 10                	add    %dl,(%eax)
 804b071:	00 00                	add    %al,(%eax)
 804b073:	00 15 00 00 00 00    	add    %dl,0x0
 804b079:	00 00                	add    %al,(%eax)
 804b07b:	00 03                	add    %al,(%ebx)
 804b07d:	00 00                	add    %al,(%eax)
 804b07f:	00 00                	add    %al,(%eax)
 804b081:	b1 04                	mov    $0x4,%cl
 804b083:	08 02                	or     %al,(%edx)
 804b085:	00 00                	add    %al,(%eax)
 804b087:	00 10                	add    %dl,(%eax)
 804b089:	01 00                	add    %eax,(%eax)
 804b08b:	00 14 00             	add    %dl,(%eax,%eax,1)
 804b08e:	00 00                	add    %al,(%eax)
 804b090:	11 00                	adc    %eax,(%eax)
 804b092:	00 00                	add    %al,(%eax)
 804b094:	17                   	pop    %ss
 804b095:	00 00                	add    %al,(%eax)
 804b097:	00 68 87             	add    %ch,-0x79(%eax)
 804b09a:	04 08                	add    $0x8,%al
 804b09c:	11 00                	adc    %eax,(%eax)
 804b09e:	00 00                	add    %al,(%eax)
 804b0a0:	48                   	dec    %eax
 804b0a1:	87 04 08             	xchg   %eax,(%eax,%ecx,1)
 804b0a4:	12 00                	adc    (%eax),%al
 804b0a6:	00 00                	add    %al,(%eax)
 804b0a8:	20 00                	and    %al,(%eax)
 804b0aa:	00 00                	add    %al,(%eax)
 804b0ac:	13 00                	adc    (%eax),%eax
 804b0ae:	00 00                	add    %al,(%eax)
 804b0b0:	08 00                	or     %al,(%eax)
 804b0b2:	00 00                	add    %al,(%eax)
 804b0b4:	fe                   	(bad)  
 804b0b5:	ff                   	(bad)  
 804b0b6:	ff 6f 18             	ljmp   *0x18(%edi)
 804b0b9:	87 04 08             	xchg   %eax,(%eax,%ecx,1)
 804b0bc:	ff                   	(bad)  
 804b0bd:	ff                   	(bad)  
 804b0be:	ff 6f 01             	ljmp   *0x1(%edi)
 804b0c1:	00 00                	add    %al,(%eax)
 804b0c3:	00 f0                	add    %dh,%al
 804b0c5:	ff                   	(bad)  
 804b0c6:	ff 6f ca             	ljmp   *-0x36(%edi)
 804b0c9:	86 04 08             	xchg   %al,(%eax,%ecx,1)
	...

Disassembly of section .got:

0804b0fc <.got>:
 804b0fc:	00 00                	add    %al,(%eax)
	...

Disassembly of section .got.plt:

0804b100 <_GLOBAL_OFFSET_TABLE_>:
 804b100:	0c b0                	or     $0xb0,%al
 804b102:	04 08                	add    $0x8,%al
	...
 804b10c:	b6 88                	mov    $0x88,%dh
 804b10e:	04 08                	add    $0x8,%al
 804b110:	c6                   	(bad)  
 804b111:	88 04 08             	mov    %al,(%eax,%ecx,1)
 804b114:	d6                   	(bad)  
 804b115:	88 04 08             	mov    %al,(%eax,%ecx,1)
 804b118:	e6 88                	out    %al,$0x88
 804b11a:	04 08                	add    $0x8,%al
 804b11c:	f6                   	(bad)  
 804b11d:	88 04 08             	mov    %al,(%eax,%ecx,1)
 804b120:	06                   	push   %es
 804b121:	89 04 08             	mov    %eax,(%eax,%ecx,1)
 804b124:	16                   	push   %ss
 804b125:	89 04 08             	mov    %eax,(%eax,%ecx,1)
 804b128:	26 89 04 08          	mov    %eax,%es:(%eax,%ecx,1)
 804b12c:	36 89 04 08          	mov    %eax,%ss:(%eax,%ecx,1)
 804b130:	46                   	inc    %esi
 804b131:	89 04 08             	mov    %eax,(%eax,%ecx,1)
 804b134:	56                   	push   %esi
 804b135:	89 04 08             	mov    %eax,(%eax,%ecx,1)
 804b138:	66 89 04 08          	mov    %ax,(%eax,%ecx,1)
 804b13c:	76 89                	jbe    804b0c7 <_DYNAMIC+0xbb>
 804b13e:	04 08                	add    $0x8,%al
 804b140:	86 89 04 08 96 89    	xchg   %cl,-0x7669f7fc(%ecx)
 804b146:	04 08                	add    $0x8,%al
 804b148:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
 804b149:	89 04 08             	mov    %eax,(%eax,%ecx,1)
 804b14c:	b6 89                	mov    $0x89,%dh
 804b14e:	04 08                	add    $0x8,%al
 804b150:	c6                   	(bad)  
 804b151:	89 04 08             	mov    %eax,(%eax,%ecx,1)
 804b154:	d6                   	(bad)  
 804b155:	89 04 08             	mov    %eax,(%eax,%ecx,1)
 804b158:	e6 89                	out    %al,$0x89
 804b15a:	04 08                	add    $0x8,%al
 804b15c:	f6                   	(bad)  
 804b15d:	89 04 08             	mov    %eax,(%eax,%ecx,1)
 804b160:	06                   	push   %es
 804b161:	8a 04 08             	mov    (%eax,%ecx,1),%al
 804b164:	16                   	push   %ss
 804b165:	8a 04 08             	mov    (%eax,%ecx,1),%al
 804b168:	26 8a 04 08          	mov    %es:(%eax,%ecx,1),%al
 804b16c:	36 8a 04 08          	mov    %ss:(%eax,%ecx,1),%al
 804b170:	46                   	inc    %esi
 804b171:	8a 04 08             	mov    (%eax,%ecx,1),%al
 804b174:	56                   	push   %esi
 804b175:	8a 04 08             	mov    (%eax,%ecx,1),%al
 804b178:	66 8a 04 08          	data16 mov (%eax,%ecx,1),%al
 804b17c:	76 8a                	jbe    804b108 <_GLOBAL_OFFSET_TABLE_+0x8>
 804b17e:	04 08                	add    $0x8,%al
 804b180:	86 8a 04 08 96 8a    	xchg   %cl,-0x7569f7fc(%edx)
 804b186:	04 08                	add    $0x8,%al
 804b188:	a6                   	cmpsb  %es:(%edi),%ds:(%esi)
 804b189:	8a 04 08             	mov    (%eax,%ecx,1),%al
 804b18c:	b6 8a                	mov    $0x8a,%dh
 804b18e:	04 08                	add    $0x8,%al
 804b190:	c6                   	(bad)  
 804b191:	8a 04 08             	mov    (%eax,%ecx,1),%al

Disassembly of section .data:

0804b1a0 <__data_start>:
 804b1a0:	00 00                	add    %al,(%eax)
	...

0804b1a4 <__dso_handle>:
	...

0804b1c0 <host_table>:
 804b1c0:	e7 a5                	out    %eax,$0xa5
 804b1c2:	04 08                	add    $0x8,%al
 804b1c4:	ff a5 04 08 19 a6    	jmp    *-0x59e6f7fc(%ebp)
 804b1ca:	04 08                	add    $0x8,%al
 804b1cc:	33 a6 04 08 00 00    	xor    0x804(%esi),%esp
	...

0804c1c0 <level_counts>:
 804c1c0:	01 00                	add    %eax,(%eax)
 804c1c2:	00 00                	add    %al,(%eax)
 804c1c4:	01 00                	add    %eax,(%eax)
 804c1c6:	00 00                	add    %al,(%eax)
 804c1c8:	01 00                	add    %eax,(%eax)
 804c1ca:	00 00                	add    %al,(%eax)
 804c1cc:	01 00                	add    %eax,(%eax)
 804c1ce:	00 00                	add    %al,(%eax)
 804c1d0:	05                   	.byte 0x5
 804c1d1:	00 00                	add    %al,(%eax)
	...

Disassembly of section .bss:

0804c1e0 <stderr@@GLIBC_2.0>:
 804c1e0:	00 00                	add    %al,(%eax)
	...

0804c1e4 <stdin@@GLIBC_2.0>:
	...

0804c200 <optarg@@GLIBC_2.0>:
 804c200:	00 00                	add    %al,(%eax)
	...

0804c204 <completed.5730>:
 804c204:	00 00                	add    %al,(%eax)
	...

0804c208 <global_save_stack>:
 804c208:	00 00                	add    %al,(%eax)
	...

0804c20c <global_offset>:
 804c20c:	00 00                	add    %al,(%eax)
	...

0804c210 <global_nitro>:
 804c210:	00 00                	add    %al,(%eax)
	...

0804c214 <gets_cnt>:
 804c214:	00 00                	add    %al,(%eax)
	...

0804c218 <global_value>:
 804c218:	00 00                	add    %al,(%eax)
	...

0804c21c <success>:
 804c21c:	00 00                	add    %al,(%eax)
	...

0804c220 <cookie>:
 804c220:	00 00                	add    %al,(%eax)
	...

0804c224 <infile>:
 804c224:	00 00                	add    %al,(%eax)
	...

0804c228 <autograde>:
 804c228:	00 00                	add    %al,(%eax)
	...

0804c22c <notify>:
 804c22c:	00 00                	add    %al,(%eax)
	...

0804c230 <userid>:
	...

0804c240 <stack_top>:
	...

0804c260 <gets_buf>:
	...

Disassembly of section .comment:

00000000 <.comment>:
   0:	47                   	inc    %edi
   1:	43                   	inc    %ebx
   2:	43                   	inc    %ebx
   3:	3a 20                	cmp    (%eax),%ah
   5:	28 44 65 62          	sub    %al,0x62(%ebp,%eiz,2)
   9:	69 61 6e 20 34 2e 37 	imul   $0x372e3420,0x6e(%ecx),%esp
  10:	2e 32 2d 35 29 20 34 	xor    %cs:0x34202935,%ch
  17:	2e 37                	cs aaa 
  19:	2e 32 00             	xor    %cs:(%eax),%al
  1c:	47                   	inc    %edi
  1d:	43                   	inc    %ebx
  1e:	43                   	inc    %ebx
  1f:	3a 20                	cmp    (%eax),%ah
  21:	28 44 65 62          	sub    %al,0x62(%ebp,%eiz,2)
  25:	69 61 6e 20 34 2e 34 	imul   $0x342e3420,0x6e(%ecx),%esp
  2c:	2e 37                	cs aaa 
  2e:	2d 32 29 20 34       	sub    $0x34202932,%eax
  33:	2e 34 2e             	cs xor $0x2e,%al
  36:	37                   	aaa    
	...
