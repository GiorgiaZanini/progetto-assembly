as test_ordinamento.s -32 -o test_ordinamento.o
as converti_str_a_int.s -32 -o converti_str_a_int.o
as stampa_stringa.s -32 -o stampa_stringa.o
as converti_int_a_str.s -32 -o converti_int_a_str.o
ld test_ordinamento.o stampa_stringa.o converti_int_a_str.o converti_str_a_int.o -m elf_i386 -o main_2.x
./main_2.x 