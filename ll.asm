%define	empty 0
%define EOF   -1
%define NULL  0
%define MAX_BUFFER 255
struc ll
	.pID:	resd 1
	.nameF:	resq 1
	.price:	resd 1
	.cost:	resd 1
	.quantity: resd 1
	.ptr:	resq 1
	.size:
endstruc

segment .data
	promptID:	db "Enter Product ID: ", 0
	promptNF:	db "Enter Product Name: ",0
	promptPrice:	db "Enter the Price: ",0
	promptCost:	db "Enter the Cost: ",0
	promptQuantity:	db "Enter the Quantity: ", 0
	newLine:	db "", 10, 10, 0

	outputID:	db "Product ID: %d", 10, 0
	outputNF:	db "Product Name: %s", 10, 0
	outputPrice:	db "Price: %d", 10, 0
	outputCost:	db "Cost: %d", 10, 0
	outputQuantity:	db "Quantity: %d", 10, 0

	outputPtr:	db "Ptr: %d", 10, 0

	intFormat:	db "%d", 0
	strFormat:	db "%s", 0

segment .bss
	head:		resq 1	;points to head of the linked list
	lastNode:	resq 1  ;points to last node to make insertions quickier
	intInput:	resd 1
	strInput:	resb MAX_BUFFER

segment	.text
	global asm_main
	extern printf, scanf, calloc, free, strncpy, strnlen

asm_main:
	enter	8, 0
	call	getInput

	;;move pointer to linked lists head to rdi 
	mov	rdi, rax

	call	printLinkedList
	mov	rax, 0
	leave
	ret

;;Gets the input and returns a pointer to the head
;;RETURN VALS
;;RAX - Pointer to head of linked list
getInput:
	enter	8, 0
	
	;;r12 will be used to reference the lastNode
	;;r13 holds the head
	xor	r12, r12
	xor	r13, r13

        mov     r12b, BYTE empty  ;tells the program no nodes have been created yet
inputLoop:
        push    rcx
        push    rsi

        ;;create the head
        cmp     r12, BYTE empty
        jne     newNode

        ;;allocate space for head of the linked list
        mov     rdi, 1
        mov     rsi, ll.size
        call    calloc
	
        ;;move head and last node 
        mov     r13, rax             ;make head point to this new node
        mov     r12, rax         ;make lastNode point to this newly created node
        jmp     fillNode

newNode:
        ;;allocate space
        mov     rdi, 1
        mov     rsi, ll.size
        call    calloc

        ;;move lastNode
        mov     r14, r12
        mov     [r14 + ll.ptr], rax
        mov     r12, rax
        ;jmp     fillNode

fillNode:
        ;;at this point lastNode contains the pointer to the most recent node in the linked list
        ;;as such any element can be accessed by this logic
        ;;      [ [lastNode] + ll.[element] ]

	;;make ptr point to 0
;	mov	[r8 + ll.ptr], QWORD NULL
	
        ;;product ID
        mov     rdi, promptID
        call    printf

        mov     rdi, intFormat
        mov     rsi, intInput
        call    scanf

	;;check eof
	cmp	eax, EOF
	jne	notEnd
	xor	r8, r8
	mov	[r14 + ll.ptr], r8	;clears the pointer, at this point r14 holds the previous node
	jmp	endInput

notEnd:
        ;;move the value into the structs location
        mov     rax, [intInput]
        mov     r8, r12
        mov     [r8 + ll.pID], eax

	;;prouct name
	mov	rdi, promptNF
	call	printf
	
	;;get name
	mov	rdi, strFormat
	mov	rsi, strInput
	call	scanf

	;;get strln and add one for eol
	mov	rdi, strInput
	mov	rsi, MAX_BUFFER
	call	strnlen
	inc	rax
	mov	r15, rax

	;;allocate memory for string
	mov	rdi, rax
	mov	rsi, 1;
	call 	calloc

	;;copy string to nodes location
	mov	[r12 + ll.nameF], rax
	mov	rdi, rax
	mov	rsi, strInput
	mov	rdx, r15
	call	strncpy

	;;product price
	mov	rdi, promptPrice
	call	printf

	mov	rdi, intFormat
	mov	rsi, intInput
	call	scanf

	;;move the value into the structs location
	mov	rax, [intInput]
	mov	r8, r12
	mov	[r8 + ll.price], eax

	;;product cost
	mov	rdi, promptCost
	call	printf

	mov	rdi, intFormat
	mov	rsi, intInput
	call	scanf

	;;move the value into structs location
	mov	rax, [intInput]
	mov	r8, r12
	mov	[r8 + ll.cost], eax
	
	;;product quantity
	mov	rdi, promptQuantity
	call	printf

	mov	rdi, intFormat
	mov	rsi, intInput
	call	scanf

	;;move the value into structs location
	mov	rax, [intInput]
	mov	r8, r12
	mov	[r8 + ll.quantity], eax

	;;put newline
	mov	rdi, newLine
	call	printf

        pop     rsi
        pop     rcx
        jmp     inputLoop

endInput:
	;;give return vals
	mov	rax, r13
	leave
	ret



;;Prints the contents of the linked list
;;RDI - the pointer to the head of the linked list
;;Returns void
printLinkedList:
	enter	8,0
        
	mov     r12, rdi     ;;r12 will point to the node
outputLoop:
        push    rcx
	push 	rsi

        ;;output nodes information
        mov     rdi, outputID
        mov     eax, [r12 + ll.pID]
        mov     rsi, rax
        call    printf

	mov	rdi, outputNF
	mov	rax, [r12 + ll.nameF]
	mov	rsi, rax
	call	printf

	mov	rdi, outputPrice
	mov	eax, [r12 + ll.price]
	mov	rsi, rax
	call	printf
	
	mov	rdi, outputCost
	mov	eax, [r12 + ll.cost]
	mov	rsi, rax
	call	printf

	mov	rdi, outputQuantity
	mov	eax, [r12 + ll.quantity]
	mov	rsi, rax
	call	printf

	mov	rdi, newLine
	call	printf

        ;;move to next node
        mov     r12, [r12 + ll.ptr]

	pop	rsi
        pop     rcx
        
	cmp	r12, NULL
        jne     outputLoop

	leave
	ret
