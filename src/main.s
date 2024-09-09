.section .data
    ordini_fd: .long -1
    pianificazione_fd: .long -1
    counter_parametri: .long 0

    errore_input_str: .ascii "Errore nei parametri passati in input\n\0"
    errore_file_str: .ascii "Errore nell'apertura del file\n\0"

    # temporaneo per testare
    a_capo: .ascii "\n\0"
    filename:   .asciz "input.txt"
.section .text

    .global _start

    _start:
       # poppo il numero di argomenti in input
       popl %esi
       movl %esi, counter_parametri

       # ignoro il nome del programma
       popl %esi 

       # poppo il file degli ordini
       popl %esi

       cmpl $0, %esi
       je errore_input

       # apro il file degli ordini
       movl $5, %eax   # sys_open
       movl %esi, %ebx     
       movl $0, %ecx   # solo lettura
       int $0x80

       cmpl $-1, %eax
       jle errore_file

       movl %eax, ordini_fd

       # verifico il numero di parametri passati da linea di comando. Se non sono 3 (eseguibile, file_ordini, file_pianificazione) inizio ad elaborara
       movl counter_parametri, %ebx
       cmpl $3, %ebx
       jne inizia_elaborazione

       popl %esi       

       cmpl $0, %esi
       je errore_input

       # apro il file di pianificazione
       movl $5, %eax   # sys_open
       movl %esi, %ebx     
       movl $1, %ecx   # solo scrittura
       int $0x80

       cmpl $-1, %eax   # se è -1 o meno è un errore
       jle errore_file

       movl %eax, pianificazione_fd

    inizia_elaborazione:
       movl ordini_fd, %eax
       movl pianificazione_fd, %ebx

       call salva_numeri

       movl ordini_fd, %eax
       movl pianificazione_fd, %ebx
       call menu

    errore_input:
       pusha
       leal errore_input_str, %eax
       movl $-1, %ebx
       call stampa_stringa
       popa

       movl ordini_fd, %eax
       movl pianificazione_fd, %ebx
       call termina_programma

    errore_file:
       pusha
       leal errore_file_str, %eax
       movl $-1, %ebx
       call stampa_stringa
       popa

       movl ordini_fd, %eax
       movl pianificazione_fd, %ebx
       call termina_programma
