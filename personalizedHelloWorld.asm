;;; Rowan Medcraft
;;; CPSC 232
;;; PA04 - Personalized Hello World
;;; file: personalizedHelloWorld.asm
;;; Hello world with subprograms & parameters
segment .data
	mesg: db "Hello, %s, Welcome to Assembly World!",10,0
	prompt: db "Please enter your first name: ",0
	inputStr: db "%s",0

segment .bss
	input: resd 1

segment .text
	global asm_main
	extern printf, scanf

asm_main:
	enter 	0,0

	mov 	rdi, prompt 	; prints the prompt for the user
	call 	printf

	mov 	rsi, input	; stores the address of the string in input
	mov	rdi, inputStr	; stores the string in inputStr (not sure if needed)
	call 	scanf
	
	mov	rsi, input	; input is the address of the input string
	call	printGreeting	; rsi is passed as a parameter to printGreeting

	mov 	rax, 0		; returns back to C
	leave
	ret

printGreeting:
	enter	0,0
	
	mov	rdi, mesg	; input is already in rsi
	call 	printf
	
	leave			; returns back to asm_main
	ret