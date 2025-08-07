%macro rwfn 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .bss
    str1 resb 100
    str2 resb 100
    concat resb 200

section .data
    prompt1 db "Enter first string: ", 0
    prompt1_len equ $ - prompt1

    prompt2 db "Enter second string: ", 0
    prompt2_len equ $ - prompt2

section .text
    global _start

_start:
    ; Prompt and read first string
    rwfn 1, 1, prompt1, prompt1_len
    rwfn 0, 0, str1, 100
    mov rbx, rax             ; save length first string in rbx

    ; Prompt and read second string
    rwfn 1, 1, prompt2, prompt2_len
    rwfn 0, 0, str2, 100
    mov rdx, rax             ; save length second string in rdx

    ; Copy first string to concat buffer
    mov rsi, str1
    mov rdi, concat
    mov rcx, rbx             ; rcx = length first string
    dec rcx
    cld
    rep movsb

    ; Copy second string after first in concat
    mov rsi, str2
    mov rdi, concat
    add rdi, rbx             ; move rdi to end of first string
    mov rcx, rdx             ; rcx = length second string
    cld
    rep movsb

    ; Calculate total length (first + second)
    add rbx, rdx             ; rbx = total length

    ; Write concatenated string
    rwfn 1, 1, concat, rbx

    ; Exit
    rwfn 60, 0, 0, 0
