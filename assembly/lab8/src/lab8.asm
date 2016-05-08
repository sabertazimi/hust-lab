.386
.model   flat,stdcall
option   casemap:none

WinMain  proto :DWORD,:DWORD,:DWORD,:DWORD
WndProc  proto :DWORD,:DWORD,:DWORD,:DWORD
Display  proto :DWORD,:DWORD
Average	 proto :DWORD
Radix	 proto :DWORD

include      lab8.inc

include      windows.inc
include      user32.inc
include      kernel32.inc
include      gdi32.inc
include      shell32.inc

includelib   user32.lib
includelib   kernel32.lib
includelib   gdi32.lib
includelib   shell32.lib

student	     struct
	     stuname   db  10 dup(0)
	     chinese  db  0
	     math     db  0
	     english  db  0
	     average  db  0
	     stugrade    db  0
student      ends

.data
ClassName    db       'TryWinClass',0
AppName      db       'Grade System',0
MenuName     db       'MyMenu',0
DlgName	     db       'MyDialog',0
AboutMsg     db       'CS1409 U201414800 Yilong Liu',0
hInstance    dd       0
CommandLine  dd       0
buf	     student  <' saber',12,34,56,0,'S'>
	     student  <'lancer',78,90,12,0,'S'>
	     student  <'archer',34,56,78,0, 'S'>
	     student  <' liuyl',90,12,34,0, 'S'>
msg_name     db       'name',0
msg_chinese  db       'chinese',0
msg_math     db       'math',0
msg_english  db       'english',0
msg_average  db       'average',0
msg_grade    db       'grade',0
chinese	     db       '00'
math	     db       '00'
english	     db       '00'
average	     db       '00'
stugrade     db	      'S'
hasText      db       0

.code
Start:	     invoke GetModuleHandle,NULL
	     mov    hInstance,eax
	     invoke GetCommandLine
	     mov    CommandLine,eax
	     invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	     invoke ExitProcess,eax
	     ;;
WinMain      proc   hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
	     LOCAL  wc:WNDCLASSEX
	     LOCAL  msg:MSG
	     LOCAL  hWnd:HWND
             invoke RtlZeroMemory,addr wc,sizeof wc
	     mov    wc.cbSize,SIZEOF WNDCLASSEX
	     mov    wc.style, CS_HREDRAW or CS_VREDRAW
	     mov    wc.lpfnWndProc, offset WndProc
	     mov    wc.cbClsExtra,NULL
	     mov    wc.cbWndExtra,NULL
	     push   hInst
	     pop    wc.hInstance
	     mov    wc.hbrBackground,COLOR_WINDOW+1
	     mov    wc.lpszMenuName, offset MenuName
	     mov    wc.lpszClassName,offset ClassName
	     invoke LoadIcon,NULL,IDI_APPLICATION
	     mov    wc.hIcon,eax
	     mov    wc.hIconSm,0
	     invoke LoadCursor,NULL,IDC_ARROW
	     mov    wc.hCursor,eax
	     invoke RegisterClassEx, addr wc
	     INVOKE CreateWindowEx,NULL,addr ClassName,addr AppName,\
                    WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
                    CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\
                    hInst,NULL
	     mov    hWnd,eax
	     INVOKE ShowWindow,hWnd,SW_SHOWNORMAL
	     INVOKE UpdateWindow,hWnd
	     ;;
MsgLoop:     INVOKE GetMessage,addr msg,NULL,0,0
             cmp    EAX,0
             je     ExitLoop
             INVOKE TranslateMessage,addr msg
             INVOKE DispatchMessage,addr msg
	     jmp    MsgLoop
ExitLoop:    mov    eax,msg.wParam
	     ret
WinMain      endp

WndProc      proc   hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	     LOCAL  hdc:HDC
     .IF     uMsg == WM_DESTROY
	     invoke PostQuitMessage,NULL
     .ELSEIF uMsg == WM_KEYDOWN
	    .IF     wParam == VK_F1
		    invoke MessageBox,hWnd,addr AboutMsg,addr AppName,0
	    .ENDIF
     .ELSEIF uMsg == WM_COMMAND
	    .IF     wParam == IDM_FILE_EXIT
		    invoke SendMessage,hWnd,WM_CLOSE,0,0
	    .ELSEIF wParam == IDM_ACT_AVG
		    invoke Average, 4
		    mov hasText, 0
	    .ELSEIF wParam == IDM_ACT_LIST
		    invoke Display,hWnd,4
		    mov hasText, 1
	    .ELSEIF wParam == IDM_HELP_ABOUT
		    invoke MessageBox,hWnd,addr AboutMsg,addr AppName,0
	    .ENDIF
     .ELSEIF uMsg == WM_MOVE || uMsg == WM_SETFOCUS || uMsg ==WM_SIZING || uMsg == WM_LBUTTONDOWN
	     ;; redraw window again
	     .IF hasText != 0
	         invoke Display, hWnd, 4
	     .ENDIF
     .ELSE
             invoke DefWindowProc,hWnd,uMsg,wParam,lParam
             ret
     .ENDIF
  	     xor    eax,eax
	     ret
WndProc      endp

; eax/ebx/esi: call radix
; edx: caculate position
; edi: get nth student address
Display      proc   hWnd:DWORD,number:DWORD
             XX     equ  10
             YY     equ  10
	     XX_GAP equ  100
	     YY_GAP equ  30
             LOCAL  hdc:HDC
		;; get window handle
	     push   eax
	     push   ebx
	     push   ecx
	     push   edx
	     push   esi
	     push   edi

             invoke GetDC,hWnd
             mov    hdc,eax
		;; draw pre-grade-list
             invoke TextOut,hdc,XX+0*XX_GAP,YY+0*YY_GAP,offset msg_name,4
             invoke TextOut,hdc,XX+1*XX_GAP,YY+0*YY_GAP,offset msg_chinese,7
             invoke TextOut,hdc,XX+2*XX_GAP,YY+0*YY_GAP,offset msg_math,4
             invoke TextOut,hdc,XX+3*XX_GAP,YY+0*YY_GAP,offset msg_english,7
             invoke TextOut,hdc,XX+4*XX_GAP,YY+0*YY_GAP,offset msg_average,7
             invoke TextOut,hdc,XX+5*XX_GAP,YY+0*YY_GAP,offset msg_grade,5
             ;; draw grade list
	     xor    ecx, ecx
display_loop:
	     cmp     ecx, number
             jge     display_finish 
		;; get nth student address
	     imul    ebx, ecx, 15
		;; calculate position
	     lea     edx, [ecx+1]
	     imul    edx, YY_GAP
	     add     edx, YY
	     lea     eax, buf
	     add     eax, ebx
             push    ecx
             push    edx
             push    ebx
             invoke TextOut,hdc,XX+0*XX_GAP, edx, eax, 6
	     pop     ebx
             pop     edx
             pop     ecx
	     xor    eax, eax
	     mov    al, buf[ebx].chinese
	     lea    si, chinese
	     invoke   Radix, 10
             push    ecx
             push    edx
             push    ebx
             invoke TextOut,hdc,XX+1*XX_GAP,edx,offset chinese,2
             pop     ebx
             pop     edx
             pop     ecx
	     xor    eax, eax
	     mov    al, buf[ebx].math
	     lea    si, math
	     invoke   Radix, 10
             push    ecx
             push    edx
             push    ebx
             invoke TextOut,hdc,XX+2*XX_GAP,edx,offset math, 2
             pop     ebx
             pop     edx
             pop     ecx
	     xor    eax, eax
	     mov    al, buf[ebx].english
	     lea    si, english
	     invoke   Radix, 10
             push    ecx
             push    edx
             push    ebx
             invoke TextOut,hdc,XX+3*XX_GAP,edx,offset english,2
             pop     ebx
             pop     edx
             pop     ecx
	     xor    eax, eax
	     mov    al, buf[ebx].average
	     lea    si, average
	     invoke   Radix, 10
             push    ecx
             push    edx
             push    ebx
             invoke TextOut,hdc,XX+4*XX_GAP,edx,offset average,2
             pop     ebx
             pop     edx
             pop     ecx
	     lea     eax, buf
	     add     eax, ebx
	     add     eax, 14
             push    ecx
             push    edx
             push    ebx
             invoke TextOut,hdc,XX+5*XX_GAP, edx, eax, 1
             pop     ebx
             pop     edx
             pop     ecx
	     inc     ecx
             jmp     display_loop
display_finish:
	     pop    edi
	     pop    esi
	     pop    edx
	     pop    ecx
	     pop    ebx
	     pop    eax
             ret
Display      endp

Average   proc  number:DWORD
        push    eax
	push    ebx
        push    ecx
        push    edx
        push    esi                    
        xor     ecx, ecx                              
avg_loop:
        cmp     ecx, number
        jge     avg_finish            
        xor     eax, eax
        xor     edx, edx
	imul	ebx, ecx, 15
        mov     al,  buf[ebx].chinese           
        mov     dl,  buf[ebx].math         
        lea     eax, [edx + eax * 2]  
        xor     edx, edx
        mov     dl,  buf[ebx].english         
        lea     esi, [edx + eax *2]    
        mov     eax, 92492493h        
        imul    esi
        add     edx, esi
        sar     edx, 2
        mov     eax, edx
        shr     eax, 1fh
        add     edx, eax
        mov     buf[ebx].average, dl
	.if	dl > 90
		mov	buf[ebx].stugrade, 'A'
	.elseif dl > 80
		mov	buf[ebx].stugrade, 'B'
	.elseif dl > 70
		mov	buf[ebx].stugrade, 'C'
	.elseif dl > 60
		mov	buf[ebx].stugrade, 'D'
	.else
		mov	buf[ebx].stugrade, 'E'
	.endif            
        inc     ecx                 
        jmp     avg_loop
avg_finish:
        pop     esi                
        pop     edx
        pop     ecx
	pop	ebx
        pop     eax
        ret
Average   endp

Radix     proc	base:DWORD
            push    ecx
	    push    ebx
            push    edx
	    mov     ebx, base
            xor     cx, cx          
radix_loop1:
            xor     edx, edx
            div     ebx
            push    dx              
            inc     cx             
            or      eax, eax
            jnz     radix_loop1   
radix_loop2:                     
            pop     ax
            cmp     al, 10
            jb      radix_l1
            add     al, 7
radix_l1:
            add     al, 30h
	    mov     [esi], al
            inc     si
            loop    radix_loop2   
            pop     edx
	    pop     ebx
            pop     ecx
            ret
Radix     endp

             end  Start
