#PURPOSE: Illustrate how functions work, compute 2^3 + 5^2

.section .data

.section .text

.globl _start
_start:
    pushl $0        # Push second argument
    pushl $2        # Push first argument
    call power      # call func
    addl $8, %esp   # move the stack pointer back
    pushl %eax      # save the first answer

    pushl $2        # push second argument
    pushl $5        # push first argument
    call power      # call func
    addl $8, %esp   # move stack pointer back

    popl %ebx       # Second answer is in %eax, first answer was in the stack. Move it into %ebx

    addl %eax, %ebx  # Add them together, into %ebx

    movl $1, %eax   # exit (%ebx is returned)
    int $0x80

# Computer the value of a num raised to a power
# %ebx - holds base power
# %ecx - holds power
# -4(%ebp) holds current result
# %eax is used for temp storage

.type power, @function
power:
    pushl %ebp     # save old base pointer
    movl %esp, %ebp # make stack pointer the base pointer
    subl $4, %esp  # make room for local storage

    movl 8(%ebp), %ebx # put first argument into %ebx
    movl 12(%ebp), %ecx # put second argument into %ecx
    movl %ebx, -4(%ebp) # store the current result

    cmpl $0, %ecx  # check if power is 0
    je power_zero

    power_loop_start:
        cmpl $1, %ecx # if the power is 1, we are done
        je end_power
        movl -4(%ebp), %eax # move the current result into %eax
        imull %ebx, %eax # mult the current result by the base number
        movl %eax, -4(%ebp) # store the current result

        decl %ecx  # decrease the power
        jmp power_loop_start

    power_zero:
        movl $1, -4(%ebp)   # Set the answer to 1
        jmp end_power       # End

    end_power:
        movl -4(%ebp), %eax # return value goes in %eax
        movl %ebp, %esp # restore the stack pointer
        popl %ebp  # restore the base pointer
        ret
        