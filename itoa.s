.section .data
    car:
        .byte 0 # la variabile car è dichiarata di tipo byte

.section .text
    .global itoa                # rende visibile il simbolo itoa al linker
    .type itoa, @function       # dichiarazione della funzione itoa
                                # la funzione converte un intero in una stringa
                                # il numero da convertire deve essere
                                # stato caricato nel registro eax

    itoa:
        mov $0, %ecx            # carica il numero 0 in ecx

    continua_a_dividere:
        cmp $10, %eax           # confronta 10 con il contenuto di eax
        jge dividi              # salta all'etichetta dividi se eax è
                                # maggiore o uguale di 10
        pushl %eax              # salva nello stack il contenuto di eax
        inc %ecx                # incrementa di 1 il valore di ecx per
                                # contare quante push eseguo
                                # ad ogni push salvo nello stack una cifra del
                                # numero (a partire da quella meno significativa)
        mov %ecx, %ebx          # pone il valore di ecx in ebx
        jmp stampa              # salta all'etichetta stampa

    dividi:
        movl $0, %edx           # carica 0 in edx
        movl $10, %ebx          # carica 10 in ebx
        divl %ebx               # divide per ebx (10) il numero ottenuto
                                # concatenando il contenuto di dx e ax (notare che
                                # in questo caso dx=0)
                                # il quoziente viene messo in eax, il resto in dx
        pushl %edx              # salva il resto nello stack
        inc %ecx                # incrementa il contatore delle cifre da stampare
        jmp continua_a_dividere

    stampa:JZ
    cmp $0, %ebx                # controlla se ci sono (ancora) caratteri da
                                # stampare
    je fine_itoa                # se ebx=0 ho stampato tutto, quindi salto alla fine
    popl %eax                   # preleva l'elemento da stampare dallo stack
    movb %al, car               # memorizza nella variabile car il valore contenuto
                                # negli 8 bit meno significativi del registro eax
                                # gli altri bit del registro non ci interessano
                                # visto che una cifra decimale e' contenuta in
                                # un solo byte
    addb $48, car               # somma al valore car il codice ascii del carattere
                                # '0' (zero)
    dec %ebx                    # decrementa di 1 il numero di cifre da stampare
    pushw %bx                   # salviamo il valore di bx nello stack poiché
                                # per effettuare la stampa dobbiamo modificare
                                # i valori dei registri come richiesto
                                # dalla funzione del sistema operativo WRITE
    movl $4, %eax               # codice della funzione write
    movl $1, %ebx               # la write scrive nello standard output
                                # identificato dal file descriptor 1
    leal car, %ecx              # il puntatore della stringa da stampare deve
                                # essere caricato in ecx
                                # l'istruzione lea carica l'indirizzo della
                                # locazione di memoria indicata dall’etichetta car,
                                # nel registro ecx
    mov $1, %edx                # la lunghezza della stringa da stampare deve
                                # essere caricata in edx
    int $0x80                   # chiamata all'interrupt 0x80 per la stampa di car
    popw %bx                    # recupera il contatore dei caratteri da stampare
                                # salvato nello stack prima della chiamata alla
                                # funzione write
    jmp stampa                  # ritorna all'etichetta stampa per stampare il
                                # prossimo carattere. Notare che il blocco di
                                # istruzioni compreso tra l'etichetta stampa
                                # e l'istruzione jmp stampa e' un classico
                                # esempio di come creare un ciclo while in assembly
    
    fine_itoa:
        movb $10, car           # copia il codice ascii del carattere line feed
                                # (per andare a capo riga) nella variabile car
        movl $4, %eax           # solito blocco di istruzioni per la stampa
        movl $1, %ebx
        leal car, %ecx
        mov $1, %edx
        int $0x80
        ret                     # fine della funzione itoa
                                # l'esecuzione riprende dall'istruzione sucessiva
                                # alla call che ha invocato itoa