.section .data
    ordini_fd: .int -1
    numero_tmp: .byte 0     # per ricostruire il numero
    carattere_letto: .byte -1   # carattere letto dalla sys
#    array_counter: .long 0
#    contatore_numero_prodotti: .long 0
    array_numero: .space 4
    array: .long 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    errore: .ascii "errore nella lattura del file\n\0"

    # temporaneo per testare
    a_capo: .ascii "\n\0"
    pre_errore: .ascii "errore nella lattura nel file descriptor\n\0"

.section .text
    .global salva_numeri
    .type salva_numeri, @function

    salva_numeri:
        movl %eax, ordini_fd
        
    read_loop:
        # printf    
        cmpl $0, %eax
        jl exit_with_errore

        # Lettura di 1 byte alla volta (1 carattere)
        movl $3, %eax        # syscall read
        movl ordini_fd, %ebx         # File descriptor
        movl $carattere_letto, %ecx
        movl $1, %edx        # Lunghezza massima
        int $0x80  

        cmpl $0, %eax
        jl exit_with_error

        cmpl $0, %eax   # fine file (non ha letto nessun byte)
        je end_read_loop

        # se passa il controllo dell'errore e del fine file -> metto il numero appena letto in eax, per i successi controlli sul numero
        movl carattere_letto, %eax  # ho già controllato eax


        # if (eax >= 0 && eax < 10)
        cmpl $48, %eax   # 0 ascii
        jl not_in_number_range     # eax < 0
        cmpl $57, %eax   # 9 ascii 
        jg not_in_number_range    # eax > 9


    in_range:   # (numero_salvato * 10) + nuova_cifra
        subl $48, %eax  # converto la cifra da ascii a "numero"

        

        # printf per conntrollare il numero
#        movl numero_tmp, %eax
#        call converti_int_a_str
#        call stampa_stringa
#        leal a_capo, %eax
#        call stampa_stringa

        jmp read_loop


    not_in_number_range:
#        cmpl $44, %eax   # ',' ascii
#        je salva_in_array

#        cmpl $10, %eax   # '\n'(new line) ascii
#        je incrementa_numero_prodotti


#    salva_in_array:    # indirizzo array + contatore x 4       DA SISTEMARE
#        movb numero_tmp, (array_counter, array)
#        movl numero_tmp, %eax
#        call converti_int_a_str
#        call stampa_stringa
#        leal a_capo, %eax
#        call stampa_stringa


#        addl $4, array_counter
#        movl $0, numero_tmp


#    incrementa_numero_prodotti:
#        incl contatore_numero_prodotti
#        jmp salva_in_array


    end_read_loop:
        ret

    exit_with_error:
        leal errore, %eax
        call stampa_stringa
        ret

    # printf            
    exit_with_errore:
        leal pre_errore, %eax
        call stampa_stringa
        ret
