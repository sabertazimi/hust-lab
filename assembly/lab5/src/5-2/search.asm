.386
.model  flat, c
.code
public search
search  proc    table:dword, num:dword, target:dword
	push	ebx
	push	ecx
	push	edx
        push    esi
        push    edi
        mov     esi, target
        mov     edi, table
	xor	ebx, ebx
	xor	ecx, ecx
search_loop:
	cmp	ecx, num
	jge	search_finish		; 所有学生名字都和输入不同,ecx > num
	xor	eax, eax
search_inner:
	cmp	eax, 10
	jge	search_finish		; 所有字符都相同
	mov	dl, ss:[esi + eax]
	cmp	ss:[edi + ebx], dl
	jnz	search_next
	cmp	dl, 0			; 已比较至空字符
	jz	search_finish		; 所有字符都相同
	inc	eax
	inc	ebx
	jmp	search_inner
search_next:
	inc	ecx
	imul	ebx, ecx, 28
	jmp	search_loop
search_finish:
	mov	eax, ecx		; 返回下标
	pop	edi
	pop	esi
	pop	edx
	pop	ecx
	pop	ebx
	ret
search  endp
        end