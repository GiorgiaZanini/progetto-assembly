.section .data
filename:   .asciz "input.txt"
buffer:     .space 160  # 16 (4 byte * 4 spazi) * 10 (spazie dell'array)
array:      .long 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
fmt:        .asciz "%d\n"  # Formato per la stampa dei numeri

.section .text
.globl _start

_start:
    # Apri il file
    movl $5, %eax          # sys_open
    movl $filename, %ebx   # Puntatore al nome del file
    movl $0, %ecx          # costante 0 per (solo) leggere il file
    int $0x80
    movl %eax, %ebx        # File descriptor

    # Leggi il contenuto del file
    movl $3, %eax          # sys_read
    movl %ebx, %ebx        # File descriptor
    leal buffer, %ecx      # Puntatore al buffer
    movl $1023, %edx       # Dimensione del buffer
    int $0x80


    add $1, %eax            # aggiungi 1 alla quantità dei caratteri letti dal file
    movb $0, (%ecx, %eax)   # insrisci '/0' alla fine dei caratteri letti

    movl %eax, %edx         # salva caratteri letti per essere usati nella syscall write

    

    # syscall write
    movl $4, %eax            
    movl $1, %ebx            
    leal buffer, %ecx         
    movl %edx, %edx     
    int $0x80
    

    # Uscita
    movl $1, %eax          # sys_exit
    xor %ebx, %ebx        # Exit code 0
    int $0x80

