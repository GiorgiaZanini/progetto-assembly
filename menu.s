.section .bss
    input: .space 4         	# Spazio per l'input

.section .data
    RScelta: .byte 0         	# Variabile per memorizzare la scelta
    Scelta:
        .ascii "Scegli se usare l'algoritmo \n1. EDF (Earliest Deadline First) \n2. HPF (Highest Priority First).\n\0"
    SceltaNonValida:
        .ascii "Scelta non valida.\n\0"
        
.section .text
    .global _menu
    .type _menu, @function

_menu:
	push %ebp
	movl %esp, %ebp

_PrimaRichiestaInput:
    # Stampa la stringa di richiesta dell'algoritmo
    leal Scelta, %eax
    call stampa_stringa

_input:
    # Legge l'input dell'algoritmo scelto
    movl $3, %eax            	# sys_read
    movl $0, %ebx            	# File descriptor 0
    movl $input, %ecx        	# Buffer dove salvare l'input
    movl $4, %edx            	# Numero massimo di byte da leggere
    int $0x80                

    # Verifica se il primo carattere è (1 o 2)
    movb input, %al          	# Carica il primo carattere in %al
    subb $0x30, %al          	# Viene Convertito in int
    cmpb $1, %al             	# Confronta se e 1
    je _ControlloLunghezza   	# Se è 1, controlla la lunghezza
    cmpb $2, %al             	# Confronta se e 2
    je _ControlloLunghezza   	# Se è 2, controlla la lunghezza
    jmp _InputNonValido      	# Altrimenti, input non valido

_ControlloLunghezza:
    # Verifica se c'è un altro carattere (input lungo più di una cifra)
    movb input+1, %bl        	# Carica il secondo carattere in %bl
    cmpb $0xA, %bl           	# Verifica se è un newline (\n)
    je _MemorizzaScelta      
    cmpb $0, %bl             	# Verifica se è il terminatore di stringa (NUL)
    je _MemorizzaScelta      
    jmp _InputNonValido     	# Se c'è piu di un carattere, l'input non valido

_MemorizzaScelta:
   # Memorizzo la scelta in %eax
   movb input, %al		# Prendo il primo byte
   subb $0x30, %al		# Viene convertito in int
   jmp _fine

_InputNonValido:
    leal SceltaNonValida, %eax
    call stampa_stringa
    jmp _input
    
_fine:
	movl %ebp, %esp		# Ripristino il vecchio stack frame
	pop %ebp		# Ripristino il frame pointer
	ret			# Ritorno con %eax che contiene la scelta
	
	
	
#	DA AGGIUNGERE AL MAIN
#ControlloScelta:
#	call menu		# Chiama la funzione Menu
#	cmp $1, %eax		# Controllo se l'utente ha scelto l'algoritmo EDF
#	je _EDF
#	cmp $2, %eax		# Controllo se l'utente ha scelto l'algoritmo HPF
#	je _HPF
