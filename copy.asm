;;; CPSC 232
;;; 5/3/23
;;; Hollister Seney
;;; PA06-StructsListFloat
;;; file: productStruc2.asm
;;; Reads, stores, and prints product details with floats!
   
	%define ARRAY_SIZE 5
	%define MAX_BUFFER 255
	%define EOF -1
	%define NULL 0

	struc pr
	.pID:   resd 1
   	.name: resq 1
   	.price: resq 1
   	.cost: resq 1
	.quantity: resd 1
	.rcdPtr	resq 1
   	.size:
   	endstruc

segment .data
	welcome:	db "Please enter in product information below (ctrl-d to stop).",0
	inventory:	db "Here is the current store inventory: ",10,0
   	promptID:	db 10,"Product ID: ",0
   	promptN:  	db "Product Name: ",0
   	promptP:  	db "Price: ",0
	promptC:  	db "Cost: ",0
	promptQ:	db "Item Quantity: ",0
   	outputID:  	db 10,"Product ID: %d",10,0
   	outputN:  	db "Product Name: %s",10,0
   	outputP:   	db "Price: %.2lf",10,0
	outputC:   	db "Cost: %.2lf",10,0
	outputQ:	db "Quantity: %d",10,0
	totalQ:		db "Total Inventory Quantity: %d",10,0
	totalA:		db "Total Inventory Assets: %.2lf",10,0
	totalL:		db "Total Inventory Liability: %.2lf",10,0
   	intFormat: 	db "%d",0
	floatFormat:	db "%lf",0
   	strFormat: 	db "%s",0
	newLine: 	db 10,0
	errOut: 	db 10,10,"null is very bad and yucky",10,10,0
		

segment .bss
   	intInput:    	resd 1
	floatInput:	resq 1
	tempFloatA:	resq 1
	tempFloatB:	resq 1
   	stringInput: 	resb MAX_BUFFER
	head: 		resq 1
	assets:		resq 1
	liability:	resq 1
	totalQuan:	resd 1

segment .text
   	global asm_main
   	extern printf, scanf, calloc, free, strncpy, strnlen

asm_main:
	enter	8,0	; dunno if 8,0 is necessary here, probably not?

	mov 	[assets], DWORD NULL
	mov	[assets + 4], DWORD NULL 	; you cant move a quad word, so you need to move 2 double words
	
	mov 	[liability], DWORD NULL
	mov	[liability + 4], DWORD NULL

	mov   	rdi, welcome
	call  	printf
	
	call	input	; call the input method
	
	leave
	ret

;; Subprogram: input
;; Takes user input and stores in linked list of products' information
input:
   	enter 8,0                    ; This keeps our stack 16-byte aligned when we puch regs
	
	mov	rdi, 1
   	mov   	rsi, pr.size
   	call  	calloc

   	mov	[head], rax            
   	mov   	rbx, rax       
inputLoop:
	xor	rax, rax
   	mov   	rdi, promptID          ; Read in product ID
   	call  	printf
   	mov   	rdi, intFormat
   	mov   	rsi, intInput
   	call  	scanf
	
	cmp   	eax, EOF
   	je    	doneInput

   	mov   	eax, [intInput]	    ; allocate space for int
   	mov   	[rbx+pr.pID], eax

	mov   	rdi, 1
   	mov   	rsi, pr.size
   	call  	calloc

   	mov   	rdi, promptN          ; Read in product name
   	call  	printf
   	mov   	rdi, strFormat
   	mov   	rsi, stringInput
   	call  	scanf

   	mov   	rdi, stringInput       ; Get string size and alloc space for string
   	mov   	rsi, MAX_BUFFER
   	call  	strnlen
   	inc   	rax
   	mov   	r13, rax

   	mov   	rdi, rax
   	mov   	rsi, 1
   	call  	calloc

   	mov   	[rbx+pr.name], rax    ; Copy name string to struct
   	mov   	rdi, rax
   	mov   	rsi, stringInput
   	mov 	rdx, r13
   	call	strncpy

   	mov   	rdi, promptP          ; Read in product price
   	call  	printf
   	mov   	rdi, floatFormat
   	mov   	rsi, floatInput
   	call  	scanf

   	mov   	rax, [floatInput]		; allocate space for float
   	mov   	[rbx+pr.price], rax

	mov   	rdi, 1
   	mov   	rsi, pr.size
   	call  	calloc

   	mov   	rdi, promptC          ; Read in product cost
   	call  	printf
   	mov   	rdi, floatFormat
   	mov   	rsi, floatInput
   	call  	scanf

   	mov   	rax, [floatInput]		; allocate space for float
   	mov   	[rbx+pr.cost], rax

   	mov   	rdi, 1
   	mov   	rsi, pr.size
   	call  	calloc

	mov   	rdi, promptQ          ; Read in product quantity
   	call  	printf
   	mov   	rdi, intFormat
   	mov   	rsi, intInput
   	call  	scanf

   	mov   	eax, [intInput]		; allocate space for int
   	mov   	[rbx+pr.quantity], eax

   	mov   	rdi, 1
   	mov   	rsi, pr.size
   	call  	calloc


  	cmp   	rax, NULL
   	je   	errorMesg

   	mov   	[rbx+pr.rcdPtr], rax
   	mov   	rbx, rax

	jmp	inputLoop
doneInput:
   	mov   	rdi, newLine
   	call  	printf
   	mov   	r13, [head]
printLoop:
	cmp   	dword [r13+pr.rcdPtr], NULL
   	je    	done

   	mov   	rdi, outputID
   	mov   	rsi, [r13+pr.pID]
   	call  	printf

	mov   	rdi, outputN
   	mov   	rsi, [r13+pr.name]
   	call  	printf

	mov   	rdi, outputP
   	mov   	rsi, [floatInput]
	movsd 	xmm0, [r13+pr.price]
	movsd	[tempFloatA], xmm0
   	mov   	rax, 1
   	call  	printf

	mov   	rdi, outputC
   	mov   	rsi, [floatInput]
	movsd 	xmm0, [r13+pr.cost]
	movsd	[tempFloatB], xmm0
  	mov   	rax, 1
   	call  	printf

	mov   	rdi, outputQ
   	mov   	rsi, [r13+pr.quantity]
	add	[totalQuan], rsi	; add to total
   	call  	printf

	; the quantity is required for all other calculations, but it needs to be a double like the floats
	cvtsi2sd	xmm0, [r13+pr.quantity]		; xmm0 = quantity
	
	movsd	xmm1, qword[tempFloatA]		; xmm1 = price
	movsd	xmm2, qword[tempFloatB]		; xmm2 = cost	
	
	movsd	xmm3, qword[assets]		; xmm3 = total assets (price*quantity)
	movsd 	xmm4, qword[liability]		; xmm4 = total liability (cost*quantity)
		
	mulsd	xmm1, xmm0
	addsd	xmm1, xmm3
	movsd	[assets], xmm1

	mulsd	xmm2, xmm0
	addsd	xmm2, xmm4
	movsd	[liability], xmm2
	
	

   	xor   	rax, rax
   	mov   	eax, NULL
   	cmp   	[r13+pr.rcdPtr], rax
   	je    	done
   	mov   	r13, [r13+pr.rcdPtr]
	
   	jmp   	printLoop

   	jmp   	doneInput
   	jmp   	done
   		
errorMesg:
   	mov   	rdi, errOut
   	call  	printf
done:
	mov	rdi, totalQ
	mov	rsi, [totalQuan]
	call 	printf

	mov	rax, 1
	mov	rdi, totalA
	movsd	xmm0, qword [assets]
	;mov	rsi, [assets]
	call 	printf

	mov	rax, 1
	mov	rdi, totalL
	movsd	xmm0, qword [liability]
	call 	printf
	
   	xor   	rax, rax
   	leave
   	ret
