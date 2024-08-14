.section .data
    array: .space 11    # 10 cifre + terminatore
#    numero_cifre: 0

.section .text
    .global _start
#    .type stampa_int, @function

    _start:
        movl $10, %ebx  # per dividere per 10 e prendere l'ultima cifra
        xorl %ecx, %ecx

        testl %eax, %eax
        jz fine

    divisione:
        xorl %edx, %edx     # azzera il resto

        divl %ebx   # eax : ebx = eax resto edx
        addl $48, %edx
        pushl %edx

        incl %ecx

        testl %eax, %eax
        jz converti_a_stringa

        jmp divisione

    converti_a_stringa:
#        movl %ecx, numero_cifre
        movl $0, %ebx

        popl %eax
        leal array, %edx
        addl %ebx, %edx     # somma indirizzo dell'array a posizione
        movl %eax, %edx

        incl %ebx

        cmpl %ebx, %ecx
        je aggiungi_terminatore

        jmp converti_a_stringa

    aggiungi_terminatore:
        incl %ebx

        leal array, %edx
        addl %ebx, %edx
        movl $0x00, %edx
    
    fine:
#        ret

                # per testare se funziona singolarmente -> sys_exit
                movl $1, %eax
                xorl %ebx, %ebx
                int $0x80
