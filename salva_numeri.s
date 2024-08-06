.section .data
    ordini_fd: .int -1
    array:      .long 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0

.section .text
    .global salva_numeri
#    .type salva_numeri, @function

    salva_numeri:
        movl %eax, ordini_fd
        
        # Lettura di 1 byte alla volta (1 carattere)
        mov $3, %eax        # syscall read
        mov pianificazione_fd, %ebx         # File descriptor
        mov $array, %ecx    # Buffer di input
        mov $1, %edx        # Lunghezza massima
        int $0x80  

        