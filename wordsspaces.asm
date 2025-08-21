%macro scall 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
    msg1 db 10, "Enter a string: "
    len1 equ $ - msg1

    m4 db 10, "Number of words: "
    l4 equ $ - m4

    m5 db 10, "Number of spaces: "
    l5 equ $ - m5

section .bss
    string1 resb 50
    length1 resb 1
    space2 resb 1
    word1 resb 1

section .text
    global _start

_start:
    ; take input
    scall 1, 1, msg1, len1
    scall 0, 0, string1, 50
    dec rax
    mov [length1], al

    ; initialize
    mov rsi, string1
    mov bl, 0          ; space counter

up:
    mov al, [rsi]
    cmp al, ' '        ; check space
    jne nspace
    inc bl             ; count space

nspace:
    inc rsi
    dec byte [length1]
    jnz up

    ; print number of spaces
    scall 1, 1, m5, l5
    add bl, 30h
    mov [space2], bl
    scall 1, 1, space2, 1

    ; print number of words
    scall 1, 1, m4, l4
    sub bl, 30h
    inc bl
    add bl, 30h
    mov [word1], bl
    scall 1, 1, word1, 1

    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall