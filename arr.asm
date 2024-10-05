%define ARRAY_SIZE	5

segment .data
	inputPrompt:	db "Please Enter int value (ctrl-d to stop): ", 0
	intFormat:	db "%d", 0
	intOutput:	db "%d", 10, 0
	numElements:	db "number of elements: %d", 10, 0
	sum:		db "Sum: %d", 10, 0
	min:		db "Min: %d", 10, 0
	max:		db "Max: %d", 10, 0

segment .bss
	myArray:	resd ARRAY_SIZE
	intInput:	resd 1

segment .text
	global		asm_main
	extern		printf, scanf

asm_main:
	enter		0, 0

	xor		r12, r12
	xor		r13, r13

	mov		rdi, myArray
	mov		rcx, ARRAY_SIZE

inputLoop:
	add		r12, 1
	push		rcx
	push		rdi
	mov		rdi, inputPrompt
	call		printf

	mov		rdi, intFormat
	mov		rsi, intInput
	call		scanf

	add		r13, [intInput]

	xor		rax, rax
	mov		eax, [intInput]
	pop		rdi
	stosd
	pop		rcx
	loop		inputLoop

	;;set up array access
	mov		rbx, myArray
	mov		rcx, r12

	;;set up max and min
	xor		r14, r14
	xor		r15, r15
	mov		r14, [rbx]
	mov		r15, [rbx]
minMaxLoop:
	push rcx
	push rsi

	;;printing
	mov		rdi, intOutput
	mov		rsi, [rbx]
	call		printf

	;;comparisons 
	cmp		[rbx], r14
	jns		returnMin
	mov		r14, [rbx]
returnMin:
	cmp		[rbx], r15
	js		returnMax
	mov		r15, [rbx]
returnMax:
	add		rbx, 4
	pop rsi
	pop rcx
	loop		minMaxLoop
	jmp		printStuff

printStuff:
	mov		rdi, numElements
	mov		rsi, r12
	call		printf

	mov		rdi, sum
	mov 		rsi, r13
	call		printf
	
	mov		rdi, min
	mov		rsi, r14
	call		printf

	mov		rdi, max
	mov		rsi, r15
	call 		printf

	mov		rax, 0
	leave
	ret
