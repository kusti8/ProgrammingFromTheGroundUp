# Given a number, this program computes the factorial

.section .data

.section .text

.globl _start
.globl factorial

_start:
    pushl $4 # The first argument is 4

    call factorial
    addl $4, %esp   # Scrubs the parameter that was pushed on the stack

    movl %eax, %ebx  # Put into exit status
    movl $1, %eax  # call exit
    int $0x80

.type factorial, @function
factorial:
    pushl %ebp
    movl %esp, %ebp

    movl 8(%ebp), %eax # Move first argument to %eax
    
    cmpl $1, %eax  # If 1, then return
    je end_factorial

    decl %eax   # decrease value
    push %eax   # push for call to factorial
    call factorial
    movl 8(%ebp), %ebx   # reload parameter into %ebx

    imull %ebx, %eax  # Multiply last call with parameter

end_factorial:
    movl %ebp, %esp
    popl %ebp
    ret
