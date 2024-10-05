;;; Rowan Medcraft
;;; CPSC 232
;;; PA02-ValueExpressions
;;; file: simpleMath.asm
;;; Calculates math equations

segment .data
	output1: db "Answer 1: %d",10,0
	output2: db "Answer 2: %d",10,0

segment .text
global asm_main
extern printf
asm_main: 
	enter	0,0
	;; equation 1
	;; adds 68 + 3
	mov	ax, 68
	mov	bx, 3
	add	ax, bx
	
	;; multiplies 4 x (68 + 3)
	mov	bx, 4
	mul	bx

	movzx	r12, ax			;stores ax (68 + 3) in r12
					; movzx for moving a smaller thing into a larger register
					; movsx is for moving negative numbers
	
	;; multiplies 19 x 6
	mov	ax, 19
	mov	bx, 6
	mul	bx
	
	movzx	r13, ax			;stores ax (19 x 6) in r13
	
	;; adds (19 x 6) + (4 x (68 + 3))
	mov 	rax, r12
	mov	rbx, r13
	add	rax, rbx

	mov 	r12, rax

	;; multiplies 22 x 5
	mov	ax, 22
	mov	bx, 5
	mul	bx

	movzx	r13, ax	

	;; Subtract ((19 x 6) + (4 x (68 + 3))) - (22 x 5)	
	
	mov	rax, r12
	mov	rbx, r13
	sub	rax, rbx

	;; prints answer1
	mov	rsi, rax
	mov	rdi, output1
  	call	printf

	;; equation 2
	

	;; multiplies 3 x 2
	xor	rax, rax
	xor	rbx, rbx
	mov	ax, 3
	mov	bx, 2
	mul	bx

	;; adds (3 x 2) + 91
	add	ax, 91

	;; multiply (3 × 2 + 91) × 17
	mov	bx, 17
	mul	bx
	
	mov 	r12, rax

	;; divide 42 / 7
	mov	ax, 42
	mov	bx, 7
	div	bx

	;; add (42 / 7) + ((3 × 2 + 91) × 17)
	mov	rbx, r12
	add	rax, rbx

	;; add ((42 / 7) + ((3 × 2 + 91) × 17)) + 2
	add	rax, 2
	
	;; prints answer1
	mov	rsi, rax
	mov	rdi, output2
  	call	printf

	mov	rax, 0
	leave
	ret