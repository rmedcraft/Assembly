;;
;; file: max.asm
;; This example demostrates how to avoid conditional branches
;; To create executable:
;; nasm -f elf64 max.asm
;; gcc -no-pie -o max max.o driver.c
;;

segment .data

message1: db "Enter a number: ",0
message2: db "Enter another number: ", 0
message3: db "The larger number is: %d", 10, 0
intFormat: db "%d",0

segment .bss

input1:  resd    1        ; first number entered
input2:  resd    1


segment .text
global  asm_main
extern printf, scanf

asm_main:
        enter   0,0               ; setup routine

        mov     rdi, message1     ; print out first message
        call    printf
	mov	rdi, intFormat
	mov	rsi, input1
        call    scanf             ; input first number

        mov     rdi, message2     ; print out second message
        call    printf
	mov	rdi, intFormat
	mov	rsi, input2
        call    scanf             ; input second number

        xor     rbx, rbx          ; rbx = 0
	mov	eax, dword [input2]
	movsxd	rax, eax
	mov	esi, dword [input1]
	movsxd	rsi, esi
        cmp     rax, rsi          ; compare second and first number
        setg    bl                ; rbx = (input2 > input1) ?                  1 : 0
        neg     rbx               ; rbx = (input2 > input1) ? 0xFFFFFFFFFFFFFFFF : 0
        mov     rcx, rbx          ; rcx = (input2 > input1) ? 0xFFFFFFFFFFFFFFFF : 0
        and     rcx, rax          ; rcx = (input2 > input1) ?             input2 : 0
        not     rbx               ; rbx = (input2 > input1) ?                  0 : 0xFFFFFFFFFFFFFFFF
	mov	esi, dword [input1]
	movsxd	rdi, esi
        and     rbx, rdi          ; rbx = (input2 > input1) ?                  0 : input1
        or      rcx, rbx          ; rcx = (input2 > input1) ?             input2 : input1

        mov     rdi, message3     ; print out result
	mov	rsi, rcx
        call    printf

        mov     rax, 0            ; return back to C
        leave
        ret
