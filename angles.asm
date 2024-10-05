;;; Rowan Medcraft
;;; CPSC 232
;;; PA02-ValueExpressions
;;; file: angles.asm
;;; Calculates which quadrant a given angle is in

segment .data
	mesg: db "Please enter an angle from 0-360: ",0
	onAxis: db "Your angle falls on an axis. ",10,0
	quad1: db "Your angle is in quadrant: I",10,0
	quad2: db "Your angle is in quadrant: II",10,0
	quad3: db "Your angle is in quadrant: III",10,0
	quad4: db "Your angle is in quadrant: IV",10,0
	error: db "Your value should be between 0 and 360.",10,0
	intInput: db "%d",0

segment .bss
	input: resd 1

segment .text
	global asm_main
	extern printf, scanf

asm_main:
	enter	0,0

mainLoop: 
	;prompt user to enter a number
	mov	rdi, mesg
	call	printf

	;read number from the user
	mov	rdi, intInput
	mov	rsi, input
	call	scanf

	;stores the user input in rbx
	mov	rbx, [input]
	
	;check if the value is on an axis
	cmp	rbx, 0
	je	axis
	cmp	rbx, 90
	je	axis
	cmp	rbx, 180
	je	axis
	cmp	rbx, 270
	je	axis
	cmp	rbx, 360
	je	axis

	;check if the value is below 0, checks if greater than 360 later in the program
	cmp	rbx, 0
	jl	outOfRange

	;check if the value is greater than 0
	cmp	rbx, 0
	jg	quadrant1
	
	
axis: 
	mov	rdi, onAxis
	call	printf
	jmp	mainLoop

outOfRange:
	mov	rdi, error	;prints if below 0 or above 360
	call	printf
	jmp 	getOut
	
quadrant1:
	cmp	rbx, 90 	;checks if the value is larger than quad 2
	jg	quadrant2	;goes to quad 2 if its outside of quad 1
	
	mov	rdi, quad1	;otherwise prints quad 1
	call	printf		
	jmp	mainLoop	;leave program
quadrant2:
	cmp	rbx, 180	;checks if the value is larger than quad 2
	jg	quadrant3	;goes to quad 3 if its outside of quad 2

	mov	rdi, quad2	;otherwise prints quad 2
	call	printf
	jmp	mainLoop	;leave program
quadrant3:
	cmp	rbx, 270	;checks if the value is larger than quad 3
	jg	quadrant4	;goes to quad 4 if its outside of quad 3

	mov	rdi, quad3	;otherwise prints quad 3
	call	printf
	jmp	mainLoop	;leave program
quadrant4:
	cmp	rbx, 360	;checks if the value is larger than quad 4
	jg	outOfRange	;prints an error if larger than 360

	mov	rdi, quad4	;otherwise prints quad 4
	call	printf
	jmp	mainLoop	;leave program

getOut:
	mov	rax, 0		;exits the program, this is just so I dont have to keep repeating these 3 lines
	leave
	ret
