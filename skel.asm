;; Rowan Medcraft
;; CPSC 232
;; 
;; file: skel.asm
;; This file is a skeleton that can be used to start assembly programs.

segment .data
;
; initialized data is put in the data segment here
;


segment .bss
;
; uninitialized data is put in the bss segment
;


segment .text
global  asm_main
asm_main:
        enter   0,0               ; setup routine

;;
;; Your code goes here.
;; Do not modify the code before
;; or after this comment.
;;

        mov     rax, 0            ; return back to C
        leave
        ret
