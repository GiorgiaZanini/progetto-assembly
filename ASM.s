.section .data                 #sezione variabili globali

hello:                         #etichetta
      .ascii "Ciao Mondo!\n"   #stringa costante

input_file:
      .ascii "input.txt"

buffer_size: .int 49

buffer: .space 50

hello_len:
      .long . - hello          #lunghezza della stringa in byte

.section .text                 #sezione istruzioni
      .global _start           #punto di inizio del programma

.section .bss
      
_start:
      movl $4, %eax            #Carica il codice della system call WRITE
                               #in eax per scrivere la stringa
                               #”Ciao Mondo!” a video.
      
      movl $1, %ebx            #Mette a 1 il contenuto di EBX
                               #Quindi ora EBX=1. 1 è il
                               #primo parametro per la write e
                               #serve per indicare che vogliamo
                               #scrivere nello standard output

      leal hello, %ecx         #Secondo parametro dell write
                               #Carica in ECX l’indirizzo di
                               #memoria associato all’etichetta
                               #hello, ovvero il puntatore alla
                               #stringa “Ciao Mondo!\n” da stampare.

      movl hello_len, %edx     #Terzo parametro della write
                               #carica in EDX la lunghezza della
                               #stringa “Ciao Mondo!\n”.

      int $0x80                #esegue la system call write
                               #tramite l’interrupt 0x80


      movl $5, %eax     
      leal input_file, %ebx
      movl $0, %ecx    
      int $0x80

      movl %eax, %ebx

      movl $3, %eax
      movl %ebx, %ebx
      leal buffer, %ecx
      movl buffer_size, %edx
      int $0x80











      movl $1, %eax            #Mette a 1 il registro EAX
                               #1 è il codice della system call exit
      
      xorl %ebx, %ebx          #azzera EBX. Contiene il codice di
                               #ritorno della exit

      int $0x80                #esegue la system call exit

