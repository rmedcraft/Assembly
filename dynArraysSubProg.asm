;;; Mike Jochen
;;; CPSC 232
;;; 3/29/23
;;; file: dynArraysSubProg.asm
;;; Dynamic single dimension array.
;;; Use subprograms to fill it, print it.

   %define ARRAY_SIZE  10
   %define ELEMENT_SIZE 4
   %define EOF -1
   
segment .data
   inputPrompt: db "Enter int value (ctrl-d to stop): ",0
   intFormat:   db "%d",0
   output:      db "Array[%d] = %d",10,0
   dbout:       db 10,"[%d]",10,0 ; This is just for debugging output
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

   ;; calling fillArray
   ;; RDI - pointer to array
   ;; RSI - max array size
   mov   rdi, [arrayPtr]        ; Will use RDI and stosd to write the array
   mov   rsi, ARRAY_SIZE
   call  fillArray

   ;; calling printArray
   ;; RDI - - pointer to array
   ;; RSI - number of elements in the array
   mov   rdi, [arrayPtr]        ; Will use RSI and lodsd to read the array
   mov   rsi, rax
   call  printArray
   
   mov   rax, 0
   leave 
   ret   

;;; Subprogram fillArray
;;; RDI - - pointer to array
;;; RSI - max size of the array
;;;
;;; Return - number of elements actually stored in array
fillArray:
   enter 0,0

   mov   rcx, rsi
   mov   r15, 0                 ; R15 counts how many elements in our array
   cld
inputLoop:
   push  rcx                    ; Save RCX and RDI across printf/scanf calls
   push  rdi
   mov   rdi, inputPrompt
   call  printf

   mov   rdi, intFormat
   mov   rsi, intInput
   call  scanf

   cmp   eax, EOF               ; Did scanf() return -1 (EOF: didn't read anything?)
   je    inputDone
   inc   r15                    ; O/w count another element & store it
   
   xor   rax, rax               ; Clear out RAX for stosd to write array to mem
   mov   eax, [intInput]
   pop   rdi                    ; Restore RDI for stosd
   stosd
   pop   rcx                    ; Restore RCS for loop instruction
   loop  inputLoop
   
inputDone:                      ; Let's get ready to print
   mov   rdi, newline
   call  printf

   mov   rax, r15
   leave 
   ret

;;; Subprogram printArray
;;; RDI - - pointer to array
;;; RSI - number of elements in the array
;;;
;;; Return - void
printArray:
   enter 0,0

   mov   rcx, rsi               ; Store actual array size to RCX
   mov   rsi, rdi
   mov   rbx, 0
   cld
printLoop:
   xor   rax, rax
   xor   rdx, rdx
   lodsd
   push  rcx                    ; Save RCX and RSI across printf call
   push  rsi
   mov   rdi, output
   mov   rsi, rbx

   movsx rdx, eax
   call  printf
   inc   rbx

   pop   rsi                    ; Restore RCX and RSI
   pop   rcx
   loop  printLoop

   leave 
   ret