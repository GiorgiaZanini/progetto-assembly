.section .data
    stringa: .ascii "stringa di prova\n\0"
    a_capo: .ascii "\n\0"
    numero_str: .ascii "127\0"

.section .text
    .global _start

    _start:    
        leal stringa, %eax  # passo alla funzione il puntatore al primo carattere della stringa
        call stampa_stringa

        leal numero_str, %eax
        call converti_str_a_int
#        movl $235, %eax
        call converti_int_a_str
        call stampa_stringa
        leal a_capo, %eax
        call stampa_stringa

        movl $1, %eax   # sys_exit (0 -> da testare appena funziona (anche su salva_numeri))
        xorl %ebx, %ebx
        int $0x80
