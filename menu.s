.section .data
    ordini_fd: .int -1
    pianificazione_fd: .int -1

.section .text
    .global menu
    .type menu, @function

    menu:


        movl ordini_fd, %eax
        call salva_numeri
        ret

        