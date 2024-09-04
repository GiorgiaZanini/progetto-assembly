.section .bss
    input: .space 4          # Spazio per l'input dell'utente

.section .data
    RScelta: .byte 0         # Variabile per memorizzare la scelta
    Scelta:
        .ascii "Scegli se usare l'algoritmo \n1. EDF (Earliest Deadline First) \n2. HPF (Highest Priority First).\n\0"
    InSceltaNonValida:
        .ascii "Scelta non valida.\n\0"

	EDFScelto:
		.ascii "Hai scelto l'algoritmo EDF.\n\0"
	HPFScelto:
		.ascii "Hai scelto l'algoritmo HPF.\n\0"
.section .text
    .global _start

_start:

_PrimaRichiestaInput:
    # Stampa la stringa di richiesta dell'algoritmo
    leal Scelta, %eax
    call stampa_stringa

_input:
    # Legge l'input dell'algoritmo scelto
    movl $3, %eax            # sys_read
    movl $0, %ebx            # File descriptor 0 (stdin)
    movl $input, %ecx        # Buffer dove salvare l'input
    movl $4, %edx            # Numero massimo di byte da leggere
    int $0x80                # Chiamata di sistema

    # Verifica se il primo carattere è valido (1 o 2)
    movb input, %al          # Carica il primo carattere in %al
    subb $0x30, %al          # Converti il carattere ASCII in numero (0-9)
    cmpb $1, %al             # Confronta con 1
    je _CheckLength          # Se è 1, controlla la lunghezza
    cmpb $2, %al             # Confronta con 2
    je _CheckLength          # Se è 2, controlla la lunghezza

    jmp _InputNonValido      # Altrimenti, input non valido

_CheckLength:
    # Verifica se c'è un altro carattere (input lungo più di una cifra)
    movb input+1, %bl        # Carica il secondo carattere in %bl
    cmpb $0xA, %bl           # Verifica se è un newline (\n)
    je _ControlloScelta      # Se c'è solo un carattere, è valido
    cmpb $0, %bl             # Verifica se è il terminatore di stringa (NUL)
    je _ControlloScelta      # Se sì, è valido

    jmp _InputNonValido      # Se c'è un altro carattere, input non valido

_ControlloScelta:
    # Esegui l'algoritmo scelto
    cmpb $1, %al             # Controlla se è 1
    je _EDF                  # Se sì, esegui EDF
    cmpb $2, %al             # Controlla se è 2
    je _HPF                  # Se sì, esegui HPF

    jmp _InputNonValido      # Altrimenti, input non valido

_EDF:
    # Gestione dell'algoritmo EDF
    leal EDFScelto, %eax
    call stampa_stringa
    jmp _fine

_HPF:
    # Gestione dell'algoritmo HPF
    leal HPFScelto, %eax
    call stampa_stringa
    jmp _fine

_InputNonValido:
    leal InSceltaNonValida, %eax
    call stampa_stringa
    jmp _input

_fine:
    movl $1, %eax            # sys_exit
    xorl %ebx, %ebx          # Stato di uscita 0
    int $0x80                # Chiamata di sistema
