;;; Rowan Medcraft
;;; CPSC 232
;;; PA07-Floats
;;; file: linkedlistfloat.asm
;;; A linked list of structs in nasm with floats :3
   
   	%define MAX_BUFFER 255
	%define EOF -1
	%define NULL 0
	%define CLEAR 0

   	;; Here is out struct definition
   	;; something akin to what we would put in a .h file
struc record
   	.num:    resd 1
   	.name: 	 resq 1
   	.price:  resq 1
   	.cost: 	 resq 1
	.quan: 	 resd 1
	.rcdPtr: resd 1
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
   	outputPR:  db "Product Price: $%10.2lf",10,0	; .2 = rounded to 2 decimal places
	outputCO:  db "Product Cost: $%10.2lf",10,0
	outputQU:  db "Product Quantity: %d",10,0

	totalLiabOut: db "Total Inventory Liability: $%10.2lf",10,0
	totalAssetOut: db "Total Inventory Assets: $%10.2lf",10,0
	totalQuanOut: db 10,"Total Inventory Quantity: $%d",10,0

   	intFormat: db "%d",0
	fltFormat: db "%lf",0		; lf = long float
   	strFormat: db "%s",0
	
segment .bss
   	intInput:    	resd 1
	fltInput: 	resq 1		; long floats take up a quad word of space
   	stringInput: 	resb MAX_BUFFER

	headPtr:	resd 1

	totalQuant:	resd 1
	totalValue: 	resq 1
	totalCost: 	resq 1
	tempValue: 	resq 1
	tempCost: 	resq 1
segment .text
   	global asm_main
   	extern printf, scanf, calloc, free, strncpy, strnlen
   
asm_main:
   	enter 	8,0
	
	;; clear totals
	mov	[totalQuant], DWORD CLEAR

	mov 	[totalValue], DWORD CLEAR
	mov	[totalValue + 4], DWORD CLEAR	; you cant move a quad word, so you need to move 2 double words
	
	mov 	[totalCost], DWORD CLEAR
	mov	[totalCost + 4], DWORD CLEAR

	;; intro text
	;sub	rsp, 8	
	mov   	rdi, intro
	call  	printf
	;add	rsp, 8	

	call  	getInput

	mov   	rdi, rax		; sending the return value of getInput as a parameter to printInput
	call  	printInput

	mov   	rax, 0
	leave
	ret
getInput:
	enter 	8,0

   	xor   	r12, r12               ; Array index
	xor   	r15, r15		     ; Array size
	xor   	rax, rax		     ; where calloc returns to
	
	mov   	rdi, 1			; finds space for the head node in memory
        mov   	rsi, record.size
        call  	calloc			; allocates array space in rax

	mov   	[headPtr], rax			; moves the pointer into r13
	
	mov   	rbx, rax			; moves the pointer into rbx
inputLoop:
	xor   	rax, rax
   	mov   	rdi, promptID          ; Read in product number
   	call  	printf
   	mov   	rdi, intFormat
   	mov   	rsi, intInput
   	call  	scanf
	
	cmp   	eax, EOF               ; Did scanf() return -1 (didn't read anything?)
   	je    	endInput

   	mov   	eax, [intInput]	    	; puts the integer into num
   	mov   	[rbx+record.num], eax

	xor   	rax, rax
   	mov   	rdi, promptNA          ; Read in product name
   	call  	printf
   	mov   	rdi, strFormat
   	mov   	rsi, stringInput
   	call  	scanf

   	mov   	rdi, stringInput       ; Get string size and alloc space for string
   	mov   	rsi, MAX_BUFFER
   	call  	strnlen
   	inc   	rax
   	mov   	r13, rax		; rax is the length of the string after strnlen is called? maybe?
					
   	mov   	rdi, rax			
   	mov   	rsi, 1
   	call  	calloc			

   	mov   	[rbx+record.name], rax    ; Copy name string to struct
   	mov   	rdi, rax
   	mov   	rsi, stringInput
   	mov   	rdx, r13
   	call  	strncpy
	
	xor   	rax, rax
   	mov   	rdi, promptPR          ; Read in product price
   	call  	printf

	mov	rax, 1
   	mov   	rdi, fltFormat		
   	mov   	rsi, fltInput
   	call  	scanf			; the input is in xmm0

   	movq   	[rbx+record.price], xmm0	; moves the float into price
	movq	[tempValue], xmm0

   	mov   	rdi, promptCO          ; Read in product cost
   	call  	printf

	mov	rax, 1
   	mov   	rdi, fltFormat
   	mov   	rsi, fltInput
   	call  	scanf

   	movq   	[rbx+record.cost], xmm0
	movq	[tempCost], xmm0

	xor   	rax, rax
	mov   	rdi, promptQU          ; Read in product quantity
   	call  	printf
   	mov   	rdi, intFormat
   	mov   	rsi, intInput
   	call  	scanf

   	mov   	eax, [intInput]	    	; puts the integer into quantity
   	mov   	[rbx+record.quan], eax

	;; calculates totals
	;; total liability
	movsd	xmm0, QWORD [tempCost]
	cvtsi2sd	xmm1, eax	; convert signed integer to scalar double 
	;; I think this is the same kinda thing as just putting (double) before an integer in java
	movsd	xmm2, QWORD [totalCost]
	mulsd	xmm0, xmm1
	addsd	xmm0, xmm2
	movsd	[totalCost], xmm0

	;; total value
	movsd	xmm0, QWORD [tempValue]
	cvtsi2sd	xmm1, eax
	movsd	xmm2, QWORD [totalValue]
	mulsd	xmm0, xmm1
	addsd	xmm0, xmm2
	movsd	[totalValue], xmm0
	
   	;; Set rbx to point to next record
	mov   	rdi, 1
        mov   	rsi, record.size
        call  	calloc			; allocates array space in rax 
	
	mov   	[rbx+record.rcdPtr], rax
	
	mov   	rbx, rax
   	jmp   	inputLoop
endInput:
	; set pointer to null
	mov   	rbx, NULL
	
	mov   	rax, [headPtr]		; return the head pointer
	leave
	ret
printInput:
	enter 	8,0

	mov   	rbx, rdi		; moves rdi to rbx before its changed for printf

	xor   	rax, rax		; this is necessary because of the stack being 8 bit aligned instead of 16 bit I think
	;; print the outro text
	mov   	rdi, outro
	call  	printf
printLoop:
	; checks if the next pointer is null
	cmp   	DWORD [rbx+record.rcdPtr], NULL
	je    	endProgram

	xor   	rax, rax
   	mov   	rdi, outputID
   	mov   	rsi, [rbx+record.num]
   	call  	printf

	xor   	rax, rax
   	mov   	rdi, outputNA
   	mov   	rsi,  [rbx+record.name]
   	call  	printf
	
	mov	rax, 1		; rax is how many long floats are read from xmm registers
	mov   	rdi, outputPR
   	movsd	xmm0, [rbx+record.price]  ; move into xmm0 as the first parameter to printf
   	call  	printf
	
	mov	rax, 1
	mov   	rdi, outputCO
   	movsd   xmm0, [rbx+record.cost]
   	call  	printf

	xor   	rax, rax
	mov   	rdi, outputQU
   	mov   	rsi, [rbx+record.quan]
   	call  	printf

	;; adds the quantity value to totalCost
	mov	rax, [rbx+record.quan]
	add	[totalQuant], rax

   	;; Set rbx to point to next record
   	mov   	rbx, [rbx+record.rcdPtr]

	jmp  	printLoop   
endProgram:
	xor	rax, rax
	mov     rdi, totalQuanOut
        mov     esi, DWORD [totalQuant]
        call    printf
	
        mov     rdi, totalAssetOut
	mov	rax, 1
        movsd   xmm0, QWORD [totalValue]
        call    printf

        mov     rdi, totalLiabOut
        mov	rax, 1
	movsd   xmm0, QWORD [totalCost]
        call    printf
	
   	mov   	rax, 0
   	leave
   	ret
