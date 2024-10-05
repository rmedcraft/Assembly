;;; Mike Jochen
;;; CPSC 232
;;; 3/15/23
;;; file: arrays.asm
;;; Static single dimension array; fill it, print it.

   %define ARRAY_SIZE  10
   
segment .data
   inputPrompt: db "Enter int value: ",0
   intFormat:   db "%d",0
   output:      db "Array[%d] = %d",10,0

segment .bss
   myArray:  resd ARRAY_SIZE
   intInput: resd 1

segment .text
   global asm_main
   extern printf, scanf
asm_main:
   enter 0,0

   ;; Get ready to write elements to the array
   ;; Load base address of array into RDI
   ;; Load array size into RCX
   ;; Clear direction flag so stosd works from index 0 to index ARRAY_SIZE
   mov   rdi, myArray
   mov   rcx, ARRAY_SIZE
   cld
inputLoop:
   ;; printf & scanf trashes RCX & RDI, so save them
   push  rcx
   push  rdi
   mov   rdi, inputPrompt
   call  printf

   ;; Read an int from stdin & store in intInput
   mov   rdi, intFormat
   mov   rsi, intInput
   call  scanf

   ;; Use stosd to store user input into next array slot
   ;; stosd writes EAX to address stored in RDI
   ;; then increments RDI by 4, so ready to write to
   ;; next location in the array
   xor   rax, rax
   mov   eax, [intInput]
   pop   rdi                    ; We need the saved RDI now
   stosd
   pop   rcx                    ; We need the saved RCX now
   loop  inputLoop
   
   ;; Get ready to read elements of the array
   ;; Load base address of array into RSI
   ;; Load array size into RCX
   ;; Clear direction flag so lodsd works from index 0 to index ARRAY_SIZE
   mov   rsi, myArray
   mov   rcx, ARRAY_SIZE
   mov   rbx, 0
   cld
printLoop:
   push  rcx                    ; Need to save RCX again

   ;; Use lodsd to read array elements into EAX
   ;; lodsd loads value from mem at address stored in RSI and loads into EAX
   ;; then increments RSI by 4, so ready to read from
   ;; next location in the array   
   xor   rax, rax
   lodsd
   push  rsi                    ; Need to save address in RSI
   mov   rdi, output
   mov   rsi, rbx

   ;; Print it out
   movsx rdx, eax
   call  printf
   inc   rbx

   ;; Restore RSI and RCX
   pop   rsi
   pop   rcx
   loop  printLoop
   
   mov   rax, 0
   leave 
   ret   
