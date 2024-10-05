;;; Mike Jochen
;;; CPSC 232
;;; file: mathFun.asm
;;; Fun with multiplation & expressions...


segment .data
   prompt1:     db    "The answer is: %d",10,0
   prompt11:    db    "The answer is: %d:%d",10,0
   prompt2:     db    "The answer is: %ld",10,0

segment .text
   global asm_main
   extern printf

;;; Reminder: order of parameters passed via register:
;;; RDI RSI RDX RCX R8 R9

asm_main:
   enter 0,0                    ; setup routine

   ;; 8-bit Multiplication: multiplicand = 16, multiplier = 2
   ;; Multiplicand stored in AL, multiplier stored in operand (BL)
   ;; Result: product stored in AX
   xor   rax, rax               ; why XOR here?
   xor   rbx, rbx
   mov   al, 16
   mov   bl, 2
   mul   bl	                ; 8-bit multiplication

   ;; Print the result: printf(promtp1, AX)
   ;; Note order of parameters: RDI, RSI
   mov   rsi, rax
   mov   rdi, prompt1
   call  printf

   ;; 16-bit Multiplication: multiplicand = 32768, multiplier = 2
   ;; Multiplicand stored in AX, multiplier stored in operand (BX)
   ;; Result: product stored in DX:AX
   xor   rax, rax
   xor   rbx, rbx
   mov   ax, 32768              ; 1000 0000 0000 0000
   mov   bx, 2
   mul   bx	                ; 16-bit multiplication
   mov   r12, rdx               ; savings these for later...
   mov   r13, rax

   ;; Print the result: printf(promtp11, DX, AX)
   ;; Note order of parameters: RDI, RSI, RDX
   mov   rsi, rax
   xchg  rsi, rdx               ; why XCHG here?
   mov   rdi, prompt11
   call  printf

   ;; Print the result another way: printf(promtp1, SI)
   ;; Note order of parameters: RDI, RSI
   ;; What we are doing here is building one 32-bit value
   ;; from two 16-bit values. r12 stores the high-16 bits
   ;; r13 stores the low-16 bits
   mov   rsi, r12
   shl   esi, 16
   add   rsi, r13
   mov   rdi, prompt1
   call  printf

   ;; 32-bit Multiplication: multiplicand = 2147483648, multiplier = 2
   ;; Multiplicand stored in EAX, multiplier stored in operand (EBX)
   ;; Result: product stored in EDX:EAX
   xor   rax, rax
   xor   rbx, rbx
   mov   eax, 2147483648        ; 1000 0000 0000 0000 0000 0000 0000 0000
   mov   ebx, 2
   mul   ebx	                ; 32-bit multiplication
   mov   r12, rdx               ; savings these for later...
   mov   r13, rax

   ;; Print the result: printf(promtp11, EDX, EAX)
   ;; Note order of parameters: RDI, RSI, RDX
   mov   rsi, rax
   xchg  rsi, rdx
   mov   rdi, prompt11
   call  printf

   ;; Print the result another way: printf(promtp1, SI)
   ;; Note order of parameters: RDI, RSI
   ;; What we are doing here is building one 64-bit value
   ;; from two 32-bit values. r12 stores the high-32 bits
   ;; r13 stores the low-32 bits
   mov   rsi, r12
   shl   rsi, 32
   add   rsi, r13
   mov   rdi, prompt2           ; note the format string "%ld"
   call  printf

   ;; 64-bit Multiplication: multiplicand = 256, multiplier = 2
   ;; Multiplicand stored in RAX, multiplier stored in operand (RBX)
   ;; Result: product stored in RDX:RAX
   xor   rax, rax
   xor   rbx, rbx
   mov   rax, 256
   mov   rbx, 2
   mul   rbx	                ; 64-bit multiplication

   ;; Print the result: printf(promtp11, RDX, RAX)
   ;; Note order of parameters: RDI, RSI, RDX
   mov   rsi, rax
   xchg  rsi, rdx
   mov   rdi, prompt11
   call  printf

   ;; 64-bit Multiplication: multiplicand = 6, multiplier = 3
   ;; Multiplicand stored in RAX, multiplier stored in operand (RBX)
   ;; Result: product stored in RDX:RAX
   mov   rax, 6
   mov   rbx, 3
   xor   rdx, rdx
   mul   rbx                    ; 64-bit multiplication

   ;; Print the result: printf(promtp11, RDX, RAX)
   ;; Note order of parameters: RDI, RSI, RDX
   mov   rsi, rax
   xchg  rsi, rdx               ; why XCHG here?
   mov   rdi, prompt11
   call  printf

   ;; Return back to C
   mov   rax, 0
   leave 
   ret   
