;;; Mike Jochen
;;; CPSC 232
;;; 3/20/23
;;; file: dynArrays.asm
;;; Dynamic single dimension array; fill it, print it.

   %define ARRAY_SIZE  10
   %define ELEMENT_SIZE 4
   %define EOF -1
   
segment .data
   inputPrompt: db "Enter int value (ctrl-d to stop): ",0
   intFormat:   db "%d",0
   output:      db "Array[%d] = %d",10,0
   dbout:       db 10, 10,"[%d]",10,10,0 ; This is just for debugging output
   newline:     db 10,0                  ; For whenever we need a newline

segment .bss
   arrayPtr:  resq 1                     ; pointer to our array
   intInput:  resd 1

segment .text
   global asm_main
   extern printf, scanf, calloc
asm_main:
   enter 0,0

   ;; Get memory for our array
   ;; Give calloc() number of element and element size
   ;; and calloc returns a pointer to zerioized memory
   mov   rdi, ARRAY_SIZE
   mov   rsi, ELEMENT_SIZE
   call  calloc
   mov   [arrayPtr], rax
   
   mov   rdi, [arrayPtr]
   mov   rcx, ARRAY_SIZE
   mov   r15, 0                 ; This counts how many elements in our array
   cld
inputLoop:
   push  rcx
   push  rdi
   mov   rdi, inputPrompt
   call  printf

   mov   rdi, intFormat
   mov   rsi, intInput
   call  scanf

   cmp   eax, EOF               ; Did scanf() return -1 (didn't read anything?)
   je    inputDone
   inc   r15                    ; O/w count another element & store it
   
   xor   rax, rax
   mov   eax, [intInput]
   pop   rdi
   stosd
   pop   rcx
   loop  inputLoop
   
inputDone:                      ; Let's get ready to print
   mov   rdi, newline
   call  printf
   mov   rsi, [arrayPtr]
   mov   rcx, r15
   mov   rbx, 0
   cld
printLoop:
   push  rcx

   xor   rax, rax
   xor   rdx, rdx
   lodsd
   push  rsi
   mov   rdi, output
   mov   rsi, rbx

   movsx rdx, eax
   call  printf
   inc   rbx

   pop   rsi
   pop   rcx
   loop  printLoop
   
   mov   rax, 0
   leave 
   ret   
