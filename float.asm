;;; Mike Jochen
;;; CPSC 232
;;; file: float.asm
;;; Fun with floats!
;;;
;;; Lets explore floats in 64-bit NASM!
;;; In x86_64, floats are passed via xmm registers
	
segment .data
   prompt:      db "Please enter a floating point value: ",0
   answerSP:    db "Your single-precision floating point number is: %f",10,0
   answerDP:    db "Your double-precision floating point number is: %lf",10,0
   sumDP:       db "%f + %lf is: %.3lf",10,0
   inFormatSP:  db "%f",0
   inFormatDP:  db "%lf",0

segment .bss
   floatingSP:  resd 1
   floatingDP:  resq 1
	
segment .text
   global asm_main
   extern printf, scanf
	
asm_main:
   enter 0,0

   ;; Prompt user for a float
   ;; (will use same promt for single/double precision)
   mov   rdi, prompt
   call  printf

   ;; Read in single-precisionnfloat
   ;; Note: not passing a float here, but pointer to float
   ;; thus, we use RSI
   mov   rdi, inFormatSP
   mov   rsi, floatingSP
   call  scanf
   
   ;; Prompt user for a float
   mov   rdi, prompt
   call  printf

   ;; Read in double-precision float
   ;; Again, use RSI for float pointer
   mov   rdi, inFormatDP
   mov   rsi, floatingDP
   call  scanf
   
   ;; note: 
   ;; pass floats via xmm0, xmm1, ...
   ;; and store float count in rax
   ;; here, already rax=1 (return from scanf)
   ;; xmm0=user-entered double (returned from scanf)

   ;; Print single-precision float
   ;; Floats are passed via XMM registers (XMM0 - XMM7)
   ;; Note: scanf() in C promotes floats to a double before
   ;; printing (that's just how C rolls), so we need to promote
   ;; our single-precision float to a double-precision float
   ;; before calling printf().
   ;; We use cvtss2sd to convert single-precision scalar to
   ;; double-precision scalar
   mov   rdi, answerSP
   cvtss2sd xmm0, [floatingSP]
   mov   rax, 1
   call  printf

   ;; Print double-precision float
   ;; Simple MOVSD into XMM0 before printf
   ;; Note: set RAX to one, telling printf that we are
   ;; passing one parameter as float
   mov   rdi, answerDP
   movsd xmm0, [floatingDP]
   mov   rax, 1
   call  printf 

   ;; Let's do a little float arithmetic
   ;; and print the result
   cvtss2sd xmm0, [floatingSP]
   movsd xmm1, [floatingDP]
   addsd xmm0, xmm1

   ;; Print all three floats (2 double-precision & 1 single-precision)
   mov   rdi, sumDP
   movsd xmm2, xmm0
   movsd xmm1, [floatingDP]
   cvtss2sd xmm0, [floatingSP]
   mov   rax, 3
   call  printf

   mov   rax, 0
   leave 
   ret   
   