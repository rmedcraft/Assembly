;;
;; file: asm_io.asm
;;   nasm -f elf64 -d ELF_TYPE asm_io.asm

%define NL 10
%define CF_MASK 0000000000000001h
%define PF_MASK 0000000000000004h
%define AF_MASK 0000000000000010h
%define ZF_MASK 0000000000000040h
%define SF_MASK 0000000000000080h
%define TF_MASK 0000000000000100h
%define IF_MASK 0000000000000200h
%define DF_MASK 0000000000000400h
%define OF_MASK 0000000000000800h

segment .data

int_format:	    db  "%i", 0
string_format:      db  "%s", 0
reg_format:
	db  "Register Dump # %d", NL
	db  "RAX = %.16lX RBX = %.16lX", NL
	db  "RCX = %.16lX RDX = %.16lX", NL
        db  "RSI = %.16lX RDI = %.16lX", NL
	db  "RBP = %.16lX RSP = %.16lX", NL
        db  "RIP = %.16lX FLAGS = %.4X %s %s %s %s %s %s %s %s %s", NL
	db  0
carry_flag:	    db  "CF", 0
parity_flag:	    db	"PF", 0
aux_carry_flag:	    db	"AF", 0
zero_flag:	    db  "ZF", 0
sign_flag:	    db  "SF", 0
trap_flag:          db  "TF", 0
interrupt_flag:     db  "IF", 0
dir_flag:	    db	"DF", 0
overflow_flag:	    db	"OF", 0


unset_flag:	    db	"  ", 0
mem_format1:        db  "Memory Dump # %ld Address = %.16X", NL, 0
mem_format2:        db  "%.16X ", 0
mem_format3:        db  "%.2X ", 0
stack_format:       db  "Stack Dump # %ld", NL
	            db  "RBP = %.16X RSP = %.16X", NL, 0
stack_line_format:  db  "%+4d  %.16X  %.16X", NL, 0
math_format1:       db  "Math Coprocessor Dump # %ld Control Word = %.4X"
                    db  " Status Word = %.4X", NL, 0
valid_st_format:    db  "ST%d: %.10g", NL, 0
invalid_st_format:  db  "ST%d: Invalid ST", NL, 0
empty_st_format:    db  "ST%d: Empty", NL, 0

;
; code is put in the _TEXT segment
;
segment .text

global  print_nl, sub_dump_regs, sub_dump_mem
global  sub_dump_math, sub_dump_stack
extern  scanf, printf, getchar, putchar


print_nl:
	enter	0,0
	pushf

	mov	rdi, 10
	call	putchar

	popf
	leave
	ret

sub_dump_regs:
	enter   16,0
	; ebp saved ebp
	; ebp-8 local 1
	; ebp-16 local 2
	push	rax
	push	rbx
	push	rcx
	push	rdx
	push	rdi
	push	rsi
	pushf
	mov     eax, [rsp]      ; read FLAGS back off stack
	mov	[rbp-8], rax    ; save flags

; show which FLAGS are set
;
	test	rax, CF_MASK
	jz	cf_off
	mov	rax, carry_flag
	jmp	short push_cf
cf_off:
	mov	rax, unset_flag
push_cf:
	push	rax

	test	dword [rbp-8], PF_MASK
	jz	pf_off
	mov	rax, parity_flag
	jmp	short push_pf
pf_off:
	mov	rax, unset_flag
push_pf:
	push	rax

	test	dword [rbp-8], AF_MASK
	jz	af_off
	mov	rax, aux_carry_flag
	jmp	short push_af
af_off:
	mov	rax, unset_flag
push_af:
	push	rax

	test	dword [rbp-8], ZF_MASK
	jz	zf_off
	mov	rax, zero_flag
	jmp	short push_zf
zf_off:
	mov	rax, unset_flag
push_zf:
	push	rax

	test	dword [rbp-8], SF_MASK
	jz	sf_off
	mov	rax, sign_flag
	jmp	short push_sf
sf_off:
	mov	rax, unset_flag
push_sf:
	push	rax

	test	dword [rbp-8], TF_MASK
	jz	tf_off
	mov	rax, trap_flag
	jmp	short push_tf


tf_off:
	mov	rax, unset_flag
push_tf:
	push	rax

	test	dword [rbp-8], IF_MASK
	jz	if_off
	mov	rax, interrupt_flag
	jmp	short push_if

if_off:
	mov	rax, unset_flag
push_if:
	push	rax

	test	dword [rbp-8], DF_MASK
	jz	df_off
	mov	rax, dir_flag
	jmp	short push_df

df_off:
	mov	rax, unset_flag
push_df:
	push	rax

	test	dword [rbp-8], OF_MASK
	jz	of_off
	mov	rax, overflow_flag
	jmp	short push_of
of_off:
	mov	rax, unset_flag
push_of:
	push	rax

	push    qword [rbp-8]   ; FLAGS
	mov	rax, [rbp+8]
	sub	rax, 13         ; EIP on stack is 13 bytes ahead of orig
	push	rax             ; EIP
	lea     rax, [rbp+16]
	push    rax             ; original ESP
	push    qword [rbp]     ; original EBP
        push    qword [rbp-56]	; original RDI
        push    qword [rbp-64]	; original RSI
	mov     r9, [rbp-48]	; original RDX
	mov	r8, [rbp-40]	; original RCX
	mov	rcx, [rbp-32]	; original RBX
	mov	rdx, [rbp-24]   ; original RAX
	mov	rsi, [rbp-56]   ; # of dump
	mov	rdi, reg_format
	call	printf
	add	rsp, 120
	popf
	pop	rsi
	pop	rdi
	add	rsp, 32

	leave
	ret

;; Need to fix
;; move 3 params from stack to rdi, rsi, rdx
;; dump_stack 1, 2, 4
;; %macro  dump_stack 3
;; mov	 rdi, qword %1 -- # of dump: 1
;; mov   rsi, qword %2 -- # of words to display: 2
;; mov	 rdx, qword %3 -- # of words above ebp: 4
;; call  sub_dump_stack
;; %endmacro
;; stack_format        db  "Stack Dump # %ld", NL
;; db  "RBP = %.16X RSP = %.16X", NL, 0
;; stack_line_format   db  "%+4d  %.16X  %.16X", NL, 0

sub_dump_stack:
	enter   24,0
	pushf
;; EBP: saved EBP
;; EBP-8:
;; EBP-16:
;; EBP-24:

	mov	[rbp-8], rdx 	; # dwords above ebp to display
	mov	[rbp-16], rsi   ; # dwords to display
	mov	[rbp-24], rdi	; dump ID #


	lea     rcx, [rbp+16]        ; original ESP before call
	mov     rdx, [rbp]           ; original EBP
	mov	rsi, rdi             ; # of dump 1
	mov	rdi, stack_format
	call	printf

	mov	rbx, [rbp]	; rbx = original ebp
	mov	rax, [rbp-8]    ; rax = # dwords above ebp
	shl	rax, 2          ; rax *= 4
	add	rbx, rax	; rbx = & highest dword in stack to display
	mov	rdx, [rbp-8]
	mov	rcx, rdx
	add	rcx, [rbp-16]
	inc	rcx		; rcx = # of dwords to display
stack_line_loop:
	push	rdx
	push	rcx		; save ecx & edx

	mov	rdi, stack_line_format

	mov	rax, rdx
	sal	rax, 2		; eax = 4*edx
	mov	rsi, rax	; offset from ebp

	mov	rdx, rbx	; address of value on stack

	mov	rcx, [rbx]	; value on stack

	call	printf

	pop	rcx
	pop	rdx

	sub	rbx, 4
	dec	rdx
	loop	stack_line_loop

	popf
	leave
	ret

;; Need to fix
;; move 3 params from stack to rdi, rsi, rdx
;; rdi - label
;; rsi - start address
;; rdx - # paragraphs
;; mem_format1         db  "Memory Dump # %d Address = %.8X", NL, 0
;; mem_format2         db  "%.16X ", 0
;; mem_format3         db  "%.2X ", 0
;;
;; called: dump_mem 2, outmsg1, 1
;; usage: dump_mem label, start-address, # paragraphs
;%macro  dump_mem 3
;	mov	 rdi, qword %1 ; label
;	mov	 rsi, qword %2 ; start-address
;	mov	 rdx, qword %3 ; paragraphs
;	call	 sub_dump_mem
;%endmacro

sub_dump_mem:
	enter	24,0
	push	rbx		; ebp-36
	pushf			; ebp-64

	mov	[rbp-8], rdi	; label
	mov	[rbp-16], rsi	; start-address
	mov	[rbp-24], rdx	; paragraphs
	mov	rdx, rsi
	mov	rsi, rdi
	mov	rdi, mem_format1
	call	printf

	mov	rsi, [rbp-16]      ; address
	and	rsi, 0FFFFFFFFFFFFFFF0h    ; move to start of paragraph
	mov	rcx, [rbp-24]
	inc	rcx
mem_outer_loop:
	push	rsi
	mov	rdx, rcx
	mov	rdi, qword mem_format2
	call	printf
	pop	rsi

	xor	rbx, rbx
mem_hex_loop:
	push	rsi
	xor	rax, rax
	mov	al, [rsi + rbx]
	mov	rsi, rax
	mov	rdi, qword mem_format3
	call	printf
	pop	rsi

	inc	rbx
	cmp	rbx, 16
	jl	mem_hex_loop

	push	rsi
	mov	rdi, '"'
	call	putchar
	pop	rsi
	xor	rbx, rbx
mem_char_loop:
	xor	rax, rax
	mov	al, [rsi+rbx]
	cmp	al, 32
	jl	non_printable
	cmp	al, 126
	jg	non_printable
	mov	rdi, rax
	jmp	mem_char_loop_continue
non_printable:
	mov	rdi, '?'
mem_char_loop_continue:
	push	rsi
	call	putchar
	pop	rsi

	inc	rbx
	cmp	rbx, 16
	jl	mem_char_loop

	mov	rdi, '"'
	push	rsi
	call	putchar
	call	print_nl
	pop	rsi

	add	rsi, 16
	pop	rcx
	dec	rcx
	jnz	mem_outer_loop

	popf
	pop	rbx
	leave
	ret

; function sub_dump_math
;   prints out state of math coprocessor without modifying the coprocessor
;   or regular processor state
; Parameters:
;  dump number - dword at RDI
; Local variables:
;   ebp-108 start of fsave buffer
;   ebp-116 temp double
; Notes: This procedure uses the Pascal convention.
;   fsave buffer structure:
;   ebp-108   control word
;   ebp-104   status word
;   ebp-100   tag word
;   ebp-80    ST0
;   ebp-70    ST1
;   ebp-60    ST2 ...
;   ebp-10    ST7
	;
;; Need to fix - DONE?
;; move one param from stack to rdi

sub_dump_math:
	enter	116,0
	push	rbp
	push	rdi
	push	rsi
	pushf

	fsave	[rbp-108]	; save coprocessor state to memory
	mov	rax, [rbp-104]  ; status word
	and	rax, 0FFFFh
	mov	rcx, rax
	mov	rax, [rbp-108]  ; control word
	and	rax, 0FFFFh
	mov	rdx, rax
	mov	rsi, rdi
	mov	rdi, math_format1
	call	printf
;
; rotate tag word so that tags in same order as numbers are
; in the stack
;
	mov	cx, [rbp-104]	; ax = status word
	shr	cx, 11
	and	cx, 7           ; cl = physical state of number on stack top
	mov	bx, [rbp-100]   ; bx = tag word
	shl     cl,1		; cl *= 2
	ror	bx, cl		; move top of stack tag to lowest bits

	mov	rdi, 0		; edi = stack number of number
	lea	rsi, [rbp-80]   ; esi = address of ST0
	mov	rcx, 8          ; ecx = loop counter
tag_loop:
	push	rcx
	mov	ax, 3
	and	ax, bx		; ax = current tag
	or	ax, ax		; 00 -> valid number
	je	valid_st
	cmp	ax, 1		; 01 -> zero
	je	zero_st
	cmp	ax, 2		; 10 -> invalid number
	je	invalid_st
	mov	rsi, rdi        ; 11 -> empty
	mov	rdi, dword empty_st_format
	call	printf

	jmp	short cont_tag_loop
zero_st:
	fldz
	jmp	short print_real
valid_st:
	fld	tword [rsi]
print_real:
	fstp	qword [rbp-116]
	mov	rcx, [rbp-112]
	mov	rdx, [rbp-116]
	mov	rsi, rdi
	mov	rdi, dword valid_st_format
	call	printf

	jmp	short cont_tag_loop
invalid_st:
	mov	rsi, rdi
	mov	rdi, dword invalid_st_format
	call	printf

cont_tag_loop:
	ror	bx, 2		; mov next tag into lowest bits
	inc	rdi
	add	rsi, 10         ; mov to next number on stack
	pop	rcx
	loop    tag_loop

	frstor	[rbp-108]       ; restore coprocessor state
	popf
	pop	rsi
	pop	rdi
	pop	rbp
	leave
	ret
