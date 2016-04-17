.386
.model	flat, stdcall
option	casemap :none   ; case sensitive

include	\masm32\include\windows.inc
include	\masm32\include\user32.inc
include	\masm32\include\kernel32.inc
includelib	\masm32\lib\user32.lib
includelib	\masm32\lib\kernel32.lib
include 	\masm32\macros\macros.asm

WndProc		PROTO  :DWORD,:DWORD,:DWORD,:DWORD
Check	PROTO  :DWORD

IDC_CHECK 		equ	1003

.data
szBuffer db 256 dup(?)
.data?
hInstance		dd		?	;dd can be written as dword


.code
start:
	invoke	GetModuleHandle, NULL
	mov	hInstance, eax
	invoke	DialogBoxParam, hInstance, 101, 0, ADDR WndProc, 0
	invoke	ExitProcess, eax
; -----------------------------------------------------------------------
WndProc	proc	hWin	:DWORD,
		uMsg	:DWORD,
		wParam	:DWORD,
		lParam	:DWORD

	.if	uMsg == WM_COMMAND
		.if	wParam == IDC_CHECK
; -----------------------------------------------------------------------
;			TODO
; -----------------------------------------------------------------------
		invoke GetDlgItemText,hWin,1001,addr szBuffer,sizeof szBuffer
		invoke Check,addr szBuffer
		.endif
	.endif
		ret
WndProc	endp

Check	proc	txtSerial:DWORD
	invoke lstrlen, txtSerial
	cmp eax, 4
	jnz nmatch
	cmp szBuffer[0], 'Q'
	jnz nmatch
	cmp szBuffer[1], 'U'
	jnz nmatch
	cmp szBuffer[2], 'I'
	jnz nmatch
	cmp szBuffer[3], 'T'
	jnz nmatch
	invoke	ExitProcess, eax
nmatch:	
	ret

Check endp

	end start

