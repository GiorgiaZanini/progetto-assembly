.section .data
    pianificazione_fd: .long -1
    puntatore_array_ordini: .long 0     # puntatore all'array dove sono salvati i numeri
    dimensione_array_ordini: .long 0
    tempo: .long 0   
    counter: .long 0    # punta al primo valore dell'ordine successivo (a ogni iterazione viene incrementato di 4)
    penalty: .long 0

    due_punti: .ascii ":\0"
    conclusione_str: .ascii "Conclusione: \0"
    penanlty_str: .ascii "Penalty: \0"

    a_capo: .ascii "\n\0"

.section .text
    .global elabora_ordini
    .type elabora_ordini, @function

    elabora_ordini:
        # esi contiene il puntatore a array_ordini
        movl %ebx, pianificazione_fd
        movl %esi, puntatore_array_ordini
        movl %ecx, dimensione_array_ordini

        # riazzero valori, perché la funzione, se richiamata, contiene ancora i valori del calcolo precedente
        movl $0, counter
        movl $0, tempo
        movl $0, penalty

    ciclo_elaborazione:
        xorl %eax, %eax
        xorl %ebx, %ebx

        movl counter, %edx
        movl dimensione_array_ordini, %ecx

        # se counter ha raggiunto la dimensione massima, è arrivato alla fine degli ordini
        cmpl %ecx, %edx
        jge fine

        # stampa id prodotto : tempo di inizo \n (e scrive su file)
        pusha
        movb (%esi, %edx), %al
        call converti_int_a_str
        movl pianificazione_fd, %ebx
        call stampa_stringa
        popa
        pusha
        leal due_punti, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        movl tempo, %eax
        call converti_int_a_str
        movl pianificazione_fd, %ebx
        call stampa_stringa
        leal a_capo, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        popa

        # incremento il tempo della durata dell'ordine corrente. Ora ho il termpo di fine dell'ordine/inizio del successivo
        movl tempo, %eax
        addl $1, %edx
        movb (%esi, %edx), %bl  # prendo la durata (secondo valore dell'ordine) per sommarla al tempo

        addl %ebx, %eax
        movl %eax, tempo

        addl $1, %edx
        movb (%esi, %edx), %bl  # predo la scadenda (terzo valore dell'ordine), per controllare se è oltre l'unità di tempo in cui è finita la produzione di questo prodotto è oltre la scadenza

        cmpl %ebx, %eax
        jg calcola_penalty  # se tempo > scadenza, calcolo la penalità

    prepara_prossimo_ciclo:    
        # risetto il counter (edx) al primo valore dell'ordine appena eseguito, 
        # e lo incremento affinché corrisponda al primo valore dell'ordine successivo (ovvero quello che devo calcolare)
        movl counter, %edx
        addl $4, %edx
        movl %edx, counter

        jmp ciclo_elaborazione

    calcola_penalty:
        # priorità * (tempo_fine - scadenza)
        subl %ebx, %eax     # tempo - scadenza

        addl $1, %edx
        movb (%esi, %edx), %bl      # predo la priorità (quarto valore dell'ordine)

        mull %ebx

        movl penalty, %ebx
        addl %ebx, %eax         # aggiorno penalty, sommando al valore calcolato finora
        movl %eax, penalty

        jmp prepara_prossimo_ciclo

    fine:
        pusha
        leal conclusione_str, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        movl tempo, %eax
        call converti_int_a_str
        movl pianificazione_fd, %ebx
        call stampa_stringa
        leal a_capo, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        popa

        pusha
        leal penanlty_str, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        movl penalty, %eax
        call converti_int_a_str
        movl pianificazione_fd, %ebx
        call stampa_stringa
        leal a_capo, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        popa

        ret


        






