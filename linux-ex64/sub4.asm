;;
;; file: sub4.asm
;; Subprogram example

;;
;; subprogram get_int
;; Parameters (in order)
;;   address of word to store input into (in RDI)
;;   number of input (in RSI)
;;
;; To create executable:
;; nasm -f elf64 sub4.asm
;; nasm -f elf64 main4.asm
;; gcc -no-pie -o sub4 sub4.o main4.o driver.c
;;

segment .data
prompt:  db      ") Enter an integer number (0 to quit): ", 0
intFormat:  db   "%d",0

segment .bss
input: resd 1
 

segment .text
global  get_int, print_sum
extern printf, scanf
get_int:
        enter   0,0
	push	rdi

        mov     rdi, intFormat
        call    printf

        mov     rdi, prompt
        call    printf

	mov	rdi, intFormat
	pop	rsi
        call    scanf

        leave
        ret                        ; jump back to caller

;; subprogram print_sum
;; prints out the sum
;; Parameter:
;;   sum to print out (at [ebp+8]) rdi
;; Note: destroys value of eax
;;
segment .data
result:  db      "The sum is %d",10,0

segment .text
print_sum:
        enter   0,0

	mov	rsi, rdi
        mov     rdi, result
        call    printf

        leave
        ret






