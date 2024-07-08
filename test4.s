.section .data
filename:   .asciz "input.txt"
buffer:     .space 128                              # Buffer per la lettura del file
array:      .long 0, 0, 0, 0, 0, 0, 0, 0, 0, 0      # Array di 10 dword inizializzati a 0
fmt:        .asciz "%d\n"                           # Formato per la stampa dei numeri
buffers:    .space 160                              # 10 buffers di 4 interi ciascuno (10*4*4)
num_lines:  .long 0                                 # Contatore per il numero di righe lette

.section .text
.global _start

_start:
    # Apri il file
    movl $5, %eax          # sys_open
    movl $filename, %ebx   # Puntatore al nome del file
    movl $0, %ecx          # O_RDONLY
    int $0x80
    
    movl %eax, %ebx        # File descriptor

    movl $0, %ecx

read_loop:
    # Leggi il contenuto del file
    movl $3, %eax          # sys_read
    leal buffer, %ecx      # Puntatore al buffer
    movl $128, %edx        # Dimensione del buffer
    int $0x80

    cmp $0, %eax                 # Controlla se abbiamo raggiunto la fine del file
    je end_read_loop

    # Aggiungi un terminatore di stringa al buffer
    movl %eax, %edx
    add $1, %edx                 # Incrementa il numero di byte letti
    movb $0, (%ecx, %edx)        # Aggiungi il terminatore di stringa

    # Calcola l'indice corrente nel buffer
    movl num_lines, %edi         # Carica il numero di righe lette
    imull $16, %edi              # Moltiplica per 16 (4 interi per riga, 4 byte ciascuno)
    lea buffers, %esi            # Puntatore all'inizio del buffer
    add %edi, %esi               # Puntatore al buffer corrente

    # Analizza e salva i valori nel buffer
    movl $0, %edi                # Contatore per i valori
    lea buffer, %ecx             # Puntatore alla riga letta
parse_values:
    movl %ecx, %eax              # Carica il puntatore alla riga nel registro
    movl $0, %ebx                # Azzeramento del valore
    call parse_int               # Parsea il prossimo valore
    movl %eax, (%esi, %edi, 4)   # Salva il valore nel buffer corrente
    incl %edi                    # Incrementa il contatore dei valori
    cmpl $4, %edi                # Controlla se abbiamo letto 4 valori
    jl parse_values              # Se no, continua a leggere

    # Salva il puntatore al buffer nell'array
    movl num_lines, %edi         # Carica il numero di righe lette
    imull $4, %edi               # Moltiplica per 4 (dimensione di ogni puntatore nell'array)
    lea array, %esi              # Puntatore all'inizio dell'array
    add %edi, %esi               # Puntatore alla cella corrente dell'array
    movl %esi, %eax              # Carica l'indirizzo del buffer corrente
    movl %eax, (%esi)            # Salva il puntatore al buffer nell'array

    incl num_lines               # Incrementa il contatore delle righe
    cmpl $10, num_lines          # Controlla se abbiamo raggiunto il massimo di 10 righe
    jl read_loop                 # Se no, continua a leggere

end_read_loop:
    # Stampa i valori salvati nell'array
    movl $0, %edi                # Inizializza l'indice delle righe
print_loop:
    cmpl num_lines, %edi         # Controlla se abbiamo stampato tutte le righe
    jge exit_success             # Se sì, esci

    lea array, %esi              # Carica l'indirizzo dell'inizio dell'array
    movl (%esi, %edi, 4), %esi   # Carica il puntatore al buffer corrente
    movl $0, %ecx                # Inizializza l'indice dei valori
print_values:
    movl (%esi, %ecx, 4), %eax   # Carica il valore corrente
    pushl %eax                   # Salva il valore sullo stack
    pushl $fmt                   # Salva il formato sullo stack
    call printf                  # Stampa il valore
    addl $8, %esp                # Ripulisce lo stack
    incl %ecx                    # Incrementa l'indice dei valori
    cmpl $4, %ecx                # Controlla se abbiamo stampato tutti i valori
    jl print_values              # Se no, continua a stampare

    incl %edi                    # Incrementa l'indice delle righe
    jmp print_loop               # Ripeti il ciclo di stampa

exit_success:
    # Uscita con successo
    movl $1, %eax                # sys_exit
    xorl %ebx, %ebx              # Exit code 0
    int $0x80

exit_error:
    # Uscita con errore
    movl $1, %eax                # sys_exit
    movl $1, %ebx                # Exit code 1
    int $0x80

parse_int:
    # Parsea il prossimo valore intero dalla stringa puntata da %eax
    # Il valore parsed viene salvato in %ebx
    pushl %ebp
    movl %esp, %ebp
    pushl %edi
    pushl %ecx
    pushl %ebx
    pushl %edx
    movl %eax, %ecx
    movl $0, %ebx
parse_int_loop:
    movb (%ecx), %dl             # Carica il prossimo carattere
    cmpb $'0', %dl
    jb parse_int_done            # Se non è un numero, termina
    cmpb $'9', %dl
    ja parse_int_done            # Se non è un numero, termina
    subb $'0', %dl               # Converte il carattere in numero
    imull $10, %ebx, %ebx        # Moltiplica il valore corrente per 10
    addl %edx, %ebx              # Aggiunge il nuovo numero
    incl %ecx                    # Passa al prossimo carattere
    jmp parse_int_loop
parse_int_done:
    movl %ebx, %eax              # Restituisce il valore parsed in %eax
    popl %edx
    popl %ebx
    popl %ecx
    popl %edi
    movl %ebp, %esp
    popl %ebp
    ret
