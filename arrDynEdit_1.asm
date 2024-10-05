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
	
	mov		QWORD[arraySize], ARRAY_SIZE
	mov		rdi, ARRAY_SIZE
	mov		rsi, ELEMENT_SIZE
	call		calloc
	mov		[arrayPtr], eax

	;; Get ready to write elements to the array
   	;; Load base address of array into RDI
   	;; Load array size into RCX
   	;; Clear direction flag so stosd works from index 0 to index ARRAY_SIZE
   	mov   		rdi, [arrayPtr]
   	cld
inputLoop:
   	;; printf & scanf trashes RDI, so save it
	push 		rcx		; I dont think I use rcx at all, but if I dont put this here it breaks
   	push  		rdi
   	mov   		rdi, inputPrompt
  	call  		printf

   	;; Read an int from stdin & store in intInput
   	mov   		rdi, intFormat
   	mov   		rsi, intInput
   	call  		scanf

	;; Exits the loop if nothing is entered
	cmp		eax, EOF
	je		endLoop

	;; using r12 as a counter of how many elements are in the array
	inc		r12
	
	add		r13, [intInput] 	; adds the input to sum
	
	

	mov 		r10, r12
	sub 		r10, [arraySize]
	js		skipBigger
makeArrBigger:
	xor		rax, rax
	xor		r9, r9

	mov		r9, [arraySize] 			; saves the old array size
	sub 		r9, 1
	mov		r8, [arraySize]
	add		[arraySize], r8		; doubles the array size

	;;push values to save
	push	r9

	;;I put this here to test if size expansion is correcy
	mov		rdi, intFormat
	mov		rsi, DWORD [arraySize]
	call	printf


	; allocates new memory with double the size
	mov		rdi, [arraySize]		
	mov		rsi, ELEMENT_SIZE
	call		calloc

	;;bring pushed values back
	pop		r9

	; deleted line here
	mov 		rdi, rax
	mov 		rsi, [arrayPtr]
	mov 		rcx, r9
	cld
	rep 		movsd
	mov 		[arrayPtr], rax
skipBigger:
   	;; Use stosd to store user input into next array slot
   	;; stosd writes EAX to address stored in RDI
   	;; then increments RDI by 4, so ready to write to
   	;; next location in the array
   	xor   		rax, rax
   	mov   		rax, [intInput]
   	pop   		rdi                    ; We need the saved RDI now
	
   	stosd
	mov		r10, [rdi - 4]		; no idea what this is supposed to do
	pop		rcx
   	jmp  		inputLoop
endLoop:
   	;; Get ready to read elements of the array
   	;; Load base address of array into RSI
   	;; Load array size into RCX
   	;; Clear direction flag so lodsd works from index 0 to index ARRAY_SIZE
   	mov   		rsi, [arrayPtr]
   	mov   		rcx, r12
   	xor   		rbx, rbx

	movsx		r14, DWORD[rbx] 	; used for minimum
	movsx		r15, DWORD[rbx] 	; used for maximum

   	cld
	mov		rbx, [arrayPtr]
	mov		rcx, r12 	; loops the length of the array

findMin:
	xor		r9, r9
	movsx		r9, DWORD[rbx]
	sub		r9, r14		; compares min value with current array value
	js		changeMin	; changes the min value to the current array value if its lower

	add		rbx, 4		; moves to next element in the array
	loop		findMin		; loops until array ends

	cld
	mov		rcx, r12 
	mov		rbx, [arrayPtr]

	jmp 		findMax		; loops findMax if the loop is over
changeMin:
	movsx		r14, DWORD[rbx]	; sets the min to the current array value
	add		rbx, 4		; moves to the next part of the array
	loop		findMin		; loops findMin if the array isnt over

	cld
	mov		rcx, r12 
	mov		rbx, [arrayPtr]
findMax: 
	xor		r9, r9
	movsx		r9, DWORD[rbx]
	sub		r9, r15		; compares max value with current array value
	jns 		changeMax	; changes the max value to the current array value if its higher;

	add		rbx, 4
	loop		findMax

	jmp 		printStuff
changeMax:
	movsx		r15, DWORD[rbx]
	add		rbx, 4
	loop		findMax
	jmp		printStuff

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