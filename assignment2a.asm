%macro rw 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
    msg db "The result is ", 0ah
    msg_len equ $ - msg

    prompt_element db "Enter element (2 hex digits, e.g., FF): ", 0ah
    prompt_element_len equ $ - prompt_element

    newline db 0ah
    newline_len equ $ - newline

    temp dw 0
    digit db 0
    cnt db 4
    num_elements db 5
    input_buffer db 10

section .bss
    user_arr resb 256

section .text
    global _start
_start:
    mov rdi, 0
    mov r8, 0

read_elements_loop:
    rw 1, 1, prompt_element, prompt_element_len
    rw 0, 0, input_buffer, 10

    mov rax, 0
    mov al, byte [input_buffer]
    call hex_to_byte_digit
    shl al, 4
    mov bl, al

    mov rax, 0
    mov al, byte [input_buffer + 1]
    call hex_to_byte_digit
    add bl, al

    mov byte [user_arr + rdi], bl
    inc rdi

    inc r8
    mov al, byte [num_elements]
    cmp r8b, al
    jb read_elements_loop

    rw 1, 1, newline, newline_len

    rw 1, 1, msg, msg_len

    xor ax, ax
    mov rsi, user_arr
    mov cl, byte [num_elements]

nextno:
    add al, [rsi]
    jnc nocarry
    inc ah

nocarry:
    inc rsi
    dec cl
    jnz nextno

    mov byte[cnt], 4

again:
    rol ax, 4
    mov [temp], ax
    and ax, 000FH
    cmp al, 09H
    jbe skip
    add al, 07H

skip:
    add al, 30H

    mov [digit], al
    rw 1, 1, digit, 1
    mov ax, [temp]
    dec byte[cnt]
    jnz again

    rw 1, 1, newline, newline_len

    mov rax, 60
    mov rdi, 0
    syscall

hex_to_byte_digit:
    cmp al, '0'
    jb .invalid_hex
    cmp al, '9'
    jbe .is_digit
    cmp al, 'A'
    jb .invalid_hex
    cmp al, 'F'
    jbe .is_upper_hex
    cmp al, 'a'
    jb .invalid_hex
    cmp al, 'f'
    jbe .is_lower_hex
    jmp .invalid_hex

.is_digit:
    sub al, '0'
    ret

.is_upper_hex:
    sub al, 'A'
    add al, 10
    ret

.is_lower_hex:
    sub al, 'a'
    add al, 10
    ret

.invalid_hex:
    mov rax, 60
    mov rdi, 1
    syscall