;;
;; file: main4.asm
;; Multi-module subprogram example program
;;
;; To create executable:
;; nasm -f elf64 sub4.asm
;; nasm -f elf64 main4.asm
;; gcc -no-pie -o sub4 sub4.o main4.o driver.c
;;

segment .data
sum:     dd   0

segment .bss
input:   resd 1

;
; psuedo-code algorithm
; i = 1;
; sum = 0;
; while( get_int(i, &input), input != 0 ) {
;   sum += input;
;   i++;
; }
; print_sum(num);

segment .text
global  asm_main
extern  get_int, print_sum
asm_main:
        enter   0,0               ; setup routine

        mov     rdx, 1            ; rdx is 'i' in pseudo-code
while_loop:
	push	rdx
        mov	rsi, rdx               ; second param i to rsi
        mov	rdi, qword input       ; put address in get_int param rdi
        call    get_int

        mov     rax, [input]
        cmp     rax, 0
        je      end_while

        add     [sum], rax        ; sum += input

	pop	rdx
        inc     rdx
        jmp     short while_loop

end_while:
	xor	rdi, rdi
        mov     edi, dword [sum]
        call    print_sum

        leave                     
        ret




