;;
;; file: sub5.asm
;; Subprogram to C interfacing example
;; To build:
;; GCC:   nasm -f elf64 sub5.asm
;;        gcc -no-pie -o sub5 main5.c sub5.o asm_io.o
;;

%include "asm_io.inc"

;; subroutine calc_sum
;; finds the sum of the integers 1 through n
;; Parameters:
;;   n    - what to sum up to (at [rbp + 16]) rdi
;;   sump - pointer to int to store sum into (at [rbp + 24]) rsi
;; pseudo C code:
;; void calc_sum( int n, int * sump )
;; {
;;   int i, sum = 0;
;;   for( i=1; i <= n; i++ )
;;     sum += i;
;;   *sump = sum;
;; }
;;

segment .text
global  calc_sum
;;
;; local variable:
;;   sum at [ebp-4]
calc_sum:
        enter   4,0               ; allocate room for sum on stack
        push    rbx               ; IMPORTANT!
	push	rdi		  ; preserve rdi
	push	rsi		  ; preserve rsi

;; Print stack 4 words above and
;; 2 words below EBP (EBP+16 to EBP-8)

        mov     dword [rbp-4], 0   ; sum = 0
;; dump_stack dump#, # words, words above rbp

        dump_stack 1, 7, 1        ; print out stack from rbp-8 to rbp+8
        mov     rcx, 1            ; ecx is i in pseudocode %BREAK
	pop	rsi		  ; restore rsi
	pop	rdi		  ; restore rdi
for_loop:
        cmp     rcx, rdi          ; cmp i and n
        jnle    end_for           ; if not i <= n, quit

        add     [rbp-4], ecx      ; sum += i
        inc     rcx
        jmp     short for_loop

end_for:
        mov     eax, [rbp-4]      ; rax = sum  %BREAK
        mov     [rsi], eax	  ; return sum (pass by reference)

        pop     rbx               ; restore ebx
        leave
        ret
