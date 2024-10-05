;;
;; file: math.asm
;; This program demonstrates how the integer multiplication and division
;; instructions work.
;
;; To create executable:
;; nasm -f elf64 math.asm
;; gcc -no-pie -o math math.o driver.c

segment .data
;;
;; Output strings
;;
prompt:          db    "Enter a number: ", 0
square_msg:      db    "Square of input is %d",10 , 0
cube_msg:        db    "Cube of input is %d",10 , 0
cube25_msg:      db    "Cube of input times 25 is %d",10 , 0
quot_msg:        db    "Quotient of cube/100 is %d",10 , 0
rem_msg:         db    "Remainder of cube/100 is %d",10 , 0
neg_msg:         db    "The negation of the remainder is %d",10 , 0
intFormat:       db    "%d",0

segment .bss
input:   resd 1


segment .text
global  asm_main
extern  printf, scanf
asm_main:
        enter   0,0               ; setup routine
	push	rbx

        mov     rdi, prompt
        call    printf

	mov	rdi, intFormat
	mov	rsi, input
        call    scanf
	mov	rax, [input]

	xor	rdx, rdx
        imul    rax               ; rdx:rax = rax * rax
	mov	rbx, rax	  ; save in rbx (protected accross call)
        mov     rsi, rax
        mov     rdi, square_msg
        call    printf
	;mov	rax, rbx
	
        ;mov     rbx, rax
        imul    rbx, [input]      ; rbx *= [input]
	mov	rsi, rbx
        mov     rdi, cube_msg
        call    printf

        imul    rsi, rbx, 25      ; rsi = ebx*25
	push	rsi
        mov     rdi, cube25_msg
        call    printf

        pop	rax
        cdq                       ; initialize edx by sign extension
        mov     rcx, 100          ; can't divide by immediate value
        idiv    rcx               ; rdx:rax / rcx
        mov     rcx, rax          ; save quotient into rcx
        mov     rdi, quot_msg
	mov	rsi, rcx
	push	rdx
        call    printf
	pop	rdx
	push	rdx
	
        mov     rdi, rem_msg
	mov	rsi, rdx
        call    printf

        pop	rdx
        neg     rdx               ; negate the remainder
	mov	rsi, rdx
        mov     rdi, neg_msg
        call    printf

        pop	rbx
        mov     rax, 0            ; return back to C
        leave                     
        ret






