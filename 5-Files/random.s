### READ RANDOM DATA AND PUT IT INTO A FILE

.equ ST_FILENAME, 0
.equ ST_RANDOM, 8
.equ ST_OUTPUT, 12

.equ LINUX_SYSCALL, 0x80

.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

.equ ST_IN, -4
.equ ST_OUT, -8

.section .data

.section .bss
.equ BUFFER_SIZE, 400
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

.globl _start

_start:
    movl %esp, %ebp
    subl $8, %esp # make room for ST_IN and ST_OUT

open_random:
    movl $SYS_OPEN, %eax
    movl ST_RANDOM(%ebp), %ebx
    movl $O_RDONLY, %ecx
    movl $0666, %edx

    int $LINUX_SYSCALL
    movl %eax, ST_IN(%ebp)

open_output:
    movl $SYS_OPEN, %eax
    movl ST_OUTPUT(%ebp), %ebx
    movl $O_CREAT_WRONLY_TRUNC, %ecx
    movl $0666, %edx

    int $LINUX_SYSCALL
    movl %eax, ST_OUT(%ebp)

read_random:
    movl $SYS_READ, %eax
    movl ST_IN(%ebp), %ebx
    movl $BUFFER_DATA, %ecx
    movl $BUFFER_SIZE, %edx

    int $LINUX_SYSCALL

write_random:
    movl $SYS_WRITE, %eax
    movl ST_OUT(%ebp), %ebx
    movl $BUFFER_DATA, %ecx

    int $LINUX_SYSCALL

cleanup:
    movl $SYS_CLOSE, %eax
    movl ST_IN(%ebp), %ebx

    int $LINUX_SYSCALL

    movl $SYS_CLOSE, %eax
    movl ST_OUT(%ebp), %ebx

    int $LINUX_SYSCALL

    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL
    