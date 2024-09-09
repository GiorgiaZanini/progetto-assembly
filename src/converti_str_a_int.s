.section .text
    .global converti_str_a_int
    .type converti_str_a_int, @function

    converti_str_a_int:
        # eax contiene l'indirizzo alla stringa
        movl %eax, %esi
        xorl %eax, %eax     # utilizzato per la mul, inizializzato a 0

        xorl %ebx, %ebx     # salvo la cifra

        xorl %ecx, %ecx     # uso ecx come contatore

    converti_loop:  # (numero_salvato * 10) + nuova_cifra
        movb (%esi, %ecx), %bl  # salvo il byte nella posizione corrente (segnata da ecx) in bl

        cmpb $0, %bl    # controllo se è arrivato alla fine della stringa
        je fine

        subb $48, %bl   # converto la cifra da ascii a valore numerico

        movb $10, %dl
        mulb %dl    # al * registro a 8 bit --> ax (risultato)
                    # moltiplico il numero letto finora per 10 (per "creare lo spazio" per la cifra appena letta) | (se il numero salvato finora è 0 -> rimane 0)

        addl %ebx, %eax     # aggiungo la cifra (convertita) al valore numrico salvato finora | dopo averne "creato lo spazio" con la mul

        incl %ecx

        jmp converti_loop

    fine:
        ret
