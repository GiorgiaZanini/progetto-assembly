.section .data
    array: .space 11    # 10 cifre + terminatore

.section .text
    .global stampa_int
    .type stampa_int, @function

    stampa_int:
        xorl %ecx, %ecx

#        testl %eax, %eax
#        jz fine

    divisione:
        movl $10, %ebx  # per dividere per 10 e prendere l'ultima cifra
        xorl %edx, %edx     # azzera il resto

        # eax -> dividendo (numero)
        # ebx -> divisore (10)
        #     -> indirizzo array --> array + contatore
        # ecx -> contatore cifre
        # edx -> resto
        ## esi (Extended Source Index) -> x
        ## edi (Extended Destination Index) -> indirizzo array --> array + contatore
        divl %ebx   # eax : ebx = eax resto edx
        addl $48, %edx  # trasformo il resto in ascii
        
        incl %ecx

        leal array, %ebx
        addl %ecx, %ebx


        subl $10, %ecx
        imull $-1, %ecx
        
        movl %edx, %ecx(array)

        movl numero_cifre, %ecx

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
        ret
        