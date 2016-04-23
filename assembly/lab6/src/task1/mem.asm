.386

code    segment use16   para    public  'code'
        assume cs: code
start:  
        xor     ax, ax
        mov     ds, ax      ; 0 -> ds
        cli
        mov     dx, ds:[10h*4]
        mov     ax, ds:[10h*4 + 2]
        sti
        mov     ah, 4ch
        int     21h
code    ends
        end start
