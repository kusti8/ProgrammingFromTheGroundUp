# Purpose: compute the square of an argument

.section .data

.section .text

.globl _start

_start:
    pushl $5  # First argument is 5
    call square
    addl $4, %esp  # Scrub the argument

    movl %eax, %ebx
    movl $1, %eax
    int $0x80

square:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %eax  # Get first argument into %eax

    imull %eax, %eax   # Square it, and return it
    jmp finish_square

finish_square:
    movl %ebp, %esp
    popl %ebp
    ret
