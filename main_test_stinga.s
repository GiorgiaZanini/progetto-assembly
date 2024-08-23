.section .data
    stringa: .ascii "stringa di prova\n\0"

.section .text
    .global _start

    _start:    
        leal stringa, %eax  # passo alla funzione il puntatore al primo carattere della stringa
        call stampa_stringa

        movl $1, %eax   # sys_exit (0 -> da testare appena funziona (anche su salva_numeri))
        xorl %ebx, %ebx
        int $0x80
