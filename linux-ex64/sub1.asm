;;
;; file: sub1.asm
;; Subprogram example program
;; This version jumps to get_int, sub2 calls get_int
;;
;; To create executable:
;; nasm -f elf64 sub1.asm
;; gcc -no-pie -o sub1 sub1.o driver.c
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
	mov	rcx, ret1
        jmp	short get_int     ; read integer

ret1:
        mov     rdi, prompt2      ; print out prompt
        call    printf

        mov     rdi, input2
	mov	rcx, $ + 12	  ; rcx = this address ($) + 12 bytes
	jmp	short get_int

ret2:
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
;;   rdi - address of dword to store integer into
;;   rbx - return address
get_int:
	push	rcx		  ; save rcx across scanf call
	mov	rsi, rdi	  ; move variable to rsi
        mov     rdi, intFormat    ; input format for scanf
        call    scanf
	pop	rcx
	jmp	rcx

