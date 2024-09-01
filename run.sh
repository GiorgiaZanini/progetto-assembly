# as -o test.o test.s
# ld -o test.x test.o
# ./test.x

# as salva_numeri.s -32 -o salva_numeri.o
# ld salva_numeri.o -m elf_i386 -o salva_numeri.x
# ./salva_numeri.x

as main.s -32 -o main.o
as test_sys.s -32 -o test_sys.o
as salva_numeri.s -32 -o salva_numeri.o
as stampa_stringa.s -32 -o stampa_stringa.o
as converti_str_a_int.s -32 -o converti_str_a_int.o
as converti_int_a_str.s -32 -o converti_int_a_str.o
ld main.o test_sys.o stampa_stringa.o converti_str_a_int.o converti_int_a_str.o salva_numeri.o -m elf_i386 -o main_2.x
./main_2.x 

# as main_test_stinga.s -32 -o main_test_stinga.o
# as converti_str_a_int.s -32 -o converti_str_a_int.o
# as stampa_stringa.s -32 -o stampa_stringa.o
# as converti_int_a_str.s -32 -o converti_int_a_str.o
# ld main_test_stinga.o stampa_stringa.o converti_int_a_str.o converti_str_a_int.o -m elf_i386 -o main_2.x
# ./main_2.x 

# as -gstabs -o main.o main.s
# as -gstabs -o itoa.o itoa.s
# ld itoa.o main.o -o esempio_eseguibile