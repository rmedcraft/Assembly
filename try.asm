;;; Abdul Khayyam Shaikh
;;; Programming Assignment 3
;;; File: 
;;; Date:
;;; Objective


section .data


prompt db "Please enter an angle between 0 and 360: ",0
intInput db "%d",0
errormsg db "Invalid input. Angle must be between 0 and 360.",10,0
axismsg db "The angle is located on an axis and not in a quadrant.",10,0
quad1 db "I",10,0
quad2 db "II',10,0
quad3 db "III",10,0
quad4 db "IV",10,0


section .bss
input resd 1

section .text
global asm_main
extern printf, scanf
asm_main:
	enter	0,0
	
	;; start of code
	
	mov	rdi, prompt
	call	printf
	
	;; stores num into input
	mov	rdi, intInput
	mov 	rsi, input
	call	scanf
	
	;; move value at mem loc input to rax
	
	mov	rax, [input]
	
	cmp	rax, 0
	jl	error
	
	cmp	rax, 360
	jg	error
axis:
	mov	rdi, axismsg
	call	printf
	jmp	asm_main
Q1:
	cmp	rax, 90
	jg	Q2
	
	mov	rdi, quad1
	call	printf
	jmp	asm_main
Q2:
	cmp	rax, 180
	jg	Q3
	
	mov	rdi, quad2
	call	printf
	jmp	asm_main

Q3:
	cmp	rax, 270
	jg	Q4
	
	mov	rdi, quad3
	call	printf
	jmp	asm_main

Q4:
	cmp	rax, 360
	jg	error
	
	mov	rdi, quad4
	call	printf
	jmp	asm_main
	
	
error:	
	mov	rdi, errormsg
	call	printf		
	
	leave
	ret
