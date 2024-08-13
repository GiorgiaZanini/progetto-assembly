.section .data
    ordini_fd: .int -1
    tmp: .long 0
    carattere_appena_letto_dal_file: .long -1
    array_counter: .long 0
    contatore_numero_prodotti: .long 0
    array: .long 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0
    errore: .ascii "errore nella lattura del file\n\0"

.section .text
    .global salva_numeri
    .type salva_numeri, @function

    salva_numeri:
        movl %eax, ordini_fd
        
    read_loop:    
        # Lettura di 1 byte alla volta (1 carattere)
        movl $3, %eax        # syscall read
        movl pianificazione_fd, %ebx         # File descriptor
        movl $carattere_appena_letto_dal_file, %ecx
        movl $1, %edx        # Lunghezza massima
        int $0x80  

        cmpl $0, %eax
        jl exit_with_error

        cmpl $0, %eax   # fine file (non ha letto nessun byte)
        je end_read_loop

        # se passa il controllo dell'errore e del fine file -> metto il numero appena letto in eax, per i successi controlli sul numero
        movl carattere_appena_letto_dal_file, %eax

        # if (eax >= 0 && eax < 10)
        cmpl $48, %eax   # 0 ascii
        jl not_in_number_range     # eax < 0
        cmpl $57, %eax   # 9 ascii 
        jg not_in_number_range    # eax > 9


    in_range:   # (numero_salvato * 10) + nuova_cifra
        movl tmp, %ebx

        imull $10, %eax
        addl %eax, %ebx

        movl %ebx, tmp

        jmp read_loop


    not_in_number_range:
        cmpl $44, %eax   # ',' ascii
        je salva_in_array

        cmpl $12, %eax   # '\n'(line feed) ascii
        je incrementa_numero_prodotti


    salva_in_array:
        movl tmp, (array, array_counter)


        addl $4, array_counter
        movl $0, tmp


    incrementa_numero_prodotti:
        incl contatore_numero_prodotti
        jmp salva_in_array


    end_read_loop:
        ret


    exit_with_error:
        movl errore, %ecx
        call stampa_stringa
        ret