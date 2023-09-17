mov ah, 0x0e ; tty mode

mov bp, 0x8000 ; this is an address far away from 0x7c00 so that we don't get overwritten
mov sp, bp ; if the stack is empty then sp points to bp

push 'K'
push 'B'
push 'C'





; to show how the stack grows downwards
mov al, [0x7ffe] ; 0x8000 - 2 = 0x7ffe which is the top of the stack now that contains 'C'
int 0x10

mov al, [0x7ffe - 2] ; 0x8000 - 2 = 0x7ffe which is the top of the stack now that contains 'C'
int 0x10

mov al, [0x7ffe - 4] ; 0x8000 - 2 = 0x7ffe which is the top of the stack now that contains 'C'
int 0x10


; however, don't try to access [0x8000] now, because it won't work
; you can only access the stack top so, at this point, only 0x7ffe (look above)
mov al, [0x8000]
int 0x10


; recover our characters using the standard procedure: 'pop'
; We can only pop full words so we need an auxiliary register to manipulate
; the lower byte
pop bx ; bx is now 'C' (0x43)
mov al, bl ; bl is the lower byte of bx
int 0x10 ; prints C

pop bx  ; bx is now 'B' (0x42)
mov al, bl
int 0x10 ; prints B

pop bx ; bx is now 'K' (0x4b)
mov al, bl
int 0x10 ; prints K

; data that has been pop'd from the stack is garbage now
mov al, [0x8000]
int 0x10


jmp $
times 510-($-$$) db 0
dw 0xaa55

