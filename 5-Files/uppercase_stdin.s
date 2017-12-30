# Purpose: Convert input file to output with all uppercase letters

.section .data

######### CONSTANTS ##############
.equ SYS_OPEN, 5
.equ SYS_WRITE, 4
.equ SYS_READ, 3
.equ SYS_CLOSE, 6
.equ SYS_EXIT, 1

.equ O_RDONLY, 0
.equ O_CREAT_WRONLY_TRUNC, 03101

.equ STDIN, 0
.equ STDOUT, 1
.equ STDERR, 2

.equ LINUX_SYSCALL, 0x80

.equ END_OF_FILE, 0

.equ NUMBER_ARGUMENTS, 2

.section .bss
.equ BUFFER_SIZE, 500
.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text

# STACK POSITIONS
.equ ST_SIZE_RESERVE, 8
.equ ST_FD_IN, -4
.equ ST_FD_OUT, -8
.equ ST_ARGC, 0  # Number of arguments
.equ ST_ARGV_0, 4 # Name of program
.equ ST_ARGV_1, 8 # Input file name
.equ ST_ARGV_2, 12 # Output file name

.globl _start
_start:
    # save the stack pointer
    movl %esp, %ebp
    subl $ST_SIZE_RESERVE, %esp # Allocate space for file descriptors

open_files:
store_fd_in:
    # save the given file descriptor
    movl $STDIN, ST_FD_IN(%ebp)
store_fd_out:
    movl $STDOUT, ST_FD_OUT(%ebp) # store the file descriptor here

read_loop_begin:
    ### READ IN BLOCK ###
    movl $SYS_READ, %eax
    movl ST_FD_IN(%ebp), %ebx # input file descriptor
    movl $BUFFER_DATA, %ecx # the location to read into
    movl $BUFFER_SIZE, %edx # The buffer size
    # Size of buffer read is returned in %eax
    int $LINUX_SYSCALL

    ### EXIT IF WE'VE REACHED THE END ###
    cmpl $END_OF_FILE, %eax
    jle read_loop_begin

continue_read_loop:
    ### CONVERT THE BLOCK TO UPPER CASE
    pushl $BUFFER_DATA # location of the buffer
    pushl %eax # size of the buffer
    call convert_to_upper
    popl %eax # get the size back
    addl $4, %esp  # restore %esp

    ## WRITE THE BLOCK TO THE OUTPUT FILE ###

    movl %eax, %edx # size of the buffer
    movl $SYS_WRITE, %eax
    movl ST_FD_OUT(%ebp), %ebx
    movl $BUFFER_DATA, %ecx
    int $LINUX_SYSCALL

    ### CONTINUE THE LOOP ###
    jmp read_loop_begin

end_loop:
    ### EXIT ###
    movl $SYS_EXIT, %eax
    movl $0, %ebx
    int $LINUX_SYSCALL


### CONVERT LOWERCASE TO UPPERCASE ###

.equ LOWERCASE_A, 'a'
.equ LOWERCASE_Z, 'z'
.equ UPPER_CONVERSION, 'A' - 'a'

.equ ST_BUFFER_LEN, 8 # Length of buffer
.equ ST_BUFFER, 12 # actual buffer

convert_to_upper:
    pushl %ebp
    movl %esp, %ebp

    movl ST_BUFFER(%ebp), %eax
    movl ST_BUFFER_LEN(%ebp), %ebx
    movl $0, %edi

    # if buffer length is 0, then leave
    cmpl $0, %ebx
    je end_convert_loop

convert_loop:
    movb (%eax,%edi,1), %cl # get the current byte

    cmpb $LOWERCASE_A, %cl
    jl next_byte
    cmpb $LOWERCASE_Z, %cl
    jg next_byte

    # otherwise, convert the byte to uppercase
    addb $UPPER_CONVERSION, %cl
    movb %cl, (%eax,%edi,1)
next_byte:
    incl %edi
    cmpl %edi, %ebx # continue unless we've reached the end
    jne convert_loop

end_convert_loop:
    movl %ebp , %esp
    popl %ebp
    ret

