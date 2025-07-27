%macro rw 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
    msg db "The result is ", 0ah
    arr db 34H, 0AAH, 0FFH, 25H, 89H
    temp dw 0
    digit db 0
    cnt db 4

section .bss

section .text
    global _start
_start:
    rw 1,1,msg,14

    mov ax, 00H
    mov rsi, arr
    mov cl, 5

nextno:
    add al, [rsi]
    jnc nocarry
    inc ah

nocarry:
    inc rsi
    dec cl
    jnz nextno

again:
    rol ax,4
    mov [temp],ax
    and ax,000FH
    cmp al,09
    jbe skip
    add al,07H

skip:
    add al,30H

    mov [digit],al
    rw 1,1,digit,1
    mov ax,[temp]
    dec byte[cnt]
    jnz again

    mov rax, 60
    mov rdi, 0
    syscall