.section .data
    test: .ascii "\nsono nel loop\n\0"
    test2: .ascii "sono nel pre-loop \0"
    spazio: .ascii " \0"
    a_capo: .ascii "\n\0"


.section .text
    .global stampa_array
    .type stampa_array, @function
    
    stampa_array:
        # ecx contiene la dimensione dell'array
        # eax contiene il puntatore alla prima cella dell'array
        movl %eax, %esi
        movl $0, %edx

    print_loop:
        cmpl %ecx, %edx
        je fine

        xorl %eax, %eax
        movb (%esi, %edx), %al

        pusha
        call converti_int_a_str
        call stampa_stringa
        leal spazio, %eax
        call stampa_stringa
        popa

        incl %edx
        jmp print_loop

    fine:
        ret    
        