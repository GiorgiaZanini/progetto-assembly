.section .bss
    input: .space 2         	# Spazio per l'input

.section .data
    ordini_fd: .long -1
    pianificazione_fd: .long -1
    array_ordini: .long 0
    counter_array_ordini: .long 0

    a_capo: .ascii "\n\0"
    edf: .ascii "Pianificazione EDF:\n\0"
    hpf: .ascii "Pianificazione HPF:\n\0"

    scelta: .ascii "Scegli se usare l'algoritmo \n1. EDF (Earliest Deadline First) \n2. HPF (Highest Priority First) \n3. Esci\n\0"
    scelta_non_valida: .ascii "\nErrore: scelta non valida (inserire un valore compreso tra 1 e 3)\n\n\0"
        
.section .text
    .global menu
    .type menu, @function

menu:
	movl %eax, ordini_fd
    movl %ebx, pianificazione_fd
    movl %esi, array_ordini
    movl %ecx, counter_array_ordini

leggi_input:
    leal scelta, %eax

    pusha
    movl $-1, %ebx
    call stampa_stringa
    popa

    # Legge l'input dell'algoritmo scelto
    movl $3, %eax   # sys_read da terminale
    movl $0, %ebx
    leal input, %ecx    # buffer dove salvare l'input
    movl $2, %edx   # numero massimo di byte da leggere
    int $0x80                

    xorl %edx, %edx

    # Verifica se il primo carattere è (1 o 2)
    movb (%ecx,%edx), %al
    subb $48, %al   # numero in input viene convertito in int
    cmpb $1, %al
    je controllo_lunghezza
    cmpb $2, %al
    je controllo_lunghezza
    cmpb $3, %al
    je controllo_lunghezza
    jmp input_non_valido    # se non supera i controlli cmp non è un numero valido

controllo_lunghezza:
    # controlla che un'eventuale secondo carattere sia \n o \0
    incl %edx
    movb (%ecx,%edx), %bl   # Carica il secondo carattere in %bl
    cmpb $10, %bl   # \n
    je esegui_comando      
    cmpb $0, %bl    # \0
    je esegui_comando      
    jmp input_non_valido    # senno non è un carattere valido

esegui_comando:
    pusha
    leal a_capo, %eax
    movl $-1, %ebx
    call stampa_stringa
    popa

    cmpb $1, %al
    je ordina_EDF

    cmpb $2, %al
    je ordina_HPF

    movl ordini_fd, %eax
    movl pianificazione_fd, %ebx
    call termina_programma    

input_non_valido:
    pusha
    leal scelta_non_valida, %eax
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

    movl counter_array_ordini, %ecx
    movl array_ordini, %esi
    call ordinamento_EDF

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

    movl counter_array_ordini, %ecx
    movl array_ordini, %esi
    call ordinamento_HPF

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
