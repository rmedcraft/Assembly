;;
;; file: big_math.asm
;; Defines asm routines that add and subtract Big_ints
;; There is a lot of common code between the add and subtract routines.
;;
;; To build:
;; GCC:   nasm -f elf64 big_math.asm
;;        g++ -no-pie -o test_big_int big_math.o big_int.cpp test_big_int.cpp
;;

segment .data

segment .bss

segment .text
global  add_big_ints, sub_big_ints

;; A Big_int class is represented by a struct with a unsigned DWORD named
;; size_ and a DWORD pointer named number_. An instance looks like:
;;  +---------+
;;  | size_   |  offset = 0
;;  +---------+
;;  | number_ |  offset = 8
;;  +---------+
;;
%define size_offset 0
%define number_offset 8

%define EXIT_OK 0
%define EXIT_OVERFLOW 1
%define EXIT_SIZE_MISMATCH 2

;; int add_big_ints(Big_int & result, const Big_int & op1, const Big_int & op2);
;; result is RDI
;; op1 is    RSI
;; op2 is    RDX
;;
add_big_ints:
	enter	0,0
        push    rbx
	push	rdi
        push    rsi
        push    rdx

;; make sure that all 3 Big_int's have the same size
;;
        mov     rax, [rsi + size_offset]
        cmp     rax, [rdx + size_offset]
        jne     sizes_not_equal                 ; op1.size_ != op2.size_
        cmp     rax, [rdi + size_offset]
        jne     sizes_not_equal                 ; op1.size_ != res.size_

        mov     rcx, rax                        ; ecx = size of Big_int's

;; now, set registers to point to their respective arrays
;;      rsi = op1.number_
;;      rdi = op2.number_
;;      rbx = res.number_
;;
        mov     rdi, [rdi + number_offset]
        mov     rsi, [rsi + number_offset]
        mov     rdx, [rdx + number_offset]

        clc                                     ; clear carry flag
        xor     rbx, rbx                        ; edx = 0
	xor	rax, rax

;; addition loop
;;
add_loop:
        mov     eax, [rsi+4*rbx]
        adc     eax, [rdx+4*rbx]
        mov     [rdi + 4*rbx], eax
        inc     rbx                             ; does not alter carry flag
        loop    add_loop

        jc      overflow
ok_done:
        xor     rax, rax                        ; return value = EXIT_OK
        jmp     done
overflow:
        mov     rax, EXIT_OVERFLOW
        jmp     done
sizes_not_equal:
        mov     rax, EXIT_SIZE_MISMATCH
done:
        pop     rdx
        pop     rsi
	pop	rdi
        pop     rbx
        leave
        ret

;; int sub_big_ints(Big_int & res, const Big_int & op1, const Big_int & op2);
;; Computes res = op1 - op2
;; This routine uses some of the add_big_ints routine code!
;; res at  RDI
;; op1 at  RSI
;; op2 at  RDX
;;
sub_big_ints:
	enter	0,0
	push    rbx
	push	rdi
	push	rsi
        push    rdx

;; make sure that all 3 Big_int's have the same size
;;
        mov     rax, [rsi + size_offset]
        cmp     rax, [rdx + size_offset]
        jne     sizes_not_equal
        cmp     rax, [rdi + size_offset]
        jne     sizes_not_equal

        mov     rcx, rax

;; now, point registers to point to their respective arrays
;;      rsi = op1.number_
;;      rdi = op2.number_
;;      rbx = res.number_
;;
        mov     rdi, [rdi + number_offset]
        mov     rsi, [rsi + number_offset]
        mov     rdx, [rdx + number_offset]

        clc
        xor     rbx, rbx
	xor	rax, rax

;; subtraction loop
;;
sub_loop:
        mov     eax, [rsi+4*rbx]
        sbb     eax, [rdx+4*rbx]
        mov     [rdi + 4*rbx], eax
        inc     rbx
        loop    sub_loop

        jnc     ok_done
        jmp     overflow
