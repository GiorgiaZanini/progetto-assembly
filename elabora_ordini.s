.section .data
    puntatore_array_ordini: .long 0     # puntatore all'array dove sono salvati i numeri
    dimensione_array_ordini: .long 0
    n_ordini: .long 0
    tempo: .long 0   # terza posizione
    counter: .long 0

    tempo_max: .long 100
    due_punti: .ascii ":\0"
    conclusione_str: .ascii "Conclusione: \0"
    penanlty_str: .ascii "Penalty: \0"

    ok: .ascii "i numeri sono nell'ordine corretto\n\0"
    inverti: .ascii "i numeri sono da scambiare\n\0"
    test: .ascii "sono nel controllo per il bubble\n\0"
    a_capo: .ascii "\n\0"

.section .text
    .global elabora_ordini
    .type elabora_ordini, @function

    elabora_ordini:
        # esi contiene il puntatore a array_ordini
        movl %esi, puntatore_array_ordini
        movl %ecx, dimensione_array_ordini

        movl %ecx, %eax
        movl $10, %ebx
        divl %ebx

        movl %eax, n_ordini

    ciclo_elaborazione:
        xorl %eax, %eax

        movl counter, %edx
        movl n_ordini, %ecx

        cmpl %ecx, %edx
        jge fine

        pusha
        movb (%esi, %edx), %al
        call converti_int_a_str
        call stampa_stringa
        popa
        pusha
        leal due_punti, %eax
        call stampa_stringa
        movl tempo, %eax
        call converti_int_a_str
        call stampa_stringa
        leal a_capo, %eax
        call stampa_stringa
        popa


        ret

    fine:

        ret


        






