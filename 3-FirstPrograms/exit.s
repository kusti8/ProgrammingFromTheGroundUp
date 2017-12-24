#Purpose: Simple code that exits and returns a status code back to the Linux kernel

#Input: none

#Output: A status code

#Variables: %eax holds the system call number
# %ebx holds the return status

.section .data

.section .text
.globl _start
_start:

movl $1, %eax

movl $5, %ebx

int $0x80