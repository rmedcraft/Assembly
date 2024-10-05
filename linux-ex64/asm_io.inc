extern  print_nl, sub_dump_regs, sub_dump_mem, sub_dump_math, sub_dump_stack

%macro dump_regs 1
	mov	  rdi, qword %1
	call	  sub_dump_regs
%endmacro


;;
;; usage: dump_mem label, start-address, # paragraphs
%macro  dump_mem 3
	mov	 rdi, qword %1 ; label
	mov	 rsi, qword %2 ; start-address
	mov	 rdx, qword %3 ; paragraphs
	call	 sub_dump_mem
%endmacro

%macro	dump_math 1
	mov	 rdi, qword %1
	call	 sub_dump_math
%endmacro

;;
;; usage: dump_stack dump-#, start-address, # paragraphs
%macro  dump_stack 3
	mov	 rdi, qword %1 ; # of dump
        mov      rsi, qword %2 ; # of words to display
	mov	 rdx, qword %3 ; # of words above ebp
        call     sub_dump_stack
%endmacro
