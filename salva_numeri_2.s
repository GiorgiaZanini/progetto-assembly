.section .data
    ordini_fd: .long -1
    tmp: .long 0
    carattere_appena_letto_dal_file: .long -1
    array_counter: .long 0
    contatore_numero_prodotti: .long 0
    array: .long 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    errore: .ascii "errore nella lettura del file\n\0"

.section .text
    .global _start
#    .type salva_numeri, @function

    _start:
    salva_numeri:
        movl %eax, ordini_fd

    read_loop:    
        # Lettura di 1 byte alla volta (1 carattere)
        movl $3, %eax          # syscall read
        movl ordini_fd, %ebx   # File descriptor (era 'pianificazione_fd', correggo in 'ordini_fd')
        movl $carattere_appena_letto_dal_file, %ecx
        movl $1, %edx          # Lunghezza massima
        int $0x80  

        cmpl $0, %eax
        jl exit_with_error

        cmpl $0, %eax          # fine file (non ha letto nessun byte)
        je end_read_loop

        # Mette il carattere appena letto in %eax
        movzbl carattere_appena_letto_dal_file, %eax

        # if (eax >= '0' && eax <= '9')
        cmpl $48, %eax         # '0' ASCII
        jl not_in_number_range # eax < '0'
        cmpl $57, %eax         # '9' ASCII
        jg not_in_number_range # eax > '9'

    in_range:   # (numero_salvato * 10) + nuova_cifra
        movl tmp, %ebx

        subl $48, %eax         # Converti carattere da ASCII a valore numerico
        imull $10, %ebx
        addl %eax, %ebx

        movl %ebx, tmp

        jmp read_loop

    not_in_number_range:
        cmpl $44, %eax         # ',' ASCII
        je salva_in_array

        cmpl $10, %eax         # '\n' (newline) ASCII
        je incrementa_numero_prodotti

        jmp read_loop          # Se non è né ',' né '\n', salta alla prossima lettura

    salva_in_array:
        movl array_counter, %ebx
        addl (array), %ebx
        movl tmp, %ebx

        addl $4, array_counter
        movl $0, tmp

        jmp read_loop

    incrementa_numero_prodotti:
        incl contatore_numero_prodotti
        jmp salva_in_array

    end_read_loop:
    #    ret
        # per testare se funziona singolarmente -> sys_exit
        movl $1, %eax
        xorl %ebx, %ebx
        int $0x80

    exit_with_error:
        movl $4, %eax          # syscall write
        movl $1, %ebx          # file descriptor (stdout)
        movl errore, %ecx      # indirizzo stringa di errore
        movl $26, %edx         # lunghezza della stringa di errore
        int $0x80

        # per testare se funziona singolarmente -> sys_exit
        movl $1, %eax
        xorl %ebx, %ebx
        int $0x80
