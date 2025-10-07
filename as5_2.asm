%macro operate 4
    mov rax, %1
    mov rdi, %2
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

section .data
msg db "File deleted successfully!",10
msglen equ $-msg

error_msg db "something went wrong!",10
error_msg_len equ $-error_msg

section .bss
	fname resb 15
	fd1 resq 1
	
	
section .text	
global _start
_start:
	pop r8    
	cmp r8,2
	jne err
	pop r8    
	pop r8
	
	mov rsi,fname
	
	above:  
		mov al,[r8]  ;r8 is pointing to the source file name 
		cmp al,00    ; we compare if current content of al is null(00)
		je next
		mov [rsi],al 
		inc r8
		inc rsi
		jmp above
		
	next:
		operate 2,fname,000000q,0777q   ;opening first file
		mov [fd1],rax
		
		operate 87,fname,0,0
		operate 1,1,msg,msglen
		jmp end
	err:
		operate 1,1,error_msg,error_msg_len
		operate 60,0,0,0
	
	end:
		operate 60,0,0,0