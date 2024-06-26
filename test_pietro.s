section .data
    filename db "input.txt", 0
    buffer_size equ 256
    buffer resb buffer_size
    products resb 40  # spazio per 10 prodotti, 4 campi (id, durata, scadenza, priorità) ciascuno
    products_count equ 10
    timeslot_count equ 100
    timeslots resb timeslot_count  # Array di slot temporali per 100 unità di tempo
    current_time db 0  # Unità di tempo corrente
    total_penalty dd 0  # Penale totale
    newline db 10  # newline character

section .bss
    fd resd 1  # file descriptor

section .text
    global _start

_start:
    # Apri il file
    mov eax, 5          # syscall number for sys_open
    mov ebx, filename   # filename
    mov ecx, 0          # O_RDONLY
    int 0x80
    mov [fd], eax       # salva il file descriptor

    # Leggi i dati dal file
    mov eax, 3          # syscall number for sys_read
    mov ebx, [fd]       # file descriptor
    mov ecx, buffer     # buffer per i dati letti
    mov edx, buffer_size # dimensione del buffer
    int 0x80

    # Chiudi il file
    mov eax, 6          # syscall number for sys_close
    mov ebx, [fd]       # file descriptor
    int 0x80

    # Parse dei dati nel buffer
    mov esi, buffer     # source index nel buffer
    mov edi, products   # destination index nei prodotti
    call parse_products

    # Pianifica la produzione e calcola le penali
    call plan_production

    # Termina il programma
    mov eax, 1          # syscall number for sys_exit
    xor ebx, ebx        # exit code 0
    int 0x80

parse_products:
    # Questo assume che ogni prodotto abbia esattamente 4 campi separati da spazi
    # e che ci siano products_count prodotti nel buffer
    xor ebx, ebx        # counter for fields
    xor edx, edx        # counter for digits in a field
parse_loop:
    lodsb               # carica un byte dal buffer in AL
    cmp al, 0
    je parse_done
    cmp al, ' '
    je parse_next_field
    cmp al, [newline]
    je parse_next_product
    sub al, '0'
    imul edx, edx, 10
    add edx, eax
    jmp parse_loop

parse_next_field:
    stosd               # salva il campo nel products (word size)
    xor edx, edx
    jmp parse_loop

parse_next_product:
    stosd               # salva l'ultimo campo
    add edi, 12
    xor edx, edx
    dec ecx
    jnz parse_loop
parse_done:
    ret

plan_production:
    # Inizia la pianificazione dei prodotti
    mov ecx, products_count
    xor esi, esi        # indice del prodotto

production_loop:
    # Carica i dati del prodotto
    mov eax, [products + esi*16]      # identificativo
    mov ebx, [products + esi*16 + 4]  # durata
    mov ecx, [products + esi*16 + 8]  # scadenza
    mov edx, [products + esi*16 + 12] # priorità

    # Pianifica il prodotto negli slot temporali
    call schedule_product

    # Passa al prossimo prodotto
    add esi, 1
    loop production_loop
    ret

schedule_product:
    # Logica per pianificare il prodotto
    # Carica la durata del prodotto
    mov esi, ebx  # salva la durata in esi
    xor ebx, ebx  # azzera ebx

find_slot:
    # Cerca il primo slot temporale disponibile
    mov al, [timeslots + ebx]
    cmp al, 0
    jne next_slot

    # Pianifica il prodotto negli slot disponibili
    mov [timeslots + ebx], dl
    dec esi
    jz slot_found
    inc ebx
    jmp find_slot

next_slot:
    inc ebx
    jmp find_slot

slot_found:
    # Controlla e calcola le penali se necessario
    mov eax, ebx
    add eax, ebx  # tempo di completamento
    cmp eax, ecx  # confronta con la scadenza
    jbe no_penalty
    # Calcola la penale
    sub eax, ecx  # ritardo
    imul eax, edx # priorità * ritardo
    add [total_penalty], eax
no_penalty:
    ret
