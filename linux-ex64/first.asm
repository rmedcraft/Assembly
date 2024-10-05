;;
;; file: first.asm
;; First assembly program. This program asks for two integers as
;; input and prints out their sum.
;; Uses demp_regs and dump_mem from asm_io
;;
;; Using Linux and gcc:
;; nasm -f elf64 first.asm
;; gcc -no-pie -o first first.o driver.c asm_io.o
;;

%include "asm_io.inc"
;
; initialized data is put in the .data segment
;
segment .data
;
; These labels refer to strings used for output
;
prompt1:   db  "Enter a number: ", 0       ; don't forget nul terminator
prompt2:   db  "Enter another number: ", 0
outmsg1:   db  "You entered %d and %d, the sum of these is %d", 10, 0
intFormat: db  "%d",0


;;
;; uninitialized data is put in the .bss segment
;;
segment .bss
;;
;; These labels refer to double words used to store the inputs
;;
input1:  resd 1
input2:  resd 1

;;
;; code is put in the .text segment
;;
segment .text
global  asm_main
extern printf, scanf

asm_main:
        enter   0,0               ; setup routine

        mov     rdi, prompt1      ; print out prompt
        call    printf

	mov	rdi, intFormat
	mov	rsi, input1
        call    scanf             ; read integer

        mov     rdi, prompt2      ; print out prompt
        call    printf

	mov	rdi, intFormat
	mov	rsi, input2
        call    scanf             ; read integer

        mov     rax, [input1]     ; eax = dword at input1
        add     rax, [input2]     ; eax += dword at input2
        mov     rbx, rax          ; ebx = eax
        dump_regs 1               ; dump out register values
        dump_mem 2, outmsg1, 1    ; dump out memory
;;
;; next print out result message as series of steps
;;

        mov     rdi, outmsg1
        mov     rsi, [input1]
        mov     rdx, [input2]
        mov     rcx, rbx
        call    printf            ; print out first message

        mov     rax, 0            ; return back to C
        leave
        ret
