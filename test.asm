;;;test.asm

segment .data
	prompt1:     db    "The answer is: %d",10,0

segment .text
	global asm_main
	extern printf

asm_main:
	enter 0,0  
	xor	rbx, rbx
	xor	rcx, rcx
	mov	rbx, 6
	mov	rcx, 12
	add	rbx, rcx

	mov	rsi, rbx
	mov	rdi, prompt1
	call 	printf
	
	mov   rax, 0
   	leave 
   	ret   