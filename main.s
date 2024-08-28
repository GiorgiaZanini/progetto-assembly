.section .data
    ordini_fd: .int -1
    pianificazione_fd: .int -1
    errore_parametri: .ascii "Errore: parametri di input mancanti\n\0"
    errore_apertura_file: .ascii "Errore: apertura file\n\0"

.section .text

    .global _start

    _start:
    popl %esi
    popl %esi

    # parametro_1
    popl %esi

    # Se il parametro_1 non è vuoto -> apri il file
    testl %esi, %esi
    jz errore_parametri

    # Apri il file del parametro_1
    movl $5, %eax   # Syscall open
    movl %esi, %ebx # Nome del file
    movl $0, %ecx   # Modalità lettura
    int $0x80

    # Se il file descriptor è null -> errore
    cmp $0, %eax
    jl errore_apertura_file

    movl %eax, ordini_fd

    call salva_numeri

    # parametro_2
    popl %esi

    # Se il parametro_2 non è vuoto -> apri il file
    testl %esi, %esi
    # jz endParams

    # Apri il file del parametro_2
    movl $5, %eax   # Syscall open
    movl %esi, %ebx # Nome del file
    movl $1, %ecx   # Modalità scrittura
    int $0x80

    cmp $0, %eax
    jl errore_apertura_file

    movl %eax, pianificazione_fd
