.section .data
    array: .space 11    # 10 cifre + terminatore

.section .text
    .global converti_int_a_str
    .type converti_int_a_str, @function

    converti_int_a_str:
        # eax contiene il numero
        movl $11, %ecx  # contatore partendo dalla fine

        # metto il terminatore nell'ultima posizione dell'array
        leal array, %ebx
        addl %ecx, %ebx
        movl $0, (%ebx)   # terminatore

        decl %ecx

    divisione_e_salvataggio_cifre:
        movl $10, %ebx  # per dividere per 10 e prendere l'ultima cifra
        xorl %edx, %edx     # azzera il resto

        # eax -> dividendo (numero)
        # ebx -> divisore (10)
        #     -> indirizzo array --> array + contatore
        # ecx -> contatore cifre
        # edx -> resto
        divl %ebx   # eax : ebx = eax resto edx
        addl $48, %edx  # trasformo il resto in ascii



        movl %ebx, %ecx
        
        pushl %eax
        pushl %ebx
        pushl %ecx
        pushl %edx

        movl $4, %eax
        movl $1, %ebx
        movl $1, %edx
        int $0x80

        popl %eax
        popl %ebx
        popl %ecx
        popl %edx



        subl $4, %ecx

        # calcolo l'idirizzo di dove collocare la cifra nell'array
        leal array, %ebx
        addl %ecx, %ebx
        # metto la cifra nell'array
        movl %edx, (%ebx)   # ebx contiene l'indirizzo dell'array + il contatore

        testl %eax, %eax
        jz ritorna_la_stringa

        jmp divisione_e_salvataggio_cifre

    ritorna_la_stringa:
        movl %ebx, %eax # ritorno il puntatore alla "nuova stringa"
                        #                           (array a partire dalla posizione del contatore)

        ret
        