;;; Rowan Medcraft
;;; CPSC 232
;;; PA06-StrucList
;;; file: linkedList.asm
;;; A linked list of structs in nasm
   
   	%define MAX_BUFFER 255
	%define EOF -1
	%define NULL 0

   	;; Here is out struct definition
   	;; something akin to what we would put in a .h file
struc record
   	.num:    resd 1
   	.name: 	 resq 1
   	.price:  resd 1
   	.cost: 	 resd 1
	.quan: 	 resd 1
	.rcdPtr: resq 1
	.size:   	; this is how you know how much space to allocate
endstruc

segment .data
	intro:     db "Welcome to Smith’s Seed Inventory Control System! Please have product number, product name, price, cost, and quantity information ready!",10,0

	outro: 	   db 10,"Now printing the store inventory you entered: ",10,0
	
   	promptID:  db 10,"Product Number: (enter ctrl+D to stop) ",0
	promptNA:  db "Product Name: ",0
   	promptPR:  db "Product Price: $",0
	promptCO:  db "Product Cost: $",0
	promptQU:  db "Product Quantity: ",0

   	outputID:  db 10,"Product Number: %d",10,0
	outputNA:  db "Product Name: %s",10,0
   	outputPR:  db "Product Price: $%d",10,0
	outputCO:  db "Product Cost: $%d",10,0
	outputQU:  db "Product Quantity: %d",10,0

   	intFormat: db "%d",0
   	strFormat: db "%s",0
	
segment .bss
   	intInput:    	resd 1
   	stringInput: 	resb MAX_BUFFER
	headPtr:	resd 1

segment .text
   	global asm_main
   	extern printf, scanf, calloc, free, strncpy, strnlen
   
asm_main:
   	enter 8,0

	;; intro text
	mov   rdi, intro
	call  printf

	call  getInput

	mov   rdi, rax		; sending the return value of getInput as a parameter to printInput
	call  printInput

	mov   rax, 0
	leave
	ret
getInput:
	enter 0,0

   	xor   r12, r12               ; Array index
	xor   r15, r15		     ; Array size
	xor   rax, rax		     ; where calloc returns to
	
	mov   rdi, 1			; finds space for the head node in memory
        mov   rsi, record.size
        call  calloc			; allocates array space in rax

	mov   [headPtr], rax			; moves the pointer into r13
	
	mov   rbx, rax			; moves the pointer into rbx
inputLoop:
   	push  rcx			; I'm not using rcx here but if I get rid of this it seg faults

	xor   rax, rax
   	mov   rdi, promptID          ; Read in product number
   	call  printf
   	mov   rdi, intFormat
   	mov   rsi, intInput
   	call  scanf
	
	pop   rcx		 	; stops seg fault if there is no input
	cmp   eax, EOF               ; Did scanf() return -1 (didn't read anything?)
   	je    endInput
	push  rcx

   	mov   eax, [intInput]	    	; puts the integer into num
   	mov   [rbx+record.num], eax

	xor   rax, rax
   	mov   rdi, promptNA          ; Read in product name
   	call  printf
   	mov   rdi, strFormat
   	mov   rsi, stringInput
   	call  scanf

   	mov   rdi, stringInput       ; Get string size and alloc space for string
   	mov   rsi, MAX_BUFFER
   	call  strnlen
   	inc   rax
   	mov   r13, rax			; rax is the length of the string after strnlen is called? maybe?

   	mov   rdi, rax			
   	mov   rsi, 1
   	call  calloc			

   	mov   [rbx+record.name], rax    ; Copy name string to struct
   	mov   rdi, rax
   	mov   rsi, stringInput
   	mov   rdx, r13
   	call  strncpy
	
	xor   rax, rax
   	mov   rdi, promptPR          ; Read in product price
   	call  printf
   	mov   rdi, intFormat
   	mov   rsi, intInput
   	call  scanf

   	mov   eax, [intInput]	    	; puts the integer into price
   	mov   [rbx+record.price], eax

   	mov   rdi, promptCO          ; Read in product cost
   	call  printf
   	mov   rdi, intFormat
   	mov   rsi, intInput
   	call  scanf

   	mov   eax, [intInput]	    	; puts the integer into cost
   	mov   [rbx+record.cost], eax

	xor   rax, rax
	mov   rdi, promptQU          ; Read in product quantity
   	call  printf
   	mov   rdi, intFormat
   	mov   rsi, intInput
   	call  scanf

   	mov   eax, [intInput]	    	; puts the integer into quantity
   	mov   [rbx+record.quan], eax

   	;; Set rbx to point to next record
	mov   rdi, 1
        mov   rsi, record.size
        call  calloc			; allocates array space in rax 
	
	mov   [rbx+record.rcdPtr], rax
	
	mov   rbx, rax
   	pop   rcx
   	jmp   inputLoop
endInput:
	; set pointer to null
	mov   rbx, NULL
	
	mov   rax, [headPtr]		; return the head pointer
	leave
	ret
printInput:
	enter 8,0

	xor   rcx, rcx
	mov   rbx, rdi		; moves rdi to rbx before its changed for printf

	xor   rax, rax		; this is necessary because of the stack being 8 bit aligned instead of 16 bit I think
	;; print the outro text
	mov   rdi, outro
	call  printf
printLoop:
    	push  rcx	; how the fuck does this work?????
	
	; checks if the next pointer is null
	cmp   DWORD [rbx+record.rcdPtr], NULL
	je    endProgram

	xor   rax, rax
   	mov   rdi, outputID
   	mov   rsi, [rbx+record.num]
   	call  printf

	xor   rax, rax
   	mov   rdi, outputNA
   	mov   rsi,  [rbx+record.name]
   	call  printf

	xor   rax, rax
	mov   rdi, outputPR
   	mov   rsi,  [rbx+record.price]
   	call  printf

	xor   rax, rax
	mov   rdi, outputCO
   	mov   rsi,  [rbx+record.cost]
   	call  printf

	xor   rax, rax
	mov   rdi, outputQU
   	mov   rsi,  [rbx+record.quan]
   	call  printf

   	;; Set rbx to point to next record
   	mov   rbx, [rbx+record.rcdPtr]

	jmp  printLoop   
endProgram:
   	mov   rax, 0
   	leave
   	ret
