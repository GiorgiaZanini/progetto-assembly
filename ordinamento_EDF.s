# scadenza (terzo numero)
# crescente

.section .data
    puntatore_array_ordini: .long 0     # puntatore all'array dove sono salvati i numeri
#    array_ordini: .space 40
    counter_array_ordini: .long 0
    counter_corrente: .long 2   # terza posizione   --> contatore 1
    counter_di_scorrimento: .long 6     # contatore_corrente + 4    --> contatore 2

    ok: .ascii "i numeri sono nell'ordine corretto\n\0"
    inverti: .ascii "i numeri sono da scambiare\n\0"
    a_capo: .ascii "\n\0"

.section .text
    .global ordinamento_EDF
    .type ordinamento_EDF, @function
    
    ordinamento_EDF:
        # esi contiene il puntatore a array_ordini
        movl %esi, puntatore_array_ordini
        movl %ecx, counter_array_ordini

#        leal array_ordini, %edi
#        rep movsb   # Copia %ecx byte da [%esi] a [%edi]

    confronto_numeri:
#        movl puntatore_array_ordini, %eax
#        addl counter_corrente, %eax
#        movl (%eax), %eax

        movb (puntatore_array_ordini, counter_corrente), %al

#        movl puntatore_array_ordini, %ebx
#        addl counter_di_scorrimento, %ebx
#        movl (%ebx), %ebx

        movb (puntatore_array_ordini, counter_di_scorrimento), %bl

        # printf
        pusha
        call converti_int_a_str
        call stampa_stringa
        leal a_capo, %eax
        call stampa_stringa
        popa
        pusha
        movl %ebx, %eax
        call converti_int_a_str
        call stampa_stringa
        leal a_capo, %eax
        call stampa_stringa
        popa

        cmpb %al, %bl
        jg inverti_numeri

        jmp incrementa_contatore_2

    inverti_numeri:
        pusha
        leal inverti, %eax
        call stampa_stringa
        popa

        jmp fine

    incrementa_contatore_2:
        pusha
        leal ok, %eax
        call stampa_stringa
        popa

    fine:
        ret
