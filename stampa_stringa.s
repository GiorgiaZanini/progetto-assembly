.section .data
    pianificazione_fd: .long -1

.section .text
    .global stampa_stringa
    .type stampa_stringa, @function
    
    stampa_stringa:
        # eax contiene la stringa
        movl %eax, %ecx
        movl %ebx, pianificazione_fd

        xorl %ebx, %ebx

        movl $0, %edx

    count_loop:
        movb (%ecx,%edx), %bl

        cmp $0, %bl
        je print

        incl %edx
        jmp count_loop

    print:
        movl $4, %eax
        movl $1, %ebx   # stdout
        # %ecx -> stringa 
        # %edx -> lunghezza della stringa
        int $0x80

        movl pianificazione_fd, %ebx
        cmpl $-1, %ebx
        je ritorna

        movl $4, %eax
        movl pianificazione_fd, %ebx   # scrivo sul file pianificazione
        # %ecx -> stringa 
        # %edx -> lunghezza della stringa
        int $0x80

ritorna:
        ret
        