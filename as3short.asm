; Define the read/write macro for 64-bit syscalls
%macro rw 4
    mov     rax, %1     ; syscall number
    mov     rdi, %2     ; 1st argument (e.g., file descriptor)
    mov     rsi, %3     ; 2nd argument (e.g., buffer address)
    mov     rdx, %4     ; 3rd argument (e.g., count)
    syscall             ; Make the system call
%endmacro

section .bss
    str1    resb 100
    str2    resb 100

section .data
    prompt1         db "Enter first string: ", 0
    prompt1_len     equ $ - prompt1

    prompt2         db "Enter second string: ", 0
    prompt2_len     equ $ - prompt2

    equal_msg       db "Strings are equal.", 10, 0
    equal_msg_len   equ $ - equal_msg

    not_equal_msg   db "Strings are NOT equal.", 10, 0
    not_equal_msg_len equ $ - not_equal_msg

section .text
    global _start

_start:
    ; Prompt for the first string
    rw 1, 1, prompt1, prompt1_len

    ; Read the first string
    rw 0, 0, str1, 100
    mov rsi, rax        ; Save the number of bytes read (length) in rsi

    ; Remove trailing newline from str1, if present
    cmp rsi, 0
    je read_second_string   ; Skip if input is empty
    mov rax, rsi
    dec rax             ; Get index of last character
    mov al, [str1 + rax]
    cmp al, 10          ; Is it a newline?
    jne read_second_string
    mov byte [str1 + rax], 0 ; Yes, replace with null terminator
    dec rsi             ; Decrement the stored length

read_second_string:
    ; Prompt for the second string
    rw 1, 1, prompt2, prompt2_len

    ; Read the second string
    rw 0, 0, str2, 100
    mov rdi, rax        ; Save the number of bytes read in rdi

    ; Remove trailing newline from str2, if present
    cmp rdi, 0
    je compare_strings  ; Skip if input is empty
    mov rax, rdi
    dec rax
    mov al, [str2 + rax]
    cmp al, 10
    jne compare_strings
    mov byte [str2 + rax], 0
    dec rdi

compare_strings:
    ; First, compare the lengths
    cmp rsi, rdi
    jne not_equal

    ; If lengths are equal, compare the content
    mov rcx, rsi        ; Set counter for the loop
    mov rsi, str1       ; Point rsi to the start of str1
    mov rdi, str2       ; Point rdi to the start of str2
    repe cmpsb          ; Compare bytes until mismatch or rcx is 0
    jne not_equal       ; Jump if the Zero Flag is not set (mismatch found)

equal:
    ; Print the "equal" message
    rw 1, 1, equal_msg, equal_msg_len
    jmp exit

not_equal:
    ; Print the "not equal" message
    rw 1, 1, not_equal_msg, not_equal_msg_len

exit:
    ; Exit the program
    mov rax, 60         ; syscall number for sys_exit
    mov rdi, 0          ; Exit code 0 (success)
    syscall