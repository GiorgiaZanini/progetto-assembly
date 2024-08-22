.section .text
    .global stampa_stringa
    .type stampa_stringa, @function
    
    stampa_stringa:
        # eax contiene la stringa
        movl %eax, %ecx

        movl $0, %edx

    count_loop:
        movb (%edx,%ecx), %bl

        cmp $0, %bl
        je print

        incl %edx
        jmp count_loop

    print:
        movl $4, %eax
        movl $1, %ebx   # stdout
        # %edx -> stringa 
        # %edx -> lunghezza della stringa
        int $0x80

        ret
        