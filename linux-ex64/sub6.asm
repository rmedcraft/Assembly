;;
;; file: sub6.asm
;; Subprogram to C interfacing example
;;
;; To build:
;; GCC:   nasm -f elf64 sub6.asm
;;        gcc -no-pie -o sub6 main6.c sub6.o
;;
;; subroutine calc_sum
;; finds the sum of the integers 1 through n
;; Parameters:
;;   n    - what to sum up to (at [ebp + 8])
;; Return value:
;;   value of sum
;; pseudo C code:
;; int calc_sum( int n )
;; {
;;   int i, sum = 0;
;;   for( i=1; i <= n; i++ )
;;     sum += i;
;;   return sum;
;; }
;;


segment .text
        global  calc_sum
;
; local variable:
;   sum at [ebp-4]
calc_sum:
        enter   16,0               ; make room for sum on stack

        mov     dword [rbp-8],0   ; sum = 0
        mov     rcx, 1            ; ecx is i in pseudocode
for_loop:
        cmp     rcx, rdi      ; cmp i and n
        jnle    end_for           ; if not i <= n, quit

        add     [rbp-8], rcx      ; sum += i
        inc     rcx
        jmp     short for_loop

end_for:
        mov     rax, [rbp-8]      ; eax = sum

        leave
        ret




