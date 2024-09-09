.section .data
    ordini_fd: .long -1
    pianificazione_fd: .long -1
    numero_in_costruzione: .space 4
    counter_numero_in_costruzione: .long 0
    array_ordini: .space 40
    counter_array_ordini: .long 0
    carattere_letto: .byte -1  # carattere letto dalla sys
    test: .ascii "\0"
    a_capo: .ascii "\n\0"
    error_not_in_range: .ascii "Il carattere letto non è un numero\n\0"

    errore_identificativo_str: .ascii "L'identificato non rientra nel range corretto: il valore letto è \0"
    errore_durata_str: .ascii "La durata non rientra nel range corretto: il valore letto è \0"
    errore_scadenza_str: .ascii "La scadenza non rientra nel range corretto: il valore letto è \0"
    errore_priority_str: .ascii "La priorità non rientra nel range corretto: il valore letto è \0"
    errore_ordini_str: .ascii "Il numero di ordini non rientra nel range previsto o non rispettano lo schema previsto (4 valori per ordine)\n\0"



.section .text
    .global salva_numeri
    .type salva_numeri, @function

    salva_numeri:
        movl %eax, ordini_fd
        movl %ebx, pianificazione_fd
        
        xorl %ebx, %ebx

    read_loop:
        movl $3, %eax        # syscall read
        movl ordini_fd, %ebx         # File descriptor
        leal carattere_letto, %ecx
        movl $1, %edx        # Lunghezza massima
        int $0x80  

        cmpl $1, %eax
        jne not_in_number_range

        movb carattere_letto, %al 

        cmpb $48, %al   # 0 ascii
        jl not_in_number_range     # eax < "0"
        cmpb $57, %al   # 9 ascii 
        jg not_in_number_range    # eax > "9"

    costruisci_numero:
        movl counter_numero_in_costruzione, %ecx
        movl $numero_in_costruzione, %esi
        movb %al, (%esi, %ecx)

        incl %ecx
        movl %ecx, counter_numero_in_costruzione

        jmp read_loop

    not_in_number_range:
        movl counter_numero_in_costruzione, %ecx

        cmpl $0, %ecx
        je ritorna

        movl $numero_in_costruzione, %esi
        movb $0, (%esi, %ecx)
        movl $0, counter_numero_in_costruzione

        movl %esi, %eax
        call converti_str_a_int

        # salvo sulla stack il nuove numero completo letto dal file
        push %eax

        # verifico a che parametro dell'ordine corrisponde il nuovo numero
        xorl %edx, %edx
        movl counter_array_ordini, %eax
        movl $10, %ebx
        divl %ebx

        cmpl $0, %edx
        je controlla_identificativo
        cmpl $1, %edx
        je controlla_identificativo
        cmpl $2, %edx
        je controlla_identificativo
        cmpl $3, %edx
        je controlla_identificativo

    controlla_identificativo:
        popl %eax
        cmpl $1, %eax
        jl errore_identificativo
        cmpl $127, %eax
        jg errore_identificativo

        jmp salva_numero_in_array_ordini

    controlla_durata:
        popl %eax
        cmpl $1, %eax
        jl errore_durata
        cmpl $10, %eax
        jg errore_durata

        jmp salva_numero_in_array_ordini

     controlla_scadenza:
        popl %eax
        cmpl $1, %eax
        jl errore_scadenza
        cmpl $100, %eax
        jg errore_scadenza

        jmp salva_numero_in_array_ordini    

    controlla_priority:
        popl %eax
        cmpl $1, %eax
        jl errore_priority
        cmpl $5, %eax
        jg errore_priority

        jmp salva_numero_in_array_ordini    

    salva_numero_in_array_ordini:
        movl counter_array_ordini, %ecx
        movl $array_ordini, %esi

        movb %al, (%esi, %ecx)
        incl %ecx
        movl %ecx, counter_array_ordini

        movb %al, %bl
        xorl %eax, %eax
        movb %bl, %al
        # call converti_int_a_str
        # call stampa_stringa

        jmp read_loop

    errore_identificativo:
        pusha
        leal errore_identificativo_str, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        popa
        pusha
        call converti_int_a_str
        movl pianificazione_fd, %ebx
        call stampa_stringa
        leal a_capo, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        popa

        jmp termina

    errore_durata:
        pusha
        leal errore_durata_str, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        popa
        pusha
        call converti_int_a_str
        movl pianificazione_fd, %ebx
        call stampa_stringa
        leal a_capo, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        popa

        jmp termina

    errore_scadenza:
        pusha
        leal errore_scadenza_str, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        popa
        pusha
        call converti_int_a_str
        movl pianificazione_fd, %ebx
        call stampa_stringa
        leal a_capo, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        popa

        jmp termina

    errore_priority:
        pusha
        leal errore_priority_str, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        popa
        pusha
        call converti_int_a_str
        movl pianificazione_fd, %ebx
        call stampa_stringa
        leal a_capo, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa  
        popa  

        jmp termina 

    errore_ordini:   
        pusha
        leal errore_ordini_str, %eax
        movl pianificazione_fd, %ebx
        call stampa_stringa
        popa

    termina:
        movl ordini_fd, %eax
        movl pianificazione_fd, %eax

        call termina_programma        

    ritorna:
        movl counter_array_ordini, %eax

        # se il file non contiene ordini restituisco un errore
        cmpl $0, %eax
        je errore_ordini

        xorl %edx, %edx
        movl $24, %eax
        movl $4, %ebx
        divl %ebx

        # se ogni ordine non contiene 4 numeri restrituisco un errore
        cmpl $0, %edx
        jne errore_ordini

        # se il file contiene più di 10 ordini restituisco un errore
        cmpl $10, %eax
        jg errore_ordini

        leal array_ordini, %esi
        movl counter_array_ordini, %ecx

        ret
