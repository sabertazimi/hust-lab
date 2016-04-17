.386
.model	flat, c
.code
public cal
cal	proc	table: dword, num: dword
	push    eax
	push    ebx
	push    ecx
	push    edx
	push    esi
	push	edi
	mov	edi, table
	xor	ebx, ebx
	xor	ecx, ecx
cal_loop:
	cmp     ecx, num
	jge     cal_finish
	mov     eax, ss:[edi + ebx + 12]    ; chinese
	mov     edx, ss:[edi + ebx + 16]	; math
	lea     eax, [edx + eax * 2]    ; (eax) = chinese * 2 + math
	mov     edx, ss:[edi + ebx + 20]	; english
	lea     esi, [edx + eax *2]     ; (esi) = (chinese * 2 + math) * 2 + english
	mov     eax, 92492493h          ; (esi) / 7
	imul    esi
	add     edx, esi
	sar     edx, 2
	mov     eax, edx
	shr     eax, 1fh
	add     edx, eax
	and	edx, 0ffh
	mov     ss:[edi + ebx + 24], edx     ; avg = sum / 3.5
	add	ebx, 28
	inc     ecx
	jmp	cal_loop
cal_finish:
	pop	edi
	pop     esi   
	pop     edx
	pop     ecx
	pop     ebx
	pop     eax
	ret
cal	endp
	end