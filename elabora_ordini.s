.section .data
    puntatore_array_ordini: .long 0     # puntatore all'array dove sono salvati i numeri
    dimensione_array_ordini: .long 0
    tempo: .long 0   
    counter: .long 0
    penality: .long 0

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

    ciclo_elaborazione:
        xorl %eax, %eax
        xorl %ebx, %ebx

        movl counter, %edx
        movl dimensione_array_ordini, %ecx

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

        movl tempo, %eax
        addl $1, %edx
        movb (%esi, %edx), %bl 

        addl %ebx, %eax
        movl %eax, tempo

        addl $1, %edx
        movb (%esi, %edx), %bl 

        cmpl %ebx, %eax
        jg calcola_penality

    prepara_prossimo_ciclo:    
        movl counter, %edx
        addl $4, %edx
        movl %edx, counter

        jmp ciclo_elaborazione

    calcola_penality:
        subl %ebx, %eax

        addl $1, %edx
        movb (%esi, %edx), %bl 

        mull %ebx

        movl penality, %ebx
        addl %ebx, %eax
        movl %eax, penality

        jmp prepara_prossimo_ciclo

    fine:
        pusha
        leal conclusione_str, %eax
        call stampa_stringa
        movl tempo, %eax
        call converti_int_a_str
        call stampa_stringa
        leal a_capo, %eax
        call stampa_stringa
        popa

        pusha
        leal penanlty_str, %eax
        call stampa_stringa
        movl penality, %eax
        call converti_int_a_str
        call stampa_stringa
        leal a_capo, %eax
        call stampa_stringa
        popa

        ret


        






