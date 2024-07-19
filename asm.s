.section .data
nome_file:  .asciz "input.txt"
buffer:     .space 160  # 16 (4 byte * 4 spazi) * 10 (spazie dell'array)
array:      .long 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

formato_di_stampa:  .asciz "%d\n"   //TODO 
                                    //da sistemare per scivere nel file


.section .text
    .global _start

_start:
    # apertura file
    movl $5, %eax   # sys_open
    movl $nome_file, %ebx
    movl $0, %ecx   # per dire che voglio leggere il file
    int  $0x80
    # il file descriptor viene poi salvato in eax
    movl %eax, %ebx

//    movl $0, %edx   # utilizzo il registro ecx come contatore e lo setto a 0

lettura_e_salvataggio_file:
    movl $3, %eax   # sys_read
    leal buffer, %ecx   # prende l'indirizzo di partenza (puntatore) del buffer e lo carica in ecx
    int 0x80

    cmp $0, %eax    # se offset è 0 -> raggiunta la fine del file
    je end_read_loop    # se ha raggiunto la fine del file (TRUE) -> non legge più

    # stampa il contenuto del buffer
    movl $4, %eax   # sys_write
    movl $1, %ebx   # file descriptor per stdout
    leal buffer, %ecx   # indirizzo di partenza del buffer
    movl %eax, %edx # numero di byte letti
    int 0x80

    jmp lettura_e_salvataggio_file # continua il ciclo di lettura

end_read_loop:
    # chiusura file
    movl $6, %eax   # sys_close
    int 0x80

    # terminazione del programma
    movl $1, %eax   # sys_exit
    xorl %ebx, %ebx # exit code 0
    int 0x80
