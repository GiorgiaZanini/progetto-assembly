# scadenza (terzo numero)
# crescente
# bubble sort

.section .data
    puntatore_array_ordini: .long 0     # puntatore all'array dove sono salvati i numeri
#    array_ordini: .space 40
    dimensione_array_ordini: .long 0
    counter_corrente: .long 2   # terza posizione   --> contatore 1
#    counter_di_scorrimento: .long 6     # contatore_corrente + 4    --> contatore 2

#    array_di_prova: .byte 1,2,3,4,5,6,7,8
    ok: .ascii "i numeri sono nell'ordine corretto\n\0"
    inverti: .ascii "i numeri sono da scambiare\n\0"
    a_capo: .ascii "\n\0"

.section .text
    .global ordinamento_EDF
    .type ordinamento_EDF, @function

    ordinamento_EDF:
        # esi contiene il puntatore a array_ordini
        movl %esi, puntatore_array_ordini
        movl %ecx, dimensione_array_ordini

        movl counter_corrente, %edx

        decl %ecx   # decrementa per loop (numero iterazioni)
        
    bubble_sort:
        jmp controllo_bubble_sort

    confronto_numeri:
        xorl %eax, %eax
        xorl %ebx, %ebx
        movb (%esi,%edx), %al  # sposto il terzo numero dell'ordine puntato in eax

        addl $4, %edx
        movb (%esi,%edx), %bl    # sposto il terzo numero dell'ordine puntato +1 in ebx

        cmpb %al, %bl   # confronto i due numeri, se il primo è più grande li inverto
        jl inverti_numeri

        jmp incrementa_contatore_2

    inverti_numeri:
        pusha
        leal inverti, %eax
        call stampa_stringa
        leal a_capo, %eax
        call stampa_stringa
        popa

        jmp fine

    incrementa_contatore_2:
        pusha
        leal ok, %eax
        call stampa_stringa
        leal a_capo, %eax
        call stampa_stringa
        popa

    controllo_bubble_sort:
        addl $4, %edx

        cmpl %edx, %ecx
        subl $4, %edx
        jle bubble_sort

        

    fine:
        ret
