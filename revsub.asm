;;; CPSC 232
;;; Bit Reverse - reverse the bits
;;; New & improved, with Loops!
;;; File: revsub.asm

segment .data
   mesg: db "Please enter a integer: ",0
   intInput: db "%d",0
   intOutput: db "%d: ",0
   niceIntOutput: db "%d",10,0
   newline: db 10,0
   
segment .bss
   input1: resd 1
   answer: resd 1
   
segment .text
   global asm_main
   extern printf, scanf

   ;; Order of registers for
   ;; parameter passing (reminder):
   ;; RDI, RSI, RDX, RCX, R8, R9
asm_main:
   enter 0,0

   ;; Prompt the user for an int
   mov   rdi, mesg
   call  printf

   ;; Read int via scanf()
   ;; result stored in input1
   mov   rdi, intInput
   mov   rsi, input1
   call  scanf

   ;; Binary Print starts here...
   mov   rcx, 32
   mov   ebx, [input1]
printLoop1:
   xor   rax, rax
   rol   ebx, 1
   setc  al
   ;; This prints a single digit
   mov   rdi, intInput
   mov   rsi, rax
   push  rcx                    ; preserve RCX across printf() call
   call  printf
   pop   rcx                    ; restore RCX
   loop  printLoop1

   mov   rdi, newline
   call  printf

   ;; Rotate one bit of of one register,
   ;; rotate it back in another register
   ;; (in reverse order).
   ;; Wow, much shorter than the non-loop version!
   mov   rcx, 32
   xor   rdx, rdx
   mov   ebx, [input1]
revLoop:
   rol   ebx, 1
   rcr   edx, 1
   loop  revLoop
   
   mov   [answer], edx

   ;; Binary Print starts here...
   mov   rcx, 32
   mov   ebx, [answer]
printLoop2:
   xor   rax, rax
   rol   ebx, 1
   setc  al
   ;; This prints a single digit
   mov   rdi, intInput
   mov   rsi, rax
   push  rcx                    ; preserve RCX across printf() call
   call  printf
   pop   rcx                    ; restore RCX
   loop  printLoop2

   mov   rdi, newline
   call  printf

   ;; Return back to C and main()
   mov   rax, 0
   leave
   ret
