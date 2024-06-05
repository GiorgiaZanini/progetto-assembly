.section .data
filename:   .asciz "input.txt"
fmt_num:    .asciz "%d\n"        # Formato per la stampa dei numeri
buffer:     .space 1024  # Buffer per la lettura del file
array:      .space 1024   # Array per memorizzare i puntatori alle righe
num_lines:  .space 4  # Contatore delle righe del file

.section .text
.globl _start

_start:
    # Apri il file
    movl $5, %eax                # sys_open
    movl $filename, %ebx         # Puntatore al nome del file
    movl $0, %ecx                # O_RDONLY
    int $0x80
    test %eax, %eax              # Controlla se c'è stato un errore nell'apertura del file
    js exit_error                # Se c'è stato un errore, esci

    movl %eax, %ebx              # Salva il file descriptor in %ebx

read_loop:
    # Leggi il contenuto del file
    movl $3, %eax                # sys_read
    movl %ebx, %ebx              # File descriptor
    leal buffer, %ecx            # Puntatore al buffer
    movl $1023, %edx             # Dimensione del buffer (-1 per lasciare spazio per il terminatore di stringa)
    int $0x80
    test %eax, %eax              # Controlla se c'è stato un errore nella lettura del file
    js exit_error                # Se c'è stato un errore, esci

    cmp $0, %eax                 # Controlla se abbiamo raggiunto la fine del file
    je end_read_loop

    # Aggiungi un terminatore di stringa al buffer
    mov %eax, %edx
    add $1, %edx                 # Incrementa il numero di byte letti
    movb $0, (%ecx, %edx)        # Aggiungi il terminatore di stringa

    # Salva il puntatore alla riga nell'array
    mov num_lines, %edi          # Carica il numero di righe lette
    shl $2, %edi                 # Moltiplica per 4 (dimensione di ogni puntatore nell'array)
    lea array, %esi              # Puntatore all'inizio dell'array
    add %edi, %esi               # Puntatore alla cella corrente dell'array
    mov %ecx, (%esi)             # Salva il puntatore al buffer nell'array
    incl num_lines                # Incrementa il contatore delle righe

    jmp read_loop

end_read_loop:
    # Stampa i valori salvati nell'array
    mov num_lines, %edi          # Carica il numero di righe lette
    movl $1, %ebx                # File descriptor 1 (STDOUT)

print_loop:
    test %edi, %edi              # Controlla se abbiamo stampato tutte le righe
    jz exit_success              # Se sì, esci

    decl %edi                     # Decrementa il contatore delle righe

    lea array, %esi              # Carica l'indirizzo dell'inizio dell'array
    mov (%esi, %edi, 4), %esi    # Carica il puntatore alla riga corrente

    mov $4, %eax                 # sys_write
    mov $1, %ecx                 # Lunghezza massima
    mov %esi, %edx               # Puntatore alla stringa da stampare
    int $0x80

    mov $fmt_num, %edi           # Prepara il formato per la stampa dei numeri
    call print_string            # Chiama la funzione per la stampa del terminatore di riga

    jmp print_loop               # Ripeti il ciclo di stampa

exit_success:
    # Uscita con successo
    mov $1, %eax                 # sys_exit
    xor %ebx, %ebx               # Exit code 0
    int $0x80

exit_error:
    # Uscita con errore
    mov $1, %eax                 # sys_exit
    mov $1, %ebx                 # Exit code 1
    int $0x80

print_string:
    # Stampa una stringa terminata da null
    mov %esp, %ebp               # Imposta il frame pointer
    mov %edx, %ecx               # Lunghezza massima
    mov $4, %eax                 # sys_write
    mov $1, %ebx                 # File descriptor 1 (STDOUT)
    int $0x80
    ret
    