.section .data
    array:  .byte 10, 3, 5, 4, 6, 1, 9  # Array di byte da ordinare
    length: .int 7                              # Lunghezza dell'array
    newline: .byte 0x0A                          # Carattere di nuova linea '\n'
    a_capo: .ascii "\n\0"

.section .text
    .globl _start

_start:
    # Inizializzazione
    movl length, %ecx          # ECX = numero di elementi dell'array (length)
    decl %ecx                  # ECX = length - 1 (numero di passaggi dell'ordinamento)

bubble_sort:
    xorl %ebx, %ebx            # EBX = 0, indice per l'array
    movl %ecx, %edx            # EDX = ECX (numero di confronti da fare per passaggio)

compare:
    movb array(%ebx), %al      # AL = array[EBX] (elemento corrente)
    cmpb array+1(%ebx), %al    # Confronta array[EBX] con array[EBX+1]
    jbe no_swap                # Se array[EBX] <= array[EBX+1], salta lo scambio

    # Scambio
    movb array+1(%ebx), %al    # AL = array[EBX+1]
    movb array(%ebx), %ah      # AH = array[EBX]
    movb %al, array(%ebx)      # array[EBX] = array[EBX+1]
    movb %ah, array+1(%ebx)    # array[EBX+1] = array[EBX]

no_swap:
    incl %ebx                  # Passa all'elemento successivo
    decl %edx                  # Decrementa il contatore dei confronti
    jnz compare                # Ripeti finché ci sono confronti da fare

    decl %ecx                  # Decrementa il numero di passaggi da fare
    jnz bubble_sort            # Ripeti l'ordinamento finché ci sono passaggi da fare

    # Stampa l'array ordinato
    movl $length, %ecx         # ECX = numero di elementi dell'array
    xorl %ebx, %ebx            # EBX = 0, indice per l'array
        movl length, %ecx


print_array:
    xorl %eax, %eax
    movb array(%ebx), %al      # AL = array[EBX]
    pusha
    call converti_int_a_str
    call stampa_stringa
    leal a_capo, %eax
    call stampa_stringa
    popa



    incl %ebx                  # Passa all'elemento successivo
    decl %ecx                  # Decrementa il contatore degli elementi rimanenti
    cmpl $0, %ecx
    jne print_array            # Ripeti finché ci sono elementi da stampare

    # Stampa una nuova linea
    movb $0x0A, %al            # AL = '\n' (newline)
    movl $1, %edx              # Lunghezza da scrivere = 1 byte
    movl $1, %ebx              # File descriptor = 1 (stdout)
    movl $4, %eax              # Syscall number = 4 (sys_write)
    int $0x80                  # Esegui la syscall

    # Termina il programma
    movl $1, %eax              # Chiamata di sistema: exit
    xorl %ebx, %ebx            # Codice di uscita: 0
    int $0x80                  # Interruzione del kernel per eseguire la syscall
