;;
;; file: read.asm
;; This subroutine reads an array of doubles from a file (stdin)
;;
;; To create executable:
;; nasm -f elf64 read.asm
;; gcc -no-pie -o readt read.o readt.c
;;
segment .data
format:  db      "%lf", 0        ; format for fscanf()

segment .bss

segment .text
global  read_doubles
extern  fscanf

%define SIZEOF_DOUBLE   8
%define TEMP_DOUBLE     [rbp - 8]

;;
;; function read_doubles
;; C prototype:
;;   int read_doubles( double * arrayp, FILE * fp, int array_size );
;; This function reads doubles from a text file into an array, until
;; EOF or array is full.
;; Parameters:
;;   arrayp     - pointer to double array to read into               RDI
;;   fp         - FILE pointer to read from (must be open for input) RSI
;;   array_size - number of elements in array                        RDX
;; Return value:
;;   number of doubles stored into array (in EAX)

read_doubles:
	enter	SIZEOF_DOUBLE,0

        xor     rbx, rbx                 ; rdx = array index (initially 0)

while_loop:
        cmp     rbx, rdx                 ; is rbx < ARRAY_SIZE?
        jnl     short quit               ; if not, quit loop
;
; call fscanf() to read a double into TEMP_DOUBLE
; fscanf() might change edx so save it
	;
        push    rbx                     ; save edx
	push	rcx
	push	rdx
	push	rdi
	push	rsi
        mov     rdi, rsi                ; push file pointer
        mov     rsi, format             ; push &format
        lea     rdx, TEMP_DOUBLE
        call    fscanf
	pop	rsi
	pop	rdi
	pop	rdx
        pop     rcx		        ; restore edx
	pop	rbx
        cmp     rax, 1                  ; did fscanf return 1?
        jne     short quit              ; if not, quit loop

;
; copy TEMP_DOUBLE into ARRAYP[edx]
;
        mov     rax, TEMP_DOUBLE
        mov     [rdi + 8*rbx], rax      ; first copy lowest 4 bytes

        inc     rbx
        jmp     while_loop

quit:
        mov     rax, rbx                ; store return value into rax
	leave
        ret 

