;;
;; file: sub2.asm
;; Subprogram example program
;; This version calls get_int, sub2 jumps to get_int
;;
;; To create executable:
;; nasm -f elf64 sub2.asm
;; gcc -no-pie -o sub1 sub2.o driver.c
;;

segment .data
prompt1: db    "Enter a number: ", 0       ; don't forget nul terminator
prompt2: db    "Enter another number: ", 0
outmsg1: db    "You entered %d and %d, the sum of these is %d",10,0
intFormat: db  "%d",0

segment .bss
;;
;; These labels refer to double words used to store the inputs
;;
input1:  resd 1
input2:  resd 1

segment .text
global  asm_main
extern printf, scanf
asm_main:
        enter   0,0               ; setup routine
        push	rbx

        mov     rdi, prompt1      ; print out prompt
        call    printf

        mov     rdi, input1       ; store address of input1 into ebx
        call    get_int           ; read integer

        mov     rdi, prompt2      ; print out prompt
        call    printf

        mov     rdi, input2
        call    get_int

        mov     rax, [input1]     ; rax = dword at input1
        add     rax, [input2]     ; rax += dword at input2
;;
;; next print out result message as series of steps
;;

        mov     rdi, outmsg1
	mov	rsi, [input1]
	mov	rdx, [input2]
	mov	rcx, rax
        call    printf            ; print out first message

        pop	rbx
        mov     rax, 0            ; return back to C
        leave
        ret
;;
;; subprogram get_int
;; Parameters:
;;   rdi - address of word to store integer into
get_int:
	enter	0,0
	push	rbx

	mov	rsi, rdi
	mov	rdi, intFormat
        call    scanf

	pop	rbx
	leave
        ret                        ; jump back to caller
