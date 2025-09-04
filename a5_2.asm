%macro operate 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
msg1 db "File copied successfully!",10
msg1len equ $-msg1

msg2 db "Error!",10
msg2len equ $-msg2

msg3 db "File deleted successfully!",10
msg3len equ $-msg3

section .bss
	fname1 resb 15
	fd1 resq 1
	fname2 resb 15
	fd2 resq 1
	buff resb 512
	bufflen resq 1
	
	
section .text	
global _start
_start:
	pop r8    ;the value 3 will come in the register r8
	cmp r8,3
	jne err   ;if r8 is not three then don't execute and throw error
	pop r8    ; we get the file name (copy.asm)
	pop r8    ; on third time we get the address of the source
	
	mov rsi,fname1   ;pointer to fname1 
	
	above:  ;we are copying the source file name to fname1
		mov al,[r8]  ;r8 is pointing to the source file name 
		cmp al,00    ; we compare if current content of al is null(00)
		je next
		mov [rsi],al ;
		inc r8
		inc rsi
		jmp above
	next:
		pop r8
		mov rsi,fname2
	above2:
		mov al,[r8]
		cmp al,00
		je next2
		mov [rsi],al 
		inc r8
		inc rsi
		jmp above2
		
		
	next2:
		operate 2,fname1,000000q,0777q   ;opening first file
		mov [fd1],rax
		
		operate 0,[fd1],buff,512         ;reading first file
		mov [bufflen],rax
		
		operate 85,fname2,0777q,0        ;create the second file
		operate 2,fname2,2,0777q         ; open the second file 
		mov [fd2],rax
		
		operate 1,[fd2],buff,[bufflen] ;write to the file
		operate 3,[fd2],0,0
		operate 3,[fd1],0,0
		
		operate 1,1,msg1,msg1len
		operate 87,[fd1],0,0
		operate 1,1,msg3,msg3len
		jmp end
		
	err:
		operate 1,1,msg2,msg2len
		operate 60,0,0,0
	end:
		operate 60,0,0,0