.section .data
    ordini_fd: .int -1
    pianificazione_fd: .int -1
    errore_parametri: .ascii "Errore: parametri di input mancanti\n\0"
    errore_apertura_file: .ascii "Errore: apertura file\n\0"

    # temporaneo per testare
    a_capo: .ascii "\n\0"
    filename:   .asciz "input.txt"
.section .text

    .global _start

_start:
#    popl %esi
#    popl %esi

    # parametro_1
#    popl %esi

    # Se il parametro_1 non è vuoto -> apri il file
#    testl %esi, %esi
#    jz errore_parametri

    # Apri il file del parametro_1
    movl $5, %eax   # sys_open
    movl filename, %ebx     # temporaneo per testare
#    movl %esi, %ebx # nome file
    movl $0, %ecx   # solo lettura
    int $0x80
    # salva poi in eax il file descriptor

    # Se il file descriptor è null -> errore
    cmp $0, %eax
    jl errore_file

    movl %eax, ordini_fd
    call salva_numeri

    # parametro_2
#    popl %esi

    # Se il parametro_2 non è vuoto -> apri il file
#    testl %esi, %esi
    # jz endParams

    # Apri il file del parametro_2
#    movl $5, %eax   # Syscall open
#    movl %esi, %ebx # Nome del file
#    movl $1, %ecx   # Modalità scrittura
#    int $0x80

#    cmp $0, %eax
#    jl errore_apertura_file

#    movl %eax, pianificazione_fd

exit:
    # per testare se funziona singolarmente -> sys_exit
    movl $1, %eax
    xorl %ebx, %ebx
    int $0x80

errore_file:
    call converti_int_a_str
    call stampa_stringa
    leal a_capo, %eax
    call stampa_stringa

    leal errore_apertura_file, %eax
    call stampa_stringa
    jmp exit
