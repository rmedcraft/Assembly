;;
;; file: dmax.asm
;;
;; To create executable:
;; nasm -f elf64 dmax.asm
;; gcc -no-pie dmaxt.c dmax.o -o dmaxt
;;

global dmax



segment .text
;; function dmax
;; returns the larger of its two double arguments
;; C prototype
;; double dmax( double d1, double d2 )
;; Parameters:
;;   d1   - first double xmm0
;;   d2   - second double xmm1
;; Return value:
;;   larger of d1 and d2 (in xmm0)

;; driver: use dmaxt.c

;; next, some helpful symbols are defined

dmax:
        enter   0, 0

	maxsd	xmm0, xmm1 	; compare xmm0 & xmm1, move max to xmm0
exit:
        leave
        ret


