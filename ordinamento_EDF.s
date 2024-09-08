.section .data
    puntatore_array_ordini: .long 0     # puntatore all'array dove sono salvati i numeri
    counter_array_ordini: .long 0
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
        movl %ecx, counter_array_ordini

        movl counter_corrente, %edx

        decl %ecx   # decrementa per loop (numero iterazioni)
        
    controllo_bubble_sort:
        addl $4, %edx

        cmpl %ecx, %edx
        jg descrementa_ordini    # se ecx < edx decrementa gli ordini di 1 e riparti col bubblesort

        subl $4, %edx # rimuovo il +4 aggiunto per verificare che esista un ordine successivo

    confronto_scadenza:
        xorl %eax, %eax
        xorl %ebx, %ebx
        movb (%esi,%edx), %al  # sposto il terzo numero dell'ordine puntato in eax

        addl $4, %edx
        movb (%esi,%edx), %bl    # sposto il terzo numero dell'ordine puntato +1 in ebx

        cmpb %al, %bl   # confronto i due numeri, se il primo è più grande li inverto
        jl inverti_numeri
        je confronta_priorita

        pusha
        leal ok, %eax
        call stampa_stringa
        popa

        jmp controllo_bubble_sort

    confronta_priorita:
        xorl %eax, %eax
        xorl %ebx, %ebx
        subl $3, %edx
        movb (%esi,%edx), %al  # sposto il terzo numero dell'ordine puntato in eax

        addl $4, %edx
        movb (%esi,%edx), %bl    # sposto il terzo numero dell'ordine puntato +1 in ebx

        decl %edx
        cmpb %al, %bl   # confronto i due numeri, se il primo è più grande li inverto    
        jle controllo_bubble_sort

    inverti_numeri:
        pusha
        leal inverti, %eax
        call stampa_stringa
        popa

        # pusho il secondo ordine nello stack
        addl $1, %edx
        movb (%esi, %edx), %bl
        pushl %ebx

        subl $1, %edx
        movb (%esi, %edx), %bl
        pushl %ebx

        subl $1, %edx
        movb (%esi, %edx), %bl
        pushl %ebx

        subl $1, %edx
        movb (%esi, %edx), %bl
        pushl %ebx

        # scrivo il primo ordine nel secondo ordine
        subl $4, %edx
        movb (%esi, %edx), %bl
        addl $4, %edx
        movb %bl, (%esi, %edx)

        subl $3, %edx
        movb (%esi, %edx), %bl
        addl $4, %edx
        movb %bl, (%esi, %edx)

        subl $3, %edx
        movb (%esi, %edx), %bl
        addl $4, %edx
        movb %bl, (%esi, %edx)

        subl $3, %edx
        movb (%esi, %edx), %bl
        addl $4, %edx
        movb %bl, (%esi, %edx)

        # poppo il secondo ordine e lo scrivo nel primo
        subl $7, %edx
        popl %ebx
        movb %bl, (%esi, %edx)

        addl $1, %edx
        popl %ebx
        movb %bl, (%esi, %edx)

        addl $1, %edx
        popl %ebx
        movb %bl, (%esi, %edx)

        addl $1, %edx
        popl %ebx
        movb %bl, (%esi, %edx)

        # ripristino l'indice dell'array alla terza casella del secondo ordine
        addl $3, %edx

        pusha
        movl %esi, %eax
        movl counter_array_ordini, %ecx
        call stampa_array
        leal a_capo, %eax
        call stampa_stringa
        popa

        jmp controllo_bubble_sort  

    descrementa_ordini:
        # decrementa di 4 ecx, rimuovendo l'ultimo ordine e resetta edx a 2
        subl $4, %ecx
        movl $2, %edx

        pusha 
        leal test, %eax
        call stampa_stringa
        popa

        # continua il ciclo finché ecx non diventa 3
        # sennò salta a fine
        cmpl $3, %ecx
        jg controllo_bubble_sort

    fine:
        movl puntatore_array_ordini, %esi
        movl counter_array_ordini, %ecx
        ret
