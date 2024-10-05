;;; Mike Jochen
;;; CPSC 232
;;; PA01-Hello World
;;; file: divFun.asm
;;; Fun with division & expressions...


segment .data
   prompt1:     db    "The answer is: %d",10,0
   prompt11:    db    "The answer is: %d:%d",10,0

segment .text
   global asm_main
   extern printf

;;; Reminder: order of parameters passed via register:
;;; RDI RSI RDX RCX R8 R9
   
asm_main:
   enter 0,0                    ; setup routine

   ;; 8-bit Division: dividend = 4, divisor = 2
   ;; Result: quotient stored in AL, remainder stored in AH
   mov   rax, 4
   mov   rbx, 2
   div   bl                     ; 8-bit division

   ;; Print the result: printf(promtp11, AL, AH)
   ;; Note order of parameters: RDI, RSI, RDX
   xor   rsi, rsi               ; Why XOR here?
   xor   rdx, rdx
   movsx esi, al
   movsx edx, ah
   mov   rdi, prompt11
   call  printf

   ;; 16-bit Division: dividend = 15, divisor = 2
   ;; Dividend stored in DX:AX
   ;; Result: quotient stored in AX, remainder stored in DX
   xor   rdx, rdx               ; Why XOR here?
   mov   rax, 15
   mov   rbx, 2
   div   bx                     ; 16-bit division

   ;; Print the result: printf(promtp11, AX, DX)
   ;; Note order of parameters: RDI, RSI, RDX
   mov   rsi, rax
   mov   rdi, prompt11
   call  printf

   ;;32-bit  Division: dividend = 32768, divisor = 2
   ;; Dividend stored in EDX:EAX
   ;; Result: quotient stored in EAX, remainder stored in EDX
   xor   rax, rax
   xor   rbx, rbx
   xor   rdx, rdx
   mov   ax, 32768              ; binary: 1000 0000 0000 0000
   mov   bx, 2
   div   ebx	                ; 32-bit division

   ;; Print the result: printf(promtp11, AX, DX)
   ;; Note order of parameters: RDI, RSI, RDX
   mov   rsi, rax
   mov   rdi, prompt11
   call  printf

   ;; 64-bit Division: dividend = 2147483648, divisor = 2
   ;; Dividend stored in RDX:RAX
   ;; Result: quotient stored in EAX, remainder stored in EDX
   xor   rdx, rdx
   mov   rax, 2147483648        ; 1000 0000 0000 0000 0000 0000 0000 0000
   mov   rbx, 3
   div   rbx	                ; 64-bit division

   ;; Print the result: printf(promtp11, AX, DX)
   ;; Note order of parameters: RDI, RSI, RDX
   mov   rsi, rax
   mov   rdi, prompt11
   call  printf

   ;; Return back to C (main)
   mov   rax, 0
   leave 
   ret   
