.section .bss
    input: .space 4         	# Spazio per l'input

.section .data
    ordini_fd: .long -1
    pianificazione_fd: .long -1
    array_ordini: .long 0
    counter_array_ordini: .long 0

    a_capo: .ascii "\n\0"
    edf: .ascii "Pianificazione EDF:\n\0"
    hpf: .ascii "Pianificazione HPF:\n\0"


    RScelta: .byte 0         	# Variabile per memorizzare la scelta
    Scelta:
        .ascii "Scegli se usare l'algoritmo \n1. EDF (Earliest Deadline First) \n2. HPF (Highest Priority First). \n3. Esci\n\0"
    SceltaNonValida:
        .ascii "Scelta non valida.\n\0"
        
.section .text
    .global menu
    .type menu, @function

menu:
	movl %eax, ordini_fd
    movl %ebx, pianificazione_fd
    movl %esi, array_ordini
    movl %ecx, counter_array_ordini

leggi_input:
    leal Scelta, %eax

    pusha
    movl $-1, %ebx
    call stampa_stringa
    popa

    # Legge l'input dell'algoritmo scelto
    movl $3, %eax            	# sys_read
    movl $0, %ebx            	# File descriptor 0
    movl $input, %ecx        	# Buffer dove salvare l'input
    movl $4, %edx            	# Numero massimo di byte da leggere
    int $0x80                

    # Verifica se il primo carattere è (1 o 2)
    movb input, %al          	# Carica il primo carattere in %al
    subb $48, %al          	    # Viene Convertito in int
    cmpb $1, %al             	# Confronta se e 1
    je _ControlloLunghezza   	# Se è 1, controlla la lunghezza
    cmpb $2, %al             	# Confronta se e 2
    je _ControlloLunghezza   	# Se è 2, controlla la lunghezza
    cmpb $3, %al             	# Confronta se e 2
    je _ControlloLunghezza   	# Se è 2, controlla la lunghezza
    jmp _InputNonValido      	# Altrimenti, input non valido

_ControlloLunghezza:
    # Verifica se c'è un altro carattere (input lungo più di una cifra)
    movb input+1, %bl        	# Carica il secondo carattere in %bl
    cmpb $10, %bl           	# Verifica se è un newline (\n)
    je esegui_comando      
    cmpb $0, %bl             	# Verifica se è il terminatore di stringa (NUL)
    je esegui_comando      
    jmp _InputNonValido     	# Se c'è piu di un carattere, l'input non valido

esegui_comando:
    pusha
    leal a_capo, %eax
    movl $-1, %ebx
    call stampa_stringa
    popa

    movl array_ordini, %esi
    movl counter_array_ordini, %ecx

    cmpb $1, %al
    je ordina_EDF

    cmpb $2, %al
    je ordina_HPF

    movl ordini_fd, %eax
    movl pianificazione_fd, %ebx
    call termina_programma    

_InputNonValido:
    pusha
    leal SceltaNonValida, %eax
    movl $-1, %ebx
    call stampa_stringa
    popa

    jmp leggi_input

ordina_EDF:
    pusha
    leal edf, %eax
    movl pianificazione_fd, %ebx
    call stampa_stringa
    popa

    movl ordini_fd, %eax
    movl pianificazione_fd, %ebx
    movl counter_array_ordini, %ecx
    movl array_ordini, %esi
    call ordinamento_EDF

    movl ordini_fd, %eax
    movl pianificazione_fd, %ebx
    movl counter_array_ordini, %ecx
    movl array_ordini, %esi
    call elabora_ordini

    pusha
    leal a_capo, %eax
    movl pianificazione_fd, %ebx
    call stampa_stringa
    popa

    jmp leggi_input

 ordina_HPF:
    pusha
    leal hpf, %eax
    movl pianificazione_fd, %ebx
    call stampa_stringa
    popa

    movl ordini_fd, %eax
    movl pianificazione_fd, %ebx
    movl counter_array_ordini, %ecx
    movl array_ordini, %esi
    call ordinamento_HPF

    movl ordini_fd, %eax
    movl pianificazione_fd, %ebx
    movl counter_array_ordini, %ecx
    movl array_ordini, %esi 
    call elabora_ordini   

    pusha
    leal a_capo, %eax
    movl pianificazione_fd, %ebx
    call stampa_stringa
    popa

    jmp leggi_input

