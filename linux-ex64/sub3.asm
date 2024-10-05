;;
;; file: sub3.asm
;; Subprogram example program
;;
;; To create executable:
;; Using gcc:
;; nasm -f elf64 sub3.asm
;; gcc -no-pie -o sub1 sub3.o driver.c
;;

segment .data
sum:         dd 0
intFormat:   db "%d",0
intFormatNL: db "%d",10,0

segment .bss
input:       resd 1

;;
;; psuedo-code algorithm
;; i = 1;
;; sum = 0;
;; while( get_int(i, &input), input != 0 ) {
;;   sum += input;
;;   i++;
;; }
;; print_sum(num);

segment .text
global  asm_main
extern printf, scanf

asm_main:
        enter   0,0               ; setup routine

        mov     rdx, 1            ; edx is 'i' in pseudo-code
while_loop:
        mov	rsi, rdx 	  ; paramter i (number of input)
        mov     rdi, input        ; parameter address of input
        call    get_int

        mov     rax, [input]
        cmp     rax, 0
        je      end_while

        add     [sum], rax        ; sum += input

        inc     rdx
        jmp     short while_loop

end_while:
	xor	rdi, rdi
        mov	edi, dword [sum]  ; push value of sum onto stack
        call    print_sum

        leave
        ret

;;
;; subprogram get_int
;; Parameters (in order pushed on stack)
;;   number of input (in rsi )
;;   address of word to store input into (in rdi )
segment .data
prompt:  db      "%d) Enter an integer number (0 to quit): ", 0

segment .text
get_int:
	enter	0,0
	push	rdi
	push	rsi

        mov     rdi, prompt
        call    printf

	pop	rsi
	pop	rdi
	push	rdi
	push	rsi
	mov	rsi, rdi
	mov	rdi, intFormat
        call    scanf

	pop	rsi
	pop	rdi

        leave
        ret                        ; jump back to caller

;; subprogram print_sum
;; prints out the sum
;; Parameter:
;;   sum to print out (in rdi)
;;
segment .data
result:  db      "The sum is %d", 10, 0

segment .text
print_sum:
	enter	0,0
	push	rdi
	push	rsi

	mov	rsi, rdi
        mov     rdi, result
        call    printf
	pop	rsi
	pop	rdi
	
        leave
        ret
