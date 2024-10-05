;;; Rowan Medcraft
;;; CPSC 232
;;; PA01-Hello World
;;; file: helloWorld.asm
;;; Hello world, in assembly...
segment .data
	mesg: db "Hello Assembly World!",10,0
segment .text
	global asm_main
	extern printf
asm_main:
	enter 0,0
	mov rdi, mesg
	call printf

	mov rax, 0
	leave
	ret