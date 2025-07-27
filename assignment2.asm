%macro rw 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
	arr db 05h, 01h, 0ah, 25h, 45h
	s1 db "sorting array is ", 20
	s2 equ $-s1

section .bss
	result resb 15

section .text
	global _start
_start : 
	mov bl, 4
	
nextp : mov cl, 4
        mov rsi, arr
        
nextc : mov al, [rsi]
        cmp al, [rsi + 1]
        jbe noex 
        xchg al, [rsi + 1]
        mov [rsi], al
        
noex :
        inc rsi
        dec cl
        
	jnz nextc 
	dec bl
	jnz nextp
	rw 1, 1, s1, s2
	mov dl, 5
	mov rdi, arr
	mov rsi, result
	
nexteL: 
	mov cl, 02
        mov al, [rdi]
        
nextd : rol al, 4
        mov bl, al
        and al, 0fh
        cmp al, 09h
jbe down 
        add al, 07h
down :
	add al, 30h
 	mov [rsi], al 
 	inc rsi
 	mov al,bl
 	dec cl
	jnz nextd
	;inc rsi
	mov byte [rsi], 0ah
	inc rsi
	inc rdi
	dec dl
	jnz nexteL 
	rw 1, 1, result, 15
	rw 60, 0, 0, 0