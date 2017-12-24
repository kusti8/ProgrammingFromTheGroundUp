# PURPOSE: Finds the maximum num of a set

# VARIABLES;
#
# %edi - The index of the current data item
# %ebx - Largest data item found
# %eax - Current data item
#
# Memory Locations:
#
# data_items - the item data. 0 is used to termiante

.section .data

data_items:
.long 3,67,34,292,35,75,54,34,44,33,22,11,66,0

.section .text

.globl _start
_start:
movl $0, %edi           # move 0 into the index register
movl data_items(,%edi,4), %eax  #load the first byte of data
movl %eax, %ebx       # %eax is the smallest

increment:
incl %edi      # load the next value
movl data_items(,%edi,4), %eax
jmp start_loop

start_loop:
cmpl $0, %eax  # check to see if we've hit the end
je loop_exit
cmpl %ebx, %eax   # compare values
jge increment   # jump to loop beginning if the new one is bigger
movl %eax, %ebx  # move the value as the largest
jmp increment   # jump to loop beginning

loop_exit:
movl $1, %eax
int $0x80
