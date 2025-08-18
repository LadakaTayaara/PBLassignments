%macro rw 4
   mov rax, %1
   mov rdi, %2
   mov rsi, %3
   mov rdx, %4
   syscall
%endmacro

section .data
Arr db 05H, 01H, 0AH, 25H, 45H
S1 db "Sorting array is", 20
S2 equ $-S1

section .bss

result resb 15

section .text
global _start
_start : 

mov BL, 4
NextP : mov CL, 4
        mov rsi, Arr
NextC : mov AL, [rsi]
        CMP AL, [rsi + 1]
        JAE NoEX 
        XCHG AL, [rsi + 1]
        MOV [rsi], AL
NoEX :
        INC rsi
        DEC CL
JNZ NextC 
DEC BL
JNZ NextP

rw 1,1,S1,S2
mov DL, 5
mov rdi, Arr
mov rsi, result
NextEL: mov CL, 02
          mov AL, [rdi]
NextD : ROL AL, 4
         MOV BL, AL
         AND AL, 0FH
         CMP AL, 09H
         JBE down 
       Add AL, 07H
down :Add AL, 30H
  mov [rsi], AL 
  INC rsi
  mov AL,BL
  DEC CL
  JNZ NextD
  ;INC rsi
  mov byte [rsi], 0AH
  INC rsi
  INC rdi
  DEC DL
  JNZ NextEL    
  rw 1,1,result,15
  rw 60,0,0,0