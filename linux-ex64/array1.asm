;;
;; file: array1.asm
;; This program demonstrates arrays in assembly
;;
;; To create executable:
;; nasm -f elf64 array1.asm
;; gcc -no-pie array1.o array1c.c -o array1
;;

%define ARRAY_SIZE 100
%define NEW_LINE 10

segment .data
FirstMsg        db   "First 10 elements of array", 0
Prompt          db   "Enter index of element to display: ", 0
SecondMsg       db   "Element %d is %d", NEW_LINE, 0
ThirdMsg        db   "Elements 20 through 29 of array", 0
InputFormat     db   "%d", 0

segment .bss
array           resd ARRAY_SIZE



segment .text
        extern  puts, printf, scanf, dump_line
        global  asm_main
asm_main:
        enter   16,0                ; local dword variable at EBP - 16
        push    rbx
        push    rsi

;; initialize array to 100, 99, 98, 97, ...

        mov     rcx, ARRAY_SIZE
        mov     rbx, array
init_loop:
        mov     [rbx], rcx
        add     rbx, 4
        loop    init_loop

        mov     rdi, FirstMsg       ; print out elements 20-29
        call    puts                ; print out FirstMsg
        pop     rcx

        mov    rsi, dword 10
        mov    rdi, array
        call   print_array          ; print first 10 elements of array

;; prompt user for element index
Prompt_loop:
        mov     rdi, Prompt
        call    printf

        lea     rax, [rbp-8]        ; eax = address of local dword
        mov     rsi, rax
        mov     rdi, dword InputFormat
        call    scanf
        cmp     rax, 1               ; eax = return value of scanf
        je      InputOK

        call    dump_line            ; dump rest of line and start over
        jmp     Prompt_loop          ; if input invalid

InputOK:
        mov     esi, [rbp-8]
	lea	rbx, [array + 4*rsi]
        mov     rdx, [rbx]
        mov	rdi, SecondMsg       ; print out value of element
        call    printf
        add     rsp, 12
        mov     rdi, dword ThirdMsg  ; print out elements 20-29
        call    puts

        mov     rsi, dword 10
        mov     rdi, dword array + 20*4  ; address of array[20]
        call    print_array

	pop	rsi
        pop     rbx
        mov     eax, 0                ; return back to C
        leave
        ret

;;
;; routine print_array
;; C-callable routine that prints out elements of a double word array as
;; signed integers.
;; C prototype:
;; void print_array( const int * a, int n);
;; Parameters:
;;   a - pointer to array to print out (at ebp+8 on stack)
;;   n - number of integers to print out (at ebp+12 on stack)

segment .data
OutputFormat    db   "%-5d %5d", NEW_LINE, 0

segment .text
        global  print_array
print_array:
        enter   32,0
	push	rdi
        push    rsi
        push    rbx

        mov     rcx, rsi             ; RSI ecx = n
        xor     rsi, rsi             ; esi = 0
        mov     rbx, rdi             ; RDI ebx = address of array
print_loop:
        push    rcx                  ; printf might change ecx!
	push	rsi
	push	rbx

        mov     rdi, OutputFormat
        mov     rdx, [rbx + 4*rsi]   ; push array[esi]
        call    printf

	pop	rbx
	pop	rsi
        inc     rsi
        pop     rcx
        loop    print_loop

        pop     rbx
        pop     rsi
	pop	rdi
        leave
        ret
