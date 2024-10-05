;;; CPSC 232
;;; 4/3/23
;;; file: struc.asm
;;; An array of Structs in NASM
   	%define ARRAY_SIZE 5
   
   	struc pR
   	.pID:   resd 1
   	.nameF: resq 1
   	.nameL: resq 1
   	.alive: resb 1
   	.size:
   	endstruc
   
segment .data
   	promptID: db "Patient ID: ",0
   	promptNF: db "Patient First Name: ",0
   	promptNL: db "Patient Last Name: ",0
   	promptA: db "Patient alive? ",0
   	outputID: db "Patient ID: %d",10,0
   	outputNF: db "Patient Name: %s %s",10,0
   	outputA: db "Patient alive? %d",0
   	intFormat: db "%d",0
   	strFormat: db "%s",0

segment .bss
   	patientDB: resb pR.size * ARRAY_SIZE
   	intInput: resd 1
   	stringInput: resb 255
	
segment .text
   	global asm_main
   	extern printf, scanf, calloc, free, strncpy
asm_main:
	enter 	0,0
		
   	xor   	r12, r12               ; Array index
   	mov   	rcx, ARRAY_SIZE
   	mov   	rbx, patientDB
inputLoop:	
   	push  	rcx
   	mov   	rdi, promptID
   	call  	printf
   	mov   	rdi, intFormat
   	mov   	rsi, intInput
   	call  	scanf
	
   	mov   	r8, pR.size
   	mov   	rdi, outputID
   	mov   	rsi, pR.size
   	call  	printf
	
   	;; LEA doesn't work here!
   	;; Need to do address math for storage location
   	;; lea   rax, [patientDB + r12 * 21]
   	;; lea   rax, [ rbx + r12 * 21 ]
   	;; mov   [rax], [intInput]

	;;rbx
	xor	rax, rax
	mov	eax, [intInput]
   	mov   	[rbx+pR.pID], eax

   	mov   	rdi, outputID
   	mov   	esi, [rbx+pR.pID]
   	call  	printf
   	
   	pop   	rcx
   	loop  	inputLoop
   	
   	mov   	rax, 0
   	leave
   	ret
