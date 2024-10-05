%define ARRAY_SIZE 3
%define ELEMENT_SIZE 1
%define EOF -1
%define MAX_BUFFER 255

struc pR
.pnum:  resd 1
.name:  resq 1
.price: resd 1
.cost:  resd 1
.Qty:   resd 1
.point  resd 1
.size:  resb 1
endstruc

segment .data
    greet:  db "Welcome to Smiths Inventory Control System!",10,0
    greet2: db "Please have product number, product name, price, cost, and quantity information ready.",10,0  
    promptPnum:  db "Product Number: ",0
    promptName:  db "Product Name: ",0
    promptPrce:  db "Product Price: ",0
    promptCost:  db "Product Cost: ",0
    promptQ:     db "Product Quantity: ",10,0
    greet3:      db "Here is the current store inventory: ",10,0  
    outputPnum:  db "Product Number: %d",10,0
    outputName:  db "Product Name: %s",10,0
    outputPrice: db "Product Price: $%d",10,0
    outputCst:   db "Product Cost: $%d",10,0
    outputQty:   db "Product Quantity: %d",10,0  
    intFormat:   db "%d",0
    strFormat:   db "%s",0

segment .bss
    intInput:    resd 1
    stringInput: resb MAX_BUFFER
    headPt:      resd 1

segment .text
    global asm_main
    extern printf, scanf, calloc, free, strncpy, strnlen
   
asm_main:
    enter 8,0
   
    mov rax, 0
    mov rdi, greet
    mov rsi, 0
    call printf
   
    mov rax, 0
    mov rdi, greet2
    mov rsi, 0
    call printf

    xor   r12, r12

    mov   rdi, 1
    mov   rsi, pR.size
    call  calloc

    mov   [headPt], rax
    mov   rbx, rax
                 
    mov   rcx, ARRAY_SIZE

inputLoop:
   
    push  rcx
    mov   rdi, promptPnum        
    call  printf
    mov   rdi, intFormat
    mov   rsi, intInput
    call  scanf

    cmp   eax, EOF
    je    coolMan

    mov   eax, [intInput]
    mov   [rbx+pR.pnum], eax

    mov   rdi, promptName        
    call  printf
    mov   rdi, strFormat
    mov   rsi, stringInput
    call  scanf

    mov   rdi, stringInput    
    mov   rsi, MAX_BUFFER
    call  strnlen
    inc   rax
    mov   r13, rax

    mov   rdi, rax
    mov   rsi, 1
    call  calloc

    mov   [rbx+pR.name], rax  
    mov   rdi, rax
    mov   rsi, stringInput
    mov   rdx, r13
    call  strncpy

    mov   rdi,  promptPrce  
    call  printf
    mov   rdi, intFormat
    mov   rsi, intInput
    call  scanf

    mov   eax, [intInput]        
    mov   [rbx+pR.price], eax

    mov   rdi, promptCost          
    call  printf
    mov   rdi, intFormat
    mov   rsi, intInput
    call  scanf

    mov   eax, [intInput]        
    mov   [rbx+pR.cost], eax

    mov   rdi,  promptQ  
    call  printf
    mov   rdi, intFormat
    mov   rsi, intInput
    call  scanf

    mov   eax, [intInput]        
    mov   [rbx+pR.Qty], eax    

    xor   rax, rax

    mov   rdi, 1
    mov   rsi, pR.size
    call  calloc

    mov   [rbx+pR.point], eax
    mov   rbx, rax

    pop   rcx
    dec   rcx
    jmp   inputLoop
   
coolMan:
    pop   rcx
    mov   rbx, 0		; set the last pointer to null
    mov   rcx, ARRAY_SIZE

    mov rax, 0
    mov rdi, greet3
    call printf

    mov   rbx, [headPt]
printLoop:
    cmp   DWORD [rbx+pR.point], 0
    je    end

    push  rcx
    mov   rdi, outputPnum
    mov   rsi, [rbx+pR.pnum]
    call  printf

    mov   rdi, outputName
    mov   rsi,  [rbx+pR.name]
    call  printf

    mov   rdi, outputPrice
    xor   rax, rax
    mov   eax, [rbx+pR.price]
    mov   rsi, rax
    call  printf

    mov   rdi, outputCst
    xor   rax, rax
    mov   eax, [rbx+pR.cost]
    mov   rsi, rax
    call  printf

    mov   rdi, outputQty
    xor   rax, rax
    mov   eax, [rbx+pR.Qty]
    mov   rsi, rax
    call  printf

    mov   rbx, [rbx + pR.point]

    pop   rcx
    dec   rcx
    ;jnz   printLoop
    jmp    printLoop
end: 
    mov   rax, 0
    leave
    ret