;; Rowan Medcraft
;; CPSC 232
;; 3/31/2023
;; file: arrDyn.asm
;; Creates a dynamic array and prints data about it once user input ends.

	%define ARRAY_SIZE  	5
   	%define ELEMENT_SIZE 	4
   	%define EOF 		-1
segment .data
	inputPrompt: 	db "Please Enter int value (ctrl-d to stop): ",0
	intFormat:   	db "%d",0
	numElements: 	db "Number of elements: %d",10,0
	sum: 		db "Sum: %d",10,0
	min: 		db "Min: %d",10,0
	max: 		db "Max: %d",10,0
	element: 	db "Array element is %d",10,0
	big: 		db "making array bigger",10,0

segment .bss
	arrayPtr:  	resq 1                     ; pointer to our array
   	intInput: 	resd 1
	arraySize: 	resq 1			; stores the size of the array

segment .text
	global  	asm_main
	extern		printf, scanf, calloc

asm_main:
        enter   	0,0		; setup routine

	;; clears r12 and r13 so they can be used to calculate stuff
	xor		r12, r12	; used for current size
	xor		r13, r13	; used for sum
	
	mov		[arraySize], DWORD ARRAY_SIZE
	mov		rdi, ARRAY_SIZE
	mov		rsi, ELEMENT_SIZE
	call		calloc
	mov		[arrayPtr], rax

	;; Get ready to write elements to the array
   	;; Load base address of array into RDI
   	;; Load array size into RCX
   	;; Clear direction flag so stosd works from index 0 to index ARRAY_SIZE
   	mov   		rdi, [arrayPtr]
	mov		rcx, ARRAY_SIZE
   	cld
inputLoop:
   	;; printf & scanf trashes RDI, so save it

	push 		rcx		; I dont think I use rcx at all, but if I dont put this here it breaks
   	push  		rdi
	xor		rdi, rdi

   	mov   		rdi, inputPrompt
  	call  		printf

   	;; Read an int from stdin & store in intInput
   	mov   		rdi, intFormat
   	mov   		rsi, intInput
   	call  		scanf

	movsx		r9, DWORD [intInput]
	;; Exits the loop if nothing is entered
	cmp		eax, EOF
	je		endLoop

	;; using r12 as a counter of how many elements are in the array
	inc		r12
	add		r13, [intInput] 	; adds the input to sum
	
	mov 		r10, r12
	sub 		r10, [arraySize]
	js		skipBigger

	call		coolGuy
	

skipBigger:
   	;; Use stosd to store user input into next array slot
   	;; stosd writes EAX to address stored in RDI
   	;; then increments RDI by 4, so ready to write to
   	;; next location in the array
   	xor   		rax, rax
   	mov   		eax, [intInput]
	pop		rdi
	
	push 		rax

	xor 		rbx, rbx
	mov		rdi, [arrayPtr]
	mov		rax, r12
	sub		rax, 1
	mov		bx, 4
	mul		bx
	add		rdi, rax

	pop		rax
	stosd

	pop		rcx
   	jmp  		inputLoop
endLoop:
	mov		rbx, [arrayPtr]
	xor		r14, r14	
	xor		r15, r15
	movsx		r14, DWORD[rbx] 	; used for minimum
	movsx		r15, DWORD[rbx] 	; used for maximum
	xor		rcx, rcx
	mov		rcx, r12 		; loops the length of the array

findMinMax:
	push		rcx
	push 		rsi
	xor		r9, r9

	movsx		r9, DWORD[rbx]
	sub		r9, r14
	jns		notMin
	movsx		r14, DWORD[rbx]
notMin:
	xor		r9, r9
	movsx		r9, DWORD[rbx]
	sub		r9, r15
	js		notMax
	movsx		r15, DWORD[rbx]
notMax:
	pop		rsi		; no reason to push or pop rcx I dont think
	pop		rcx
	add		rbx, 4
	loop		findMinMax
printStuff:
	mov		rdi, numElements
	mov		rsi, r12
	call		printf

	mov		rdi, sum
	mov		rsi, r13
	call		printf

	mov		rdi, min
	mov		rsi, r14
	call		printf

	mov		rdi, max
	mov		rsi, r15
	call		printf
	
       	mov     	rax, 0            ; return back to C
      	leave
        ret

coolGuy:
	enter 		0,0
	xor		rax, rax
	xor		r9, r9

	mov		r9, [arraySize] 	; saves the old array size
	sub 		r9, 1
	mov		r8, [arraySize]
	add		[arraySize], r8		; doubles the array size
	
	;;push values to save
	push	r9

	; allocates new memory with double the size
	mov		rdi, [arraySize]		
	mov		rsi, ELEMENT_SIZE
	call		calloc

	;;bring pushed values back
	pop		r9

	mov 		rdi, rax
	mov 		rsi, [arrayPtr]
	mov 		rcx, r9
	cld
	rep 		movsd
	mov 		[arrayPtr], rax
	
	leave
	ret
