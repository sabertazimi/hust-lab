	.data
	.align 2
_Main:
	.long 0
	.long _STRING0
	.long main



	.text
	.global main
main:
	pushl %ebp
	movl %esp, %ebp
	pushl $4000       # 4000/4 = 1000 fake registers
	call malloc
	movl %eax, %esi   # store registers base into %esi
	movl $4, %edi
	movl $233, %eax
	movl %eax, (%esi, %edi, 4)
	movl $4, %edi
	movl (%esi, %edi, 4), %eax
	movl $1, %edi
	movl %eax, (%esi, %edi, 4)
	movl $5, %edi
	movl $0, %eax
	movl %eax, (%esi, %edi, 4)
	movl $5, %edi
	movl (%esi, %edi, 4), %eax
	movl $2, %edi
	movl %eax, (%esi, %edi, 4)
	movl $6, %edi
	leal _STRING1, %eax
	movl %eax, (%esi, %edi, 4)
	movl $6, %edi
	movl (%esi, %edi, 4), %eax
	movl $3, %edi
	movl %eax, (%esi, %edi, 4)
	movl $1, %edi
	movl (%esi, %edi, 4), %eax
	pushl %eax
	call _PrintInt
	movl $2, %edi
	movl (%esi, %edi, 4), %eax
	pushl %eax
	call _PrintBool
	movl $3, %edi
	movl (%esi, %edi, 4), %eax
	pushl %eax
	call _PrintString
	movl $7, %edi
	leal _STRING2, %eax
	movl %eax, (%esi, %edi, 4)
	movl $7, %edi
	movl (%esi, %edi, 4), %eax
	pushl %eax
	call _PrintString
	call _ReadInteger
	movl $8, %edi
	movl %eax, (%esi, %edi, 4)
	movl $8, %edi
	movl (%esi, %edi, 4), %eax
	movl $1, %edi
	movl %eax, (%esi, %edi, 4)
	movl $9, %edi
	movl $1, %eax
	movl %eax, (%esi, %edi, 4)
	movl $9, %edi
	movl (%esi, %edi, 4), %eax
	movl $2, %edi
	movl %eax, (%esi, %edi, 4)
	movl $10, %edi
	leal _STRING3, %eax
	movl %eax, (%esi, %edi, 4)
	movl $10, %edi
	movl (%esi, %edi, 4), %eax
	pushl %eax
	call _PrintString
	call _ReadLine
	movl $11, %edi
	movl %eax, (%esi, %edi, 4)
	movl $11, %edi
	movl (%esi, %edi, 4), %eax
	movl $3, %edi
	movl %eax, (%esi, %edi, 4)
	movl $1, %edi
	movl (%esi, %edi, 4), %eax
	pushl %eax
	call _PrintInt
	movl $2, %edi
	movl (%esi, %edi, 4), %eax
	pushl %eax
	call _PrintBool
	movl $3, %edi
	movl (%esi, %edi, 4), %eax
	pushl %eax
	call _PrintString
	leave
	pushl $0
	call exit


	.data
_STRING1:
	.string "Hello, DragonLang!"
_STRING0:
	.string "Main"
_STRING2:
	.string "Please input a number:"
_STRING3:
	.string "Please input a string:"
intFormat:
	.string "%d\n"
trues:
	.string "true\n"
falses:
	.string "false\n"
stringFormat:
	.string "%s\n"
readBuf:
	.string "00000000000000000000000000000000000000000000000000\0"
readFormat:
	.string "%s"

	.text
	.global _ReadInteger
_ReadInteger:
	pushl %ebp
	movl %esp, %ebp
	leal readBuf, %eax
	pushl %eax
	pushl $readFormat
	call scanf
	popl %ebx
	popl %ebx
	leal readBuf, %eax
	pushl %eax
	call atoi
	popl %ebx
	popl %ebx
	leave
	ret
	.global _ReadLine
_ReadLine:
	pushl %ebp
	movl %esp, %ebp
	leal readBuf, %eax
	pushl %eax
	pushl $readFormat
	call scanf
	popl %ebx
	popl %ebx
	leal readBuf, %eax
	leave
	ret
	.global _PrintInt
_PrintInt:
	pushl %ebp
	movl %esp, %ebp
	pushl 8(%ebp)
	pushl $intFormat
	call printf
	popl %eax
	popl %eax
	leave
	ret
	.global _PrintBool
_PrintBool:
	pushl %ebp
	movl %esp, %ebp
	xorl %eax, %eax
	cmpl 8(%ebp), %eax
	je .L_f
	pushl $trues
	jmp .L_e
.L_f:
	pushl $falses
.L_e:
	call printf
	leave
	ret
	.global _PrintString
_PrintString:
	pushl %ebp
	movl %esp, %ebp
	pushl 8(%ebp)
	pushl $stringFormat
	call printf
	popl %eax
	popl %eax
	leave
	ret
