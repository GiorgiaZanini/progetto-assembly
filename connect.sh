# as -gstabs -o main.o main.s
# as -gstabs -o itoa.o itoa.s
# ld itoa.o main.o -o esempio_eseguibile

# as -gstabs -o main_test_stinga.o main_test_stinga.s
# as -gstabs -o stampa_stringa.o stampa_stringa.s
# ld main_test_stinga.o stampa_stringa.o -o main_2.x
# ./main_2.x

as main_test_stinga.s -32 -o main_test_stinga.o
as stampa_stringa.s -32 -o stampa_stringa.o
as converti_int_a_str.s -32 -o converti_int_a_str.o
ld main_test_stinga.o stampa_stringa.o converti_int_a_str.o -m elf_i386 -o main_2.x
./main_2.x