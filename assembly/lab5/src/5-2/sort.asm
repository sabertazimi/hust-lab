.386
.model flat, c
.code
public sort
sort	proc	table:dword, num:dword
	push    eax
	push    ebx
	push    ecx
	push    edx
	push    esi
	push    edi
	mov	edx, table
	xor     ebx, ebx
	xor     ecx, ecx
	xor     eax, eax
sort_outer:
	cmp     eax, num
	jge     sort_finish
	imul    esi, eax, 28
	mov     ebx, ss:[edx + esi + 24]	; avg[i]
	lea     ecx, [eax + 1]
sort_inner:
	cmp     ecx, num
	jge     sort_outer_next
	imul    edi, ecx, 28
	cmp	ss:[edx + edi + 24], ebx	; avg[j] > avg[i]
	jl      sort_inner_next
	; ½»»»
	push	eax
	push    ecx
	push    edx
	push	esi
	push	edi
	mov	eax, table
	xor     ecx, ecx
	exchange_loop:
	mov     dl, ss:[eax + esi]
	xchg    dl, ss:[eax + edi]
	mov     ss:[eax + esi], dl
	inc     ecx
	inc	esi
	inc	edi
	cmp     ecx, 1ch
	jne     exchange_loop
	pop	edi
	pop	esi
	pop	edx
	pop     ecx
	pop	eax
	; ½»»»
sort_inner_next:
	inc	ecx
	jmp     sort_inner
sort_outer_next:
	inc     eax
	jmp     sort_outer
sort_finish:
	pop     edi
	pop     esi
	pop     edx
	pop     ecx
	pop     ebx
	pop     eax
	ret
sort	endp
	end