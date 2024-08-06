.section .data
    ordini_fd: .int -1
    tmp: .long 1
    array: .long 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0, 000, 00, 000, 0

.section .text
    .global salva_numeri
    .type salva_numeri, @function

    salva_numeri:
        movl %eax, ordini_fd
        
    read_loop:    
        # Lettura di 1 byte alla volta (1 carattere)
        mov $3, %eax        # syscall read
        mov pianificazione_fd, %ebx         # File descriptor
        mov $array, %ecx    # Buffer di input   --> forse serve un counter per spostrsi nelle altre celle dell'array
        mov $1, %edx        # Lunghezza massima
        int $0x80  

#        test ...   # --> controlla se la sys ha avuto successo

        # if (eax >= 0 && eax < 10)
        cmp $0, %eax
#        cmp $48, %eax   # 0 ascii
        jl not_in_range     # eax < 0
        cmp $10, %eax
#        cmp $57, %eax   # 9 ascii 
        jge not_in_range    # eax >= 10
#        jg not_in_range    # eax > 9

        jmp in_0range


    in_range:   # (numero_salvato * 10) + nuova_cifra
        movl tmp, %ebx

        mull $10, %eax
        addl %eax, %ebx

        movl %ebx, tmp

        jmp read_loop


    not_in_range:

    #    cmp $',', %eax
        cmp $44, %eax   # ',' ascii





        movl $0, tmp

        
