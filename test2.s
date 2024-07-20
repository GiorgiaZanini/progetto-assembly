.section .data
filename:    .asciz "input.txt"
buffer:      .space 1024
numbers:     .space 256       # spazio per gli interi

.section .bss
.lcomm int_buffer, 256

.section .text
.globl _start

_start:
    # Open the file
    movl $5, %eax            # sys_open
    movl $filename, %ebx     # filename
    movl $0, %ecx            # read-only mode
    int $0x80

    # Check if the file was opened successfully
    test %eax, %eax
    js _exit
    movl %eax, %ebx          # file descriptor

    # Read the file content into buffer
    movl $3, %eax            # sys_read
    movl %ebx, %ebx          # file descriptor
    movl $buffer, %ecx       # buffer
    movl $1024, %edx         # buffer size
    int $0x80

    # Check if the file was read successfully
    test %eax, %eax
    js _exit

    movl %eax, %esi          # save the number of bytes read
    movl $buffer, %edi       # pointer to the buffer

    # Initialize the pointers
    movl $int_buffer, %edi   # destination for integers
    xorl %ebx, %ebx          # clear EBX to use as temporary storage for integer conversion

parse_loop:
    cmp $0, %esi              # check if we have read all bytes
    je end_parsing

    movb (%ecx), %al         # read a byte
    inc %ecx
    dec %esi

    # Check if the byte is a digit
    cmp $'0', %al
    jb parse_loop            # not a digit, continue parsing
    cmp $'9', %al
    ja parse_loop            # not a digit, continue parsing

    # Convert ASCII to integer
    sub $'0', %al
    imul $10, %ebx           # multiply previous number by 10
    add %eax, %ebx           # add current digit

    # Check the next character to see if it's still part of the number
    cmp $0, %esi              # check if we have read all bytes
    je save_number

    movb (%ecx), %al         # read the next byte
    cmp $'0', %al
    jb save_number           # if not a digit, save the current number
    cmp $'9', %al
    ja save_number           # if not a digit, save the current number
    jmp parse_loop

save_number:
    mov %ebx, (%edi)         # save the integer
    add $4, %edi             # move to the next position in int_buffer
    xorl %ebx, %ebx          # reset EBX for the next number

    jmp parse_loop

end_parsing:
    # Exit the program
_exit:
    movl $1, %eax            # sys_exit
    xorl %ebx, %ebx          # exit code 0
    int $0x80
