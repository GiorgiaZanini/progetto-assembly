.section .data
    ordini_fd: .int -1
    numero_in_costruzione: .space 4
    counter_numero_in_costruzione: .int 0
    array_ordini: .space 40, 7
    counter_array_ordini: .long 0
    carattere_letto: .byte -1  # carattere letto dalla sys
    test: .ascii "\0"
    a_capo: .ascii "\n\0"
    line: .ascii "-\0"
    filename:  .asciz "input.txt"
    error_not_in_range: .ascii "Il carattere letto non è un numero\n\0"


.section .text
    .global ciao
    .type ciao, @function

    ciao:
#        movl $5, %eax   # sys_open
#        movl $filename, %ebx
#        movl $0, %ecx   # solo lettura
#        int $0x80

        movl %eax, ordini_fd
        xorl %ebx, %ebx

    read_loop:
        movl $3, %eax        # syscall read
        movl ordini_fd, %ebx         # File descriptor
        movl $carattere_letto, %ecx
        movl $1, %edx        # Lunghezza massima
        int $0x80  

        cmpl $1, %eax
        jne not_in_number_range

        movb carattere_letto, %al

        cmpb $48, %al   # 0 ascii
        jl not_in_number_range     # eax < "0"
        cmpb $57, %al   # 9 ascii 
        jg not_in_number_range    # eax > "9"

    salva_in_array:
        movl counter_numero_in_costruzione, %ecx
        movl $numero_in_costruzione, %esi
        movb %al, (%esi, %ecx)

        incl %ecx
        movl %ecx, counter_numero_in_costruzione

        jmp read_loop

    not_in_number_range:
        movl counter_numero_in_costruzione, %ecx

        cmpl $0, %ecx
        je exit

        movl $numero_in_costruzione, %esi
        movb $0, (%esi, %ecx)
        movl $0, counter_numero_in_costruzione

        movl %esi, %eax
        call converti_str_a_int

        movl counter_array_ordini, %ecx
        movl $array_ordini, %esi

    #    pusha
    #    movl %eax, %eax
    #    call converti_int_a_str
    #    call stampa_stringa
    #    popa

        movb %al, (%esi, %ecx)

        incl %ecx
        movl %ecx, counter_array_ordini

#        pusha
#        leal array_ordini, %eax
#        call stampa_array
#        leal a_capo, %eax
#        call stampa_stringa
#        popa

#        pusha
#        movb %al, %bl
#        xorl %eax, %eax
#        movb %bl, %al
#        call converti_int_a_str
#        call stampa_stringa
#        leal a_capo, %eax
#        call stampa_stringa
#        popa
#        
        jmp read_loop

    exit:
#        pusha
#        movl counter_array_ordini, %eax
#        call converti_int_a_str
#        call stampa_stringa
#        leal a_capo, %eax
#        call stampa_stringa
#        leal array_ordini, %eax
#        movl counter_array_ordini, %ecx
#        call stampa_array
#        popa

        leal array_ordini, %esi
        movl counter_array_ordini, %ecx
        ret
