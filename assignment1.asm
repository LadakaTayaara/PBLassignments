%macro rw 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
    msg db "The sum is: ", 0ah
    msg_len equ $ - msg
    arr db 34H, 0AAH, 0FFH, 25H, 89H
    arr_len equ $ - arr
    
    result_ascii db "0000", 0ah
    result_ascii_len equ $ - result_ascii

section .bss

section .text
    global _start
_start:
    rw 1, 1, msg, msg_len

    mov ax, 00H
    mov rsi, arr
    mov cl, arr_len

nextno:
    add al, [rsi]
    jnc nocarry
    inc ah

nocarry:
    inc rsi
    dec cl
    jnz nextno

    mov rsi, result_ascii + 3
    mov rcx, 4

convert_loop:
    rol ax, 4
    push rax
    and al, 0FH

    cmp al, 09
    jbe add_digit
    add al, 7

add_digit:
    add al, 30h
    mov [rsi], al

    pop rax
    dec rsi
    loop convert_loop

    rw 1, 1, result_ascii, result_ascii_len

    mov rax, 60
    mov rdi, 0
    syscall