section .bss
    str1 resb 100
    str2 resb 100

section .data
    prompt1 db "Enter first string: ", 0
    prompt1_len equ $ - prompt1

    prompt2 db "Enter second string: ", 0
    prompt2_len equ $ - prompt2

    equal_msg db "Strings are equal.", 10, 0
    equal_msg_len equ $ - equal_msg

    not_equal_msg db "Strings are NOT equal.", 10, 0
    not_equal_msg_len equ $ - not_equal_msg

section .text
    global _start

_start:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt1
    mov edx, prompt1_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, str1
    mov edx, 100
    int 0x80
    mov esi, eax

    cmp esi, 0
    je read_second_string
    mov eax, esi
    dec eax
    mov al, [str1 + eax]
    cmp al, 10
    jne read_second_string
    mov byte [str1 + eax], 0
    dec esi

read_second_string:
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt2
    mov edx, prompt2_len
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, str2
    mov edx, 100
    int 0x80
    mov edi, eax

    cmp edi, 0
    je compare_strings
    mov eax, edi
    dec eax
    mov al, [str2 + eax]
    cmp al, 10
    jne compare_strings
    mov byte [str2 + eax], 0
    dec edi

compare_strings:
    cmp esi, edi
    jne not_equal

    mov ecx, esi
    mov esi, str1
    mov edi, str2

    repe cmpsb

    jne not_equal

equal:
    mov eax, 4
    mov ebx, 1
    mov ecx, equal_msg
    mov edx, equal_msg_len
    int 0x80
    jmp exit

not_equal:
    mov eax, 4
    mov ebx, 1
    mov ecx, not_equal_msg
    mov edx, not_equal_msg_len
    int 0x80

exit:
    mov eax, 1
    mov ebx, 0
    int 0x80
