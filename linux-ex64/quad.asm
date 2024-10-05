;;
;; file: quad.asm
;;
;; To create executable:
;; nasm -f elf64 quad.asm
;; gcc -no-pie -o quadt quad.o quadt.c
;;
;; function quadratic
;; finds solutions to the quadratic equation:
;;       a*x^2 + b*x + c = 0
;;	( -b +/- sqrt(b*b-4*a*c) ) / (2*a) )
;; C prototype:
;;   int quadratic( double a, double b, double c,
;;                  double * root1, double *root2 )
;; Parameters:
;;   a, b, c - coefficients of powers of quadratic equation (see above)
;;   root1   - pointer to double to store first root in
;;   root2   - pointer to double to store second root in
;; Return value:
;;   returns 1 if real roots found, else 0
;;


%define a               qword [rbp-8]
%define b               qword [rbp-16]
%define c               qword [rbp-24]
%define root1           dword [rbp-32]
%define root2           dword [rbp-40]
%define disc            qword [rbp-48]
%define one_over_2a     qword [rbp-56]

segment .data
MinusFour:       dq      -4.0
one:             dq       1.0
minusOne:        dq      -1.0

segment .bss
;disc:            resq     1
;one_over_2a:     resq     1

segment .text
global  quadratic
quadratic:
	enter	56,0
        push    rbx                ; must save original ebx
	movsd	a, xmm0
	movsd	b, xmm1
	movsd	c, xmm2

;;	( -b +/- sqrt(b*b-4*a*c) ) / (2*a) )
	mulsd	xmm1, xmm1	    ; b*b
	movsd	xmm3,  [MinusFour]
	mulsd	xmm3, xmm0	    ; -4*a
	mulsd	xmm3, xmm2	    ; -4*a*c

	addsd	xmm3, xmm1	    ; b*b-4*a*c
        ftst                        ; test with 0
        fstsw   ax
        sahf
        jb      no_real_solutions ; if disc < 0, no real solutions
	sqrtsd	xmm3, xmm3	    ; sqrt(b*b-4*a*c)

	movsd	disc, xmm3	    ; disc=sqrt(b*b-4*a*c)
	movsd	xmm1, b
	subsd	xmm3, xmm1	    ; -b+sqrt(b*b-4*a*c)

	addsd	xmm0, xmm0	    ; 2*a
	movsd	xmm2, [one]
	divsd	xmm2, xmm0	    ; 1/(2*a)
	movsd	one_over_2a, xmm2 ; store 1/(2*a)
	mulsd	xmm3, xmm2	    ; (-b+sqrt(b*b-4*a*c))/2a
	movq	rbx, xmm3
	mov	[rdi], rbx	    ; store to root1

	movsd	xmm1, b
	movsd	xmm2, disc
	movsd	xmm5, [minusOne]
	mulsd	xmm1, xmm5
	subsd	xmm1, xmm2	   ; -b-sqrt(b*b-4*a*c)
	movsd	xmm0, one_over_2a
	mulsd	xmm1, xmm0	   ; (-b-sqrt(b*b-4*a*c))/2a
	movq	rbx, xmm1
	mov	[rsi], rbx	   ; store to root2

	mov	rax, 1
	jmp	short quit

no_real_solutions:
        mov     rax, 0          ; return value is 0

quit:
        pop     rbx
	leave
        ret
