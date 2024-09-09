.section .data
    ordini_fd: .int -1
    pianificazione_fd: .int -1

.section .text
    .global termina_programma
    .type termina_programma, @function

    termina_programma:
        movl %eax, ordini_fd
        movl %ebx, pianificazione_fd

        xorl %ecx, %ecx
        xorl %edx, %edx

        movl ordini_fd, %ebx
        cmp $-1, %ebx
        jne chiudi_ordini

    esci:
        movl $1, %eax       
        movl $0, %ebx     # stato di uscita
        int $0x80

    chiudi_ordini:
        movl $6, %eax
        movl ordini_fd, %ebx
        int $0x80    

        movl pianificazione_fd, %ebx
        cmp $-1, %ebx
        je esci

    chiudi_pianificazione:
        movl $6, %eax
        # fd già caricato
        int $0x80

        jmp esci    
