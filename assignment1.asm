%macro rw 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
    msg db "The decimal sum is: ", 0ah
    msg_len equ $ - msg

    arr db 52, 10, 100, 40, 80
    arr_len equ $ - arr
    
    result_ascii db "00000", 0ah
    result_ascii_len equ $ - result_ascii

section .bss

section .text
    global _start

_start:
    rw 1, 1, msg, msg_len

    mov ax, 0
    mov rsi, arr
    mov cl, arr_len

next_num:
    add al, [rsi]
    jnc nocarry
    inc ah

nocarry:
    inc rsi
    dec cl
    jnz next_num

    mov rsi, result_ascii + 4
    mov bx, 10

convert_loop:
    mov dx, 0
    div bx
    add dl, 30h
    mov [rsi], dl
    dec rsi
    cmp ax, 0
    jnz convert_loop

    rw 1, 1, result_ascii, result_ascii_len

    mov rax, 60
    mov rdi, 0
    syscall