# scadenza (terzo numero)
# crescente
# bubble sort

.section .data
    puntatore_array_ordini: .long 0     # puntatore all'array dove sono salvati i numeri
    indice_max_array_ordini: .long 0
    counter_corrente: .long 2   # terza posizione

    ok: .ascii "i numeri sono nell'ordine corretto\n\0"
    inverti: .ascii "i numeri sono da scambiare\n\0"
    test: .ascii "sono nel controllo per il bubble\n\0"
    a_capo: .ascii "\n\0"

.section .text
    .global ordinamento_EDF
    .type ordinamento_EDF, @function

    ordinamento_EDF:
        # esi contiene il puntatore a array_ordini
        movl %esi, puntatore_array_ordini
        movl %ecx, indice_max_array_ordini

        movl counter_corrente, %edx

        decl %ecx   # decrementa per loop (numero iterazioni)
        jmp confronto_numeri
        
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

        pusha
        leal ok, %eax
        call stampa_stringa
        popa

        jmp bubble_sort

    inverti_numeri:
        pusha
        leal inverti, %eax
        call stampa_stringa
        popa

        jmp bubble_sort

    controllo_bubble_sort:
        pusha
        popa

        addl $4, %edx

        cmpl %edx, %ecx
        subl $4, %edx
        jle confronto_numeri    # se edx <= ecx continua con l'iterazione successiva

        # se è maggiore decrementa di 4 ecx e resetta edx a 2
        subl $4, %ecx
        movl $2, %edx

        # continua il ciclo finché ecx non diventa 3
        # sennò salta a fine
        cmpl $3, %ecx
        jg confronto_numeri

    fine:
        movl puntatore_array_ordini, %esi
        movl puntatore_array_ordini, %eax
        ret
