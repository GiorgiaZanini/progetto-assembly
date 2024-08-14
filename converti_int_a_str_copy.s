.section .data
    array: .space 11    # 10 cifre + terminatore
    buffer: .space 11   # Buffer per leggere l'input dalla tastiera

.section .text
    .global _start

    _start:

        ## Leggi l'intero da tastiera

        movl $3, %eax              # syscall: sys_read
        movl $0, %ebx              # file descriptor: stdin
        leal buffer, %ecx          # Puntatore al buffer
        movl $10, %edx             # Numero massimo di byte da leggere
        int $0x80                  # Chiamata al kernel

        # Converti la stringa letta in un intero
        leal buffer, %esi          # Puntatore al buffer
        xorl %eax, %eax            # Azzerare %eax (accumulatore per il numero)

    convert_loop:
        movb (%esi), %dl           # Carica il prossimo carattere
        cmpb $0x0A, %dl            # Controlla se è un newline (0x0A)
        je done_conversion         # Se è newline, esci dal loop
        subb $'0', %dl             # Converti da ASCII a valore numerico
        imull $10, %eax            # Moltiplica l'attuale valore per 10
        addl %edx, %eax            # Aggiungi la nuova cifra
        incl %esi                  # Passa al prossimo carattere
        jmp convert_loop           # Ripeti

    done_conversion:

        # Conversione dell'intero in stringa
        movl $10, %ebx             # per dividere per 10 e prendere l'ultima cifra
        xorl %ecx, %ecx            # %ecx conterrà il numero di cifre

    divisione:
        xorl %edx, %edx            # azzera il resto
        divl %ebx                  # eax : ebx = eax / 10, resto in edx
        addl $48, %edx             # Converti il resto in carattere ASCII
        pushl %edx                 # Salva la cifra nello stack
        incl %ecx                  # Incrementa il contatore di cifre

        testl %eax, %eax           # Se eax è 0, la divisione è finita
        jnz divisione

    converti_a_stringa:
        movl $0, %ebx              # Inizializza l'indice

    scrivi_cifre:
        popl %edx                  # Recupera la cifra dallo stack
        movb %dl, array(%ebx)      # Salva la cifra nell'array
        incl %ebx                  # Incrementa l'indice

        decl %ecx                  # Decrementa il contatore di cifre
        jnz scrivi_cifre           # Continua finché non abbiamo finito

    aggiungi_terminatore:
        movb $0, array(%ebx)       # Aggiungi terminatore null

        ## Stampa il numero convertito

        movl $4, %eax              # syscall: sys_write
        movl $1, %ebx              # file descriptor: stdout
        leal array, %ecx           # Puntatore alla stringa da stampare
        subl $1, %ebx              # Correggi l'indice
        movl %ebx, %edx            # Usa %ebx come lunghezza della stringa
        int $0x80                  # Chiamata al kernel per la stampa

    fine:
        # per testare se funziona singolarmente -> sys_exit
        movl $1, %eax              # syscall: sys_exit
        xorl %ebx, %ebx            # exit code: 0
        int $0x80
