.section .data
filename:   .asciz "input.txt"
buffer:     .space 1024         # Buffer per la lettura di una riga del file
array:      .space 4096         # Array per memorizzare le righe del file (max 256 righe a 16 byte ciascuna)
fmt:        .asciz "%d\n"       # Formato per la stampa dei numeri

.section .bss
num_lines:  .long 0             # Contatore delle righe del file

.section .text
.globl _start

_start:
    # Apri il file
    movl $5, %eax          # sys_open
    movl $filename, %ebx   # Puntatore al nome del file
    movl $0, %ecx          # O_RDONLY
    int $0x80
    movl %eax, %ebx        # File descriptor

read_loop:
    # Leggi una riga del file
    movl $3, %eax          # sys_read
#    movl %ebx, %ebx        # File descriptor
    leal buffer, %ecx      # Puntatore al buffer
    movl $1023, %edx       # Dimensione del buffer (-1 per lasciare spazio per il terminatore di stringa)
    int $0x80

    # Controlla fine file
    cmp $0, %eax
    je end_read_loop

    # Aggiungi un terminatore di stringa al buffer
    addl $1, %eax          # Incrementa il numero di byte letti
    movb $0, (%ecx, %eax)  # Aggiungi il terminatore di stringa

    # Salva la riga nell'array
    leal array, %edi       # Puntatore all'inizio dell'array
    addl num_lines, %edi   # Puntatore alla cella corrente dell'array
    movl %ecx, (%edi)      # Copia la riga nel nuovo array
    addl $1, num_lines     # Incrementa il contatore delle righe

    jmp read_loop

end_read_loop:
    # Stampa le righe lette
    leal array, %esi       # Puntatore alla prima riga
    movl num_lines, %ecx   # Numero di righe da stampare
    call print_lines

    # Uscita
    movl $1, %eax          # sys_exit
    xor %ebx, %ebx        # Exit code 0
    int $0x80

print_lines:
    # Stampa le righe salvate nell'array
    movl $4, %eax          # sys_write
    movl $1, %ebx          # File descriptor 1 (STDOUT)
    movl $fmt, %edx        # Puntatore al formato

print_loop:
    cmp $0, %ecx          # Controlla se abbiamo stampato tutte le righe
    je print_done
    movl (%esi), %edi      # Puntatore alla riga corrente
    int $0x80
    addl $4, %esi          # Passa alla riga successiva
    decl %ecx              # Decrementa il contatore delle righe
    jmp print_loop

print_done:
    ret
