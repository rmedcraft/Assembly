;;; CPSC 232
;;; 4/3/23
;;; file: struc.asm
;;; An array of Structs in NASM
;;;
;;; This version is almost complete, but not quite done yet!
   
   %define ARRAY_SIZE 5
   %define MAX_BUFFER 255

   ;; Here is out struct definition
   ;; something akin to what we would put in a .h file
   struc pR
   .pID:   resd 1
   .nameF: resq 1
   .nameL: resq 1
   .alive: resb 1
   .size:
   endstruc

segment .data
   promptID:  db 10,"Patient ID: ",0
   promptNF:  db "Patient First Name: ",0
   promptNL:  db "Patient Last Name: ",0
   promptA:   db "Patient alive? ",0
   outputID:  db "Patient ID: %d",10,0
   outputNF:  db "Patient Name: %s %s",10,0
   outputA:   db "Patient alive? %d",0
   intFormat: db "%d",0
   strFormat: db "%s",0

segment .bss
   patientDB:   resb pR.size * ARRAY_SIZE
   intInput:    resd 1
   stringInput: resb MAX_BUFFER

segment .text
   global asm_main
   extern printf, scanf, calloc, free, strncpy, strnlen
   
asm_main:
   enter 0,0

   xor   r12, r12               ; Array index
   mov   rcx, ARRAY_SIZE
   mov   rbx, patientDB
inputLoop:
   push  rcx
   mov   rdi, promptID          ; Read in patient ID
   call  printf
   mov   rdi, intFormat
   mov   rsi, intInput
   call  scanf

   mov   eax, [intInput]
   mov   [rbx+pR.pID], eax

   mov   rdi, promptNF          ; Read in patient first name
   call  printf
   mov   rdi, strFormat
   mov   rsi, stringInput
   call  scanf

   mov   rdi, stringInput       ; Get string size and alloc space for string
   mov   rsi, MAX_BUFFER
   call  strnlen
   inc   rax
   mov   r13, rax

   mov   rdi, rax
   mov   rsi, 1
   call  calloc

   mov   [rbx+pR.nameF], rax    ; Copy first name string to struct
   mov   rdi, rax
   mov   rsi, stringInput
   mov   rdx, r13
   call  strncpy

   mov   rdi, promptNL          ; Read in patient last name
   call  printf
   mov   rdi, strFormat
   mov   rsi, stringInput
   call  scanf

   mov   rdi, stringInput       ; Get string size and alloc space for string
   mov   rsi, 255
   call  strnlen
   inc   rax
   mov   r13, rax

   mov   rdi, rax
   mov   rsi, 1
   call  calloc

   mov   [rbx+pR.nameL], rax    ; Copy first name string to struct
   mov   rdi, rax
   mov   rsi, stringInput
   mov   rdx, r13
   call  strncpy

   mov   rdi, promptA           ; Read in patient alive status
   call  printf
   mov   rdi, intFormat
   mov   rsi, intInput
   call  scanf

   mov   al, [intInput]         ; We should check this to confirm only 1 or zero
   mov   [rbx+pR.alive], al     ; before storing into struc mem

   ;; Set rbx to point to next record
   add   rbx, pR.size
   pop   rcx
   ;; Our loop is too big, so we need to decrement RCX and use regular jump
   dec   rcx
   jnz   inputLoop

   ;; We're moved printing out of the main loop
   mov   rcx, ARRAY_SIZE
   mov   rbx, patientDB
printLoop:
    push  rcx
   mov   rdi, outputID
   mov   esi, [rbx+pR.pID]
   call  printf

   mov   rdi, outputNF
   mov   rsi,  [rbx+pR.nameF]
   mov   rdx,  [rbx+pR.nameL]
   call  printf

   mov   rdi, outputA
   xor   rax, rax
   mov   al, [rbx+pR.alive]
   mov   rsi, rax
   call  printf

   ;; Set rbx to point to next record
   add   rbx, pR.size
   pop   rcx
   loop  printLoop


   mov   rax, 0
   leave
   ret
