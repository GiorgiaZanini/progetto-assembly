.section .data
    stringa: .ascii "stringa di prova\n\0"

.section .text
    .global _start

    _start:    
        movl stringa, %eax  # passo alla funzione il puntatore al primo carattere della stringa
        call stampa_stringa

        movl $1, %eax
        xorl %ebx, %ebx
        int $0x80
