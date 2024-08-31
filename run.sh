# as -o test.o test.s
# ld -o test.x test.o
# ./test.x

# as salva_numeri.s -32 -o salva_numeri.o
# ld salva_numeri.o -m elf_i386 -o salva_numeri.x
# ./salva_numeri.x

as main.s -32 -o main.o
as salva_numeri.s -32 -o salva_numeri.o
as stampa_stringa.s -32 -o stampa_stringa.o
as converti_int_a_str.s -32 -o converti_int_a_str.o
ld main.o stampa_stringa.o converti_int_a_str.o salva_numeri.o -m elf_i386 -o main_2.x
./main_2.x 

# as -gstabs -o main.o main.s
# as -gstabs -o itoa.o itoa.s
# ld itoa.o main.o -o esempio_eseguibile